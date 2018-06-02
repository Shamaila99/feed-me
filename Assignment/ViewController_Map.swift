//
//  ViewController_Map.swift
//  Assignment
//
//  Created by Shamaila Afridi on 05/03/2018.
//  Copyright © 2018 Shamaila Afridi. All rights reserved.
//
// My viewcontroller_map class for controlling the second view where the map will be displayed.
// Going to configure this class to display the selected restaurant on the mapview.

import UIKit
import MapKit


class ViewController_Map: UIViewController, MKMapViewDelegate {
    
    //outlet for smaller map on page for specific restaurant
    @IBOutlet weak var myMap: MKMapView!
    
    //rating display
    @IBOutlet weak var monLbl: UILabel!
    @IBOutlet weak var imgRating: UIImageView!
    
    //self explanatory
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var rest_address: UILabel!
    @IBOutlet weak var ratingDateLbl: UILabel!
    @IBOutlet weak var monImg: UIImageView!
    
    var restaurant: Restaurant?
    
    //again retrieving user location from segue to use
    var user_lat:Double = 0
    var user_long:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myMap.delegate = self
        
        restaurantName.text = restaurant?.BusinessName
        
        //displaying all of the restaurant information together inside the label
        rest_address.text =  (restaurant?.AddressLine2)! + "\n " + (restaurant?.AddressLine3)! + "\n" + (restaurant?.PostCode)! + "\n"
        
        //date restaurant was rated
        ratingDateLbl.text = "Rated on " + (restaurant?.RatingDate)!
    
        //location and annotation functionality
        let span :MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
        
        //region tells the map where to focus using span and location
        let location :CLLocationCoordinate2D = CLLocationCoordinate2DMake((restaurant?.Latitude as! NSString).doubleValue, (restaurant?.Longitude as! NSString).doubleValue)
        
        let region :MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        
        myMap.setRegion(region, animated: true)
        myMap.mapType = .standard
        
        //creating my custom pin
        let annotation = CustomPin()
        annotation.image = UIImage(named: "square-pin_2")
        annotation.coordinate = location
        annotation.title = restaurant?.BusinessName
        annotation.subtitle = (restaurant?.AddressLine2)! + ", " + (restaurant?.AddressLine3)! + ", " + (restaurant?.PostCode)!
        myMap.addAnnotation(annotation)
        
        let user_location :CLLocationCoordinate2D = CLLocationCoordinate2DMake(user_lat, user_long)
        //custom pin for user location
        let user_annotation = CustomPin()
        user_annotation.image = UIImage(named: "red-pin_2")
        user_annotation.coordinate = user_location
        user_annotation.title = "You are here!"
        myMap.addAnnotation(user_annotation)
        myMap.selectAnnotation(user_annotation, animated: true)
       
        //switch statement to display diff monster based on rating value
        switch(restaurant?.RatingValue){
        case "5"?:
            monImg.image = UIImage(named: "blue-mon")
            monLbl.text = "\"Very good!\""
        case "4"?:
            monImg.image = UIImage(named: "blue-mon")
            monLbl.text = "\"Good!\""
        case "3"?:
            monImg.image = UIImage(named: "green-mon")
            monLbl.text = "\"Generally satisfactory...\""
        case "2"?:
            monImg.image = UIImage(named: "pink-mon")
            monLbl.text = "\"Improvement necessary!\""
        case "1"?:
            monImg.image = UIImage(named: "pink-mon")
            monLbl.text = "\"Major improvement necessary...\""
        case "0"?:
            monImg.image = UIImage(named: "pink-mon")
             monLbl.text = "\"Urgent improvement necessary!\""
        case "-1"?:
            monImg.image = UIImage(named: "pink-mon")
             monLbl.text = "\"Exempt.\""
        default:
            monImg.image = UIImage(named: "pink-mon")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else {return nil}
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let customPointAnnotation = annotation as! CustomPin
        annotationView!.image = customPointAnnotation.image
        
        return annotationView
    }
}
