//
//  Reachability.swift
//  ParkStore
//
//  Created by Chethan Kumar on 09/06/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import Foundation
import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0)).takeRetainedValue()
        }
        
        var flags: SCNetworkReachabilityFlags = 0
        if SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) == 0 {
            return false
        }
        
        let isReachable = (flags & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return isReachable && !needsConnection
    }
    
    class func isConnectedToCloudantDataProxy(callback:(Bool)->())  {
        let configurationPath = NSBundle.mainBundle().pathForResource("worklight", ofType: "plist")
        let configuration = NSDictionary(contentsOfFile: configurationPath!)
        let protocolString = configuration?["protocol"] as! String
        let host = configuration?["host"] as! String
        let port = configuration?["port"] as! String
        let proxy = configuration?["dataproxy"] as! String
        
        let url = NSURL(string: "\(protocolString)://\(host):\(port)/\(proxy)") as NSURL!
        var request:NSURLRequest = NSURLRequest(URL: url)
        let queue:NSOperationQueue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            
            if error != nil{
                callback(false)
            }else{
                callback(true)
            }
        })
    }

    
}
