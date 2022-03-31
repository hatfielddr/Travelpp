//
//  LoginController.swift
//  Travel++
//
//  Created by Tori Duguid on 2/19/22.
//

import UIKit
import Firebase
import FirebaseAuthUI

var handle: AuthStateDidChangeListenerHandle?

var user_id = ""
var fname = ""
var lname = ""
var full_name = ""
var user_email = ""

class LoginController: UIViewController {
    typealias DoneButtonAction = () -> Void
    typealias SignUpButtonAction = () -> Void
    
    var doneButtonAction: DoneButtonAction?
    var signUpButtonAction: SignUpButtonAction?
    
    let database = Database.database().reference()
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    //@IBOutlet var password: UITextInputPasswordRules!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet weak var errMsg: UILabel!
    
    @IBAction func doneButtonTriggered(_ sender: UIButton) {
        self.errMsg.isHidden = true
        
        // sign in user
        Auth.auth().signIn(withEmail: username.text!, password: password.text!)
        
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
            self.errMsg.isHidden = false
            self.username.text = ""
            self.password.text = ""
            print("invalid password")
        }
        
        // sign out user (for testing purposes; keep commented out unless needed)
        /*do {
            try Auth.auth().signOut()
            print("signed out")
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }*/
    }
    
    @IBAction func signUpButtonTriggered(_ sender: UIButton) {
        // Get our main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Instantiate ViewController with the ID "ViewController" (needs to be set
        // within the main storyboard file. Click desired view controller and set
        // "Storyboard ID" in the far right menus accordingly
        let mainController = storyboard.instantiateViewController(withIdentifier: "SignUpController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
      }

    override func viewDidLoad() {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
            print("User signed in")
            print(uid)
            print(email)
        } else {
            print("No user signed in")
        }
        
        errMsg.isHidden = true
    }

}
