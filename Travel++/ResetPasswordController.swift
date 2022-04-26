//
//  ResetPasswordController.swift
//  Travel++
//
//  Created by Rachel Cavender on 4/26/22.
//

import UIKit
import Firebase
import FirebaseAuthUI

class ResetPasswordController: UIViewController {
    typealias SubmitButtonAction = () -> Void
    typealias BackButtonAction = () -> Void
    
    var submitButtonAction: SubmitButtonAction?
    var backButtonAction: BackButtonAction?
    
    let database = Database.database().reference()
    
    @IBOutlet var username: UITextField!
    @IBOutlet var submitButton: UIButton!
    @IBOutlet var backButton: UIButton!
    
    @IBAction func backButtonTriggered(_ sender: UIButton) {
        // Get to login page
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "LoginController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainController)
    }
    
    @IBAction func submitButtonTriggered(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: self.username.text!) { error in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
}
