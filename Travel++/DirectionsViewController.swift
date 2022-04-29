//
//  DirectionsViewController.swift
//  Travel++
//
//  Created by Emily Blanchard on 3/30/22.
//

import UIKit
import MapKit

var toSearch = false
var fromSearch = false

class DirectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet var directionsTable: UITableView!
    @IBOutlet weak var toSearchView: UIView!
    @IBOutlet weak var fromSearchView: UIView!
    
    var toLatitude = Double()
    var fromLatitude = Double()
    var toLongitude = Double()
    var fromLongitude = Double()
    
    var stepsArray = [String]()
    var distancesArray = [MKRoute.Step]()
    
    let searchVC1 = UISearchController(searchResultsController: DirectionsResultsViewController())
    let searchVC2 = UISearchController(searchResultsController: DirectionsResultsViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Directions"
        
        toLatitude = latitude
        fromLatitude = currentLatitude
        toLongitude = longitude
        fromLongitude = currentLongitude
        
        searchVC1.searchResultsUpdater = self
        searchVC1.searchBar.delegate = self
        searchVC1.searchBar.placeholder = toSelectedName
        searchVC1.hidesNavigationBarDuringPresentation = false
        searchVC1.isActive = true
        searchVC1.hidesNavigationBarDuringPresentation = false
        
        searchVC2.searchResultsUpdater = self
        searchVC2.searchBar.delegate = self
        searchVC2.searchBar.placeholder = "Current Location"
        searchVC2.hidesNavigationBarDuringPresentation = false
        searchVC2.isActive = true
        searchVC2.hidesNavigationBarDuringPresentation = false
        
        toSearchView.addSubview(searchVC1.searchBar)
        fromSearchView.addSubview(searchVC2.searchBar)

        pullDirections(fromLatitude: fromLatitude, fromLongitude: fromLongitude, toLatitude: toLatitude, toLongitude: toLongitude)
        
        self.directionsTable.dataSource = self;
        self.directionsTable.delegate = self;
    }
    
    //need to figure out issue with closing search bar
    //need to figure out placeholder with using MapViewController first
    override func viewDidDisappear(_ animated: Bool) {
        print("in viewDidDisappear")
        
        toSearch = false
        searchVC1.searchBar.resignFirstResponder()
        searchVC1.dismiss(animated: true, completion: nil)
        
        fromSearch = false
        searchVC2.searchBar.resignFirstResponder()
        searchVC2.dismiss(animated: true, completion: nil)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("in searchBarCancelButtonClicked")
        
        if (searchBar == searchVC1) {
            print("canceled toSearch")
            toSearch = false
            searchVC1.searchBar.resignFirstResponder()
            searchVC1.dismiss(animated: true, completion: nil)
        }
        
        if (searchBar == searchVC2) {
            print("canceled fromSearch")
            fromSearch = false
            searchVC2.searchBar.resignFirstResponder()
            searchVC2.dismiss(animated: true, completion: nil)
        }
    }
    
    //convert from meters to miles
    func getMiles(meters: Double) -> Double {
         return meters * 0.000621371192
    }
    
    @IBAction func searchDirections(_ sender: Any) {
        pullDirections(fromLatitude: fromLatitude, fromLongitude: fromLongitude, toLatitude: toLatitude, toLongitude: toLongitude)
    }
    
    //clear directions results
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    
    //pull directions from apple maps for given source/destination
    func pullDirections(fromLatitude: Double, fromLongitude: Double, toLatitude: Double, toLongitude: Double) {
        //set start and end points from coordinates
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: fromLatitude, longitude: fromLongitude))
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: toLatitude, longitude: toLongitude))

        //create request to pull directions from p1 to p2
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        
        //pull directions
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            print(route.steps.map { $0.instructions }.filter { !$0.isEmpty })
            self.stepsArray = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
            self.distancesArray = route.steps
 
            //print(self.steps)
            self.directionsTable.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = directionsTable.dequeueReusableCell(withIdentifier: "StepCell") as? StepTableViewCell {

            let step = stepsArray[indexPath.row]
            let distance = distancesArray[indexPath.row].distance
            cell.stepLabel!.lineBreakMode = .byWordWrapping
            cell.stepLabel?.text = step
            cell.distanceLabel?.text = String(format: "%.1f", getMiles(meters: distance))
        
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Use length of array a stable row count.
        return stepsArray.count
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("in updateSearchResults")
        
        if (searchController == searchVC1) {
            toSearch = true
        }
        
        if (searchController == searchVC2) {
            fromSearch = true
        }
        
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              let resultsVC = searchController.searchResultsController as? DirectionsResultsViewController else {
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

extension DirectionsViewController: DirectionsResultsViewControllerDelegate {
    func didTapPlace(with coordinates: CLLocationCoordinate2D) {
        print("in didTapPlace")
        //put keyboard down
        if (toSearch == true) {
            print("toSearch == true")
            toLatitude = coordinates.latitude
            toLongitude = coordinates.longitude
            searchVC1.searchBar.resignFirstResponder()
            searchVC1.dismiss(animated: true, completion: nil)
            searchVC1.searchBar.text = toSelectedName
            toSearch = false
        }
        
        else if (fromSearch == true) {
            print("fromSearch == true")
            fromLatitude = coordinates.latitude
            fromLongitude = coordinates.longitude
            searchVC2.searchBar.resignFirstResponder()
            searchVC2.dismiss(animated: true, completion: nil)
            searchVC2.searchBar.text = fromSelectedName
            fromSearch = false
        }
    }
}
