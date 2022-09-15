//
//  mainView.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/8/22.
//

import SwiftUI

struct TabContainer: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            ProfileView()
                .tabItem {
                    Label("Missionary", systemImage: "person.text.rectangle")
                }
        }
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor(Color.white.opacity(0.1))
                        
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        TabContainer()
    }
}
