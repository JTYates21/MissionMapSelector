//
//  profileView.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/8/22.
//

import SwiftUI

struct ProfileView: View {
    @State var isPresented = false
    
    var body: some View {
        
        VStack {
            VStack {
                Header()
                ProfileText()
            }
            Spacer()
//            Button (
//                action: { self.isPresented = true },
//                label: {
//                    Label("Edit", systemImage: "pencil")
//                })
//            .padding(.bottom, 80)
//            .sheet(isPresented: $isPresented, content: {
//                SettingsView()
//            })
        }
        .background(.ultraThinMaterial)
        .background {
            GeometryReader { geometry in
                Image("WorldMap1")
                    .resizable()
                    .blur(radius: 1)
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geometry.size.width + 50, height: geometry.size.height + 50, alignment: .center)
                    .offset(x: -10, y: -10)
            }
        }
    }
}

struct ProfileText: View {
    @ObservedObject var missionaryController = MissionaryController.shared
    
    @AppStorage("description") var description = DefaultSettings.description
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                Text((missionaryController.missionary?.firstName ?? "") + (" ") + (missionaryController.missionary?.lastName ?? ""))
                    .bold()
                    .font(.title)
            }.padding()
            Text(description)
                .multilineTextAlignment(.center)
                .padding()
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
