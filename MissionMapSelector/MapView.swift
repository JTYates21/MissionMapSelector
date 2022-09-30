//
//  mapView.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/8/22.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}


struct MapView: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.770410, longitude: -111.891747), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    @State var locations = [
        Location(name: "Salt Lake Temple", coordinate: CLLocationCoordinate2D(latitude: 40.770410, longitude: -111.891747))
    ]
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, annotationItems: locations) { locations in
                MapMarker(coordinate: locations.coordinate)
            }
            VStack {
                Spacer()
                Button(action: {
                    locations.append(Location(name: "Guess", coordinate: mapRegion.center))
                }, label: {
                    Text("Click to make a guess")
                        .font(.custom("CinzelDecorative-Regular", size: 14))
                        .foregroundColor(.black)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 5)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .padding(.horizontal, 15)
                })
                .padding(.bottom, 100)
            }
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
