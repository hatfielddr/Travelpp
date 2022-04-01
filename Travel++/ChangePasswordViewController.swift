//
//  ChangePasswordViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/28/22.
//

import UIKit
import Firebase
import FirebaseAuthUI

class ChangePasswordViewController: UIViewController {
    
    @IBOutlet weak var new_pass: UITextField!
    
    @IBOutlet weak var submit: UIButton!
    
    @IBOutlet weak var successMsg: UILabel!
    
    @IBOutlet weak var failMsg: UILabel!
    @IBAction func submitTriggered(_ sender: UIButton) {
        successMsg.isHidden = true
        failMsg.isHidden = true
        
        Auth.auth().currentUser?.updatePassword(to: self.new_pass.text!) { error in
            if let error = error {
                print("***update password error***")
                print(error)
                self.new_pass.text = ""
                self.failMsg.isHidden = false
                print("***end update password error***")
            } else {
                self.new_pass.text = ""
                self.successMsg.isHidden = false
                print("changed password successfully")
            }
        }
        
        // get current user's id
        /*var user_id = ""
        let user = Auth.auth().currentUser
        if let user = user {
            user_id = user.uid
        } else {
            print("No user signed in")
        }
        
        let usersRef = ref.child("users")
        let query = usersRef.queryOrdered(byChild: "user_id").queryEqual(toValue: user_id)
        
        query.observeSingleEvent(of: .value, with: {snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let dict = snap.value as! [String: Any]
                let password = dict["password"] as! String
            
                // check that the input password matches the database password
                if password == self.old_pass.text! {
                    self.old_pass.text = ""
                    self.new_pass.text = ""
                    
                    self.successMsg.isHidden = false
                    
                    Auth.auth().currentUser?.updatePassword(to: password) { error in
                        
                    }
                    print("changed password")
                } else {
                    print("invalid password")
                    self.old_pass.text = ""
                    self.new_pass.text = ""
                    self.failMsg.isHidden = false
                }
            }
        })*/
    }
    
    override func viewDidLoad() {
        successMsg.isHidden = true
        failMsg.isHidden = true
    }
}
