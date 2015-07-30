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
//        var dataproxyUrl = NSUserDefaults.standardUserDefaults().objectForKey("DataProxyCustomServerURL") as? String
//        if dataproxyUrl != nil {
//            let url = NSURL(string: dataproxyUrl!) as NSURL!
//            var request:NSURLRequest = NSURLRequest(URL: url)
//            let queue:NSOperationQueue = NSOperationQueue()
//            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//                
//                if error != nil{
//                    callback(false)
//                }else{
//                    callback(true)
//                }
//            })
//        }
        
        var manager:IMFDataManager = IMFDataManager.initializeWithUrl(NSUserDefaults.standardUserDefaults().objectForKey("DataProxyCustomServerURL") as! String)
        
        manager.remoteStore("wishlist17", completionHandler: { (createdStore:CDTStore!, err:NSError!) -> Void in
            if err != nil{
                callback(false)
            }else{
                callback(true)
            }
        })
    }

    
}
