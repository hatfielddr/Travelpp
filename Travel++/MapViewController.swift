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

//var bounds = CGRect()

class MapViewController: UIViewController, UISearchResultsUpdating, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet var mapView: UIView!
    @IBOutlet weak var getDirectionsButton: UIButton!
    
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    let locationManager = CLLocationManager()

    var zoom = Float(4.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Maps"
        
        toSelectedName = "Center of the US"
        
        latitude = 39.8283
        longitude = -98.5795
        
        //bounds = mapView.bounds
        
        //set up search bar
        searchVC.searchBar.backgroundColor = .black
        searchVC.searchResultsUpdater = self
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
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: self.zoom)
        let map = GMSMapView.map(withFrame: mapView.bounds, camera: camera)
        
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        
        self.view = mapView
        self.view.addSubview(map)
        self.view.addSubview(getDirectionsButton)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLatitude = locValue.latitude
        currentLongitude = locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func updateSearchResults(for searchController: UISearchController) {
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
                }
            case .failure(let error):
                print(error)
            }
        }
    }
 }

extension MapViewController: ResultsViewControllerDelegate {
    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        //put keyboard down
        searchVC.searchBar.resignFirstResponder()
        searchVC.dismiss(animated: true, completion: nil)
        
        latitude = coordinates.latitude
        longitude = coordinates.longitude
        zoom = Float(18.0)
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let map = GMSMapView.map(withFrame: mapView.bounds, camera: camera)
        
        map.isMyLocationEnabled = true
        map.settings.myLocationButton = true
        
        self.view.addSubview(map)
        self.view.addSubview(getDirectionsButton)
    }
}

