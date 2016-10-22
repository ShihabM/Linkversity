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

class DetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let defaults = UserDefaults.standard
    var dismiss: UIButton?
    var dateLabel = UILabel(frame: CGRect(x: 250, y: 195, width: 60, height: 20))
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Colors.blueDark
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
        
        
        // Date label
        dateLabel = UILabel(frame: CGRect(x: 50, y: 20, width: self.view.bounds.width - 70, height: 40))
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textAlignment = NSTextAlignment.right
        dateLabel.text = self.dateText
        dateLabel.textColor = Colors.blueDim
        dateLabel.backgroundColor = UIColor.clear
        self.view.addSubview(dateLabel)
        
        // Translate animation using MengTo's Spring library
        springWithDelay(duration: 0.65, delay: 0, animations: {
            self.dateLabel.alpha = 1
        })
        
        
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
        infoText.font = UIFont.systemFont(ofSize: 12)
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
        self.view.addSubview(mapView)
        mapView.tintColor = Colors.blueAlternative
        
        let locValue:CLLocationCoordinate2D = CLLocationManager().location!.coordinate
        mapView.setCenter(locValue, animated: true)
        
        // Drop a pin
        let newYorkLocation = CLLocationCoordinate2DMake(CLLocationDegrees(self.latText), CLLocationDegrees(self.longText))
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = newYorkLocation
        dropPin.title = "You posted here"
        mapView.addAnnotation(dropPin)
        
    }
    /*
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        if (annotation.isKindOfClass(CustomAnnotation)) {
            let customAnnotation = annotation as? CustomAnnotation
            mapView.translatesAutoresizingMaskIntoConstraints = false
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "CustomAnnotation") as MKAnnotationView!
            
            if (annotationView == nil) {
                annotationView = customAnnotation?.annotationView()
            } else {
                annotationView?.annotation = annotation;
            }
            
            self.addBounceAnimationToView(annotationView)
            return annotationView
        } else {
            return nil
        }
    }
    */
    
    func dismiss(button: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
