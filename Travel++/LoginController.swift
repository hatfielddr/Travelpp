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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "ViewController")
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainController)
    }
    
    
}
