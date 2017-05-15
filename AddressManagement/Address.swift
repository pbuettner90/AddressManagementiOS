//
//  Address.swift
//  AddressManagement
//
//  Created by Patrick Büttner on 10.05.17.
//  Copyright © 2017 Patrick Büttner. All rights reserved.
//

class Address
{
    var id : Int
    var firstName : String
    var lastName : String
    var street : String
    var city : String
    var plz : String
    
    init()
    {
        id = 0
        firstName = ""
        lastName = ""
        street = ""
        city = ""
        plz = ""
    }
        
    init(id:Int, firstName : String, lastName : String, street : String, city: String, plz : String)
    {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.street = street
        self.city = city
        self.plz = plz
    }
}
