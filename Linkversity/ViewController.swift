//
//  ViewController.swift
//  Linkversity
//
//  Created by Shihab Mehboob on 16/10/2016.
//  Copyright © 2016 Shihab Mehboob. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITabBarController {
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Tab bar
        UITabBar.appearance().tintColor = Colors.blueAlternative
        UITabBar.appearance().barTintColor = Colors.blueDark
        // Used to change the tint colour of inactive tab bar images
        // Credit to BoilingLime http://stackoverflow.com/questions/29876722/how-to-change-color-for-tab-bar-non-selected-icon-in-swift
        for item in self.tabBar.items! as [UITabBarItem] {
            if let image = item.image {
                item.image = image.imageWithColor(color1: Colors.blueDim).withRenderingMode(.alwaysOriginal)
            }
        }
        
        // Left button item on the navigation bar
        var leftNavImage = UIImage(named: "more.png") as UIImage?
        let leftNavButton:UIButton = UIButton(type: UIButtonType.custom) as UIButton
        leftNavButton.addTarget(self, action: #selector(more(button:)), for: .touchUpInside)
        leftNavButton.sizeToFit()
        leftNavImage = leftNavImage?.imageWithColor(color1: Colors.blueDim).withRenderingMode(.alwaysOriginal)
        leftNavButton.setBackgroundImage(leftNavImage, for: .normal)
        leftNavButton.frame = CGRect(x: 0, y: 0, width: 20, height: 5)
        leftNavButton.alpha = 1
        let leftNavButtonItem:UIBarButtonItem = UIBarButtonItem(customView: leftNavButton)
        self.navigationItem.leftBarButtonItem  = leftNavButtonItem
        
        // Right button item on the navigation bar
        var rightNavImage = UIImage(named: "add.png") as UIImage?
        let rightNavButton:UIButton = UIButton(type: UIButtonType.custom) as UIButton
        rightNavButton.addTarget(self, action: #selector(add(button:)), for: .touchUpInside)
        rightNavButton.sizeToFit()
        rightNavImage = rightNavImage?.imageWithColor(color1: Colors.white).withRenderingMode(.alwaysOriginal)
        rightNavButton.setBackgroundImage(rightNavImage, for: .normal)
        rightNavButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        rightNavButton.alpha = 1
        let rightNavButtonItem:UIBarButtonItem = UIBarButtonItem(customView: rightNavButton)
        self.navigationItem.rightBarButtonItem  = rightNavButtonItem
        
        // Title item on the navigation bar
        let navigationBackgroundView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 20.0))
        navigationBackgroundView.backgroundColor = Colors.blueDark
        self.navigationController!.view.addSubview(navigationBackgroundView)
        navigationController?.navigationBar.barTintColor = Colors.blueDark
        navigationController?.navigationBar.backgroundColor = Colors.blueDark
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let imageViewTitle = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        imageViewTitle.contentMode = .scaleAspectFit
        let imageTitle = UIImage(named: "title.png")
        imageViewTitle.image = imageTitle
        navigationItem.titleView = imageViewTitle
        // Backup title if image isn't found
        self.navigationController?.navigationBar.topItem?.title = "Linkversity"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Colors.white]
        
        
        
        
        
        /*
        // Display registartion form initially
        let register = defaults.object(forKey: "hasRegistered") as? Int
        if register != nil {
            defaults.set(4, forKey: "hasRegistered")
        } else {
            defaults.set(2, forKey: "hasRegistered")
            var controller = RegisterViewController()
            self.present(controller, animated: true, completion: nil)
        }
        */
        
        var controller = RegisterViewController()
        self.present(controller, animated: true, completion: nil)
        
        
        
        
    }
    
    func more(button: UIButton) {
        
    }
    
    func add(button: UIButton) {
        
        var controller = PostViewController()
        self.present(controller, animated: true, completion: nil)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



// Used to change the tint colour of inactive tab bar images
// Credit to BoilingLime http://stackoverflow.com/questions/29876722/how-to-change-color-for-tab-bar-non-selected-icon-in-swift
extension UIImage {
    func imageWithColor(color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(.normal)
        let rect = CGRect(x:0, y:0, width:self.size.width, height:self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        color1.setFill()
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
