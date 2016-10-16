//
//  RegisterViewController.swift
//  Linkversity
//
//  Created by Shihab Mehboob on 16/10/2016.
//  Copyright © 2016 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    var dismiss: UIButton?
    let defaults = UserDefaults.standard
    var emailField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    var passwordField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.blueDark
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Title logo
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRect(x: self.view.bounds.width/2 - 75, y: 35, width: 150, height: 50));
        imageView.image = UIImage(named:"title.png")
        self.view.addSubview(imageView)
        
        // Translate animation using MengTo's Spring library
        imageView.transform = CGAffineTransform(translationX: 0, y: -100)
        springWithDelay(duration: 0.8, delay: 0, animations: {
            imageView.alpha = 1
            imageView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        
        // Email text field
        emailField = UITextField(frame: CGRect(x: 40, y: 110, width: self.view.bounds.width - 80, height: 40))
        emailField.font = UIFont.systemFont(ofSize: 18)
        emailField.autocorrectionType = UITextAutocorrectionType.no
        emailField.keyboardType = UIKeyboardType.default
        emailField.returnKeyType = UIReturnKeyType.default
        emailField.tintColor = Colors.blueAlternative
        emailField.textColor = Colors.white
        emailField.backgroundColor = Colors.blueDark
        emailField.attributedPlaceholder = NSAttributedString(string:"Email", attributes:[NSForegroundColorAttributeName: Colors.blueDim])
        emailField.delegate = self
        emailField.alpha = 0
        self.view.addSubview(emailField)
        
        // Translate animation using MengTo's Spring library
        springWithDelay(duration: 1, delay: 0, animations: {
            self.emailField.alpha = 1
        })
        
        
        // Password text field
        passwordField = UITextField(frame: CGRect(x: 40, y: 160, width: self.view.bounds.width - 80, height: 40))
        passwordField.font = UIFont.systemFont(ofSize: 18)
        passwordField.autocorrectionType = UITextAutocorrectionType.no
        passwordField.keyboardType = UIKeyboardType.default
        passwordField.returnKeyType = UIReturnKeyType.default
        passwordField.tintColor = Colors.blueAlternative
        passwordField.textColor = Colors.white
        passwordField.backgroundColor = Colors.blueDark
        passwordField.attributedPlaceholder = NSAttributedString(string:"Password", attributes:[NSForegroundColorAttributeName: Colors.blueDim])
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
        passwordField.alpha = 0
        self.view.addSubview(passwordField)
        
        // Translate animation using MengTo's Spring library
        springWithDelay(duration: 1.1, delay: 0.3, animations: {
            self.passwordField.alpha = 1
        })
        
        
        // Sign up and log in button
        self.dismiss = UIButton(type: UIButtonType.custom)
        self.dismiss!.frame = CGRect(x: 0, y: self.view.bounds.height - 60, width: self.view.bounds.width, height: 60)
        self.dismiss!.alpha = 0
        self.dismiss!.backgroundColor = Colors.blueAlternative
        self.dismiss!.setTitle("Sign Up / Log In", for: .normal)
        self.dismiss!.addTarget(self, action: #selector(dismiss(button:)), for: .touchUpInside)
        self.dismiss!.setTitleColor(Colors.white, for: .normal)
        self.view.addSubview(dismiss!)
        
        // Translate animation using MengTo's Spring library
        self.dismiss!.transform = CGAffineTransform(translationX: 0, y: 100)
        springWithDelay(duration: 0.8, delay: 0, animations: {
            self.dismiss!.alpha = 1
            self.dismiss!.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
    }
    
    
    func dismiss(button: UIButton) {
        
        // Get text from fields
        let email = self.emailField.text
        let password = self.passwordField.text
        
        // Register and authenticate users with Firebase
        FIRAuth.auth()!.createUser(withEmail: email!,
                                   password: password!) { user, error in
                                    
                                    // If already a member, simply sign in
                                    if error == nil {
                                        
                                        FIRAuth.auth()!.signIn(withEmail: email!,
                                                               password: password!)
                                        
                                    }
        }
        
        // Dismiss view
        let register = self.defaults.object(forKey: "hasRegistered") as? Int
        if register != nil {
            self.defaults.set(3, forKey: "hasRegistered")
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
}
