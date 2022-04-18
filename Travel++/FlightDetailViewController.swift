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
    @IBOutlet var status: UILabel!
    @IBOutlet var delay: UILabel!
    var flightNo = ""
    
    var flight: Flight?
    @IBOutlet var editButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    
    override func viewDidLoad() {
        // Here we replace the default values
        origin.text = flight?.origin
        destination.text = flight?.dest
        dateChange.text = flight?.date
        status.text = flight?.status
        flightNo = flight?.flightNo ?? "Unknown"
        print("FlightNo = \(flightNo)")
        let d = Int(flight!.delay)! / 60
        if d < 0 {
            delay.text = "Early: " + String(-d) + " minutes"
        }
        else {
            delay.text = "Delay: " + String(d) + " minutes"
        }
    }
    
    @IBAction func editButtonTriggered(_ sender: UIButton) {
        print("clicked edit")
    }
    
    @IBAction func deleteButtonTriggered(_ sender: UIButton) {
        print("clicked delete")
        
        // get current user
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            print("User signed in")
            
            // remove trip from database
            //database.child("users/\(uid)/flights/\(flightNo)").removeValue()
            
            let flightsRef = self.database.child("users/\(uid)/flights")
            let query = flightsRef.queryOrdered(byChild: "flightNo").queryEqual(toValue: flightNo)
            query.observeSingleEvent(of: .value, with: {snapshot in
                if !snapshot.exists() {
                    print("flight not found")
                } else {
                    print("flight found")
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let dict = snap.value as! [String: Any]
                        let flightKey = snap.key
                        
                        self.database.child("users/\(uid)/flights/\(flightKey)").removeValue()
                    }
                }
            })
            
        } else {
            print("No user signed in")
        }
        
    }
}
