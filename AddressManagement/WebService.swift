//
//  WebService.swift
//  AddressManagement
//
//  Created by Patrick Büttner on 10.05.17.
//  Copyright © 2017 Patrick Büttner. All rights reserved.
//

import Foundation

class WebService
{
    //WebserviceURL: "http:addressodata20170508023216.azurewebsites.net/odata/Addresses"

    func getJsonResponse(completion: @escaping (_ response: [Address])->())
    {
        let queue = DispatchQueue.global(qos: .background)
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        queue.async
        {
                let defaults = UserDefaults.standard
                var webServiceUrl = ""
            
                if let urlObject = defaults.object(forKey: "url")
                {
                    let urlData = urlObject as! NSData
                    webServiceUrl = (NSKeyedUnarchiver.unarchiveObject(with: urlData as Data) as? String)!
                }
            
                guard let url = URL(string:webServiceUrl) else
                {
                    print("Fehler beim Erstellen der URL")
                    return
                }
                            
                let task = session.dataTask(with: url, completionHandler:
                {
                    (data, response, error) in
                
                    if let error = error
                    {
                        print(error.localizedDescription)
                        return
                    }
                
                    guard let data = data,
                          let apiResponse = self.createResponse(fromData: data) else
                    {
                        
                            print("Keine Daten?")
                            return
                    }
                
                    DispatchQueue.main.async
                    {
                        completion(apiResponse)
                    }
                })
            
                task.resume()
        }
    }
    
    private func parseJson(data: Data) -> NSDictionary?
    {
        do
        {
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary
            
            return jsonDict
        }
            
        catch
        {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func createResponse(fromData : Data) -> [Address]?
    {
        var items = [Address]()

        guard let jsonDict = parseJson(data: fromData) else
        {
            print("Problem beim Verarbeiten von JSON")
            return nil
        }
        
        
        guard let addressColl = jsonDict["value"] as? NSArray else
        {
            return nil
        }
        
        
        for address in addressColl
        {
            let item = address as! [String:Any]
            
            guard
                  let id = item["Id"] as? Int,
                  let firstName = item["FirstName"] as? String,
                  let lastName = item["LastName"] as? String,
                  let street = item["Street"] as? String,
                  let city = item["City"] as? String,
                  let plz = item["Plz"] as? String else
            {
                return nil
            }
 
            let response = Address(id: id, firstName: firstName, lastName: lastName, street: street, city: city, plz: plz, searchPercentage : 0)
            
            items.append(response)
        }

        return items
    }
    
    static func updateData(address:Address)
    {
        let putEndpoint: String = "http://addressodata20170508023216.azurewebsites.net/odata/Addresses(\(address.id))"

        print(putEndpoint)
        guard let url = URL(string: putEndpoint) else
        {
            print("Fehler beim Erstellen der URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        let updateAddress : [String:Any] =
            ["FirstName": address.firstName,
            "LastName": address.lastName,
            "Street": address.street,
            "City": address.city,
            "Plz": address.plz]
             
        let jsonAddress : Data
        
        do
        {
            jsonAddress = try JSONSerialization.data(withJSONObject: updateAddress, options: [])
            request.httpBody = jsonAddress
        }
            
        catch
        {
            return
        }
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request)
        {
            (data, response, error) in
            
            guard error == nil else
            {
                return
            }
            
            guard let responseData = data else
            {
                return
            }
            
            do
            {
                guard let receivedAddress = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:Any] else
                {
                    
                    return
                }
                
                guard let addressId = receivedAddress["Id"] as? Int else
                {
                    return
                }
            }
                
            catch
            {
                return
            }
        }
        
        task.resume()
        
    }
    
    static func postDataToUrl(address:Address)
    {
        let postEndpoint: String = "http://addressodata20170508023216.azurewebsites.net/odata/Addresses"
        
        guard let url = URL(string: postEndpoint) else
        {
            print("Fehler beim Erstellen der URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        
        let newAddress : [String:Any] =
            ["FirstName": address.firstName,
             "LastName": address.lastName,
             "Street": address.street,
             "City": address.city,
             "Plz": address.plz]
        
        let jsonAddress : Data
        
        do
        {
            jsonAddress = try JSONSerialization.data(withJSONObject: newAddress, options: [])
            request.httpBody = jsonAddress
        }
        
        catch
        {
            return
        }
        
        let session = URLSession.shared

    
       let task = session.dataTask(with: request)
       {
            (data, response, error) in
        
            guard error == nil else
            {
                return
            }
        
            guard let responseData = data else
            {
                return
            }
        
            do
            {
                guard let receivedAddress = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:Any] else
                {
                    return
                }
                                
                guard let addressId = receivedAddress["Id"] as? Int else
                {
                    return
                }
            }
                
            catch
            {
                return
            }
       }
       
       task.resume()

    }
}
