//
//  FavoritesListViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 2/24/22.
//

import UIKit
import SwiftUI
import FirebaseDatabase
import FirebaseAuthUI


var favNameList = [String](repeating: String(""), count: 0)

class FavoritesListViewController: UITableViewController {
    
    let nameRef = ref.child("bookmarkedRestaurants").child("name")
    
    override func viewDidLoad() {
        // Here we replace the default values
        getFavorites()
        self.tableView.reloadData()
    }
    
    func getFavorites() {
        let group = DispatchGroup()
        favNameList = [String](repeating: String(""), count: 0)
        group.enter()
        
        // get current bookmarked restaurants from database
        var userID = ""
        let user = Auth.auth().currentUser
        if let user = user { userID = user.uid }
        else { return }
        let nameRef = ref.child("users/\(userID)/bookmarkedRestaurants")
        nameRef.observe(.value, with: { snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let restaurantName = snap.value as! String
                favNameList.append(restaurantName)
            }
        })
        group.leave()
        group.notify(queue: .main, execute: {
            print("Going to Refresh")
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
    }
    
    func getData() {
        let group = DispatchGroup()
        
        group.enter()
        nameRef.observe(.value, with: { snapshot in
            
            if let unfiltArray = snapshot.value as? [String : String] {
                var filtArray: [String] = []
            
                for element in unfiltArray {
                    filtArray.append(element.value)
                }
                print(unfiltArray)
                print(filtArray)
            
                favNameList = filtArray
            } else {
                print("empty")
                favNameList = [""]
            }
            
            
        
        }, withCancel: nil)
        group.leave()
        
        
        group.notify(queue: .main, execute: {
            print("Going to Refresh")
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        })
                
    }
}

extension FavoritesListViewController {
    static let favListCellIdentifier = "FavoritesListCell"
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favNameList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Self.favListCellIdentifier,
                                        for: indexPath) as? FavoritesListCell else {
            fatalError("Unable to dequeue FavoriteCell")
        }
        let favs = favNameList[indexPath.row]
        cell.favName.text = favs
        return cell
    }
}
