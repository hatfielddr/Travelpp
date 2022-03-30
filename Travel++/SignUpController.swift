//
//  SignUpController.swift
//  Travel++
//
//  Created by Drew Hatfield on 3/22/22.
//

import UIKit
import Firebase
import FirebaseAuthUI

class SignUpController: UIViewController {
    typealias SignUpButtonAction = () -> Void
    
    var signUpButtonAction: SignUpButtonAction?
    
    let database = Database.database().reference()
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    //@IBOutlet var password: UITextInputPasswordRules!
    @IBOutlet var signUpButton: UIButton!
    
    @IBAction func signUpButtonTriggered(_ sender: UIButton) {
        // register new user in database
        Auth.auth().createUser(withEmail: username.text!, password: password.text!)
        
        // print uid and email, for testing purposes
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            print(uid)
            print(email)
        }
        
        if Auth.auth().currentUser != nil {
            // User is signed in; go to main view
            print("signed in")
            
            // Get our main storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // Instantiate ViewController with the ID "ViewController" (needs to be set
            // within the main storyboard file. Click desired view controller and set
            // "Storyboard ID" in the far right menus accordingly
            let mainController = storyboard.instantiateViewController(withIdentifier: "ViewController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainController)
        } else {
            // No user is signed in
            print("not signed in")
        }
        
        // sign out user (for testing purposes; keep commented out unless needed)
        do {
            try Auth.auth().signOut()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
}
