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

class MapViewController: UIViewController, UISearchResultsUpdating, CLLocationManagerDelegate {

    @IBOutlet weak var zoomIn: UIButton!
    @IBOutlet weak var zoomOut: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var getDirectionsButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    let searchVC = UISearchController(searchResultsController: ResultsViewController())
    let locationManager = CLLocationManager()

    var zoom = Float(4.0)
    var center = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Maps"
        
        selectedName = "Center of United States (0.0, 0.0)"
        
        latitude = 39.8283
        longitude = -98.5795
        
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
        reload()
    }
    
    //fix this: make sure the center of the map is constantly being updated with movements
    //which then set the latitude and longitude
    func mapView(mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        center = mapView.centerCoordinate
        print("Latitude: \(center.latitude), Longitude: \(center.longitude)")
    }
    
    func reload() {
        self.view.addSubview(zoomIn)
        self.view.addSubview(zoomOut)
        self.view.addSubview(currentLocationButton)
        self.view.addSubview(getDirectionsButton)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        currentLatitude = locValue.latitude
        currentLongitude = locValue.longitude
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    @IBAction func currentLocation(_ sender: Any) {
        var coordinate = CLLocationCoordinate2D()
        coordinate.latitude = currentLatitude
        coordinate.longitude = currentLongitude
        didTapPlace(with: coordinate)
    }
    
    @IBAction func ZoomIn(_ sender: Any) {
        zoom += 1
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let map = GMSMapView.map(withFrame: mapView.bounds, camera: camera)
        self.view.addSubview(map)
        reload()
    }
    
    @IBAction func ZoomOut(_ sender: Any) {
        zoom -= 1
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: zoom)
        let map = GMSMapView.map(withFrame: mapView.bounds, camera: camera)
        self.view.addSubview(map)
        reload()
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
        self.view.addSubview(map)
        reload()
    }
}
