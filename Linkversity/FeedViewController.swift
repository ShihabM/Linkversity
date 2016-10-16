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

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView = UITableView()
    var content: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the table and set its datasource and delegate
        tableView.frame = CGRect(x: 0, y: ((self.navigationController?.navigationBar.bounds.height)! + 20), width: self.view.bounds.width - 0, height: self.view.bounds.height - (self.navigationController?.navigationBar.bounds.height)! - 70);
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        self.tableView.reloadData()
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        
        cell.textLabel?.text = self.content[indexPath.row]
        
        // Every otehr row has a different background shade
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = Colors.cellNorm
        } else {
            cell.backgroundColor = Colors.white
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
