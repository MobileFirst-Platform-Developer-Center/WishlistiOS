/**
* Copyright 2015 IBM Corp.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import Foundation
import SystemConfiguration
import CloudantToolkit
import IMFData

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(&zeroAddress, {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }) else {
            return false
        }
        
        var flags : SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        return (isReachable && !needsConnection)
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
        
        let dataproxyUrl = NSUserDefaults.standardUserDefaults().objectForKey("DataProxyCustomServerURL") as? String
        
        if(dataproxyUrl != nil){
            let manager:IMFDataManager = IMFDataManager.initializeWithUrl(dataproxyUrl)
        
            manager.remoteStore("wishlist17", completionHandler: { (createdStore:CDTStore!, err:NSError!) -> Void in
                if err != nil{
                    callback(false)
                }else{
                    callback(true)
                }
            })
        }else{
            callback(false)
        }
        
    }

    
}
