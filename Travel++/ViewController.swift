//
//  ViewController.swift
//  Travel++
//
//  Created by Emily Blanchard on 2/11/22.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Create a GMSCameraPosition that tells the map to display the
        // Indy: 39.7169° N, 86.2956° W
        //39.71503538310621, -86.29779997696295
        let camera = GMSCameraPosition.camera(withLatitude: 39.7150, longitude: -86.2978, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
 
        self.view.addSubview(mapView)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 39.72, longitude: -86.30)
        marker.title = "Indianapolis"
        marker.snippet = "Indiana"
        marker.map = mapView
    }


}
