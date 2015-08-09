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
    
    @IBOutlet weak var loginButton: UIButton!
    
    let MyKeyChainWrapper = KeychainWrapper()
    let createLoginButtonTag = 0
    let loginButtonTag = 1
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func doVerifyLogin(sender: UIButton) {
        if (usernameTextField.text == "" || passwordTextField.text == "") {
            var alert = UIAlertView()
            alert.title = "You must enter both a username and password"
            alert.addButtonWithTitle("Whoops!")
            alert.show()
            return
        }
        
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        userLogin()
//
//        if sender.tag == createLoginButtonTag {
//            let hasLoginKey = defaults.boolForKey("hasLoginKey")
//            if hasLoginKey == false {
//                defaults.setValue(self.usernameTextField.text, forKey: "username")
//            }
//            
//            MyKeyChainWrapper.mySetObject(passwordTextField.text, forKey: kSecValueData)
//            MyKeyChainWrapper.writeToKeychain()
//            defaults.setBool(true, forKey: "hasLoginKey")
//            defaults.synchronize()
//            loginButton.tag = loginButtonTag
//            
//            performSegueWithIdentifier("loginViewSegue", sender: self)
//        } else if sender.tag == loginButtonTag {
//            if checkLogin(usernameTextField.text, password: passwordTextField.text) {
//                performSegueWithIdentifier("loginViewSegue", sender: self)
//            }
//        } else {
//            var alert = UIAlertView()
//            alert.title = "Login Problem"
//            alert.message = "Wrong username or password"
//            alert.addButtonWithTitle("Rats")
//            alert.show()
//        }
    }
    
    func userLogin() {
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if error != nil {
                if let error = error {
                    self.messageLabel.text = "NO record found"
                    println(error)
                }
            } else {
                if let user = user {
                    // If user record is returned
                    self.messageLabel.text = "Record found"
                    
                    // Look in UserDefaults to see if there is a loginKey
                    let hasLoginKey = self.defaults.boolForKey("hasLoginKey")
                    // If not, set the value of "username" to the current username in UserDefaults
                    if hasLoginKey == false {
                        self.defaults.setValue(self.usernameTextField.text, forKey: "username")
                    }
                    
                    // Save the user password to Keychain
                    self.MyKeyChainWrapper.mySetObject(self.passwordTextField.text, forKey: kSecValueData)
                    self.MyKeyChainWrapper.writeToKeychain()
                    // Set "hasLoginKey" to true
                    self.defaults.setBool(true, forKey: "hasLoginKey")
                    self.defaults.synchronize()
                    
                    self.performSegueWithIdentifier("loginViewSegue", sender: self)

                }
                
            }
        }
    }
    
    // Ensure that the username matches what is stored in UserDefault and the password matches Keychain
    func checkLogin(username: String, password:String) -> Bool {
        let password = MyKeyChainWrapper.myObjectForKey("v_Data") as? String
        let username = defaults.valueForKey("username") as? String
        
        if let password = password {
            println("found a password in keychain")
            if let username = username {
                println("found a username in user defaults")
                PFUser.logInWithUsernameInBackground(username, password: password) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if error != nil {
                        if let error = error {
                            println("User not found")
                            println(error)
                            
                        } else {
                            if let user = user {
                                println("parse returned a user")
                            }
                        }
                    }
                }
                println("returned true")
                return true
            } else {
                println("returned false")
                return false
            }
        }
            
        return false
    }
    
    @IBAction func doPresentSignUp(sender: UIButton) {
    }

}
