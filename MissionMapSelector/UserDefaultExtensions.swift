//
//  UserDefaultExtensions.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/14/22.
//

import Foundation

extension UserDefaults {
    
    var missionaryId: String? {
        get {
            value(forKey: #function) as? String
        } set {
            if let newValue = newValue {
                set(newValue, forKey: #function)
            } else {
                removeObject(forKey: #function)
            }
        }
    }
}
