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
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var scavengrLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var alreadyHaveAnAccountButton: UIButton!
    
    let MyKeyChainWrapper = KeychainWrapper()
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLabel(scavengrLabel)
        setupButtons(signUpButton)
        setupButtons(alreadyHaveAnAccountButton)
        setupView()
        setupTextFields(emailTextField)
        setupTextFields(passwordTextField)
        setupTextFields(usernameTextField)
    }
    
    func setupLabel(label :UILabel) {
        label.textColor = UIColor.whiteColor()
        label.layer.shadowColor = UIColor.blackColor().CGColor
        label.layer.shadowOffset = CGSizeMake(5, 5)
        label.layer.shadowRadius = 5
        label.layer.shadowOpacity = 0.3
    }
    
    func setupButtons(button : UIButton) {
        button.backgroundColor = UIColor.clearColor()
        button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        button.layer.shadowColor = UIColor.blackColor().CGColor
        button.layer.shadowOffset = CGSizeMake(2, 2)
        button.layer.shadowRadius = 2
        button.layer.shadowOpacity = 0.2
    }
    
    func setupView() {
        let firstColor : UIColor = UIColor(hexString: "#3AB34C")!
        let secondColor : UIColor = UIColor(hexString: "#2D9F48")!
        let gradient : CAGradientLayer = CAGradientLayer()
        gradient.colors = [firstColor.CGColor, secondColor.CGColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x:0.3, y: 0.2)
        gradient.endPoint = CGPoint(x:0.7, y: 0.7)
        gradient.frame = CGRect(x:0.0, y: 0.0, width: self.view.frame.size.width, height : self.view.frame.size.height)
        
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    func setupTextFields(textField : UITextField) {
        textField.backgroundColor = UIColor(white: 1, alpha: 0.3)
        textField.layer.shadowColor = UIColor.blackColor().CGColor
        textField.layer.shadowOffset = CGSizeMake(2, 2)
        textField.layer.shadowRadius = 2
        textField.layer.shadowOpacity = 0.2
        textField.borderStyle = UITextBorderStyle.None
        
        let paddingView = UIView(frame: CGRectMake(0,0,25,textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = UITextFieldViewMode.Always
        
    }
    
    @IBAction func doVerifySignUp(sender: UIButton) {
        if emailTextField.text == "" {
            var alert = UIAlertView(title: "Invalid", message: "Please enter a valid email address", delegate: self, cancelButtonTitle: "Dismiss")
            alert.show()
            return
        } else if count(passwordTextField.text.utf16) < 5 {
            var alert = UIAlertView(title: "Invalid", message: "Password must be longer than 5 characters", delegate: self, cancelButtonTitle: "Dismiss")
            alert.show()
            return
        } else if count(usernameTextField.text.utf16) < 4 {
            var alert = UIAlertView(title: "Invalid", message: "Username must be longer than 4 characters", delegate: self, cancelButtonTitle: "Dismiss")
            alert.show()
            return
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
                    var alert = UIAlertView()
                    alert.title = error["error"] as! String
                    alert.addButtonWithTitle("Try again")
                    alert.show()
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
                    var alert = UIAlertView()
                    alert.title = "No record found"
                    alert.addButtonWithTitle("Try again")
                    alert.show()
                    println(error)
                }
            } else {
                println("IS it this one? \(user)")
                if let user = user {
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
                    
                    self.performSegueWithIdentifier("signUpSegue", sender: self)
                    
                }
                
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "signUpSegue") {
            var navigationVC = segue.destinationViewController as! UINavigationController
            var homeVC = navigationVC.topViewController as! HomeViewController
            
        }
    }

    
}