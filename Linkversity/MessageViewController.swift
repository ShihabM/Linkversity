//
//  MessageViewController.swift
//  Linkversity
//
//  Created by Shihab Mehboob on 16/10/2016.
//  Copyright © 2016 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TwicketSegmentedControlDelegate {
    
    var tableView: UITableView = UITableView()
    var content: [String] = []
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
    var contentEmail: [String] = []
    var segmentTouched = 0
    var post: UIButton?
    var ref = FIRDatabase.database().reference()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.blueDim
        
        
        // Create the table and set its datasource and delegate
        tableView.frame = CGRect(x: 0, y: ((self.navigationController?.navigationBar.bounds.height)! + 60), width: self.view.bounds.width - 0, height: self.view.bounds.height - (self.navigationController?.navigationBar.bounds.height)! - 110);
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = Colors.blueDim
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        self.tableView.reloadData()
        
        // Segmented control (TwicketSegmentedControl library by Pol Quintana)
        let titles = ["My Replies", "My Messages"]
        let frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.height)! + 20, width: view.frame.width - 0, height: 40)
        
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self
        
        self.view.addSubview(segmentedControl)
        
        
        loadDataFromFirebase()
    }
    
    
    
    
    func didSelect(_ segmentIndex: Int) {
        if segmentIndex == 0 {
            self.hidePostButton()
            self.segmentTouched = 0
            self.loadDataFromFirebase()
        } else if segmentIndex == 1 {
            self.showPostButton()
            self.segmentTouched = 1
            self.loadDataFromFirebaseMessage()
        } else {
            
        }
    }
    
    func hidePostButton() {
        
        // Translate animation using MengTo's Spring library
        self.post!.transform = CGAffineTransform(translationX: 0, y: 0)
        springWithDelay(duration: 0.9, delay: 0.05, animations: {
            self.post!.alpha = 1
            self.post!.transform = CGAffineTransform(translationX: 0, y: 100)
        })
        
    }
    
    func showPostButton() {
    
        
        // Post button
        self.post = UIButton(type: UIButtonType.custom)
        self.post!.frame = CGRect(x: self.view.bounds.width - 75, y: self.view.bounds.height - 125, width: 50, height: 50)
        self.post!.alpha = 0
        self.post!.layer.cornerRadius = 25
        self.post!.backgroundColor = Colors.blueAlternative
        self.post!.addTarget(self, action: #selector(post(button:)), for: .touchUpInside)
        var postImage = UIImage(named: "post.png")!
        postImage = postImage.imageWithColor(color1: Colors.white).withRenderingMode(.alwaysOriginal)
        self.post!.setImage(postImage, for: .normal)
        self.post!.imageEdgeInsets = UIEdgeInsetsMake(14, 14, 14, 14)
        self.view.addSubview(post!)
        
        // Translate animation using MengTo's Spring library
        self.post!.transform = CGAffineTransform(translationX: 0, y: 100)
        springWithDelay(duration: 0.9, delay: 0.05, animations: {
            self.post!.alpha = 1
            self.post!.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        
    }
    
    
    func post(button: UIButton) {
        
        var controller = SendMessageViewController()
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    
    func loadDataFromFirebase() {
        
        
        
        let user = self.defaults.object(forKey: "user") as? String
        let userData = self.defaults.dictionary(forKey: user!) as! [String : String]
        var nameData = userData["name"]
        var uniData = userData["uni"]
        var courseData = userData["course"]
        var userEmail = userData["email"]
        
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        FIRDatabase.database().reference().observe(.value, with: { snapshot in
            var tempItems = [NSDictionary]()
            
            for item in snapshot.children {
                let child = item as! FIRDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            
            self.content = []
            self.content2 = []
            self.content3 = []
            self.content4 = []
            self.content5 = []
            self.content6 = []
            self.content7 = []
            self.content8 = []
            self.content9 = []
            self.content10 = []
            self.content11 = []
            
            var x = 0
            for item in tempItems {
                
                if (tempItems[x]["reported"] as! String) == "thisIsAMessage" {
                    
                } else {
                
                if let val = tempItems[x]["replies"] {
                    var tempRep = tempItems[x]["replies"] as! NSDictionary
                    for (key, value) in tempRep {
                        
                        
                        var value2 = value as! NSDictionary
                        for (y,z) in value2 {
                            
                            if y as! String == "replyUserEmail" {
                                if (z as! String) == userEmail {
                                    
                                    
                                    for (y,z) in value2 {
                                        if y as! String == "reply" {
                                            self.content.append(z as! String)
                                            self.content2.append(tempItems[x]["text"] as! String)
                                            self.content3.append(tempItems[x]["user"] as! String)
                                            self.content4.append(tempItems[x]["name"] as! String)
                                            self.content5.append(tempItems[x]["uni"] as! String)
                                            self.content6.append(tempItems[x]["course"] as! String)
                                            self.content7.append(tempItems[x]["date"] as! String)
                                            var vote = (tempItems[x]["votes"] as! String)
                                            self.content8.append(Int(vote)!)
                                            var report = (tempItems[x]["reported"] as! String)
                                            self.content9.append(Int(report)!)
                                            self.content10.append(tempItems[x]["lat"] as! Int)
                                            self.content11.append(tempItems[x]["long"] as! Int)
                                        }
                                    }
                                    
                                    
                                }
                            }
                            
                            
                        }
                        
                    }
                }
                }
                x = x + 1
            }
            
            self.tableView.reloadData()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    
    func loadDataFromFirebaseMessage() {
        
        
        let user = self.defaults.object(forKey: "user") as? String
        let userData = self.defaults.dictionary(forKey: user!) as! [String : String]
        var nameData = userData["name"]
        var uniData = userData["uni"]
        var courseData = userData["course"]
        var userEmail = userData["email"]
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        FIRDatabase.database().reference().observe(.value, with: { snapshot in
            var tempItems = [NSDictionary]()
            
            for item in snapshot.children {
                let child = item as! FIRDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            
            self.content = []
            self.content2 = []
            self.content3 = []
            self.content4 = []
            self.content5 = []
            self.content6 = []
            self.content7 = []
            self.content8 = []
            self.content9 = []
            self.content10 = []
            self.content11 = []
            var x = 0
            
            for item in tempItems {
                
                if (tempItems[x]["reported"] as! String) == "thisIsAMessage" {
                    if (tempItems[x]["votes"] as! String) == userEmail {
                    
                    self.content2.append(tempItems[x]["text"] as! String)
                    self.content3.append(tempItems[x]["user"] as! String)
                    self.content4.append(tempItems[x]["name"] as! String)
                    self.content5.append(tempItems[x]["uni"] as! String)
                    self.content6.append(tempItems[x]["course"] as! String)
                    self.content7.append(tempItems[x]["date"] as! String)
                    self.contentEmail.append(tempItems[x]["votes"] as! String)
                        
                    }
                }
                x = x + 1
                
            }
            
            self.tableView.reloadData()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.segmentTouched == 0 {
            return self.content.count
        } else {
            return self.content2.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.segmentTouched == 0 {
        if let string: String = self.content[indexPath.row]  {
            
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
        } else {
            if let string: String = self.content2[indexPath.row]  {
                
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
        
        
        return 140
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "subtitleCell")
        
        if self.segmentTouched == 0 {
            cell.textLabel?.text = self.content[indexPath.row]
            cell.detailTextLabel?.text = "Replied to: " + self.content2[indexPath.row]
            
            
            // Row background shade for rows with content
            if indexPath.row < self.content.count + 1 {
                if indexPath.row % 2 == 0 {
                    cell.backgroundColor = Colors.white
                } else {
                    cell.backgroundColor = Colors.cellAlternative
                }
            } else {
                cell.backgroundColor = Colors.blueDim
            }
            
        } else {
            cell.textLabel?.text = self.content2[indexPath.row]
            cell.detailTextLabel?.text = self.content3[indexPath.row]
            
            
            // Row background shade for rows with content
            if indexPath.row < self.content2.count + 1 {
                if indexPath.row % 2 == 0 {
                    cell.backgroundColor = Colors.white
                } else {
                    cell.backgroundColor = Colors.cellAlternative
                }
            } else {
                cell.backgroundColor = Colors.blueDim
            }
        }
        
        
        
        cell.textLabel?.textColor = Colors.grayDark
        cell.detailTextLabel?.textColor = UIColor.gray
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.textLabel!.font = UIFont.systemFont(ofSize: 16)
        cell.detailTextLabel!.font = UIFont.italicSystemFont(ofSize: 12)
        cell.textLabel?.numberOfLines = 0
        
        tableView.showsVerticalScrollIndicator = false
        cell.isUserInteractionEnabled = true
        
        if self.segmentTouched == 1 {
            // Cell image
            var feedImage = UIImage(named: "profile.png") as UIImage?
            feedImage = feedImage?.imageWithColor(color1: Colors.blueDim).withRenderingMode(.alwaysOriginal)
            cell.imageView?.image = feedImage
        }
        
        return cell
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        if self.segmentTouched == 0 {
            
            var controller = DetailViewController()
            controller.titleText = self.content2[indexPath.row]
            controller.emailText = self.content3[indexPath.row]
            controller.nameText = self.content4[indexPath.row]
            controller.uniText = self.content5[indexPath.row]
            controller.courseText = self.content6[indexPath.row]
            controller.dateText = self.content7[indexPath.row]
            controller.voteText = self.content8[indexPath.row]
            controller.reportedText = self.content9[indexPath.row]
            controller.latText = self.content10[indexPath.row]
            controller.longText = self.content11[indexPath.row]
            self.present(controller, animated: true, completion: nil)
            
        } else {
            
        }
        
    }
    
}
