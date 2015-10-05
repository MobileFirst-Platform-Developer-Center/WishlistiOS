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
        let defaults = NSUserDefaults.standardUserDefaults()
        return defaults.URLForKey("MFPCustomServerURL")!
    }
}