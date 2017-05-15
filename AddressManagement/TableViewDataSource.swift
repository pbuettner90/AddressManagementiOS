//
//  TableViewDataSource.swift
//  AddressManagement
//
//  Created by Patrick Büttner on 10.05.17.
//  Copyright © 2017 Patrick Büttner. All rights reserved.
//

import UIKit

class TableViewDataSource : NSObject, UITableViewDataSource
{
    var addresses = [Address]()
    var filtered = [Address]()
    var searchActive : Bool = false

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if searchActive
        {
           return filtered.count
        }
        
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressCell
        
        if searchActive
        {
            cell.lblFirstName.text = filtered[indexPath.row].firstName
            cell.lblLastName.text = filtered[indexPath.row].lastName
            cell.lblStreet.text = filtered[indexPath.row].street
            cell.lblCity.text = filtered[indexPath.row].city
        }
        
        else
        {
            cell.lblFirstName.text = addresses[indexPath.row].firstName
            cell.lblLastName.text = addresses[indexPath.row].lastName
            cell.lblStreet.text = addresses[indexPath.row].street
            cell.lblCity.text = addresses[indexPath.row].city
            
            cell.tapAction = { (cell) in
                
            }
        }
    
        return cell
    }
}
