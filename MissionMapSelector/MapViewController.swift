//
//  MapViewController.swift
//  MissionMapSelector
//
//  Created by Jacek Yates on 9/30/22.
//

import UIKit
import SwiftUI
import MapKit

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
    }
    
    @objc func handleLongTappedGesture(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            let touchLocation = gestureRecognizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            
            print("Tapped at latitude: \(locationCoordinate.latitude), longitude: \(locationCoordinate.longitude)")
            
            let myPin = MKPointAnnotation()
            myPin.coordinate = locationCoordinate
            
            myPin.title = "latitude: \(locationCoordinate.latitude), longitude: \(locationCoordinate.longitude)"
            
            mapView.addAnnotation(myPin)
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

