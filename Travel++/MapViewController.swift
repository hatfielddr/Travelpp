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
        // Indy: 39.7169° N, 86.2956° W
        //39.71503538310621, -86.29779997696295

        //set up map view
        let camera = GMSCameraPosition.camera(withLatitude: 39.7150, longitude: -86.2978, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
        self.view.addSubview(mapView)

    }

}


