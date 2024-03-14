//
//  mainView.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/8/22.
//

import SwiftUI

struct TabContainer: View {
    var body: some View {
        NavigationView {
            TabView {
                MapViewRepresentable()
                    .edgesIgnoringSafeArea(.all)
                    .tabItem {
                        Label("Map", systemImage: "map")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Missionary", systemImage: "person.text.rectangle")
                    }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: { MissionaryController.shared.missionary = nil }) {
                        Text("return")
                            .font(.custom("CinzelDecorative-Regular", size: 14))
                            .foregroundColor(.black)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .padding(.horizontal, 15)
                    }
                }
            })
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
