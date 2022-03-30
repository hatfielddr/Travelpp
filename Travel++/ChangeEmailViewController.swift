//
//  ChangeEmailViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/29/22.
//

import UIKit
import Firebase

class ChangeEmailViewController: UIViewController {
    
    var delegate: UpdateEmail?
    
    @IBOutlet weak var new_email: UITextField!
    
    @IBOutlet weak var successMsg: UILabel!
    @IBOutlet weak var submit: UIButton!
    @IBAction func submitTriggered(_ sender: UIButton) {
        
        ref.child("users").child(user_id).child("email").setValue(self.new_email.text!)
        
        delegate?.updateEmail(newEmail: self.new_email.text!)
        self.new_email.text = ""
        successMsg.isHidden = false
    }
    
    override func viewDidLoad() {
        
        successMsg.isHidden = true
    }
}

