//
//  ChangeEmailViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/29/22.
//

import UIKit
import Firebase
import FirebaseAuthUI

class ChangeEmailViewController: UIViewController {
    
    var delegate: UpdateEmail?
    
    @IBOutlet weak var new_email: UITextField!
    
    @IBOutlet weak var successMsg: UILabel!
    @IBOutlet weak var submit: UIButton!
    
    @IBAction func submitTriggered(_ sender: UIButton) {
        Auth.auth().currentUser?.updateEmail(to: self.new_email.text!) { error in
            self.completeUpdateEmail()
        }
    }
    
    func completeUpdateEmail() {
        var user_id = ""
        
        let user = Auth.auth().currentUser
        if let user = user {
            user_id = user.uid
        } else {
            print("No user signed in")
        }
        
        ref.child("users/\(user_id)").updateChildValues(["email": self.new_email.text!])
        
        delegate?.updateEmail(newEmail: self.new_email.text!)
        self.new_email.text = ""
        successMsg.isHidden = false
    }
    
    override func viewDidLoad() {
        
        successMsg.isHidden = true
    }
}

