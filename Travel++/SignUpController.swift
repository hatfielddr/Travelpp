//
//  SignUpController.swift
//  Travel++
//
//  Created by Drew Hatfield on 3/22/22.
//

import UIKit
import Firebase

class SignUpController: UIViewController {
    typealias SignUpButtonAction = () -> Void
    
    var signUpButtonAction: SignUpButtonAction?
    
    let database = Database.database().reference()
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    //@IBOutlet var password: UITextInputPasswordRules!
    @IBOutlet var signUpButton: UIButton!
    
    @IBAction func signUpButtonTriggered(_ sender: UIButton) {
        // Get our main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // Instantiate ViewController with the ID "ViewController" (needs to be set
        // within the main storyboard file. Click desired view controller and set
        // "Storyboard ID" in the far right menus accordingly
        let mainController = storyboard.instantiateViewController(withIdentifier: "SignUpController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainController)
    }
}
