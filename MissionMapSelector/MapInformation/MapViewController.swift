//
//  MapViewController.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/30/22.
//

import MapKit
import SwiftUI
import UIKit

class MapViewController: UIViewController {
    
    let mapView : MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saltLake = MKPointAnnotation()
        saltLake.title = "Salt Lake Temple"
        saltLake.coordinate = CLLocationCoordinate2D(latitude: 40.770410, longitude: -111.891747)
        mapView.addAnnotation(saltLake)
        
        self.view.addSubview(mapView)
        setMapConstraints()
        
        let oLongTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongTappedGesture(gestureRecognizer:)))
        
        self.mapView.addGestureRecognizer(oLongTapGesture)
        MissionaryController.shared.retrieveGeoPoints(missionaryId: MissionaryController.shared.missionary!.id!, completion: {
            for guess in MissionaryController.shared.guesses {
                let myPin = MKPointAnnotation()
                let locationCoordinate = CLLocationCoordinate2D(latitude: guess.coordinates.latitude, longitude: guess.coordinates.longitude)
                myPin.coordinate = locationCoordinate
                
                myPin.title = "\(guess.countryCode!)"
                
//                if guess.countryCode == "United States" {
//                    locationCoordinate.placemark { placemark, error in
//
//                        myPin.title = "\(placemark?.state)"
//                        print(placemark?.state)
//                    }
//                }
                
                
                self.mapView.addAnnotation(myPin)
            }
        })
        
    }
    
    @objc func handleLongTappedGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            MissionaryController.shared.saveGuess(at: locationCoordinate, completion: { guess in
                
            
            
            print("Tapped at latitude: \(locationCoordinate.latitude), longitude: \(locationCoordinate.longitude)")
            
            let myPin = MKPointAnnotation()
            myPin.coordinate = locationCoordinate
            
            myPin.title = "\(guess.countryCode!)"
            
                self.mapView.addAnnotation(myPin)
            })
        }
        
        if gestureRecognizer.state != UIGestureRecognizer.State.began {
            return
        }
    }
    
    func setMapConstraints() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
}

struct MapViewRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MapViewController
    
    func makeUIViewController(context: Context) -> MapViewController {
        let vc = MapViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        
    }
    
}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}

extension CLPlacemark {
    /// street name, eg. Infinite Loop
    var streetName: String? { thoroughfare }
    /// // eg. 1
    var streetNumber: String? { subThoroughfare }
    /// city, eg. Cupertino
    var city: String? { locality }
    /// neighborhood, common name, eg. Mission District
    var neighborhood: String? { subLocality }
    /// state, eg. CA
    var state: String? { administrativeArea }
    /// county, eg. Santa Clara
    var county: String? { subAdministrativeArea }
    /// zip code, eg. 95014
    var zipCode: String? { postalCode }
    /// postal address formatted
}
