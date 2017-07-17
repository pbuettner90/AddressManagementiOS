//
//  AddressCell.swift
//  AddressManagement
//
//  Created by Patrick Büttner on 10.05.17.
//  Copyright © 2017 Patrick Büttner. All rights reserved.
//

import UIKit

class AddressCell : UITableViewCell
{
    var tapAction: ((UITableViewCell) -> Void)?

    
    @IBOutlet weak var lblFirstName: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblStreet: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    @IBAction func btnAddressMatch(_ sender: UIButton)
    {
        tapAction?(self)
    }
}
