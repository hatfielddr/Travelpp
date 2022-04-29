//
//  MapViewController.swift
//  Travel++
//
//  Created by Emily Blanchard on 2/22/22.
//  Used iOS Academy tutorial
//

import UIKit
import MapKit
import GooglePlaces
import GoogleMaps

var currentLatitude = Double()
var currentLongitude = Double()
var latitude = Double()
var longitude = Double()

var toSelectedName = String()
var fromSelectedName = String()

//var map = GMSMapView()

class MapViewController: UIViewController, UISearchResultsUpdating, CLLocationManagerDelegate {

    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    //var camera: GMSCameraPosition!
    
    let locationManager = CLLocationManager()
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    
    var zoom = Float(4.0)
    //var center = CLLocationCoordinate2D()
    var bounds = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Maps"
        
        toSelectedName = "Center of United States"
        
        latitude = 39.8283
        longitude = -98.5795
        
        //set up search bar
        searchVC.searchBar.backgroundColor = .black
        searchVC.searchResultsUpdater = self
        //searchVC.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchVC
        
        //set up location permission
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //set up initial map location
        bounds = mapView.bounds
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: self.zoom)
        //self.map.delegate = self
        let map = GMSMapView.map(withFrame: mapView.bounds, camera: camera)
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        self.view = mapView
        self.view.addSubview(map)
        self.view.addSubview(getDirectionsButton)
    }
    
    //update viewing latitude when user moves map camera
//    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
//        latitude = position.target.latitude
//        longitude = position.target.longitude
//        toSelectedName = String(format: "latitude: %.3f, longitude: %.3f", latitude, longitude)
//
//        print(position.target)
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLatitude = locValue.latitude
        currentLongitude = locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    //handles search results
    func updateSearchResults(for searchController: UISearchController) {
        print("in mapviewcontroller updateSearchResults")
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? ResultsViewController else {
            return
        }
        
        resultsVC.delegate = self
        
        GooglePlacesManager.shared.findPlaces(query: query) { result in
            switch result {
            case .success(let places):
                DispatchQueue.main.async {
                    resultsVC.update(with: places)
                    print("after")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
 }

extension MapViewController: ResultsViewControllerDelegate {
    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        print("mapviewcontroller: didTapPlace")
        //put keyboard down
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        
        latitude = coordinates.latitude
        longitude = coordinates.longitude
        //toSelectedName = String(format: "lat: %.3f, long: %.3f", latitude, longitude)
        zoom = Float(18.0)
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let map = GMSMapView.map(withFrame: bounds, camera: camera)
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        self.view = mapView
        self.view.addSubview(map)
        self.view.addSubview(getDirectionsButton)
    }
}

