//
//  InfoView.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 8/26/22.
//

import SwiftUI

struct InfoView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var infoText: String {
                        """
        this app has been produced for the use of
        individuals seeking to have fun guessing
        which mission a family member or friend
        might be going to.
        
        this app is not sponsered or affiliated with the church of jesus christ of latter-day saints.
        
        a big thank you to those who helped
        produce and stylize the app, to those
        family and friends, and the wonderful
        people of houston, texas.
        
        """
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(infoText)
                .font(.custom("CinzelDecorative-Regular", size: 18))
                .foregroundColor(.black)
                .padding(.horizontal, 15)
                .padding(.vertical, 2)
                
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 30)
            
            Spacer()
            
            HStack {
                Text("made by: jacek yates")
                    .font(.custom("CinzelDecorative-Regular", size: 14))
                    .foregroundColor(.black)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(.horizontal, 30)
                    .multilineTextAlignment(.center)
                Spacer()
                Text("2022")
                    .font(.custom("CinzelDecorative-Regular", size: 14))
                    .foregroundColor(.black)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 5)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(.horizontal, 30)
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .cancellationAction) {
                Button(action: goBack) {
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
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
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
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
}
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
