//
//  Global2.swift
//  url
//
//  Created by Mac on 24.06.2018.
//  Copyright © 2018 testOrg. All rights reserved.
//

import Foundation


class Global2 {
    
    
    static let url = NSURL(string:"https://stroccoli-sebasfreetest-v1.p.mashape.com/calendar")
    let request = NSMutableURLRequest(url: url! as URL)
    
    request.httpMethod = "GET"
    request.addValue("1rksEaJHXjmshr9Os90W2v0joaavp1P1XHXjsn9EjaGpGlgcaM", forHTTPHeaderField: "X-Mashape-Key")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    print(request.httpBody ?? Error.self)

}

