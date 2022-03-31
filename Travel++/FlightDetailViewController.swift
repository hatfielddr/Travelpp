//
//  FlightDetailViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/23/22.
//

import UIKit
import Firebase

class FlightDetailViewController: UIViewController {
    typealias EditButtonAction = () -> Void
    typealias DeleteButtonAction = () -> Void
    
    var editButtonAction: EditButtonAction?
    var deleteButtonAction: DeleteButtonAction?
    
    let database = Database.database().reference()
    
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
        //ref.child("restaurants/00002").removeValue()
        
    }
}
