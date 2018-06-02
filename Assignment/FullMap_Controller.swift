//
//  FullMap_Controller.swift
//  Assignment
//
//  Created by Shamaila Afridi on 13/03/2018.
//  Copyright © 2018 Shamaila Afridi. All rights reserved.
//

import UIKit
import MapKit

class FullMap_Controller: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mainmap: MKMapView!
    
    var restaurantData = [Restaurant]()
    
    //lat and long to use in segue code to retrieve the user's location
    var latitude_full:Double = 0
    var longitude_full:Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainmap.delegate = self
        
        //testing values
//        print(restaurantData.count)
//        print(latitude_full)
//        print(longitude_full)
        
        let span :MKCoordinateSpan = MKCoordinateSpanMake(0.005, 0.005)
        
        let location :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude_full , longitude_full)
        
        let region :MKCoordinateRegion = MKCoordinateRegionMake(location, span)
    
        mainmap.setRegion(region, animated: true)
     
        
        let user_location :CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude_full, longitude_full)
        
        //custom pin for user location
        let user_annotation = CustomPin()
        user_annotation.image = UIImage(named: "red-pin_2")
        user_annotation.coordinate = user_location
        user_annotation.title = "You are here!"
        mainmap.addAnnotation(user_annotation)
        mainmap.selectAnnotation(user_annotation, animated: true)
        
        //displaying all restaurants on map with custom pin
        for x in restaurantData {
            let annotation = CustomPin()
            annotation.image = UIImage(named: "square-pin_2")
            annotation.coordinate = CLLocationCoordinate2D(latitude: (x.Latitude as NSString).doubleValue, longitude: (x.Longitude as NSString).doubleValue)
            annotation.title = x.BusinessName
            annotation.subtitle = (x.AddressLine2)! + ", " + (x.AddressLine3)! + ", " + (x.PostCode)
            mainmap.addAnnotation(annotation)
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
