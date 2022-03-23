//
//  RestaurantViewController.swift
//  Travel++
//
//  Created by csuser on 2/22/22.
//

import UIKit
import CDYelpFusionKit
import SwiftUI
import FirebaseDatabase

let yelpAPIClient = CDYelpAPIClient(apiKey: "5L45BSRF7lJZ1d0A7bYQo9SGHYTIay2ccCmIV3mO6WUEzgoLEJeP4yuvz9VCvBF86mZpT76M7XyYIOC7SLHX8qCB4PVagiMWiKewOojJeAvsHVOZBiXxoAWtKbcXYnYx")
let numListings = 9
let location = "San Francisco"



let ref = Database.database().reference()


// List is created here with 9 default values otherwise the app has a fit for some reason
var restaurantList = [Restaurant](repeating: Restaurant(name: "", rating: 0), count: numListings)

class RestaurantListViewController: UITableViewController {
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var viewFavButton: UIButton!
    
    @IBAction func viewFavButtonTriggered(_ sender: UIButton) {
        self.performSegue(withIdentifier: "FavsSegue", sender: self)
    }
    override func viewDidLoad() {
        // Here we replace the default values
        getData()
        locationLabel.text = location
    }
    
    func getData() {
        let group = DispatchGroup()
        
        group.enter()
        // MARK: API Call
        // Cancel any API requests previously made
        yelpAPIClient.cancelAllPendingAPIRequests()
        // Query Yelp Fusion API for business results
        yelpAPIClient.searchBusinesses(byTerm: "Food",
                                       location: location,
                                       latitude: nil,
                                       longitude: nil,
                                       radius: 10000,
                                       categories: [.activeLife, .food],
                                       locale: .english_unitedStates,
                                       limit: numListings,
                                       offset: 0,
                                       sortBy: .distance,
                                       priceTiers: [.oneDollarSign, .twoDollarSigns],
                                       openNow: true,
                                       openAt: nil,
                                       attributes: nil) { (response) in

            if let response = response,
              let businesses = response.businesses,
              businesses.count > 0 {
              print("\n\n\n\n")
              var count = 0
              for business in businesses {
                  restaurantList[count] = Restaurant(name: business.name!, rating: business.rating!, isFavorite: false)
                  count += 1
              }
                group.leave()
          }
        }
        
        // This segment refreshes the table AFTER the API call is done
        group.notify(queue: .main, execute: {
            print("Going to Refresh")
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
    }
}

extension RestaurantListViewController {
    static let restaurantListCellIdentifier = "RestaurantListCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.restaurantListCellIdentifier, for: indexPath) as? RestaurantListCell else {
            fatalError("Unable to dequeue RestaurantCell")
        }
        let restaurant = restaurantList[indexPath.row]
        let image = restaurant.isFavorite ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        cell.nameLabel.text = restaurant.name
        cell.ratingLabel.text = String(format: "%.1f", restaurant.rating)
        cell.faveButton.setBackgroundImage(image, for: .normal)
        cell.faveButtonAction = {
            restaurantList[indexPath.row].isFavorite.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
            let str = String(indexPath.row)
            let indexStr = "rest" + str
            if (restaurant.isFavorite == false) {
                ref.child("bookmarkedRestaurants/name").child(indexStr).setValue(restaurant.name)
            }
            if (restaurant.isFavorite == true) {
                ref.child("bookmarkedRestaurants/name").child(indexStr).setValue(nil)
            }
        }
        return cell
    }
}
