//
//  MapViewController.swift
//  Travel++
//
//  Created by Emily Blanchard on 2/22/22.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Indianaplis
        let latitude = 39.7150
        let longitude = -86.2978
        
        //San Francisco
//        let latitude = 37.6213
//        let longitude = -122.3790

        //set up map view
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        self.view.addSubview(mapView)

    }

}


