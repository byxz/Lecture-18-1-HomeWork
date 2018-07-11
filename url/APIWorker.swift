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
        //static let mainUrl = "https://api.privatbank.ua/p24api/infrastructure?atm&address=&city=%D0%94%D0%BD%D0%B5%D0%BF%D1%80%D0%BE%D0%BF%D0%B5%D1%82%D1%80%D0%BE%D0%B2%D1%81%D0%BA"
        static let mainUrl = "https://api.privatbank.ua/p24api/infrastructure?atm&address=&city=Днепропетровск"
     
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
        
        //??? 
        let escapedString = URLs.mainUrl.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        print("escapedString: \(String(describing: escapedString))")
        
        guard let url = URL(string: URLs.mainUrl) else {
            print("URL missing ")
            completion(nil, SerializationError.missing("MISSING!!"))
            return
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        //request.setValue(Keys.serviceKey, forHTTPHeaderField: "X-Mashape-Key")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else { return }
            guard let arr = jsonObject as? [[String:Any]] else {
                completion(nil, nil)
                print("Error deserializing JSON: \(String(describing: error))")
                return
            }
   print(data)
            print(jsonObject)
            print(arr)
            
            var privat = [PrivatStruct]()
            
            for dict in arr {
                let city = dict["city"] as? String ?? ""
                let address = dict["address"] as? String ?? ""
                
                let devices = dict["devices"] as? [String: Any]
                let type = devices!["type"] as? String ?? ""
                let cityRU = devices!["full"] as? String ?? ""
                let cityUA = devices!["tri"] as? String ?? ""
                let cityEN = devices!["tri"] as? String ?? ""
                let fullAddressRu = devices!["tri"] as? String ?? ""
                let fullAddressUa = devices!["tri"] as? String ?? ""
                let fullAddressEn = devices!["tri"] as? String ?? ""
                let placeRu = devices!["tri"] as? String ?? ""
                let placeUa = devices!["tri"] as? String ?? ""
                let latitude = devices!["tri"] as? String ?? ""
                let longitude = devices!["tri"] as? String ?? ""
               
                
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
