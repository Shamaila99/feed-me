//
//  ViewController.swift
//  Assignment
//
//  Created by Shamaila Afridi on 15/02/2018.
//  Copyright © 2018 Shamaila Afridi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reusing the cells as they fall off the screen
        let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell")!
        //assigning the text of the prototype cell to the name of the business
        cell.textLabel?.text = restaurantData[indexPath.row].BusinessName
        
        return cell
    }
    
    
    //array of data of type Restaurant
    var restaurantData = [Restaurant]()
    let locationManager = CLLocationManager()  //opening app to retrieve the location

    //declaring device lat&long variables globally so that I can access them outside of the locationmanager function
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //allowing this class to control the tableview
        myTableView.dataSource = self
        myTableView.delegate = self
        
        //asking for user authoriSation - I cannot spell it with a 'z', only forced to in the actual code
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        //configuring the location manager once authorisation has been granted
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            //triggering location update if device moves more than 30m
            //since it is looking for restaurants, 30m is a good distance for maybe finding restaurants that were previously out of range?
            locationManager.distanceFilter = 30
            locationManager.startUpdatingLocation()
            
        }
        
        //this is the url to retrieve the location information
        //do not hard code the latitude and longitude in here, do the rest of the lab for this week and then change it ******************
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(latitude)&long=\(longitude)")
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data  = data else {print("error with data"); return }
            do {
                self.restaurantData = try JSONDecoder().decode([Restaurant].self, from: data);
                
                for i in self.restaurantData {
                    print(i.BusinessName)
                }
                
                print(self.restaurantData.count)
                //not sure what else to do here right now, just printing number of objects in array to test it works - which it currently does
            } catch let err {
                print("Error:", err)
            }
        }.resume() //beginning the network call
    }
    
    
    //function to update the location to wherever the device is
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //these are the coordinates of the device
        latitude = locations[0].coordinate.latitude
        longitude = locations[0].coordinate.longitude
    }
    
   
    
}

