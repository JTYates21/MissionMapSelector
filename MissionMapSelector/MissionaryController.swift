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
    
    @Published var missionary: Missionary?
    
    private let path: String = "Missionary"
    
    private let store = Firestore.firestore()
    
    
    let db = Firestore.firestore()
    
    
    
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
                let dataDescription = try? document.data(as: Missionary.self)
                print("Document data: \(dataDescription)")
            } else {
                print("Data does not exist")
            }
        }
    }
}
