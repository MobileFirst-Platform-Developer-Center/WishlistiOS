//
//  Utils.swift
//  ParkStore
//
//  Created by Chethan Kumar on 01/06/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import Foundation

class Utils{
    
    class func getMfpServerUrl() ->NSString{
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("worklight", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            let proto:String = dict.objectForKey("protocol")as! String
            let host:String = dict.objectForKey("host") as! String
            let port:String = dict.objectForKey("port") as! String
            let context:String = dict.objectForKey("wlServerContext") as! String
            return "\(proto)://\(host):\(port)\(context)";
        }
        return "http://localhost:9080/MobileFirstStarter";
    }
    
    class func getDataProxyUrl() ->NSString{
        var myDict: NSDictionary?
        if let path = NSBundle.mainBundle().pathForResource("worklight", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        if let dict = myDict {
            let proto:String = dict.objectForKey("protocol")as! String
            let host:String = dict.objectForKey("host") as! String
            let port:String = dict.objectForKey("port") as! String
            let proxy:String = dict.objectForKey("dataproxy") as! String
            return "\(proto)://\(host):\(port)/\(proxy)";
        }
        return "http://localhost:9080/imfdata";
    }
    
    class func getCustomMFPServerUrlFromUserDefaults() ->NSURL{
        var defaults = NSUserDefaults.standardUserDefaults()
        return defaults.URLForKey("MFPCustomServerURL")!
    }
}