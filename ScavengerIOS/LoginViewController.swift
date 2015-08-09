//
//  LoginViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/9/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit
import Foundation
import Parse

class LoginViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func doVerifyLogin(sender: UIButton) {
        view.endEditing(true)
        if passwordTextField.text != "" && usernameTextField.text != ""{
            userLogin()
        } else {
            self.messageLabel.text = "Please enter a valid email and password"
        }

    }
    
    func userLogin() {
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil {
                if let error = error {
                    println("something went wrong")
                }
            } else {
                if let user = user {
                    self.messageLabel.text = "Record found"
                }
            }
        }
    }
    @IBAction func doPresentSignUp(sender: UIButton) {
    }
    
    @IBAction func doPresentForgotPassword(sender: UIButton) {
    }

}
