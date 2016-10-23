//
//  DetailViewController.swift
//  Linkversity
//
//  Created by Shihab Mehboob on 22/10/2016.
//  Copyright © 2016 Shihab Mehboob. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import MapKit
import CoreLocation

class DetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let defaults = UserDefaults.standard
    var dismiss: UIButton?
    var up: UIButton?
    var down: UIButton?
    var reply: UIButton?
    var flag: UIButton?
    var share: UIButton?
    var isUpvoted: Bool = false
    var isDownvoted: Bool = false
    var isReported: Bool = false
    var dateLabel = UILabel(frame: CGRect(x: 250, y: 195, width: 60, height: 20))
    var voteLabel = UILabel(frame: CGRect(x: 250, y: 195, width: 60, height: 20))
    var postText = UITextView(frame: CGRect(x: 250, y: 195, width: 60, height: 20))
    var infoText = UILabel(frame: CGRect(x: 250, y: 195, width: 60, height: 20))
    var titleText = ""
    var emailText = ""
    var nameText = ""
    var uniText = ""
    var courseText = ""
    var dateText = ""
    var voteText = 0
    var reportedText = 0
    var latText = 0
    var longText = 0
    let locationManager = CLLocationManager()
    var mapView: MKMapView = MKMapView()
    var tableView: UITableView = UITableView()
    var content: [String] = ["1", "2", "3", "4", "5", "6"]
    var repArray: [String] = ["1", "2", "3", "4", "5", "6"]
    var repArray2: [String] = ["1", "2", "3", "4", "5", "6"]
    
    
    
    
    
    
    func loadDataFromFirebase() {
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        FIRDatabase.database().reference().observe(.value, with: { snapshot in
            var tempItems = [NSDictionary]()
            
            for item in snapshot.children {
                let child = item as! FIRDataSnapshot
                let dict = child.value as! NSDictionary
                tempItems.append(dict)
            }
            
            self.repArray = []
            self.repArray2 = []
            var x = 0
            for item in tempItems {
                if (tempItems[x]["text"] as! String) == self.titleText {
                    
                    
                    if let val = tempItems[x]["replies"] {
                        var tempRep = tempItems[x]["replies"] as! NSDictionary
                        for (key, value) in tempRep {
                            
                            
                            var value2 = value as! NSDictionary
                            for (y,z) in value2 {
                                
                                if y as! String == "reply" {
                                    self.repArray.append(z as! String)
                                }
                                if y as! String == "replyUser" {
                                    self.repArray2.append(z as! String)
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
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.blueDark
        
        loadDataFromFirebase()
        
        // Ask for location authorisation from user and use in foreground
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        
        
        
        // Post text label
        postText = UITextView(frame: CGRect(x: 20, y: 60, width: self.view.bounds.width - 40, height: 250))
        postText.font = UIFont.systemFont(ofSize: 20)
        postText.textAlignment = NSTextAlignment.left
        postText.text = self.titleText
        postText.textColor = Colors.white
        postText.backgroundColor = UIColor.clear
        postText.isEditable = false
        self.view.addSubview(postText)
        
        // Translate animation using MengTo's Spring library
        springWithDelay(duration: 1, delay: 0, animations: {
            self.postText.alpha = 1
        })
        
        
        
        // Info label
        infoText = UILabel(frame: CGRect(x: 20, y: 185, width: self.view.bounds.width - 40, height: 35))
        infoText.font = UIFont.italicSystemFont(ofSize: 12)
        infoText.textAlignment = NSTextAlignment.left
        infoText.text = "Posted by " + self.nameText + ", a " + self.courseText + " student from " + self.uniText
        infoText.textColor = Colors.blueDim
        infoText.backgroundColor = UIColor.clear
        self.view.addSubview(infoText)
        
        // Translate animation using MengTo's Spring library
        springWithDelay(duration: 0.65, delay: 0, animations: {
            self.infoText.alpha = 1
        })
        
        // Map
        mapView.frame = CGRect(x: 0, y: 220, width: self.view.bounds.width, height: 150)
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.tintColor = Colors.blueAlternative
        self.view.addSubview(mapView)
        
        // Zoom in on map to region
        let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.latText), longitude: CLLocationDegrees(self.longText))
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(region, animated: true)
        
        // Drop a pin
        let newYorkLocation = CLLocationCoordinate2DMake(CLLocationDegrees(self.latText), CLLocationDegrees(self.longText))
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = newYorkLocation
        dropPin.title = "You posted here"
        mapView.addAnnotation(dropPin)
        
        
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        // Action buttons
        
        // share button
        self.share = UIButton(type: UIButtonType.custom)
        self.share!.frame = CGRect(x: 0, y: 370, width: (self.view.bounds.width/5), height: 60)
        self.share!.alpha = 0
        self.share!.layer.cornerRadius = 25
        self.share!.backgroundColor = UIColor.clear
        self.share!.addTarget(self, action: #selector(share(button:)), for: .touchUpInside)
        var shareImage = UIImage(named: "share.png") as UIImage?
        shareImage = shareImage?.imageWithColor(color1: Colors.white).withRenderingMode(.alwaysOriginal)
        self.share!.setImage(shareImage, for: .normal)
        self.share!.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16)
        self.view.addSubview(share!)
        // Translate animation using MengTo's Spring library
        self.share!.transform = CGAffineTransform(translationX: 0, y: 100)
        springWithDelay(duration: 0.7, delay: 0.03, animations: {
            self.share!.alpha = 1
            self.share!.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        // flag button
        self.flag = UIButton(type: UIButtonType.custom)
        self.flag!.frame = CGRect(x: (self.view.bounds.width/5), y: 370, width: (self.view.bounds.width/5), height: 60)
        self.flag!.alpha = 0
        self.flag!.layer.cornerRadius = 25
        self.flag!.backgroundColor = UIColor.clear
        self.flag!.addTarget(self, action: #selector(flag(button:)), for: .touchUpInside)
        var flagImage = UIImage(named: "flag.png") as UIImage?
        flagImage = flagImage?.imageWithColor(color1: Colors.white).withRenderingMode(.alwaysOriginal)
        self.flag!.setImage(flagImage, for: .normal)
        self.flag!.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16)
        self.view.addSubview(flag!)
        // Translate animation using MengTo's Spring library
        self.flag!.transform = CGAffineTransform(translationX: 0, y: 100)
        springWithDelay(duration: 0.65, delay: 0.15, animations: {
            self.flag!.alpha = 1
            self.flag!.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        // reply button
        self.reply = UIButton(type: UIButtonType.custom)
        self.reply!.frame = CGRect(x: (self.view.bounds.width/5)*2, y: 370, width: (self.view.bounds.width/5), height: 60)
        self.reply!.alpha = 0
        self.reply!.layer.cornerRadius = 25
        self.reply!.backgroundColor = UIColor.clear
        self.reply!.addTarget(self, action: #selector(reply(button:)), for: .touchUpInside)
        var replyImage = UIImage(named: "reply.png") as UIImage?
        replyImage = replyImage?.imageWithColor(color1: Colors.white).withRenderingMode(.alwaysOriginal)
        self.reply!.setImage(replyImage, for: .normal)
        self.reply!.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16)
        self.view.addSubview(reply!)
        // Translate animation using MengTo's Spring library
        self.reply!.transform = CGAffineTransform(translationX: 0, y: 100)
        springWithDelay(duration: 0.67, delay: 0.17, animations: {
            self.reply!.alpha = 1
            self.reply!.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        // downvote button
        self.down = UIButton(type: UIButtonType.custom)
        self.down!.frame = CGRect(x: (self.view.bounds.width/5)*3, y: 370, width: (self.view.bounds.width/5), height: 60)
        self.down!.alpha = 0
        self.down!.layer.cornerRadius = 25
        self.down!.backgroundColor = UIColor.clear
        self.down!.addTarget(self, action: #selector(downvote(button:)), for: .touchUpInside)
        var downImage = UIImage(named: "down.png") as UIImage?
        downImage = downImage?.imageWithColor(color1: Colors.white).withRenderingMode(.alwaysOriginal)
        self.down!.setImage(downImage, for: .normal)
        self.down!.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16)
        self.view.addSubview(down!)
        // Translate animation using MengTo's Spring library
        self.down!.transform = CGAffineTransform(translationX: 0, y: 100)
        springWithDelay(duration: 0.65, delay: 0.19, animations: {
            self.down!.alpha = 1
            self.down!.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        // upvote button
        self.up = UIButton(type: UIButtonType.custom)
        self.up!.frame = CGRect(x: (self.view.bounds.width/5)*4, y: 370, width: (self.view.bounds.width/5), height: 60)
        self.up!.alpha = 0
        self.up!.layer.cornerRadius = 25
        self.up!.backgroundColor = UIColor.clear
        self.up!.addTarget(self, action: #selector(upvote(button:)), for: .touchUpInside)
        var upImage = UIImage(named: "up.png") as UIImage?
        upImage = upImage?.imageWithColor(color1: Colors.white).withRenderingMode(.alwaysOriginal)
        self.up!.setImage(upImage, for: .normal)
        self.up!.imageEdgeInsets = UIEdgeInsetsMake(16, 16, 16, 16)
        self.view.addSubview(up!)
        // Translate animation using MengTo's Spring library
        self.up!.transform = CGAffineTransform(translationX: 0, y: 100)
        springWithDelay(duration: 0.8, delay: 0.21, animations: {
            self.up!.alpha = 1
            self.up!.transform = CGAffineTransform(translationX: 0, y: 0)
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
        springWithDelay(duration: 0.65, delay: 0.15, animations: {
            self.dismiss!.alpha = 1
            self.dismiss!.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        
        
        
        // Vote label
        voteLabel = UILabel(frame: CGRect(x: Int(self.view.bounds.width/2 - 50), y: 20, width: 100, height: 40))
        voteLabel.font = UIFont.boldSystemFont(ofSize: 18)
        voteLabel.textAlignment = NSTextAlignment.center
        voteLabel.text = String(self.voteText) + "\u{021C5}"
        voteLabel.textColor = Colors.blueAlternative
        voteLabel.backgroundColor = UIColor.clear
        self.view.addSubview(voteLabel)
        
        // Translate animation using MengTo's Spring library
        self.voteLabel.transform = CGAffineTransform(translationX: 0, y: -100)
        springWithDelay(duration: 0.8, delay: 0.2, animations: {
            self.voteLabel.alpha = 1
            self.voteLabel.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        
        
        
        // Date label
        dateLabel = UILabel(frame: CGRect(x: 50, y: 20, width: self.view.bounds.width - 70, height: 40))
        dateLabel.font = UIFont.italicSystemFont(ofSize: 12)
        dateLabel.textAlignment = NSTextAlignment.right
        dateLabel.text = self.dateText
        dateLabel.textColor = Colors.blueDim
        dateLabel.backgroundColor = UIColor.clear
        self.view.addSubview(dateLabel)
        
        // Translate animation using MengTo's Spring library
        springWithDelay(duration: 1, delay: 0.23, animations: {
            self.dateLabel.alpha = 1
        })
        
        
        
        // Create the table and set its datasource and delegate
        tableView.frame = CGRect(x: 0, y: 430, width: self.view.bounds.width - 0, height: (self.view.bounds.height - 430));
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = Colors.blueDark
        tableView.separatorStyle = .none
        tableView.alpha = 0
        self.view.addSubview(tableView)
        self.tableView.reloadData()
        
        // Translate animation using MengTo's Spring library
        self.tableView.transform = CGAffineTransform(translationX: 0, y: 100)
        springWithDelay(duration: 0.65, delay: 0.2, animations: {
            self.tableView.alpha = 1
            self.tableView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.repArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "subtitleCell")
        
        
        print("----------------------")
        print(repArray)
        print("==================")
        print(repArray2)
        
        
        cell.textLabel?.text = self.repArray[indexPath.row]
        cell.detailTextLabel?.text = self.repArray2[indexPath.row]
        
        
        // Row background shade for rows with content
        if indexPath.row < self.content.count + 1 {
            cell.backgroundColor = Colors.blueDim
        } else {
            cell.backgroundColor = Colors.blueDark
        }
        cell.textLabel?.textColor = Colors.white
        cell.detailTextLabel?.textColor = UIColor.lightGray
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.textLabel!.font = UIFont.systemFont(ofSize: 16)
        cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 12)
        cell.textLabel?.numberOfLines = 0
        
        tableView.showsVerticalScrollIndicator = false
        cell.isUserInteractionEnabled = false
        
        
        return cell
        
    }

    
    func dismiss(button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func reply(button: UIButton) {
        var controller = ReplyViewController()
        controller.titleText = self.titleText
        self.present(controller, animated: true, completion: nil)
    }
    func share(button: UIButton) {
        
        // Share the main post, bring up a Share Sheet
        
        let textToShare = self.titleText
        
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = button as! UIView
        self.present(activityVC, animated: true, completion: nil)

    }
    func flag(button: UIButton) {
        
        if self.isReported == false {
            var reportImage = UIImage(named: "flag.png") as UIImage?
            reportImage = reportImage?.imageWithColor(color1: UIColor.red).withRenderingMode(.alwaysOriginal)
            self.flag!.setImage(reportImage, for: .normal)
            
            
            self.isReported = true
            
            
            var newReport = self.reportedText + 1
            self.reportedText = newReport
            
            
            var sanitisedString = self.titleText.replacingOccurrences(of: ".", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "#", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "$", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "[", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "]", with: "|")
            
            FIRDatabase.database().reference().child(sanitisedString).child("reported").setValue(String(newReport))
        } else {
            
            var reportImage = UIImage(named: "flag.png") as UIImage?
            reportImage = reportImage?.imageWithColor(color1: UIColor.white).withRenderingMode(.alwaysOriginal)
            self.flag!.setImage(reportImage, for: .normal)
            
            
            self.isReported = false
            
            
            var newReport = self.reportedText - 1
            self.reportedText = newReport
            
            
            var sanitisedString = self.titleText.replacingOccurrences(of: ".", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "#", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "$", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "[", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "]", with: "|")
            
            FIRDatabase.database().reference().child(sanitisedString).child("reported").setValue(String(newReport))
        }
    }
    func downvote(button: UIButton) {
        
        
        if self.isDownvoted == false {
            var upImage = UIImage(named: "up.png") as UIImage?
            upImage = upImage?.imageWithColor(color1: Colors.white).withRenderingMode(.alwaysOriginal)
            self.up!.setImage(upImage, for: .normal)
            
            var downImage = UIImage(named: "down.png") as UIImage?
            downImage = downImage?.imageWithColor(color1: Colors.blueAlternative).withRenderingMode(.alwaysOriginal)
            self.down!.setImage(downImage, for: .normal)
            
            self.isDownvoted = true
            self.isUpvoted = false
            
            
            var newVote = self.voteText - 1
            self.voteText = newVote
            voteLabel.text = String(newVote) + "\u{021C5}"
            
            
            var sanitisedString = self.titleText.replacingOccurrences(of: ".", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "#", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "$", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "[", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "]", with: "|")
            
            FIRDatabase.database().reference().child(sanitisedString).child("votes").setValue(String(newVote))
        } else {
            
            var downImage = UIImage(named: "down.png") as UIImage?
            downImage = downImage?.imageWithColor(color1: Colors.white).withRenderingMode(.alwaysOriginal)
            self.down!.setImage(downImage, for: .normal)
            
            self.isUpvoted = false
            self.isDownvoted = false
            
            
            var newVote = self.voteText + 1
            self.voteText = newVote
            voteLabel.text = String(newVote) + "\u{021C5}"
            
            
            var sanitisedString = self.titleText.replacingOccurrences(of: ".", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "#", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "$", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "[", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "]", with: "|")
            
            FIRDatabase.database().reference().child(sanitisedString).child("votes").setValue(String(newVote))
        }
        
        
        
    }
    func upvote(button: UIButton) {
        
        if self.isUpvoted == false {
            var upImage = UIImage(named: "up.png") as UIImage?
            upImage = upImage?.imageWithColor(color1: Colors.blueAlternative).withRenderingMode(.alwaysOriginal)
            self.up!.setImage(upImage, for: .normal)
            
            var downImage = UIImage(named: "down.png") as UIImage?
            downImage = downImage?.imageWithColor(color1: Colors.white).withRenderingMode(.alwaysOriginal)
            self.down!.setImage(downImage, for: .normal)
            
            self.isUpvoted = true
            self.isDownvoted = false
            
            
            var newVote = self.voteText + 1
            self.voteText = newVote
            voteLabel.text = String(newVote) + "\u{021C5}"
            
            
            var sanitisedString = self.titleText.replacingOccurrences(of: ".", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "#", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "$", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "[", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "]", with: "|")
            
            FIRDatabase.database().reference().child(sanitisedString).child("votes").setValue(String(newVote))
        } else {
            
            var upImage = UIImage(named: "up.png") as UIImage?
            upImage = upImage?.imageWithColor(color1: Colors.white).withRenderingMode(.alwaysOriginal)
            self.up!.setImage(upImage, for: .normal)
            
            
            self.isDownvoted = false
            self.isUpvoted = false
            
            
            var newVote = self.voteText - 1
            self.voteText = newVote
            voteLabel.text = String(newVote) + "\u{021C5}"
            
            
            var sanitisedString = self.titleText.replacingOccurrences(of: ".", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "#", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "$", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "[", with: "|")
            sanitisedString = sanitisedString.replacingOccurrences(of: "]", with: "|")
            
            FIRDatabase.database().reference().child(sanitisedString).child("votes").setValue(String(newVote))
        }
        
        
        
    }
    
}
