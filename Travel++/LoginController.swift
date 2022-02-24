//
//  LoginController.swift
//  Travel++
//
//  Created by Tori Duguid on 2/19/22.
//

import UIKit

class LoginController: UIViewController {
    typealias DoneButtonAction = () -> Void
    
    var doneButtonAction: DoneButtonAction?
    
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextInputPasswordRules!
    @IBOutlet var loginButton: UIButton!
    
    @IBAction func doneButtonTriggered(_ sender: UIButton) {
            //self.performSegue(withIdentifier: "MapSegue", sender: nil)
            
            // Get our main storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            // Instantiate ViewController with the ID "ViewController" (needs to be set
            // within the main storyboard file. Click desired view controller and set
            // "Storyboard ID" in the far right menus accordingly
            let mainController = storyboard.instantiateViewController(withIdentifier: "ViewController")
            
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainController)
        }
    
    
}
