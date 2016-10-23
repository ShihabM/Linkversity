//
//  ProfileViewController.swift
//  Linkversity
//
//  Created by Shihab Mehboob on 16/10/2016.
//  Copyright © 2016 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView()
    var content: [String] = ["Name:", "Email:", "University:", "Course:"]
    var content2: [String] = []
    var content3: [String] = []
    var content4: [String] = []
    var content5: [String] = []
    var content6: [String] = []
    var content7: [String] = []
    var content8: [Int] = []
    var content9: [Int] = []
    var content10: [Int] = []
    var content11: [Int] = []
    var ref = FIRDatabase.database().reference()
    var imageView = UIImageView()
    var imageView2 = UIImageView()
    let defaults = UserDefaults.standard
    var logOut: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.cellNorm
        
        // Header section
        var headerImageView : UIImageView
        headerImageView  = UIImageView(frame:CGRect(x: 0, y: ((self.navigationController?.navigationBar.bounds.height)! + 20), width: self.view.bounds.width, height: 200));
        headerImageView.backgroundColor = Colors.blueDim
        self.view.addSubview(headerImageView)
        
        
        // Create the table and set its datasource and delegate
        tableView.frame = CGRect(x: 0, y: ((self.navigationController?.navigationBar.bounds.height)! + 220), width: self.view.bounds.width - 0, height: self.view.bounds.height - (self.navigationController?.navigationBar.bounds.height)! - 270);
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Avatar background
        imageView  = UIImageView(frame:CGRect(x: self.view.bounds.width/2 - 50, y: ((self.navigationController?.navigationBar.bounds.height)! + 70), width: 100, height: 100));
        imageView.backgroundColor = Colors.blueDark
        imageView.layer.cornerRadius = 50
        imageView.layer.borderColor = Colors.white.cgColor
        imageView.layer.borderWidth = 4
        self.view.addSubview(imageView)
        
        // Translate animation using MengTo's Spring library
        imageView.transform = CGAffineTransform(translationX: 0, y: -100)
        springWithDelay(duration: 0.8, delay: 0, animations: {
            self.imageView.alpha = 1
            self.imageView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        // Avatar
        imageView2  = UIImageView(frame:CGRect(x: 27.5, y: 25, width: 45, height: 50));
        imageView2.backgroundColor = UIColor.clear
        var shareImage = UIImage(named: "profile.png") as UIImage?
        shareImage = shareImage?.imageWithColor(color1: Colors.blueDim).withRenderingMode(.alwaysOriginal)
        imageView2.image = shareImage
        self.imageView.addSubview(imageView2)
        
        // Translate animation using MengTo's Spring library
        imageView2.transform = CGAffineTransform(translationX: 0, y: -100)
        springWithDelay(duration: 0.8, delay: 0, animations: {
            self.imageView2.alpha = 1
            self.imageView2.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        
        
        
        
        
        // Log out button
        self.logOut = UIButton(type: UIButtonType.custom)
        self.logOut!.frame = CGRect(x: (self.view.bounds.width/4)*3 - 20, y: ((self.navigationController?.navigationBar.bounds.height)! + 102.5), width: 90, height: 45)
        self.logOut!.alpha = 0
        self.logOut!.layer.cornerRadius = 22.5
        self.logOut!.backgroundColor = Colors.blueDark
        self.logOut!.setTitle("Log Out", for: .normal)
        self.logOut!.addTarget(self, action: #selector(logOut(button:)), for: .touchUpInside)
        self.logOut!.setTitleColor(Colors.white, for: .normal)
        self.view.addSubview(logOut!)
        
        // Translate animation using MengTo's Spring library
        self.logOut!.transform = CGAffineTransform(translationX: 0, y: -100)
        springWithDelay(duration: 0.9, delay: 0.05, animations: {
            self.logOut!.alpha = 1
            self.logOut!.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        // Populate profile with user data
        let user = self.defaults.object(forKey: "user") as? String
        let userData = self.defaults.dictionary(forKey: user!) as! [String : String]
        var nameData = userData["name"]
        var uniData = userData["uni"]
        var courseData = userData["course"]
        
        content = ["Name: \(nameData!)", "Email: \(user!)", "University: \(uniData!)", "Course: \(courseData!)"]
        
        loadDataFromFirebase()
        
        self.tableView.reloadData()
        
        
    }
    
    
    
    
    func loadDataFromFirebase() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        FIRDatabase.database().reference().observe(.value, with: { snapshot in
            var tempItems = [NSDictionary]()
            
            for item in snapshot.children {
                let child = item as! FIRDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            
            self.content2 = []
            self.content3 = []
            var x = 0
            for item in tempItems {
                
                var storedUser = tempItems[x]["user"] as! String
                let user = self.defaults.object(forKey: "user") as? String
                if user == storedUser {
                    
                    self.content2.append(tempItems[x]["text"] as! String)
                    self.content3.append(tempItems[x]["user"] as! String)
                    self.content4.append(tempItems[x]["date"] as! String)
                    self.content5.append(tempItems[x]["name"] as! String)
                    self.content6.append(tempItems[x]["uni"] as! String)
                    self.content7.append(tempItems[x]["course"] as! String)
                    var vote = (tempItems[x]["votes"] as! String)
                    self.content8.append(Int(vote)!)
                    var report = (tempItems[x]["reported"] as! String)
                    self.content9.append(Int(report)!)
                    self.content10.append(tempItems[x]["lat"] as! Int)
                    self.content11.append(tempItems[x]["long"] as! Int)
                    
                }
                x = x + 1
            }
            
            self.tableView.reloadData()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    
    
    
    
    func logOut(button: UIButton) {
        do {
            try FIRAuth.auth()!.signOut()
        } catch {
            print("error")
        }
        var controller = RegisterViewController()
        self.present(controller, animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Translate animation using MengTo's Spring library
        // Dismiss avatar and button so that it doesn't overlap when displayed again
        imageView.transform = CGAffineTransform(translationX: 0, y: 0)
        springWithDelay(duration: 0.8, delay: 0, animations: {
            self.imageView.alpha = 0
            self.imageView.transform = CGAffineTransform(translationX: 0, y: -200)
        })
        
        logOut!.transform = CGAffineTransform(translationX: 0, y: 0)
        springWithDelay(duration: 0.8, delay: 0, animations: {
            self.logOut!.alpha = 0
            self.logOut!.transform = CGAffineTransform(translationX: 0, y: -200)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.row == 4 {
            return 40;
        } else if indexPath.row > 4 {
            if let string: String = self.content2[indexPath.row - 5]  {
                
                let someWidth: CGFloat = tableView.frame.size.width - 80
                let stringAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
                let attrString: NSAttributedString = NSAttributedString(string: string, attributes: stringAttributes)
                let frame: CGRect = CGRect(x: 0, y: 0, width: someWidth, height: CGFloat.greatestFiniteMagnitude)
                let textView: UITextView = UITextView(frame: frame)
                textView.textStorage.setAttributedString(attrString)
                textView.sizeToFit()
                let height: CGFloat = textView.frame.size.height + 30
                
                return height
                
            }
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count + self.content2.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row < 4 {
            var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            
            cell.textLabel?.text = self.content[indexPath.row]
            
            cell.backgroundColor = Colors.white
            cell.textLabel?.textColor = Colors.grayDark
            
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            
            cell.textLabel!.font = UIFont.systemFont(ofSize: 16)
            cell.textLabel?.numberOfLines = 0
            
            tableView.showsVerticalScrollIndicator = false
            cell.isUserInteractionEnabled = false
            
            
            return cell
            
        } else if indexPath.row == 4 {
            
            var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
            
            cell.textLabel?.text = "My Posts:"
            
            cell.backgroundColor = Colors.cellNorm
            
            cell.textLabel?.textColor = UIColor.gray
            
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            
            cell.textLabel!.font = UIFont.systemFont(ofSize: 12)
            cell.textLabel?.numberOfLines = 0
            
            tableView.showsVerticalScrollIndicator = false
            cell.isUserInteractionEnabled = false
            
            
            return cell
            
        } else {
            
            
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "subtitleCell")
            
            cell.textLabel?.text = self.content2[indexPath.row - 5]
            cell.detailTextLabel?.text = self.content4[indexPath.row - 5]
            
            cell.backgroundColor = Colors.white
            
            cell.textLabel?.textColor = Colors.grayDark
            cell.detailTextLabel?.textColor = UIColor.gray
            
            cell.layoutMargins = UIEdgeInsets.zero
            cell.separatorInset = UIEdgeInsets.zero
            
            cell.textLabel!.font = UIFont.systemFont(ofSize: 16)
            cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 12)
            cell.textLabel?.numberOfLines = 0
            
            tableView.showsVerticalScrollIndicator = false
            cell.isUserInteractionEnabled = true
            
            
            return cell
            
            
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 4 {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        
        
        var controller = DetailViewController()
        controller.titleText = self.content2[indexPath.row - 5]
        controller.emailText = self.content3[indexPath.row - 5]
        controller.nameText = self.content5[indexPath.row - 5]
        controller.uniText = self.content6[indexPath.row - 5]
        controller.courseText = self.content7[indexPath.row - 5]
        controller.dateText = self.content4[indexPath.row - 5]
        controller.voteText = self.content8[indexPath.row - 5]
        controller.reportedText = self.content9[indexPath.row - 5]
        controller.latText = self.content10[indexPath.row - 5]
        controller.longText = self.content11[indexPath.row - 5]
        self.present(controller, animated: true, completion: nil)
        }
    }
    
    
}
