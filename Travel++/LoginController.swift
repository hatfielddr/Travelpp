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
        self.performSegue(withIdentifier: "MapSegue", sender: self)
    }
    
    
}
