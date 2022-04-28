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
    @IBOutlet weak var term_org: UILabel!
    @IBOutlet weak var gate_org: UILabel!
    @IBOutlet weak var term_dest: UILabel!
    @IBOutlet weak var gate_dest: UILabel!
    @IBOutlet weak var sch_out: UILabel!
    @IBOutlet weak var sch_off: UILabel!
    @IBOutlet weak var sch_on: UILabel!
    @IBOutlet weak var sch_in: UILabel!
    @IBOutlet weak var baggage: UILabel!
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
        if (flight?.delay != "") {
        let d = Int(flight!.delay)! / 60
        if d < 0 {
            delay.text = "Early: " + String(-d) + " minutes"
        }
        else {
            delay.text = "Delay: " + String(d) + " minutes"
        }
        }
        sch_out.text = flight?.scheduled_out
        sch_off.text = flight?.scheduled_out
        sch_on.text = flight?.scheduled_on
        sch_in.text = flight?.scheduled_in
        let terminal_origin_val = flight?.terminal_origin
        if (terminal_origin_val == "") {
            term_org.text = "N/A"
        } else {
            term_org.text = terminal_origin_val
        }
        let gate_org_val = flight?.gate_origin
        if (gate_org_val == "") {
            gate_org.text = "N/A"
        } else {
            gate_org.text = gate_org_val
        }
        let term_dest_val = flight?.terminal_dest
        if (term_dest_val == "") {
            term_dest.text = "N/A"
        } else {
            term_dest.text = term_dest_val
        }
        let gate_dest_val = flight?.gate_dest
        if (gate_dest_val == "") {
            gate_dest.text = "N/A"
        } else {
            gate_dest.text = gate_dest_val
        }
        let baggage_val =  flight?.baggage_claim
        if (baggage_val == "") {
            baggage.text = "N/A"
        } else {
            baggage.text = baggage_val
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
