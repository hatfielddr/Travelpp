//
//  ProfileViewController.swift
//  Travel++
//
//  Created by Tori Duguid on 3/28/22.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var changeEmail: UIButton!
    
    @IBOutlet weak var changeName: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var changePass: UIButton!
    
    @IBAction func changePassTriggered(_ sender: UIButton) {
        self.performSegue(withIdentifier: "ChangePasswordSegue", sender: self)
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
