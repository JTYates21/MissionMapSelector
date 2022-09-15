//
//  MainContainerView.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/14/22.
//

import SwiftUI

struct MainContainerView: View {
    
    @ObservedObject var missionaryController = MissionaryController.shared
    
    var body: some View {
        Group {
            if missionaryController.missionary == nil {
                HomePageView()
            } else {
                TabContainer()
            }
        }
    }
}

struct MainContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MainContainerView()
    }
}
