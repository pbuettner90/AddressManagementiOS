//
//  AddressesTableViewController.swift
//  AddressManagement
//
//  Created by Patrick Büttner on 10.05.17.
//  Copyright © 2017 Patrick Büttner. All rights reserved.
//

import UIKit

class AddressesTableViewController: UITableViewController, UISearchBarDelegate
{
    @IBOutlet weak var searchBar: UISearchBar!
    
    var headerAddress : Address?
    var datasource = TableViewDataSource()
    
    var unsortedCustomers = [Address]()
    
    var addressList = [Address]()
    {
        didSet
        {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        let webservice = WebService()
        webservice.getJsonResponse
        {
            (response) in
            
            self.addressList = response
            
            for address in self.addressList
            {
                self.calcSearchPercentage(actAddress: address, address: self.headerAddress!)
                self.unsortedCustomers.append(address)
            }
            
            self.datasource.addresses = self.unsortedCustomers.sorted
            {
                $0.searchPercentage > $1.searchPercentage
            }

            self.tableView.dataSource = self.datasource
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        datasource.filtered = datasource.addresses.filter { $0.firstName.contains(searchText) || $0.lastName.contains(searchText) || $0.city.contains(searchText) || $0.street.contains(searchText) || $0.plz.contains(searchText) }
        
        if(datasource.filtered.count == 0)
        {
            datasource.searchActive = false;
        }
            
        else
        {
            datasource.searchActive = true;
        }
        
        self.tableView.reloadData()
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let  headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! CustomHeaderCell
        headerCell.backgroundColor = UIColor.yellow

        switch(section)
        {
            case 0:
                
                if let headerFirstName = headerAddress?.firstName,
                    let headerLastName = headerAddress?.lastName,
                    let headerCity  = headerAddress?.city,
                    let headerPlz = headerAddress?.plz,
                    let headerStreet = headerAddress?.street
                    
                {
                    headerCell.lblHeaderAddress.text = "Ihre Addresse:  \(headerFirstName) \(headerLastName) \(headerStreet) \(headerPlz) \(headerCity)"
                }

            default:
                headerCell.lblHeaderAddress.text = ""
        }
    
        return headerCell
    }
    
    func calcSearchPercentage(actAddress: Address, address:Address)
    {
        if address.firstName == actAddress.firstName
        {
            actAddress.searchPercentage = 50

            if address.plz == actAddress.plz || address.city == actAddress.city
            {
                actAddress.searchPercentage += 30;
                
                if address.street == actAddress.street
                {
                    actAddress.searchPercentage += 20;
                }
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "newAddress"
        {
            let vc = segue.destination as! NewAddressViewController
            vc.addNewData = true
            
            guard let firstName = headerAddress?.firstName,
                  let lastName = headerAddress?.lastName,
                  let street = headerAddress?.street,
                  let plz = headerAddress?.plz,
                  let city = headerAddress?.city else
            {
                return
            }
            
            vc.firstname = firstName
            vc.lastName = lastName
            vc.street = street
            vc.plz = plz
            vc.city = city 
            
        }
        
        else if segue.identifier == "updateData"
        {
            let addressIndex = self.tableView.indexPathForSelectedRow?.row
            let vc = segue.destination as! EditAddressViewController
            
            vc.id = datasource.addresses[addressIndex!].id
            vc.firstname = datasource.addresses[addressIndex!].firstName
            vc.lastName = datasource.addresses[addressIndex!].lastName
            vc.street = datasource.addresses[addressIndex!].street
            vc.city = datasource.addresses[addressIndex!].city
            vc.plz = datasource.addresses[addressIndex!].plz
            
            headerAddress = datasource.addresses[addressIndex!]
        }
    }
}
