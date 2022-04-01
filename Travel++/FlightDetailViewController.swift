//
//  FlightDetailViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/23/22.
//

import UIKit
import Firebase
import FirebaseAuthUI

class FlightDetailViewController: UIViewController {
    typealias EditButtonAction = () -> Void
    typealias DeleteButtonAction = () -> Void
    
    var editButtonAction: EditButtonAction?
    var deleteButtonAction: DeleteButtonAction?
    
    let database = Database.database().reference()
    
    @IBOutlet var origin: UILabel!
    @IBOutlet var destination: UILabel!
    @IBOutlet var dateChange: UILabel!
    
    var flight: Flight?
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    override func viewDidLoad() {
        // Here we replace the default values
        origin.text = flight?.origin
        destination.text = flight?.dest
        dateChange.text = flight?.date
    }
    
    @IBAction func editButtonTriggered(_ sender: UIButton) {
        print("clicked edit")
    }
    
    @IBAction func deleteButtonTriggered(_ sender: UIButton) {
        print("clicked delete")
        
        // get flight ID
        let flight_id = "UA4417"
        
        // get current user
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            print("User signed in")
            
            // remove trip from database
            database.child("users/\(uid)/flights/\(flight_id)").removeValue()
            
        } else {
            print("No user signed in")
        }
        
    }
}
