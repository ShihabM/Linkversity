//
//  ReplyViewController.swift
//  Linkversity
//
//  Created by Shihab Mehboob on 22/10/2016.
//  Copyright © 2016 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class ReplyViewController: UIViewController, UITextViewDelegate, CLLocationManagerDelegate {
    
    let defaults = UserDefaults.standard
    var titleText = ""
    var post: UIButton?
    var dismiss: UIButton?
    var postImage = UIImage()
    var postField = UITextView(frame: CGRect(x: 20, y: 100, width: 300, height: 40))
    var placeholderLabel = UILabel(frame: CGRect(x: 250, y: 195, width: 60, height: 20))
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.blueDark
        
        // Ask for location authorisation from user and use in foreground
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Post button
        self.post = UIButton(type: UIButtonType.custom)
        self.post!.frame = CGRect(x: self.view.bounds.width - 70, y: 30, width: 45, height: 45)
        self.post!.alpha = 0
        self.post!.layer.cornerRadius = 22.5
        self.post!.backgroundColor = Colors.blueDim
        self.post!.addTarget(self, action: #selector(post(button:)), for: .touchUpInside)
        self.postImage = UIImage(named: "post.png")!
        self.postImage = self.postImage.imageWithColor(color1: Colors.blueDark).withRenderingMode(.alwaysOriginal)
        self.post!.setImage(self.postImage, for: .normal)
        self.post!.imageEdgeInsets = UIEdgeInsetsMake(14, 14, 14, 14)
        self.view.addSubview(post!)
        
        // Translate animation using MengTo's Spring library
        self.post!.transform = CGAffineTransform(translationX: 0, y: -80)
        springWithDelay(duration: 0.9, delay: 0.05, animations: {
            self.post!.alpha = 1
            self.post!.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        
        
        // dismiss button
        self.dismiss = UIButton(type: UIButtonType.custom)
        self.dismiss!.frame = CGRect(x: 10, y: 20, width: 45, height: 45)
        self.dismiss!.alpha = 0
        self.dismiss!.layer.cornerRadius = 25
        self.dismiss!.backgroundColor = UIColor.clear
        self.dismiss!.addTarget(self, action: #selector(dismiss(button:)), for: .touchUpInside)
        var dismissImage = UIImage(named: "cross.png") as UIImage?
        dismissImage = dismissImage?.imageWithColor(color1: Colors.blueDim).withRenderingMode(.alwaysOriginal)
        self.dismiss!.setImage(dismissImage, for: .normal)
        self.dismiss!.imageEdgeInsets = UIEdgeInsetsMake(14, 14, 14, 14)
        self.view.addSubview(dismiss!)
        
        // Translate animation using MengTo's Spring library
        self.dismiss!.transform = CGAffineTransform(translationX: 0, y: -100)
        springWithDelay(duration: 0.65, delay: 0, animations: {
            self.dismiss!.alpha = 1
            self.dismiss!.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        
        
        
        // Placeholder label
        placeholderLabel = UILabel(frame: CGRect(x: 20, y: 75, width: 250, height: 20))
        placeholderLabel.textAlignment = NSTextAlignment.left
        placeholderLabel.text = "...Reply to: " + self.titleText
        placeholderLabel.textColor = Colors.blueDim
        self.view.addSubview(placeholderLabel)
        
        // Translate animation using MengTo's Spring library
        springWithDelay(duration: 1, delay: 0, animations: {
            self.placeholderLabel.alpha = 1
        })
        
        
        
        // Post text field
        postField = UITextView(frame: CGRect(x: 20, y: 105, width: self.view.bounds.width - 40, height: self.view.bounds.height - 150))
        postField.font = UIFont.systemFont(ofSize: 20)
        postField.autocorrectionType = UITextAutocorrectionType.yes
        postField.keyboardType = UIKeyboardType.default
        postField.returnKeyType = UIReturnKeyType.default
        postField.tintColor = Colors.blueAlternative
        postField.textColor = Colors.white
        postField.backgroundColor = Colors.blueDark
        postField.delegate = self
        postField.becomeFirstResponder()
        postField.alpha = 0
        self.view.addSubview(postField)
        
        // Translate animation using MengTo's Spring library
        springWithDelay(duration: 1, delay: 0, animations: {
            self.postField.alpha = 1
        })
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if self.postField.text != "" || self.postField.text != " " {
            self.post!.backgroundColor = Colors.blueAlternative
            self.postImage = self.postImage.imageWithColor(color1: Colors.white).withRenderingMode(.alwaysOriginal)
            self.post!.setImage(self.postImage, for: .normal)
        } else {
            self.post!.backgroundColor = Colors.blueDim
            self.postImage = self.postImage.imageWithColor(color1: Colors.blueDark).withRenderingMode(.alwaysOriginal)
            self.post!.setImage(self.postImage, for: .normal)
        }
    }
    
    func post(button: UIButton) {
        if self.postField.text == "" || self.postField.text == " " {
            
        } else {
            
            
            // Update Firebase message with replies
            
            var sanitisedString = self.titleText.replacingOccurrences(of: ".", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "#", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "$", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "[", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "]", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "\n", with: "|")
            
            var sanitisedString2 = self.postField.text.replacingOccurrences(of: ".", with: "|")
            sanitisedString2 = sanitisedString2.replacingOccurrences(of: "#", with: "|")
            sanitisedString2 = sanitisedString2.replacingOccurrences(of: "$", with: "|")
            sanitisedString2 = sanitisedString2.replacingOccurrences(of: "[", with: "|")
            sanitisedString2 = sanitisedString2.replacingOccurrences(of: "]", with: "|")
            sanitisedString2 = sanitisedString2.replacingOccurrences(of: "\n", with: "|")
            
            let user = self.defaults.object(forKey: "user") as? String
            let userData = self.defaults.dictionary(forKey: user!) as! [String : String]
            let emailData = userData["email"]
            let nameData = userData["name"]
            let uniData = userData["uni"]
            let courseData = userData["course"]
            
            FIRDatabase.database().reference().child(sanitisedString).child(byAppendingPath: "replies")
            FIRDatabase.database().reference().child(sanitisedString).child("replies").child(byAppendingPath: sanitisedString2)
            FIRDatabase.database().reference().child(sanitisedString).child("replies").child(sanitisedString2).child("reply").setValue(self.postField.text)
            FIRDatabase.database().reference().child(sanitisedString).child("replies").child(sanitisedString2).child("replyUser").setValue(nameData!)
            FIRDatabase.database().reference().child(sanitisedString).child("replies").child(sanitisedString2).child("replyUserEmail").setValue(emailData!)
            FIRDatabase.database().reference().child(sanitisedString).child("replies").child(sanitisedString2).child("replyUserUni").setValue(uniData!)
            FIRDatabase.database().reference().child(sanitisedString).child("replies").child(sanitisedString2).child("replyUserCourse").setValue(courseData!)
            
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func dismiss(button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
