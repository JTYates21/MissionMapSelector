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
    
    let locations = [
        Location(name: "Salt Lake Temple", coordinate: CLLocationCoordinate2D(latitude: 40.770410, longitude: -111.891747))
    ]
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: locations) { locations in
            MapMarker(coordinate: locations.coordinate)
        }
            .ignoresSafeArea()
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
