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
    
    var logIn: UIButton?
    var register: UIButton?
    var begin: UIButton?
    let defaults = UserDefaults.standard
    var emailField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    var passwordField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    var nameField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    var uniField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    var courseField = UITextField(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    
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
        emailField.returnKeyType = UIReturnKeyType.next
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
        passwordField.returnKeyType = UIReturnKeyType.done
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
        
        
        // Register button
        self.register = UIButton(type: UIButtonType.custom)
        self.register!.frame = CGRect(x: 0, y: self.view.bounds.height - 70, width: self.view.bounds.width/2, height: 50)
        self.register!.alpha = 0
        self.register!.backgroundColor = UIColor.clear
        self.register!.setTitle("Sign Up", for: .normal)
        self.register!.addTarget(self, action: #selector(register(button:)), for: .touchUpInside)
        self.register!.setTitleColor(Colors.white, for: .normal)
        self.view.addSubview(register!)
        
        // Translate animation using MengTo's Spring library
        self.register!.transform = CGAffineTransform(translationX: 0, y: 100)
        springWithDelay(duration: 0.8, delay: 0, animations: {
            self.register!.alpha = 1
            self.register!.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        // Log in button
        self.logIn = UIButton(type: UIButtonType.custom)
        self.logIn!.frame = CGRect(x: self.view.bounds.width/2 + 40, y: self.view.bounds.height - 70, width: self.view.bounds.width/2 - 80, height: 50)
        self.logIn!.alpha = 0
        self.logIn!.layer.cornerRadius = 25
        self.logIn!.backgroundColor = Colors.blueAlternative
        self.logIn!.setTitle("Log In", for: .normal)
        self.logIn!.addTarget(self, action: #selector(logIn(button:)), for: .touchUpInside)
        self.logIn!.setTitleColor(Colors.white, for: .normal)
        self.view.addSubview(logIn!)
        
        // Translate animation using MengTo's Spring library
        self.logIn!.transform = CGAffineTransform(translationX: 0, y: 100)
        springWithDelay(duration: 0.9, delay: 0.05, animations: {
            self.logIn!.alpha = 1
            self.logIn!.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.emailField.isFirstResponder || self.nameField.isFirstResponder || self.uniField.isFirstResponder {
            self.passwordField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
            return false
        }
        
        return true
    }
    
    
    func register(button: UIButton) {
        
        
        
        
        
        // Get text from fields
        let email = self.emailField.text
        let password = self.passwordField.text
        
        // Register users with Firebase
        FIRAuth.auth()!.createUser(withEmail: email!,
                                   password: password!) { user, error in
                                    
                                    // Sign in after registration
                                    if error == nil {
                                        
                                        FIRAuth.auth()!.signIn(withEmail: email!, password: password!)
                                        self.defaults.set(user?.email, forKey: "user")
                                        
                                        
                                        
                                        
                                        
                                        // Name text field
                                        self.nameField = UITextField(frame: CGRect(x: 40, y: 110, width: self.view.bounds.width - 80, height: 40))
                                        self.nameField.font = UIFont.systemFont(ofSize: 18)
                                        self.nameField.autocorrectionType = UITextAutocorrectionType.no
                                        self.nameField.keyboardType = UIKeyboardType.default
                                        self.nameField.returnKeyType = UIReturnKeyType.next
                                        self.nameField.tintColor = Colors.blueAlternative
                                        self.nameField.textColor = Colors.white
                                        self.nameField.backgroundColor = Colors.blueDark
                                        self.nameField.attributedPlaceholder = NSAttributedString(string:"Name (Or nickname, be creative...)", attributes:[NSForegroundColorAttributeName: Colors.blueDim])
                                        self.nameField.delegate = self
                                        self.nameField.alpha = 0
                                        self.view.addSubview(self.nameField)
                                        
                                        // Translate animation using MengTo's Spring library
                                        springWithDelay(duration: 1, delay: 0, animations: {
                                            self.emailField.alpha = 0
                                            self.passwordField.alpha = 0
                                            self.nameField.alpha = 1
                                        })
                                        
                                        
                                        
                                        // University text field
                                        self.uniField = UITextField(frame: CGRect(x: 40, y: 160, width: self.view.bounds.width - 80, height: 40))
                                        self.uniField.font = UIFont.systemFont(ofSize: 18)
                                        self.uniField.autocorrectionType = UITextAutocorrectionType.no
                                        self.uniField.keyboardType = UIKeyboardType.default
                                        self.uniField.returnKeyType = UIReturnKeyType.next
                                        self.uniField.tintColor = Colors.blueAlternative
                                        self.uniField.textColor = Colors.white
                                        self.uniField.backgroundColor = Colors.blueDark
                                        self.uniField.attributedPlaceholder = NSAttributedString(string:"University", attributes:[NSForegroundColorAttributeName: Colors.blueDim])
                                        self.uniField.delegate = self
                                        self.uniField.alpha = 0
                                        self.view.addSubview(self.uniField)
                                        
                                        // Translate animation using MengTo's Spring library
                                        springWithDelay(duration: 1.1, delay: 0.3, animations: {
                                            self.uniField.alpha = 1
                                        })
                                        
                                        
                                        
                                        // course text field
                                        self.courseField = UITextField(frame: CGRect(x: 40, y: 210, width: self.view.bounds.width - 80, height: 40))
                                        self.courseField.font = UIFont.systemFont(ofSize: 18)
                                        self.courseField.autocorrectionType = UITextAutocorrectionType.no
                                        self.courseField.keyboardType = UIKeyboardType.default
                                        self.courseField.returnKeyType = UIReturnKeyType.done
                                        self.courseField.tintColor = Colors.blueAlternative
                                        self.courseField.textColor = Colors.white
                                        self.courseField.backgroundColor = Colors.blueDark
                                        self.courseField.attributedPlaceholder = NSAttributedString(string:"Course", attributes:[NSForegroundColorAttributeName: Colors.blueDim])
                                        self.courseField.delegate = self
                                        self.courseField.alpha = 0
                                        self.view.addSubview(self.courseField)
                                        
                                        // Translate animation using MengTo's Spring library
                                        springWithDelay(duration: 1.3, delay: 0.4, animations: {
                                            self.courseField.alpha = 1
                                        })
                                        
                                        
                                        
                                        

                                        // Begin button
                                        self.begin = UIButton(type: UIButtonType.custom)
                                        self.begin!.frame = CGRect(x: self.view.bounds.width/2 - 75, y: self.view.bounds.height - 70, width: 150, height: 50)
                                        self.begin!.alpha = 0
                                        self.begin!.layer.cornerRadius = 25
                                        self.begin!.backgroundColor = Colors.blueAlternative
                                        self.begin!.setTitle("Let's go!", for: .normal)
                                        self.begin!.addTarget(self, action: #selector(self.begin(button:)), for: .touchUpInside)
                                        self.begin!.setTitleColor(Colors.white, for: .normal)
                                        self.view.addSubview(self.begin!)
                                        
                                        // Translate animation using MengTo's Spring library
                                        self.begin!.transform = CGAffineTransform(translationX: 0, y: 100)
                                        springWithDelay(duration: 0.9, delay: 0.05, animations: {
                                            self.logIn?.alpha = 0
                                            self.register?.alpha = 0
                                            self.begin!.alpha = 1
                                            self.begin!.transform = CGAffineTransform(translationX: 0, y: 0)
                                        })
                                        
                                        
                                        

                                    }
                                    
                                    
        }
        
        
    }
    
    func begin(button: UIButton) {
        
        // Dictionary for new user
        let user = self.defaults.object(forKey: "user") as? String
        var newUser = [
            "email" : user,
            "name" : self.nameField.text,
            "uni" : self.uniField.text,
            "course" : self.courseField.text
        ]
        // Store dictionary in user defaults
        var userData = NSKeyedArchiver.archivedData(withRootObject: newUser)
        defaults.set(userData, forKey: (FIRAuth.auth()!.currentUser?.email)!)
        
        
        // Dismiss view
        let register = self.defaults.object(forKey: "hasRegistered") as? Int
        if register != nil {
            self.defaults.set(3, forKey: "hasRegistered")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func logIn(button: UIButton) {
        
        // Get text from fields
        let email = self.emailField.text
        let password = self.passwordField.text
        
        // Authenticate users with Firebase
        FIRAuth.auth()!.signIn(withEmail: email!, password: password!) { user, error in
            if error == nil {
                self.defaults.set(user?.email, forKey: "user")
                
                // Dismiss view
                let register = self.defaults.object(forKey: "hasRegistered") as? Int
                if register != nil {
                    self.defaults.set(3, forKey: "hasRegistered")
                }
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        
        
        
        
        
        
    }
    
}
