//
//  profileView.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/8/22.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        
        VStack {
            HStack {
                Text("Profile photo")
                    .padding(40)
                Spacer()
                VStack {
                    Text("First Name")
                    Text("Last Name")
                }
                Spacer()
                
                
            }
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
