//
//  FlightDetailViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/23/22.
//

import UIKit

class FlightDetailViewController: UIViewController {
    
    @IBOutlet var origin: UILabel!
    
    @IBOutlet var destination: UILabel!
    
    @IBOutlet var dateChange: UILabel!
    
    var flight: Flight?
    
    
    override func viewDidLoad() {
        // Here we replace the default values
        origin.text = flight?.origin
        destination.text = flight?.dest
        dateChange.text = flight?.date
    }
    
    
}
