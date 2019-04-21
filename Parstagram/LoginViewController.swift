//
//  LoginViewController.swift
//  Parstagram
//
//  Created by Weiran Xiong on 4/16/19.
//  Copyright © 2019 Weiran Xiong. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.delegate = self
        passwordLabel.delegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signIn(_ sender: Any) {
        let username = usernameLabel.text!
        let password = passwordLabel.text!
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, err) in
            if user != nil {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(err?.localizedDescription)")
            }
        }

    }
    
    @IBAction func signUp(_ sender: Any) {
        let user = PFUser()
        user.username = usernameLabel.text
        user.password = passwordLabel.text
        
        user.signUpInBackground { (success, err) in
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                print("Error: \(err?.localizedDescription)")
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


}
