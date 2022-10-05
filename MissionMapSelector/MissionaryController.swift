//
//  MissionaryController.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/1/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum MissionaryError: Error {
    case noMissionaryFound
    case noDocuments
    case unknown
}

class MissionaryController: ObservableObject {
    static let shared = MissionaryController()
    
    @Published var adminMissionary: Missionary? {
        didSet {
            UserDefaults.standard.missionaryId = missionary?.id
        }
    }
    
    @Published var missionary: Missionary?
    
    private let path: String = "Missionary"
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
        let missionaryRef = db.collection(path)
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
            let newM = try store.collection(path).addDocument(from: missionary)
            print(newM.documentID)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func retrieveMissionary(id: String) {
        let docRef = db.collection(path).document(id)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let missionary = try? document.data(as: Missionary.self)
                self.missionary = missionary
            } else {
                print("Data does not exist")
            }
        }
    }
}
