//
//  ProfileViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/28/22.
//

import UIKit
import Firebase
import FirebaseAuthUI

protocol UpdateName {
    func updateName(newName: String)
}

protocol UpdateEmail {
    func updateEmail(newEmail: String)
}

class ProfileViewController: UIViewController, UpdateName, UpdateEmail {
    
    let database = Database.database().reference()
    let firstname = ""
    let lastname = ""
    
    @IBOutlet weak var signOut: UIButton!
    @IBOutlet weak var changeEmail: UIButton!
    @IBOutlet weak var changeName: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var changePass: UIButton!
    @IBOutlet weak var myProfile: UILabel!
    @IBOutlet var name2: UILabel!
    @IBOutlet var email2: UILabel!
    @IBOutlet var createAccountButton: UIButton!
    @IBOutlet weak var notifications: UISwitch!
    
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
    
    @IBAction func createAccount(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "SignUpController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(mainController)
    }
    
    func updateEmail(newEmail: String) {
        email.text = newEmail
    }
    
    @IBAction func signOutTriggered(_ sender: UIButton) {
        do {
            let user = Auth.auth().currentUser
            if let user = user {
                let email = user.email
                print("\(email ?? "Nobody ") is signed in")
            } else {
                print("No user signed in")
            }
            try Auth.auth().signOut()
            print("signed out")
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        
        // go back to login screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginController = storyboard.instantiateViewController(withIdentifier: "LoginController")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(loginController)
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
        if (guest) {
            name.isHidden = true
            email.isHidden = true
            signOut.isHidden = true
            changeName.isHidden = true
            changePass.isHidden = true
            changeEmail.isHidden = true
            myProfile.isHidden = true
            name2.isHidden = true
            email2.isHidden = true
            createAccountButton.isHidden = false
        }
        else {
            name.isHidden = false
            email.isHidden = false
            signOut.isHidden = false
            changeName.isHidden = false
            changePass.isHidden = false
            changeEmail.isHidden = false
            myProfile.isHidden = false
            name2.isHidden = false
            email2.isHidden = false
            createAccountButton.isHidden = true
        }
        if (Auth.auth().currentUser == nil) {return}
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { snapshot in
          // Get user value
            let value = snapshot.value as? NSDictionary
            let firstname = value?["first_name"] as? String ?? ""
            let lastname = value?["last_name"] as? String ?? ""
            let email = value?["email"] as? String ?? ""
            print("\(firstname), \(lastname), \(email)")
            self.name.text = "\(firstname) \(lastname)"
            self.email.text = "\(email)"
        }) { error in
          print(error.localizedDescription)
        }
    }
}
