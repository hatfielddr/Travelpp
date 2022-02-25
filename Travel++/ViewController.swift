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
        
        // *** FIREBASE TEST QUERIES ***
        /*let ref = Database.database().reference()
        ref.child("someid/name").setValue("User2")
        
        // add Chicago O'Hare International Airport
        ref.child("airports").childByAutoId().setValue(["airport_id":"00002", "city":"Chicago", "current_flights":"00002", "name":"Chicago O'Hare International Airport", "short_name":"ORD", "state":"Illinois" ])
        
        // update Flight 00001 airline from United to Southwest
        ref.child("flights/00001/airline").setValue("Southwest")
        
        // change Manager 0002's airport from IND to ORD
        ref.child("managers/0002/airport").setValue("ORD")
        
        // delete restaurant 00002
        ref.child("restaurants/00002").removeValue()
        
        // add new user review
        ref.child("reviews").childByAutoId().setValue(["review_id":"00003", "user_id":"0001", "restaurant_id":"00001", "description":"My favorite place to eat!", "rating":"5.0"])
        
        // update user 0001's password
        ref.child("users/0001/password").setValue("safe_password")*/
    }

}
