//
//  Missionary.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/1/22.
//

import CoreLocation
import Firebase
import FirebaseFirestoreSwift
import Foundation


struct Missionary: Codable {
    @DocumentID var id: String? = UUID().uuidString
    let firstName: String
    let lastName: String
    let openingDateString: String
    let roomCode: String
    let adminPin: String
//    var description: String
}

struct Guess: Codable {
    @DocumentID var id: String? = UUID().uuidString
    let coordinates: GeoPoint
    let userId: String
    let createdAtString: String
    let countryCode: String?
    let stateCode: String?
}
