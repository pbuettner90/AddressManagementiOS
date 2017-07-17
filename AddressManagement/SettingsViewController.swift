//
//  SettingsViewController.swift
//  AddressManagement
//
//  Created by Patrick Büttner on 15.05.17.
//  Copyright © 2017 Patrick Büttner. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController
{
    
    @IBOutlet weak var tfUrl: UITextField!
    let defaults = UserDefaults.standard
    
    @IBAction func btnSave(_ sender: UIBarButtonItem)
    {
        let url = tfUrl.text!
        let urlData = NSKeyedArchiver.archivedData(withRootObject: url)
        defaults.set(urlData, forKey: "url")
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func readDefaults()
    {
        if let urlObject = defaults.object(forKey: "url")
        {
            let urlData = urlObject as! NSData
            let url = NSKeyedUnarchiver.unarchiveObject(with: urlData as Data) as? String
            tfUrl.text = url
        }
        
        else
        {
            tfUrl.text = ""
        }
        
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        readDefaults()
    }
    
}
