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
    var content: [String] = ["Name:", "Bio:", "Email:", "University:", "Course:"]
    var ref = FIRDatabase.database().reference()
    var imageView = UIImageView()
    let defaults = UserDefaults.standard
    var logOut: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.cellNorm
        
        // Header section
        var headerImageView : UIImageView
        headerImageView  = UIImageView(frame:CGRect(x: 0, y: ((self.navigationController?.navigationBar.bounds.height)! + 20), width: self.view.bounds.width, height: 200));
        headerImageView.backgroundColor = Colors.blueAlternative
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
        
        // Avatar
        imageView  = UIImageView(frame:CGRect(x: self.view.bounds.width/2 - 50, y: ((self.navigationController?.navigationBar.bounds.height)! + 70), width: 100, height: 100));
        imageView.backgroundColor = Colors.white
        imageView.layer.cornerRadius = 50
        //imageView.image = UIImage(named:"title.png")
        self.view.addSubview(imageView)
        
        // Translate animation using MengTo's Spring library
        imageView.transform = CGAffineTransform(translationX: 0, y: -100)
        springWithDelay(duration: 0.8, delay: 0, animations: {
            self.imageView.alpha = 1
            self.imageView.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        
        
        
        
        // Log out button
        self.logOut = UIButton(type: UIButtonType.custom)
        self.logOut!.frame = CGRect(x: (self.view.bounds.width/4)*3 - 15, y: ((self.navigationController?.navigationBar.bounds.height)! + 95), width: 90, height: 50)
        self.logOut!.alpha = 0
        self.logOut!.layer.cornerRadius = 25
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
        
        
        
        let user = self.defaults.object(forKey: "user") as? String
        print(user)
        content = ["Name:", "Bio:", "Email: \(user!)", "University:", "Course:"]
        
        self.tableView.reloadData()
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
        // Dismiss avatar so that it doesn't overlap when displayed again
        imageView.transform = CGAffineTransform(translationX: 0, y: 0)
        springWithDelay(duration: 0.8, delay: 0, animations: {
            self.imageView.alpha = 0
            self.imageView.transform = CGAffineTransform(translationX: 0, y: -200)
        })
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = self.content[indexPath.row]
        
        // Different background shades
        if indexPath.row < 5 {
            cell.backgroundColor = Colors.white
        } else {
            cell.backgroundColor = Colors.cellNorm
        }
        cell.textLabel?.textColor = Colors.grayDark
        
        cell.layoutMargins = UIEdgeInsets.zero
        cell.separatorInset = UIEdgeInsets.zero
        
        cell.textLabel!.font = UIFont.systemFont(ofSize: 12)
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
