//
//  SettingsView.swift
//  SettingsView
//
//  Created by Patrick Mifsud on 25/8/21.
//  Copyright © 2021 Patrick Mifsud. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("description") var description = DefaultSettings.description

    var body: some View {
        NavigationView {
            Form {
                HeaderBackgroundSliders()
                ProfileSettings(description: $description)
            }
            .navigationBarTitle(Text("Settings"))
            .navigationBarItems(
                trailing:
                    Button (
                        action: {
                            save()
                            self.presentationMode.wrappedValue.dismiss()
                        },
                        label: {
                            Text("Done")
                        }
                    )
            )
        }
    }
    func save() {
        guard let missionary = MissionaryController.shared.missionary else {return}
        
//        missionary.description = description
        MissionaryController.shared.save(missionary: missionary)
    }
}
struct ProfileSettings: View {
    @AppStorage("name") var name = (MissionaryController.shared.missionary?.firstName ?? "") + " " + (MissionaryController.shared.missionary?.lastName ?? "")
    @Binding var description: String
    
    var body: some View {
        Section(header: Text("Profile")) {
            
            TextField("Name", text: $name)
            TextEditor(text: $description)
        }
    }
}

struct HeaderBackgroundSliders: View {
    @AppStorage("rValue") var rValue = DefaultSettings.rValue
    @AppStorage("gValue") var gValue = DefaultSettings.gValue
    @AppStorage("bValue") var bValue = DefaultSettings.bValue
    
    var body: some View {
        Section(header: Text("Header Background Color")) {
            HStack {
                VStack {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(width: 100)
                        .foregroundColor(Color(red: rValue, green: gValue, blue: bValue, opacity: 1.0))
                }

                VStack {
                    ColorSlider(value: $rValue, textColor: .red)
                    ColorSlider(value: $gValue, textColor: .green)
                    ColorSlider(value: $bValue, textColor: .blue)
                }
            }
        }
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
