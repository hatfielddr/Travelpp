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
    typealias BackButtonAction = () -> Void
    
    var signUpButtonAction: SignUpButtonAction?
    var backButtonAction: BackButtonAction?
    
    let database = Database.database().reference()
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    //@IBOutlet var password: UITextInputPasswordRules!
    @IBOutlet var signUpButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    @IBOutlet weak var errMsg: UILabel!
    
    @IBAction func backButtonTriggered(_ sender: UIButton) {
        // Get to login page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "LoginController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainController)
    }
    
    @IBAction func signUpButtonTriggered(_ sender: UIButton) {
        // register new user in database
        Auth.auth().createUser(withEmail: username.text!, password: password.text!) { authResult, error in
            if error != nil {
                print(error?.localizedDescription)
            }
            self.completeSignUp()
        }
    }
    
    func completeSignUp() {
        let user = Auth.auth().currentUser
        if user != nil {
            // User is signed in; go to main view
            print("sign up successful")
            self.errMsg.isHidden = true
            
            if let user = user {
                let email = user.email
                let uid = user.uid
                database.child("users/\(uid)").setValue(["email": email])
                guest = false
            }
            
            // Get our main storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mainController = storyboard.instantiateViewController(withIdentifier: "ViewController")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainController)
        } else {
            // No user is signed in
            print("sign up unsuccessful")
            self.errMsg.isHidden = false
        }
    }
    
    override func viewDidLoad() {
        self.errMsg.isHidden = true
    }
    
}
