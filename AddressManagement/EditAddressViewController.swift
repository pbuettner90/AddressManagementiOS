//
//  EditAddressViewController.swift
//  AddressManagement
//
//  Created by Patrick Büttner on 11.05.17.
//  Copyright © 2017 Patrick Büttner. All rights reserved.
//

import UIKit
import CoreLocation

class EditAddressViewController: UIViewController
{
    var address: Address?
    var id : Int?
    var firstname : String?
    var lastName : String?
    var street : String?
    var city : String?
    var plz : String?
    var position : Position?
    
    var coords: CLLocationCoordinate2D?


    @IBOutlet weak var checkAddress: UIButton!
    @IBOutlet weak var showMap: UIButton!
    
    @IBOutlet weak var tfFirstName: UITextField!
    @IBOutlet weak var tfLastName: UITextField!
    @IBOutlet weak var tfStreet: UITextField!
    @IBOutlet weak var tfPlz: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    
    override func viewWillAppear(_ animated: Bool)
    {
        checkAddress.setFAIcon(icon: .FACheck, iconSize: 25, forState: .normal)
        showMap.setFAIcon(icon: .FAGlobe, iconSize: 25, forState: .normal)
    }
    
    @IBAction func btnEdit(_ sender: UIBarButtonItem)
    {
        enableTextFields()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setTextFields()
        disableTextFields()
    }
    
    private func saveDataToModel()
    {
        address = Address()
        
        address?.id = id!
        address?.firstName = tfFirstName.text!
        address?.lastName = tfLastName.text!
        address?.street = tfStreet.text!
        address?.city = tfCity.text!
        address?.plz = tfPlz.text!
    }
    
    private func disableTextFields()
    {
        tfFirstName.isEnabled = false
        tfLastName.isEnabled = false
        tfStreet.isEnabled = false
        tfCity.isEnabled = false
        tfPlz.isEnabled = false
    }
    
    private func enableTextFields()
    {
        tfFirstName.isEnabled = true
        tfLastName.isEnabled = true
        tfStreet.isEnabled = true
        tfCity.isEnabled = true
        tfPlz.isEnabled = true
    }
    
    private func setTextFields()
    {
        tfFirstName.text = firstname
        tfLastName.text = lastName
        tfStreet.text = street
        tfCity.text = city
        tfPlz.text = plz
    }
    
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "showMap"
        {
            let vc = segue.destination as! MapViewController
            vc.street = tfStreet.text!
            vc.city = tfCity.text!
            vc.isUpdated = true 
        }
        
        else if segue.identifier=="checkAddress"
        {
            saveDataToModel()            
            WebService.updateData(address: address!)
        }
    }
}
