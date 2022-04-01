//
//  FlightAddViewController.swift
//  Travel++
//
//  Created by csuser on 3/29/22.
//

import UIKit

class FlightAddViewController: UIViewController {
    
    @IBOutlet var flightAirline: UITextField!
    @IBOutlet var flightId: UITextField!
    @IBOutlet var flightOrigin: UITextField!
    
    var flightAirlineString: String = ""
    var flightIdString: String = ""
    var flightOriginString: String = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            flightAirlineString = flightAirline.text!
            flightIdString = flightId.text!
            flightOriginString = flightOrigin.text!
        }
    }
}
