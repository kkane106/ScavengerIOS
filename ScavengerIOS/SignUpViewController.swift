//
//  SignUpViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/9/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//


import UIKit
import Parse

class SignUpViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doVerifyLogin(sender: UIButton) {
        if emailTextField.text != "" && passwordTextField.text != "" && usernameTextField.text != ""{
            userSignUp()
        } else {
            self.messageLabel.text = "Please enter a valid email and password"
        }
    }
    
    func userSignUp() {
        var user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text

        user.signUpInBackground()
    }
    
}