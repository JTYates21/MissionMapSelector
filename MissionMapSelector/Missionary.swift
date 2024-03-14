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

/// A `Missionary` object reflecting the actual missionary that is
/// being viewed by the original creator or the general public.
struct Missionary: Codable {
    @DocumentID var id: String? = UUID().uuidString
    let firstName: String
    let lastName: String
    let openingDateString: String
    let roomCode: String
    let adminPin: String
//    var description: String
}

/// A `Guess` object that reflects a guess made by either the creator
/// or someone from the general public. This is displayed in the form of
/// a pin that can be seen on the `MapView`. This object is also saved
/// to the Firestore Database under the `Missionary` being viewed.
struct Guess: Codable {
    @DocumentID var id: String? = UUID().uuidString
    let coordinates: GeoPoint
    let userId: String
    let createdAtString: String
    let countryCode: String?
    var stateCode: String?
}
