//
//  Missionary.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/1/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Missionary: Codable {
    @DocumentID var id: String? = UUID().uuidString
    let firstName: String
    let lastName: String
    let openingDateString: String
    let roomCode: String
    let adminPin: String
//    var openingDate: Date {
//        
//    }
}
