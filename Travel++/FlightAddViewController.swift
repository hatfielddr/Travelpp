//
//  FlightAddViewController.swift
//  Travel++
//
//  Created by csuser on 3/29/22.
//

import UIKit

class FlightAddViewController: UIViewController {
    
    @IBOutlet var originAdd: UITextField!
    @IBOutlet var destAdd: UITextField!
    @IBOutlet var dateAdd: UITextField!
    
    var originAddString: String = ""
    var destAddString: String = ""
    var dateAddString: String = ""
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSegue" {
            originAddString = originAdd.text!
            destAddString = destAdd.text!
            dateAddString = dateAdd.text!
        }
    }
}
