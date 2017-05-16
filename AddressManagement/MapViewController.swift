//
//  MapViewController.swift
//  AddressManagement
//
//  Created by Patrick Büttner on 12.05.17.
//  Copyright © 2017 Patrick Büttner. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController
{
    var longitude : Double?
    var latitude : Double?
    var street : String?
    var city : String?
    var location : CLLocation?
    var isUpdated : Bool = false
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if isUpdated
        {
            getLocationFromAddress()
        }
        
        else
        {
           let location = CLLocation(latitude: latitude!, longitude: longitude!)
           showMap(location: location)
        }
    }
    
    private func getLocationFromAddress()
    {
        guard let street = self.street else
        {
            return
        }
        guard let city = self.city else
        {
            return
        }
        
        let addressStr =  " \(city), \(street)"
        
        print(addressStr)
        CLGeocoder().geocodeAddressString(addressStr, completionHandler:
        {
                (placemarks, error) in
                
                if error != nil
                {
                    return
                }
                    
                else if placemarks!.count > 0
                {
                    print("placemarks found")
                    let placemark = placemarks![0]
                    self.location = placemark.location
                    self.showMap(location: self.location!)
                }
        })
    }
    
    private func getPosition() -> CLLocation
    {
        guard let lat = latitude else
        {
            return CLLocation()
        }
        
        guard let long = longitude else
        {
            return CLLocation()
        }

        let location = CLLocation(latitude: lat, longitude: long)

        
        return location
    }
    
    private func showMap(location:CLLocation)
    {
        
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: myLocation, span: span)
        self.map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
    }
}
