//
//  AdminView.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 8/26/22.
//

import SwiftUI

struct AdminView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var userCode = ""
    @State var userPin = ""
    
    var body: some View {
        NavigationView {
            VStack {
                
                Spacer()

                VStack {
                    TextField("User Code", text: $userCode)
                        .padding(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.black, lineWidth: 2))
                        .padding(.horizontal, 10)
                        .padding(.top, 10)
                    
                    TextField("Pin", text: $userPin)
                        .padding(15)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.black, lineWidth: 2))
                        .padding(10)
                        .padding(.bottom, 0)
                    
                    Button(action: saveNew) {
                        Text("enter")
                            .font(.custom("CinzelDecorative-Regular", size: 20))
                            .foregroundColor(.black)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 5)
                            .background(.ultraThinMaterial)
                            .clipShape(Capsule())
                            .padding(.horizontal, 15)
                    }
                    .padding(.bottom, 10)
                    .disabled(userCode.isEmpty || userPin.isEmpty)
                }
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 75)
                
                    NavigationLink("create new user", destination: NewUserView())
                        .font(.custom("CinzelDecorative-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.horizontal, 50)
                
                Spacer()
                Spacer()
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func saveNew() {
        //        let missionary = Missionary(firstName: "Stoctkon", lastName: "Yates", userCode: "Viking", openingDate: "")
        //        MissionaryController.shared.save(missionary: missionary)
        MissionaryController.shared.retrieveMissionary(id: "OzhacfuRSbovQutQ506W")
    }
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView()
    }
}
