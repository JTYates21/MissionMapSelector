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
        let map = MKMapView
        map.overrideUserInterfaceStyle = .dark
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(mapView)
        
    }
    
    func setMapConstraints() {
        view.addSubview(mapView)
        
        map.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
