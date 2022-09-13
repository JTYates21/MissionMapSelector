//
//  NewUserView.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/2/22.
//

import SwiftUI

struct NewUserView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var firstName = ""
    @State var lastName = ""
    @State var openingDate = Date()
    @State var adminPin = ""
    @State var publicCode = ""
    
    @State var showMain = false
    
    @State var showAdminPinPanel = false
    @State var showPublicInfoPanel = false
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    Spacer()
                    VStack {
                        Text("create a new missionary")
                            .font(.custom("CinzelDecorative-Regular", size: 25))
                            .multilineTextAlignment(.center)
                        
                        
                        HStack {
                            Text("first name:")
                            TextField("first name", text: $firstName)
                        }
                        .font(.custom("CinzelDecorative-Regular", size: 14))
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.black, lineWidth: 2))
                        
                        
                        HStack{
                            Text("last name:")
                            TextField("last name", text: $lastName)
                        }
                        .font(.custom("CinzelDecorative-Regular", size: 14))
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.black, lineWidth: 2))
                        
                        
                        HStack {
                            DatePicker("opening date:", selection: $openingDate, in: Date()..., displayedComponents: [.date])
                            
                        }
                        .font(.custom("CinzelDecorative-Regular", size: 14))
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.black, lineWidth: 2))
                        
                        HStack{
                            Text("admin pin:")
                            TextField("4 digit pin", text: $adminPin)
                                .onChange(of: adminPin) { newValue in
                                    if newValue.count > 4 {
                                        adminPin = String(adminPin.prefix(4))
                                    }
                                }
//                            Button {
//                                showAdminPinPanel.toggle()
//                            } label: {
//                                Image(systemName: "info.circle")
//                            }
//                            .foregroundColor(.gray)
                        }
                        .font(.custom("CinzelDecorative-Regular", size: 14))
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.black, lineWidth: 2))
                        
                        
                        HStack{
                            Text("public code:")
                            TextField("8 letter word", text: $publicCode)
//                            Button {
//                                showPublicInfoPanel.toggle()
//                            } label: {
//                                Image(systemName: "info.circle")
//                            }
//                            .foregroundColor(.gray)
                        }
                        .font(.custom("CinzelDecorative-Regular", size: 14))
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.black, lineWidth: 2))
                        
                    }
                    .padding(5)
                    
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
                    
                    NavigationLink("enter", isActive: $showMain) {
                        MainView()
                    }
                    .hidden()
                    .frame(width: 0, height: 0)
                    
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
                    
                    Spacer()
                    Spacer()
                }
                .padding(60)
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
                
                
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.gray)
                    .frame(width: showAdminPinPanel ? 175 : 0,
                           height: showAdminPinPanel ? 50 : 0)
                    .animation(.spring(), value: showAdminPinPanel)
                    .opacity(0.9)
                    .offset(y: 21)
                
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.gray)
                    .frame(width: showPublicInfoPanel ? 175 : 0,
                           height: showPublicInfoPanel ? 50 : 0)
                    .animation(.spring(), value: showPublicInfoPanel)
                    .opacity(0.9)
                    .offset(y: 60)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
    
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func saveNew() {
        guard !firstName.isEmpty, !lastName.isEmpty, !publicCode.isEmpty, !adminPin.isEmpty else {
            return
        }
        
        showMain = true
        
        let missionary = Missionary(firstName: firstName, lastName: lastName, openingDateString: openingDate.description, roomCode: publicCode, adminPin: adminPin)
        
        MissionaryController.shared.save(missionary: missionary)
    }
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView()
    }
}
