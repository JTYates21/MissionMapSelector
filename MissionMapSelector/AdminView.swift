//
//  AdminView.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 8/26/22.
//

import SwiftUI

struct AdminView: View {
    
    @State var firstName: String
    @State var lastName: String
    @State var openingDate: Date
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    HStack {
                        Text("First Name:")
                        TextField("First Name", text: $firstName)
                    }
                    HStack {
                        Text("Last Name:")
                        TextField("Last Name", text: $lastName)
                    }
                    Section {
                        HStack {
                            DatePicker(selection: $openingDate, in: ...Date(), displayedComponents: .date) {
                                Text("Opening date:")
                            }
                        }
                    }
                }
                .padding(30)
                
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
}

struct AdminView_Previews: PreviewProvider {
    static var previews: some View {
        AdminView(firstName: "", lastName: "", openingDate: Date())
    }
}
