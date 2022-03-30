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
    @IBOutlet weak var originAdd: UITextField!
    @IBOutlet weak var destAdd: UITextField!
    @IBOutlet weak var dateAdd: UITextField!
    
    var flight: Flight?
    var originAddString: String = ""
    var destAddString: String = ""
    var dateAddString: String = ""
    
    
    override func viewDidLoad() {
        // Here we replace the default values
        origin.text = flight?.origin
        destination.text = flight?.dest
        dateChange.text = flight?.date
    }
    
}
