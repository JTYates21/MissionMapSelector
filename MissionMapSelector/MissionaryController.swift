//
//  MissionaryController.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/1/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

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
    private let adminPinKey = "adminPin"
    
    private let store = Firestore.firestore()
    
    
    let db = Firestore.firestore()
    
    init() {
        if let missionaryId = UserDefaults.standard.missionaryId {
            retrieveMissionary(id: missionaryId)
        }
    }
    
    func findAdminMissionary(with roomCode: String, adminPin: String) {
        let missionaryRef = db.collection(path)
        let query = missionaryRef.whereField(roomCodeKey, isEqualTo: roomCode).whereField(adminPinKey, isEqualTo: adminPin)
        
        query.getDocuments { snapshot, error in
            if let snapshot = snapshot {
                if let firstDoc = snapshot.documents.first {
                    guard snapshot.documents.count == 1 else {
                        print("more than one missionary found")
                        return
                    }
                    let missionary = try? firstDoc.data(as: Missionary.self)
                    self.adminMissionary = missionary
                } else {
                    //Show error code
                    print("no missionary found")
                }
                for document in snapshot.documents {
                    let missionary = try? document.data(as: Missionary.self)
                    print("\(document.documentID) => \(document.data())")
                }
            } else if let err = error {
                print("Error getting documents: \(err)")
            } else {
                print("You are lost")
            }
        }
    }
    
    func findMissionary(with roomCode: String) {
        let missionaryRef = db.collection(path)
        let query = missionaryRef.whereField(roomCodeKey, isEqualTo: roomCode)
        
        query.getDocuments { snapshot, error in
            if let snapshot = snapshot {
                if let firstDoc = snapshot.documents.first {
                    guard snapshot.documents.count == 1 else {
                        print("more than one missionary found")
                        return
                    }
                    let missionary = try? firstDoc.data(as: Missionary.self)
                    self.missionary = missionary
                } else {
                    //Show error code
                    print("no missionary found")
                }
                for document in snapshot.documents {
                    let missionary = try? document.data(as: Missionary.self)
                    print("\(document.documentID) => \(document.data())")
                }
            } else if let err = error {
                print("Error getting documents: \(err)")
            } else {
                print("You are lost")
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
