//
//  NetWorker.swift
//  url
//
//  Created by Mac on 24.06.2018.
//  Copyright © 2018 testOrg. All rights reserved.
//

import Foundation

class APIWorker {
    
    var task: URLSessionDataTask?
    
    enum URLs {
        static let mainUrl = "https://api.privatbank.ua/p24api/infrastructure?json&atm&address=&city=Днепропетровск"
        
    }
    
    //Delet
    /*
     enum Keys {
     static let serviceKey = "LsHoEdcE1pmshD6kwQzdL2S4CpN0p1yJltgjsnA9fyaRGXs3Fj"
     static let serviceKeyTwo = "1rksEaJHXjmshr9Os90W2v0joaavp1P1XHXjsn9EjaGpGlgcaM"
     
     }
     */
    
    enum SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    func loadData(completion: @escaping ([PrivatStruct]?, Error?) -> Void) {
        
        let escapedString = URLs.mainUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        guard let url = URL(string: escapedString!) else {
            print("URL missing ")
            completion(nil, SerializationError.missing("MISSING!!"))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard
                let data = data,
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                let arr = jsonObject as? [String:Any]
                else {
                    completion(nil, nil)
                    print("Error deserializing JSON: \(String(describing: error))")
                    return
            }
            
            var privat = [PrivatStruct]()
            
            let city = arr["city"] as? String  ?? ""
            let address = arr["address"] as? String ?? ""
            let devices = arr["devices"] as? [[String: Any]]
            
            for dict in devices! {
                
                let type = dict["type"] as? String ?? ""
                let cityRU = dict["cityRU"] as? String ?? ""
                let cityUA = dict["cityUA"] as? String ?? ""
                let cityEN = dict["cityEN"] as? String ?? ""
                let fullAddressRu = dict["fullAddressRu"] as? String ?? ""
                let fullAddressUa = dict["fullAddressUa"] as? String ?? ""
                let fullAddressEn = dict["fullAddressEn"] as? String ?? ""
                let placeRu = dict["placeRu"] as? String ?? ""
                let placeUa = dict["placeUa"] as? String ?? ""
                let latitude = dict["latitude"] as? String ?? ""
                let longitude = dict["longitude"] as? String ?? ""
                
                let tw = dict["tw"] as? [String: Any]
                let mon = tw!["mon"] as? String ?? ""
                let tue = tw!["tue"] as? String ?? ""
                let wed = tw!["wed"] as? String ?? ""
                let thu = tw!["thu"] as? String ?? ""
                let fri = tw!["fri"] as? String ?? ""
                let sat = tw!["sat"] as? String ?? ""
                let sun = tw!["sun"] as? String ?? ""
                let hol = tw!["hol"] as? String ?? ""
                
                let twStruct = Tw(mon: mon, tue: tue, wed: wed, thu: thu, fri: fri, sat: sat, sun: sun, hol: hol)
                
                let deviceStruct = Devices(type: type, cityRU: cityRU, cityUA: cityUA, cityEN: cityEN, fullAddressRu: fullAddressRu, fullAddressUa: fullAddressUa, fullAddressEn: fullAddressEn, placeRu: placeRu, placeUa: placeUa, latitude: latitude, longitude: longitude, tw: twStruct)
                
                
                let privatStructs = PrivatStruct(city: city, address: address, devices: deviceStruct)
                
                privat.append(privatStructs)
            }
            completion(privat, nil)
        }
        
        task.resume()
    }
    
    func сancel() {
        task?.cancel()
    }
    
    
}
