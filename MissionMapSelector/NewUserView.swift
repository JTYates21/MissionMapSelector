//
//  NewUserView.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/2/22.
//

import SwiftUI

/// This view represents the screen that is seen by the user when
/// they want to create a new `Missionary`.
struct NewUserView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var openingDate: Date = Date()
    @State var dateToggle: Bool = false
    @State var adminPin: String = ""
    @State var publicCode: String = ""
    @State var showMain: Bool = false
    
    @State private var showingEmptyFieldsAlert: Bool = false
    @State private var showingPublicCodeAlert: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack {
                newMissionaryCreationView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .alert("Oops!",
               isPresented: $showingEmptyFieldsAlert,
               actions: {
            Button("OK") {}
        },
               message: {
            Text("It looks like there are empty fields. Please enter all information.")
        })
        .alert("Oops!",
               isPresented: $showingPublicCodeAlert,
               actions: {
            Button("OK") {}
        },
               message: {
            Text("A user already is using this public code. Please enter a different code.")
        })
    }
    
    /// Function that allows the user to drop back to the `HomePageView`.
    func goBack() {
        presentationMode.wrappedValue.dismiss()
    }
    
    /// Function that saves the information the user input to a new `Missionary`
    /// object.
    ///
    /// This function first checks if there are any empty values in the view, and
    /// displays an alert asking the user to finish filling those out if there are.
    ///
    /// This function then searched the Firestore Database for a `Missionary`
    /// with a matching `publicCode` variable. If none are found, we display
    /// an alert asking the user to pick a new code.
    ///
    /// If all is satisfied, we save the new `Missionary` to the database and
    /// move to the `TabContainerView` where the missionary can see the
    /// map and their profile.
    func saveNew() {
        guard !firstName.isEmpty, !lastName.isEmpty, !publicCode.isEmpty, !adminPin.isEmpty else {
            showingEmptyFieldsAlert = true
            return
        }
        
        let publicCode = publicCode.lowercased()
        MissionaryController.shared.findMissionary(with: publicCode) { error in
            if error == nil {
                showingPublicCodeAlert = true
            } else {
                showMain = true
                
                let missionary = Missionary(firstName: firstName,
                                            lastName: lastName,
                                            openingDateString: openingDate.formatted(date: .abbreviated,
                                                                                     time: .omitted),
                                            roomCode: publicCode.lowercased(),
                                            adminPin: adminPin)
                
                MissionaryController.shared.save(missionary: missionary)
            }
        }
    }
}

extension NewUserView {
    /// The view that the user will see.
    func newMissionaryCreationView() -> some View {
        VStack {
            Spacer()
            contentView()
            NavigationLink("enter", isActive: $showMain) {
                TabContainer()
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
    }
    
    /// The view containing all the cells that the user will need to fill out
    /// in order to successfully create a new `Missionary`.
    func contentView() -> some View {
        VStack {
            Text("create a new missionary")
                .font(.custom("CinzelDecorative-Regular", size: 25))
                .multilineTextAlignment(.center)
            firstNameRow()
            lastNameRow()
            openingDateView()
            adminPinRow()
            publicCodeRow()
        }
        .padding(5)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
    }
    
    /// The row where the user will input the first name of the
    /// `Missionary` to be created.
    func firstNameRow() -> some View {
        HStack {
            Text("first name:")
            TextField("first name", text: $firstName)
        }
        .font(.custom("CinzelDecorative-Regular", size: 14))
        .padding(5)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.black, lineWidth: 2))
    }
    
    /// The row where the user will input the last name of the
    /// `Missionary` to be created.
    func lastNameRow() -> some View {
        HStack{
            Text("last name:")
            TextField("last name", text: $lastName)
        }
        .font(.custom("CinzelDecorative-Regular", size: 14))
        .padding(5)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.black, lineWidth: 2))
    }
    
    /// View that contains a toggle for if the missionary does not
    /// yet have a opening date.
    func datePickerView() -> some View {
        HStack {
            DatePicker("opening date:", selection: $openingDate, in: Date()..., displayedComponents: [.date])
        }
    }
    
    /// The view that contains the date picker for when the given
    /// missionary is opening their mission call.
    func openingDateView() -> some View {
        VStack {
            if dateToggle != true {
                datePickerView()
            } else {
                datePickerView()
                    .opacity(0.5)
                    .disabled(true)
            }
            HStack {
                Toggle(isOn: $dateToggle) {
                    Text("I don't have a date yet")
                }
                .tint(.black)
            }
        }
        .font(.custom("CinzelDecorative-Regular", size: 14))
        .padding(5)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.black, lineWidth: 2))
    }
    
    /// The row where the user inputs a chosen 4-digit pin.
    func adminPinRow() -> some View {
        HStack{
            Text("admin pin:")
            TextField("4 digit pin", text: $adminPin)
                .onChange(of: adminPin) { newValue in
                    if newValue.count > 4 {
                        adminPin = String(adminPin.prefix(4))
                    }
                }
        }
        .font(.custom("CinzelDecorative-Regular", size: 14))
        .padding(5)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.black, lineWidth: 2))
    }
    
    /// The row where the user inputs a chosen `publicCode`.
    /// This code is what the missionary can share with the public,
    /// and what the public uses to get to that missionary's page.
    func publicCodeRow() -> some View {
        HStack{
            Text("public code:")
            TextField("6-8 letter word", text: $publicCode)
        }
        .font(.custom("CinzelDecorative-Regular", size: 14))
        .padding(5)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(.black, lineWidth: 2))
    }
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView()
    }
}
