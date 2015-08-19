//
//  ForgotPasswordViewController.swift
//  ScavengerIOS
//
//  Created by Kristopher Kane on 8/19/15.
//  Copyright (c) 2015 Kris Kane. All rights reserved.
//

import UIKit
import Parse

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var requestResetButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkEmailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkEmailLabel.text = ""
        setupLabel(checkEmailLabel)
        setupButtons(backButton)
        setupButtons(requestResetButton)
        setupView()
        setupTextFields(emailTextField)
        
    }
    
    @IBAction func doRequestPasswordReset(sender: UIButton) {
        PFUser.requestPasswordResetForEmailInBackground(emailTextField.text)
        checkEmailLabel.text = "Check your email for a reset link!"
        
    }
    
    @IBAction func doGoBackToLogin(sender: UIButton) {
        performSegueWithIdentifier("goBackToLogin", sender: self)
    }
    
    
    func setupLabel(label :UILabel) {
        label.textColor = UIColor.whiteColor()
        label.layer.shadowColor = UIColor.blackColor().CGColor
        label.layer.shadowOffset = CGSizeMake(2, 2)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.2
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goBackToLogin") {
            var destinationVC = segue.destinationViewController as! LoginViewController
        }
    }

}
