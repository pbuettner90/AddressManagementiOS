//
//  ViewController.swift
//  AddressManagement
//
//  Created by Patrick Büttner on 10.05.17.
//  Copyright © 2017 Patrick Büttner. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts

class NewAddressViewController: UIViewController, CLLocationManagerDelegate
{
    var address : Address?
    var position : Position?
    var addNewData : Bool?
    
    var firstname : String?
    var lastName : String?
    var street : String?
    var city : String?
    var plz : String?
    
    let manager = CLLocationManager()
   
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfStreet: UITextField!
    @IBOutlet weak var tfPlz: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        address = Address()
        position = Position()
        determineCurrentLocation()
    
        guard let add = addNewData else {
            return
        }
        
        if add
        {
            setTextFields()
        }
    }
    
    func setTextFields()
    {
        tfFirstName.text = firstname
        tfLastName.text = lastName
        tfPlz.text = plz
        tfCity.text = city
        tfStreet.text = street
    }
    
    func determineCurrentLocation()
    {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error: \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation:CLLocation = locations[0] as CLLocation
        manager.stopUpdatingLocation()
        position?.latitude = userLocation.coordinate.latitude
        position?.longitude = userLocation.coordinate.longitude
    }
    
    func postalAddressFromAddressDictionary(_ addressdictionary: Dictionary<NSObject,AnyObject>) -> CNMutablePostalAddress
    {
        let address = CNMutablePostalAddress()

        address.street = addressdictionary["Street" as NSObject] as? String ?? ""
        address.city = addressdictionary["City" as NSObject] as? String ?? ""
        address.postalCode = addressdictionary["ZIP" as NSObject] as? String ?? ""

        return address
    }

    @IBAction func getAddress(_ sender: UIButton)
    {
        guard let longitude = position?.longitude,
            let latitude = position?.latitude  else
        {
            return
        }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location, completionHandler:
        {
                (placemarks, error) -> Void in
                
                if error != nil
                {
                    return
                }
                
                if (placemarks?.count)!>0
                {
                    guard let pm = placemarks?[0] else
                    {
                        return
                    }
                    
                    let address = self.postalAddressFromAddressDictionary(pm.addressDictionary! as Dictionary<NSObject, AnyObject>)
                    
                    self.tfCity.text = address.city
                    self.tfStreet.text = address.street
                    self.tfPlz.text = address.postalCode
                }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "checkAddress"
        {
            let vc = segue.destination as! AddressesTableViewController

            address?.firstName = tfFirstName.text!
            address?.lastName = tfLastName.text!
            address?.city = tfCity.text!
            address?.street = tfStreet.text!
            address?.plz = tfPlz.text!
            
            vc.headerAddress = address
            
            guard let add = addNewData else
            {
                return
            }
            
            if add
            {

                //WebService.postDataToUrl(address: address!)
                vc.tableView.reloadData()
            }
        }
        
        else if segue.identifier == "showMap"
        {
            let vc = segue.destination as! MapViewController
            
            vc.latitude = position?.latitude
            vc.longitude = position?.longitude
        }
    }
}

