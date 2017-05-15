//
//  CustomHeaderCell.swift
//  AddressManagement
//
//  Created by Patrick Büttner on 11.05.17.
//  Copyright © 2017 Patrick Büttner. All rights reserved.
//

import UIKit

class CustomHeaderCell: UITableViewCell
{
    @IBOutlet weak var lblHeaderAddress: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
}
