//
//  FeedViewController.swift
//  Linkversity
//
//  Created by Shihab Mehboob on 16/10/2016.
//  Copyright © 2016 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TwicketSegmentedControlDelegate {
    
    var tableView: UITableView = UITableView()
    var content: [String] = []
    var content2: [String] = []
    var ref = FIRDatabase.database().reference()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the table and set its datasource and delegate
        tableView.frame = CGRect(x: 0, y: ((self.navigationController?.navigationBar.bounds.height)! + 60), width: self.view.bounds.width - 0, height: self.view.bounds.height - (self.navigationController?.navigationBar.bounds.height)! - 110);
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = Colors.cellNorm
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        self.tableView.reloadData()
        
        // Segmented control (TwicketSegmentedControl library by Pol Quintana)
        let titles = ["All Posts", "Campus Posts", "My Posts"]
        let frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.bounds.height)! + 20, width: view.frame.width - 0, height: 40)
        
        let segmentedControl = TwicketSegmentedControl(frame: frame)
        segmentedControl.setSegmentItems(titles)
        segmentedControl.delegate = self
        
        self.view.addSubview(segmentedControl)
        
        
        loadDataFromFirebase()
        
    }
    
    
    func didSelect(_ segmentIndex: Int) {
        if segmentIndex == 0 {
            self.loadDataFromFirebase()
        } else if segmentIndex == 1 {
            self.loadDataFromFirebaseCampus()
        } else {
            self.loadDataFromFirebaseMy()
        }
    }
    
    
    func setLoad(notification: NSNotification) {
        loadDataFromFirebase()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadDataFromFirebase()
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
            
            self.content = []
            self.content2 = []
            var x = 0
            for item in tempItems {
                self.content.append(tempItems[x]["text"] as! String)
                self.content2.append(tempItems[x]["user"] as! String)
                x = x + 1
            }
            
            self.tableView.reloadData()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    
    func loadDataFromFirebaseCampus() {
        
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
            var x = 0
            for item in tempItems {
                
                let user = self.defaults.object(forKey: "user") as? String
                let userData = self.defaults.dictionary(forKey: user!) as! [String : String]
                var storedUni = userData["uni"]
                var uniData = (tempItems[x]["uni"] as! String)
                
                if uniData == storedUni! {
                    
                    self.content.append(tempItems[x]["text"] as! String)
                    self.content2.append(tempItems[x]["user"] as! String)
                    
                }
                x = x + 1
            }
            
            self.tableView.reloadData()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    
    func loadDataFromFirebaseMy() {
        
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
            var x = 0
            for item in tempItems {
                
                var storedUser = tempItems[x]["user"] as! String
                let user = self.defaults.object(forKey: "user") as? String
                if user == storedUser {
                    
                    self.content.append(tempItems[x]["text"] as! String)
                    self.content2.append(tempItems[x]["user"] as! String)
                    
                }
                x = x + 1
            }
            
            self.tableView.reloadData()
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "subtitleCell")
        
        cell.textLabel?.text = self.content[indexPath.row]
        cell.detailTextLabel?.text = "Posted by: \(self.content2[indexPath.row])"
        
        // Every other row has a different background shade
        if indexPath.row < self.content.count + 1 {
            cell.backgroundColor = Colors.white
        } else {
            cell.backgroundColor = Colors.cellNorm
        }
        cell.textLabel?.textColor = Colors.grayDark
        cell.detailTextLabel?.textColor = UIColor.gray
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.textLabel!.font = UIFont.systemFont(ofSize: 16)
        cell.detailTextLabel!.font = UIFont.systemFont(ofSize: 12)
        cell.textLabel?.numberOfLines = 0
        
        tableView.showsVerticalScrollIndicator = false
        cell.isUserInteractionEnabled = false
        
        
        return cell
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }

    
    
}
