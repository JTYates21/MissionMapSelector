//
//  ContentView.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 8/22/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var userCode: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("mission map selector")
                    .font(.custom("CinzelDecorative-Regular", size: 40))
                    .multilineTextAlignment(.center)
                    .padding(5)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                
                Spacer()
                
                
                VStack {
                    TextField("####-####", text: $userCode)
                        .multilineTextAlignment(.center)
                        .padding(7)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.black, lineWidth: 2))
                        .textContentType(.oneTimeCode).onChange(of: userCode) { newValue in
                            if newValue.count == 4 {
                                userCode = userCode + "-"
                            } else if newValue.count > 9 {
                                userCode = String(userCode.prefix(9))
                            }
                        }
                    Text("enter code")
                        .font(.custom("CinzelDecorative-Regular", size: 17))
                }
                .padding(5)
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .padding(.horizontal, 100)
                
                
                Spacer()
                
                HStack {
                    NavigationLink("info", destination: InfoView())
                        .font(.custom("CinzelDecorative-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.horizontal, 50)
                    
                    Spacer()
                    
                    NavigationLink("admin", destination: AdminView(firstName: "", lastName: "", openingDate: Date()))
                        .font(.custom("CinzelDecorative-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.horizontal, 50)
                }
            }
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
    //    extension UITextContentType {
    //
    //    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
