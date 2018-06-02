//
//  ViewController.swift
//  Assignment
//
//  Created by Shamaila Afridi on 15/02/2018.
//  Copyright © 2018 Shamaila Afridi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    //setting up the tableview functionality
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //number of rows in the tableview is number of restaurants in array
        return restaurantData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //reusing the cells as they fall off the screen
            let cell = myTableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! CustomTableViewCell
            cell.restNameLbl.text = restaurantData[indexPath.row].BusinessName
        
        //switch statement to display the correct rating image
        switch(restaurantData[indexPath.row].RatingValue) {
        case "5":
            cell.imgRating.image = UIImage(named: "fhrs_5_en-gb")
        case "4":
            cell.imgRating.image = UIImage(named: "fhrs_4_en-gb")
        case "3":
            cell.imgRating.image = UIImage(named: "fhrs_3_en-gb")
        case "2":
            cell.imgRating.image = UIImage(named: "fhrs_2_en-gb")
        case "1":
            cell.imgRating.image = UIImage(named: "fhrs_1_en-gb")
        case "0":
            cell.imgRating.image = UIImage(named: "fhrs_0_en-gb")
        case "-1":
            cell.imgRating.image = UIImage(named: "fhrs_exempt_en-gb")
        default:
            cell.restNameLbl.text = restaurantData[indexPath.row].BusinessName + ": " + restaurantData[indexPath.row].RatingValue
        }
        return cell
    }
    
    //array of data of type Restaurant
    var restaurantData = [Restaurant]()
    
    //opening app to retrieve the location
    let locationManager = CLLocationManager()

    //declaring device lat&long variables globally so that I can access them outside of the locationmanager function to put into the URL
    var latitude:Double = 0
    var longitude:Double = 0
  
    //outlets for various features
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var imgRating: UIImageView!
    @IBOutlet weak var currentLocationLbl: UILabel!
    
    //cancel button if user decides not to search
    @IBAction func cancelActn(_ sender: Any) {
        searchBox.isHidden = true
        resetBtn.isHidden = true
        
        //if cancel is pressed it displays default restaurants
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(latitude)&long=\(longitude)")
        //print(url?.absoluteString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {print("error with data"); return }
            do {
                self.restaurantData = try JSONDecoder().decode([Restaurant].self, from: data);
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            } catch let err {
                print("Error:", err)
            }
            }.resume() //beginning the network call
    }
    
    //resetting the text inside the text fields when the search button is pressed
    @IBAction func searchActn(_ sender: Any) {
        searchBox.isHidden = false
        searchName.text = ""
        searchPostcode.text = ""
        searchBoxLbl.text = "Enter a restaurant name OR postcode below!"
        resetBtn.isHidden = false
    }

    @IBOutlet weak var searchName: UITextField!
    @IBOutlet weak var searchPostcode: UITextField!
    @IBOutlet weak var searchBox: UIView!
    @IBOutlet weak var searchBoxLbl: UILabel!
    
    //code for when the search button is pressed
    //it allows for the postcode OR name to be searched but since both cannot be put into the url together as parameters they cannot be used together
    //works to a degree
    @IBAction func searchBtnActn(_ sender: Any) {
        //if restaurant name is entered
        if(searchName.text != "" && searchPostcode.text == ""){
            let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_name&name=\(searchName.text!)")
            if(url == nil){
                searchBoxLbl.text = "Restaurant not found in database... try again"
                searchBox.isHidden = false
            }
            else if (url != nil){
                print(url?.absoluteString)
                URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    guard let data = data else {print("error with data"); return }
                    do {
                        self.restaurantData = try JSONDecoder().decode([Restaurant].self, from: data);
                        if (self.restaurantData.count == 0){
                            self.searchBoxLbl.text = "No results found"
                            self.searchBox.isHidden = false
                        }else{
                            DispatchQueue.main.async {
                            self.myTableView.reloadData()
                            }
                        }
                    } catch let err {
                        print("Error:", err)
                    }
                }.resume() //beginning the network call
                searchBox.isHidden = true
            }
        }
        //if postcode is entered
        if (searchPostcode.text != "" && searchName.text == ""){
            let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_postcode&postcode=\(searchPostcode.text!)")
            
            if(url == nil){
                searchBoxLbl.text = "Not a valid postcode... try again!"
                searchBox.isHidden = false
            }
            else if (url != nil){
                print(url?.absoluteString)
                URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    guard let data = data else {print("error with data"); return }
                    do {
                        self.restaurantData = try JSONDecoder().decode([Restaurant].self, from: data);
                        if (self.restaurantData.count == 0){
                            self.searchBoxLbl.text = "No results found"
                            self.searchBox.isHidden = false
                        }
                        else{
                        DispatchQueue.main.async {
                            self.myTableView.reloadData()
                        }
                    }
                    } catch let err {
                        print("Error:", err)
                    }
                    }.resume() //beginning the network call
                searchBox.isHidden = true
            }
        }
        //if text entered in both fields
        if(searchName.text != "" && searchPostcode.text != ""){
            searchBoxLbl
            .text = "Please only enter a restaurant name OR postcode!"
            searchBox.isHidden = false
        }
       
    }
    
    @IBOutlet weak var resetBtn: UIButton!
    
    //reset button to show default restaurants in that area
    @IBAction func resetBtnActn(_ sender: Any) {
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(latitude)&long=\(longitude)")
        //print(url?.absoluteString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {print("error with data"); return }
            do {
                self.restaurantData = try JSONDecoder().decode([Restaurant].self, from: data);
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            } catch let err {
                print("Error:", err)
            }
            }.resume() //beginning the network call
        
        searchBox.isHidden = true
        resetBtn.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hiding search box and reset button until the search button is pressed
        searchBox.isHidden = true
        resetBtn.isHidden = true
        
        //default placeholders for the text fields inside the view
        searchName.placeholder = "Enter a restaurant name"
        searchPostcode.placeholder = "Enter a postcode"

        //allowing this class to control the tableview
        myTableView.dataSource = self
        myTableView.delegate = self
        
        //asking for user authoriSation - I cannot spell it with a 'z', only forced to in the actual code
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        currentLocationLbl.text = "Current location: "
        
        //configuring the location manager once authorisation has been granted
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            //triggering location update if device moves more than 30m
            //since it is looking for restaurants, 30m is a good distance for maybe finding restaurants that were previously out of range
            locationManager.distanceFilter = 50
            locationManager.startUpdatingLocation()
        }
    }
    
    //function to update the location to wherever the device is
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //these are the coordinates of the device
        latitude = locations[0].coordinate.latitude
        longitude = locations[0].coordinate.longitude
        
        //reverse geocoding user location
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locations[0]) { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                if let locality = firstLocation?.locality {
                    if let country = firstLocation?.country {
                        self.currentLocationLbl.text = "\(locality), \(country)"
                    }
                } else {
                    self.currentLocationLbl.text = "location details not available!"
                }
            } else {
                if let error = error {
                    print("error with reverse geocoding \n \(error)")
                }
            }
        }
        
        //update table view again here as the location updates
        let url = URL(string: "http://radikaldesign.co.uk/sandbox/hygiene.php?op=s_loc&lat=\(latitude)&long=\(longitude)")
        print(url?.absoluteString)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {print("error with data"); return }
            do {
                self.restaurantData = try JSONDecoder().decode([Restaurant].self, from: data);
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                }
            } catch let err {
                print("Error:", err)
            }
        }.resume() //beginning the network call
    }
    
    //code for segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            let i = myTableView.indexPath(for: cell)!.row

            if segue.identifier == "restaurant_map" {
                let dvc = segue.destination as! ViewController_Map
            dvc.restaurant = self.restaurantData[i]
            dvc.user_lat = latitude
            dvc.user_long = longitude
            }
            
        } else if segue.identifier == "all_rest" {
            let dvc = segue.destination as! FullMap_Controller
            dvc.restaurantData = self.restaurantData
            dvc.latitude_full = latitude
            dvc.longitude_full = longitude
        }

    }
}

