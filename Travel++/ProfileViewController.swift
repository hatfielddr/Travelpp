//
//  ProfileViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/28/22.
//

import UIKit

protocol UpdateName {
    func updateName(newName: String)
}

protocol UpdateEmail {
    func updateEmail(newEmail: String)
}

class ProfileViewController: UIViewController, UpdateName, UpdateEmail {
    
    
    @IBOutlet weak var changeEmail: UIButton!
    
    @IBOutlet weak var changeName: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var changePass: UIButton!
    
    @IBAction func changePassTriggered(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ChangePasswordSegue", sender: self)
    }
    
    @IBAction func changeNameTriggered(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ChangeNameSegue", sender: self)
    }
    func updateName(newName: String) {
        name.text = newName
    }
    
    @IBAction func changeEmailTriggered(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ChangeEmailSegue", sender: self)
    }
    func updateEmail(newEmail: String) {
        email.text = newEmail
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "ChangeNameSegue" {
            let destination = segue.destination as! ChangeNameViewController
            destination.delegate = self
        }
        if segue.identifier  == "ChangeEmailSegue" {
            let destination = segue.destination as! ChangeEmailViewController
            destination.delegate = self

        }
    }
    
   
    
    override func viewDidLoad() {
        print(user_id)
        
        name.text = full_name
        email.text = user_email
        
        getData()
        
    }
    
    func getData() {
        
        
    }
    
    
}
