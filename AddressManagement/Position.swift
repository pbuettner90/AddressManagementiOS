//
//  Position.swift
//  AddressManagement
//
//  Created by Patrick Büttner on 12.05.17.
//  Copyright © 2017 Patrick Büttner. All rights reserved.
//

class Position
{
    var longitude : Double
    var latitude : Double
    
    init()
    {
        longitude = 0.0
        latitude = 0.0
    }
    
    init(longitude:Double, latitude:Double)
    {
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
