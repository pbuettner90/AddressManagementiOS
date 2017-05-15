//
//  MapViewController.swift
//  AddressManagement
//
//  Created by Patrick Büttner on 12.05.17.
//  Copyright © 2017 Patrick Büttner. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController
{
    var longitude : Double?
    var latitude : Double?
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        showMap()
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
    
    private func showMap()
    {
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let myLocation = CLLocationCoordinate2D(latitude: getPosition().coordinate.latitude, longitude: getPosition().coordinate.longitude)
        let region = MKCoordinateRegion(center: myLocation, span: span)
        self.map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
    }
}
