//
//  Restaurant.swift
//  Assignment
//
//  Created by Shamaila Afridi on 15/02/2018.
//  Copyright © 2018 Shamaila Afridi. All rights reserved.
//

import Foundation

class Restaurant: Codable {
    
    //declaring the attributes for the class
    let id: String
    let BusinessName: String
    let AddressLine1: String
    //second line of address could be optional
    let AddressLine2: String?
    //as could third line
    let AddressLine3: String?
    let PostCode: String
    let RatingValue: String
    let RatingDate: String
    let Longitude: String 
    let Latitude: String
    
    
    
    
    
}
