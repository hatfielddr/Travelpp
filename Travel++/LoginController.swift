//
//  LoginController.swift
//  Travel++
//
//  Created by Tori Duguid on 2/19/22.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    typealias DoneButtonAction = () -> Void
    
    var doneButtonAction: DoneButtonAction?
    
    let database = Database.database().reference()
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    //@IBOutlet var password: UITextInputPasswordRules!
    @IBOutlet var loginButton: UIButton!
    
    @IBAction func doneButtonTriggered(_ sender: UIButton) {
        
        // check for username and password validity with database
        let usersRef = self.database.child("users")
        let query = usersRef.queryOrdered(byChild: "email").queryEqual(toValue: self.username.text!)
        query.observeSingleEvent(of: .value, with: {snapshot in
            if !snapshot.exists() {
                print("invalid email") /// #TODO add invalid email handling here
            } else {
                // found user with matching email; get user's password from database
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let dict = snap.value as! [String: Any]
                    let password = dict["password"] as! String
                    
                    // check that the input password matches the database password
                    if password == self.password.text! {
                        // password matches; proceed to map view
                        //self.performSegue(withIdentifier: "MapSegue", sender: nil)
                        
                        // Get our main storyboard
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        // Instantiate ViewController with the ID "ViewController" (needs to be set
                        // within the main storyboard file. Click desired view controller and set
                        // "Storyboard ID" in the far right menus accordingly
                        let mainController = storyboard.instantiateViewController(withIdentifier: "ViewController")
                        
                        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainController)
                    } else {
                        print("invalid password") /// #TODO add invalid password handling here
                    }
                }
            }
        })
    }
}
