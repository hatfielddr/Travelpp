//
//  DirectionsViewController.swift
//  Travel++
//
//  Created by Emily Blanchard on 3/30/22.
//

import UIKit
import MapKit

class DirectionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate {
    
    @IBOutlet var directionsTable: UITableView!
    var steps = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        pullDirections()
        
        self.directionsTable.dataSource = self;
        self.directionsTable.delegate = self;
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        print("gone")
        steps = []
        
        //call function to clear directionsTable
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                steps.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    
    func pullDirections() {
    
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude))
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)

        directions.calculate { response, error in
              guard let route = response?.routes.first else { return }
//              mapView.addAnnotations([p1, p2])
//              mapView.addOverlay(route.polyline)
//              mapView.setVisibleMapRect(
//                route.polyline.boundingMapRect,
//                edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
//                animated: true)
            self.steps = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
            print(self.steps)
            self.directionsTable.reloadData()
        }
    }

    func tableView(_ tableView: UITableView,
        cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let cell = directionsTable.dequeueReusableCell(withIdentifier: "StepCell") {
            cell.textLabel!.numberOfLines = 0
            cell.textLabel!.lineBreakMode = .byWordWrapping
            cell.textLabel!.font = UIFont.systemFont(ofSize: 14.0)
            cell.textLabel!.text = steps[indexPath.row]
            return cell
            
        } else {
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Use length of array a stable row count.
        return steps.count
    }
}
