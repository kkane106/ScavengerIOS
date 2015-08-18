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
    
    let MyKeyChainWrapper = KeychainWrapper()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func doVerifySignUp(sender: UIButton) {
        if emailTextField.text == "" {
            var alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "Dismiss")
            alert.show()
        } else if count(passwordTextField.text.utf16) < 5 {
            var alert = UIAlertView(title: "Invalid", message: "Password must be longer than 5 characters", delegate: self, cancelButtonTitle: "Dismiss")
            alert.show()
        } else if count(usernameTextField.text.utf16) < 4 {
            var alert = UIAlertView(title: "Invalid", message: "Username must be longer than 4 characters", delegate: self, cancelButtonTitle: "Dismiss")
            alert.show()
        } else {
            userSignUp()
        }
    }
    
    func userSignUp() {
        var user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.email = emailTextField.text
        user.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if let error = error {
                if let error = error.userInfo {
                self.messageLabel.text = error["error"] as! String
                }
            }
            self.userLogin()
        }
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
                println("IS it this one? \(user)")
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
                    
                    self.performSegueWithIdentifier("signupViewSegue", sender: self)
                    
                }
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "signupSegueView") {
            var navigationVC = segue.destinationViewController as! UINavigationController
            var homeVC = navigationVC.topViewController
            
        }
    }

    
}