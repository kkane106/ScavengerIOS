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
import CoreData

class LoginViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    let MyKeyChainWrapper = KeychainWrapper()
    
    var currentUser = [PFUser]()
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        println("prepare to check login")
        checkUserLogin { (parseUser) -> () in
            self.performSegueWithIdentifier("loginViewSegue", sender: self)
//            self.unwrapParseUserValues(parseUser)

        }
        println("just checked login")
        var currentUser = PFUser.currentUser()
        println(currentUser)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


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
                    
                    self.performSegueWithIdentifier("loginViewSegue", sender: self)

                }
                
            }
        }
    }
    
    func unwrapParseUserValues(user : PFUser?) {
        if let userToSave = user {
            if let objectId = userToSave.objectId {
                if let createdAt = userToSave.createdAt {
                    if let updatedAt = userToSave.updatedAt {
                        if let username = userToSave.username {
                            if let email = userToSave.email {

                                self.saveUser(username as! String, email: email as! String, createdAt: createdAt as! NSDate, updatedAt: updatedAt as! NSDate, objectId: objectId as! String)
                            }
                        }

                    }
                }
            }
        }
    }
    
    func checkUserLogin(completion : (parseUser: PFUser) -> ()) {
        let passwordKeychain = MyKeyChainWrapper.myObjectForKey("v_Data") as? String
        let usernameDefault = defaults.valueForKey("username") as? String
        if PFUser.currentUser() != nil {
            if let savedPW = passwordKeychain {
                println(savedPW)
                if let savedUserName = usernameDefault {
                    println(savedUserName)
                    PFUser.logInWithUsernameInBackground(savedUserName, password: savedPW, block: {
                        (user, error) -> Void in
                        if error != nil {
                            if let error = error {
                                println("User not found")
                                println(error)
                                
                            }
                        }
                        
                        if let user = user {
                            completion(parseUser: user)
                        }
                        
                    })
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "loginSegueView") {
            var navigationVC = segue.destinationViewController as! UINavigationController
            var homeVC = navigationVC.topViewController
            
        }
    }
    
    func saveUser(username: String, email: String, createdAt: NSDate, updatedAt: NSDate, objectId: String ) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let entity = NSEntityDescription.entityForName("User", inManagedObjectContext: managedContext)
        
        let user = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        
        user.setValue(username, forKey: "username")
        user.setValue(email, forKey: "email")
        user.setValue(createdAt, forKey: "createdAt")
        user.setValue(updatedAt, forKey: "updatedAt")
        user.setValue(objectId, forKey: "objectId")
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    @IBAction func doPresentSignUp(sender: UIButton) {
    }

}
