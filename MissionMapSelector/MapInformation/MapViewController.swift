//
//  MapViewController.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/30/22.
//

import MapKit
import SwiftUI
import UIKit

/// A class where functions for the lifecycle and logic of the `MapView`
/// are located.
class MapViewController: UIViewController {
    
    /// Allows us to override the light/dark mode of the user's device.
    /// We set it to `.dark` to maintain continuity between views.
    let mapView : MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// Default pin that is given to every `Missionary` object.
        let saltLake = MKPointAnnotation()
        saltLake.title = "Salt Lake Temple"
        saltLake.coordinate = CLLocationCoordinate2D(latitude: 40.770410, longitude: -111.891747)
        mapView.addAnnotation(saltLake)
        
        self.view.addSubview(mapView)
        setMapConstraints()
        
        let longTapGesture = UILongPressGestureRecognizer(target: self,
                                                          action: #selector(MapViewController.handleLongTappedGesture(_ :)))
        self.mapView.addGestureRecognizer(longTapGesture)
        
        setupCurrentGuesses()
    }
    
    /// Function that converts the touch point to `CLLocationCoordinate2D`, and
    /// then calls the `addPin()` function to add a pin to the map
    /// - Parameter gestureRecognizer: The gesture that we want to recognize
    /// and convert into coordinates to be saved.
    @objc func handleLongTappedGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let locationCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            addPin(at: locationCoordinates)
        }
    }
    
    /// Function that adds a visible pin to the `MapView` using the coordinates
    /// given by the `handleLongTappedGesture()` function.
    /// - Parameter coordinates: The coordinates we are adding the pin to.
    func addPin(at coordinates: CLLocationCoordinate2D) {
        MissionaryController.shared.saveGuess(at: coordinates) { guess in
            let newPin = MKPointAnnotation()
            newPin.coordinate = coordinates
            newPin.title = guess.countryCode
            
            if guess.countryCode == "United States",
               let stateCode = guess.stateCode {
                newPin.title = "\(stateCode)"
            }
            
            self.mapView.addAnnotation(newPin)
        }
    }
    
    /// This function access the Firestore Database and pulls in the array of
    /// guesses linked to the missionary currently being viewed.
    func setupCurrentGuesses() {
        guard let missionaryId = MissionaryController.shared.missionary?.id else {
            print("!!! There is no missionaryId !!!")
            return
        }
        
        MissionaryController.shared.retrieveGeoPoints(missionaryId: missionaryId,
                                                      completion: {
            for guess in MissionaryController.shared.guesses {
                let myPin = MKPointAnnotation()
                let locationCoordinate = CLLocationCoordinate2D(latitude: guess.coordinates.latitude,
                                                                longitude: guess.coordinates.longitude)
                myPin.coordinate = locationCoordinate
                
                myPin.title = "\(guess.countryCode!)"
                
                if guess.countryCode == "United States",
                   let stateCode = guess.stateCode {
                    myPin.title = "\(stateCode)"
                }
                
                self.mapView.addAnnotation(myPin)
            }
        })
    }
    
    /// Function to correctly setup the constraints of the `MapView` to the
    /// current user's device.
    func setMapConstraints() {
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    }
}

/// A `UIViewControllerRepresentable` version of the `MapViewController`
/// that we can use to connect, navigate, and communicate between SwiftUI and UIKit views.
struct MapViewRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MapViewController
    
    func makeUIViewController(context: Context) -> MapViewController {
        let vc = MapViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {}
}

extension CLLocation {
    /// Function used to retrieve state and country information using the
    /// given `CLLocation` information.
    func fetchStateAndCountry(completion: @escaping (_ state: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.administrativeArea, $0?.first?.country, $1) }
    }
}
