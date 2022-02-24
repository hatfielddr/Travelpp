//
//  RestaurantViewController.swift
//  Travel++
//
//  Created by csuser on 2/22/22.
//

import UIKit
import CDYelpFusionKit
import SwiftUI

let yelpAPIClient = CDYelpAPIClient(apiKey: "7sugvLP78ErxaxiLRaRdJMjOwRc_kjl6A5we3iUPiwIDW7CWl-ZNCLdUsGKmvnYqPyd9tzFMhPy7tFQIgoMbWgNnUriYV3vH7Cf4xtFRLLCE6to3nH6ryolQoroXYnYx")

// List is created here with 9 default values otherwise the app has a fit for some reason
var restaurantList = [Restaurant](repeating: Restaurant(name: ""), count: 9)

class RestaurantListViewController: UITableViewController {
    override func viewDidLoad() {
        // Here we replace the default values
        getData()
    }
    
    func getData() {
        let group = DispatchGroup()
        
        group.enter()
        // MARK: API Call
        // Cancel any API requests previously made
        yelpAPIClient.cancelAllPendingAPIRequests()
        // Query Yelp Fusion API for business results
        yelpAPIClient.searchBusinesses(byTerm: "Food",
                                       location: "San Francisco",
                                       latitude: nil,
                                       longitude: nil,
                                       radius: 10000,
                                       categories: [.activeLife, .food],
                                       locale: .english_unitedStates,
                                       limit: 9,
                                       offset: 0,
                                       sortBy: .rating,
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
                  restaurantList[count] = Restaurant(name: business.name!, isFavorite: false)
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
        let image = restaurant.isFavorite ? UIImage(systemName: "circle.fill") : UIImage(systemName: "circle")
        cell.nameLabel.text = restaurant.name
        cell.faveButton.setBackgroundImage(image, for: .normal)
        cell.faveButtonAction = {
            restaurantList[indexPath.row].isFavorite.toggle()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        return cell
    }
}
