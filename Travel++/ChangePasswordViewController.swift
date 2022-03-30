//
//  ChangePasswordViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/28/22.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var old_pass: UITextField!
    @IBOutlet weak var new_pass: UITextField!
    
    @IBOutlet weak var submit: UIButton!
    
    @IBOutlet weak var successMsg: UILabel!
    
    @IBOutlet weak var failMsg: UILabel!
    @IBAction func submitTriggered(_ sender: UIButton) {
        successMsg.isHidden = true
        failMsg.isHidden = true
        let usersRef = ref.child("users")
        let query = usersRef.queryOrdered(byChild: "user_id").queryEqual(toValue: user_id)
        
        query.observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: Any]
                let password = dict["password"] as! String
            
                // check that the input password matches the database password
                if password == self.old_pass.text! {
                    
                    ref.child("users").child(user_id).child("password").setValue(self.new_pass.text!)
                    
                    self.old_pass.text = ""
                    self.new_pass.text = ""
                    
                    self.successMsg.isHidden = false
                
                } else {
                    print("invalid password") /// #TODO add invalid password handling here
                    self.old_pass.text = ""
                    self.new_pass.text = ""
                    self.failMsg.isHidden = false
                }
            }
            
        })
        
        
    }
    
    override func viewDidLoad() {
        
        successMsg.isHidden = true
        failMsg.isHidden = true
    }
}