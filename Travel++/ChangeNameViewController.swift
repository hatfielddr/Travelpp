//
//  ChangeNameViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/29/22.
//

import UIKit
import Firebase
import FirebaseAuthUI

class ChangeNameViewController: UIViewController {
    
    var delegate: UpdateName?
    
    @IBOutlet weak var successMsg: UILabel!
    @IBOutlet weak var first_name: UITextField!
    @IBOutlet weak var last_name: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    @IBAction func submitTriggered(_ sender: UIButton) {
        var user_id = ""
        
        let user = Auth.auth().currentUser
        if let user = user {
            user_id = user.uid
        } else {
            print("No user signed in")
        }
        
        var f_name = ""
        var l_name = ""
        
        if (self.last_name.text == "") {
            ref.child("users/\(user_id)").updateChildValues(["first_name": self.first_name.text!])
            f_name = self.first_name.text!
            l_name = lname
        } else if (self.first_name.text == "") {
            ref.child("users/\(user_id)").updateChildValues(["last_name": self.last_name.text!])
            f_name = fname
            l_name = self.last_name.text!
        } else {
            ref.child("users/\(user_id)").updateChildValues(["first_name": self.first_name.text!, "last_name": self.last_name.text!])
            f_name = self.first_name.text!
            l_name = self.last_name.text!
        }
        
        let full_name = f_name + " " + l_name
        
        delegate?.updateName(newName: full_name)
        self.first_name.text = ""
        self.last_name.text = ""
        successMsg.isHidden = false
    }
    
    override func viewDidLoad() {
        successMsg.isHidden = true
    }
}
