//
//  ViewController.swift
//  Travel++
//
//  Created by Emily Blanchard on 2/11/22.
//

import UIKit
import GoogleMaps
import FirebaseDatabase

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Firebase test queries
        let ref = Database.database().reference()
        ref.child("someid/name").setValue("User1")
        
        
        // Create a GMSCameraPosition that tells the map to display the
        // Indy: 39.7169° N, 86.2956° W
        //39.71503538310621, -86.29779997696295
        let camera = GMSCameraPosition.camera(withLatitude: 39.7150, longitude: -86.2978, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.zoomGestures = true
 
        self.view.addSubview(mapView)

    }


}
