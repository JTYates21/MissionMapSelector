//
//  MissionaryController.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/1/22.
//

import CoreLocation
import FirebaseFirestore
import Foundation

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
    
    private let missionaryPath: String = "Missionary"
    private let guessesPath = "Guesses"
    private let roomCodeKey = "roomCode"
    let adminPinKey = "adminPin"
    
    private var isAdmin = false
    
    private let store = Firestore.firestore()
    
    
    let db = Firestore.firestore()
    
    init() {
        if let missionaryId = UserDefaults.standard.missionaryId {
            retrieveMissionary(id: missionaryId)
        }
    }

    
    func findMissionary(with roomCode: String, adminPin: String? = nil, callBack: @escaping (MissionaryError?) -> ()) {
        var adminPin = adminPin
        if adminPin == nil {
            adminPin = UserDefaults.standard.string(forKey: adminPinKey)
        }
        let missionaryRef = db.collection(missionaryPath)
        let query = missionaryRef.whereField(roomCodeKey, isEqualTo: roomCode.lowercased())
        
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
                    let missionary = try? document.data(as: Missionary.self)
                    print("\(document.documentID) => \(document.data())")
                }
            } else if let err = error {
                callBack(.noDocuments)
            } else {
                callBack(.unknown)
            }
        }
    }
    
    
    func save(missionary: Missionary) {
        do {
            let newM = try store.collection(missionaryPath).addDocument(from: missionary)
            print(newM.documentID)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func retrieveMissionary(id: String) {
        let docRef = db.collection(missionaryPath).document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let missionary = try? document.data(as: Missionary.self)
                self.missionary = missionary
            } else {
                print("Data does not exist")
            }
        }
    }
    
    func retrieveGeoPoints(missionaryId: String, completion: @escaping () -> Void) {
        let docRef = db.collection(missionaryPath).document(missionaryId).collection(guessesPath)
        
        docRef.getDocuments { (guessDocs, error) in
            if let guessDocs = guessDocs, !guessDocs.isEmpty {
                var guesses: [Guess] = []
                for document in guessDocs.documents {
                    guard let guess = try? document.data(as: Guess.self) else {continue}
                    guesses.append(guess)
                }
                self.guesses = guesses
            } else {
                print("Data does not exist")
            }
            completion()
        }
    }
    
    func saveGuess(at location: CLLocationCoordinate2D, completion: @escaping (Guess) -> Void) {
        guard let missionary, let id = missionary.id else {return} //TODO: show user error
        let geoPoint = GeoPoint(latitude: location.latitude, longitude: location.longitude)
        let createdAtString = Date.now.description
        let clLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        clLocation.fetchCityAndCountry { city, country, error in
            
            if country == "United States" {
                clLocation.placemark { placemark, error in
                    placemark?.state
                    print(placemark?.state)
                }
            }
            
            let newGuess = Guess(coordinates: geoPoint, userId: UserDefaults.standard.currentUserId, createdAtString: createdAtString, countryCode: country, stateCode: city)
            let path = "\(self.missionaryPath)/\(id)/\(self.guessesPath)"
            do {
                let newM = try self.store.collection(path).addDocument(from: newGuess)
            } catch {
                print(error.localizedDescription)
            }
            completion(newGuess)
        }
    }
    
    func generateGuessFromLocation() {
        
    }
}
