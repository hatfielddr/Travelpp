//
//  DirectionsViewController.swift
//  Travel++
//
//  Created by Emily Blanchard on 3/30/22.
//

import UIKit
import MapKit

class DirectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate, UISearchBarDelegate {
    @IBOutlet weak var toSearchBar: UISearchBar!
    @IBOutlet weak var fromSearchBar: UISearchBar!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet var directionsTable: UITableView!
    
    var stepsArray = [String]()
    var distancesArray = [MKRoute.Step]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        toSearchBar.delegate = self
        fromSearchBar.delegate = self
        
        toSearchBar.placeholder = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)).name
        fromSearchBar.placeholder = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)).name
        
        pullDirections()
        
        self.directionsTable.dataSource = self;
        self.directionsTable.delegate = self;
    }
    
    //convert from meters to miles
    func getMiles(meters: Double) -> Double {
         return meters * 0.000621371192
    }
    
    //clear directions results
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    
    //pull directions from apple maps for given source/destination
    func pullDirections() {
        //set start and end points from coordinates
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude))
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))

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
}
