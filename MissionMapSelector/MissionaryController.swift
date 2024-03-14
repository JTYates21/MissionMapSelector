//
//  MissionaryController.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/1/22.
//

import CoreLocation
import Foundation
import FirebaseFirestore

enum MissionaryError: Error {
    case noMissionaryFound
    case noDocuments
    case unknown
}

/// A class containing helper functions that relate to a `Missionary` object.
class MissionaryController: ObservableObject {
    
    /// The shared instance of a `MissionaryController`.
    static let shared = MissionaryController()
    
    @Published var adminMissionary: Missionary? {
        didSet {
            UserDefaults.standard.missionaryId = missionary?.id
        }
    }
    @Published var missionary: Missionary?
    @Published var guesses: [Guess] = []
    
    private let firestoreDataBase = Firestore.firestore()
    private let missionaryPath: String = "Missionary"
    private let guessesPath = "Guesses"
    private let publicCodeKey = "publicCode"
    private var isAdmin = false
    
    public let adminPinKey = "adminPin"

    init() {
        if let missionaryId = UserDefaults.standard.missionaryId {
            retrieveMissionary(id: missionaryId)
        }
    }

    /// Function that allows us to call into the Firestore Database and search for a
    /// `Missionary` object.
    /// - Parameters:
    ///   - publicCode: The unique public code created by the missionary that
    ///   others can use to find their profile.
    ///   - adminPin: The unique 4-digit number pin that the missionary created.
    ///   This allows them to log into their account as an "admin".
    ///   - callBack: A completion block to handle if there are any errors.
    func findMissionary(with publicCode: String,
                        adminPin: String? = nil,
                        callBack: @escaping (MissionaryError?) -> ()) {
        var adminPin = adminPin
        if adminPin == nil {
            adminPin = UserDefaults.standard.string(forKey: adminPinKey)
        }
        let missionaryRef = firestoreDataBase.collection(missionaryPath)
        let query = missionaryRef.whereField(publicCodeKey, isEqualTo: publicCode.lowercased())
        
        query.getDocuments { [weak self] snapshot, error in
            guard let self = self else {return}
            if let snapshot = snapshot {
                if let firstDoc = snapshot.documents.first {
                    
                    do {
                        let missionary = try firstDoc.data(as: Missionary.self)
                        self.missionary = missionary
                        callBack(nil)
                        if let adminPin = adminPin, adminPin == missionary.adminPin {
                            self.isAdmin = true
                        }
                    } catch {
                        print(error)
                    }
                } else {
                    callBack(.noMissionaryFound)
                }
                for document in snapshot.documents {
                    _ = try? document.data(as: Missionary.self)
                    print("\(document.documentID) => \(document.data())")
                }
            } else if error != nil {
                callBack(.noDocuments)
            } else {
                callBack(.unknown)
            }
        }
    }
    
    /// Function that saves a given missionary to the Firestore Database.
    /// - Parameter missionary: The missionary that the user
    /// wants to save.
    func save(missionary: Missionary) {
        do {
            let newM = try firestoreDataBase.collection(missionaryPath).addDocument(from: missionary)
            print(newM.documentID)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// Function that calls into the Firestore Database and searches for any
    /// `Missionary` objects. This checks to see if the missionaryId of
    /// that given `Missionary` matches the `id` passed in.
    /// - Parameter id: The unique id linked to the missionary that
    /// we want to check for.
    func retrieveMissionary(id: String) {
        let docRef = firestoreDataBase.collection(missionaryPath).document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let missionary = try? document.data(as: Missionary.self)
                self.missionary = missionary
            } else {
                print("Unable to retrieve Missionary from given Missionary ID.")
            }
        }
    }
    
    /// Function that calls into the Firestore Database and searches for the
    /// array of guesses (if any) that are linked to the `Missionary` object.
    /// - Parameters:
    ///   - missionaryId: The unique id linked to the missionary that
    ///   we want to check for.
    ///   - completion: The closure to call when the operation is completed.
    func retrieveGeoPoints(missionaryId: String, completion: @escaping () -> Void) {
        let docRef = firestoreDataBase.collection(missionaryPath).document(missionaryId).collection(guessesPath)
        
        docRef.getDocuments { (guessDocs, error) in
            if let guessDocs = guessDocs, !guessDocs.isEmpty {
                var guesses: [Guess] = []
                for document in guessDocs.documents {
                    guard let guess = try? document.data(as: Guess.self) else {continue}
                    guesses.append(guess)
                }
                self.guesses = guesses
            } else {
                print("Unable to retrieve GeoPoints from given Missionary ID.")
            }
            completion()
        }
    }
    
    /// Function that saves a `Guess` to the `Missionary` object that the
    /// user is currently looking at. This guess is saved to array of guesses
    /// linked to the Firestore Database for the given missionary.
    /// - Parameters:
    ///   - location: The `CLLocationCoordinate` of the guess that
    ///   we are wanting to save.
    ///   - completion: The closure to call when the operation is completed.
    func saveGuess(at location: CLLocationCoordinate2D, completion: @escaping (Guess) -> Void) {
        guard let missionary, let id = missionary.id else {return}
        let geoPoint = GeoPoint(latitude: location.latitude, longitude: location.longitude)
        let createdAtString = Date.now.description
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        clLocation.fetchStateAndCountry { state, country, error in
            
            var currentStateName: String = ""
            for (key, value) in stateNames {
                if key == state {
                    currentStateName = value
                }
            }
            
            let newGuess = Guess(coordinates: geoPoint,
                                 userId: UserDefaults.standard.currentUserId,
                                 createdAtString: createdAtString,
                                 countryCode: country,
                                 stateCode: currentStateName)
            let path = "\(self.missionaryPath)/\(id)/\(self.guessesPath)"
            do {
                let _ = try self.firestoreDataBase.collection(path).addDocument(from: newGuess)
            } catch {
                print(error.localizedDescription)
            }
            completion(newGuess)
        }
    }
}
