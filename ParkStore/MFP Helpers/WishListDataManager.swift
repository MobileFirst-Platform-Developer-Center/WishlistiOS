//
//  WishListDataManager.swift
//  ParkStore
//
//  Created by Hector Rodriguez on 4/24/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class WishListDataManager: NSObject {
    
    var dataStore:CDTStore!
    var appDelegate:AppDelegate!
    let cloudantProxyPath:String = "imfdata"
//        let cloudantProxyPath:String = "datastore"
    let remoteStoreName:String = "wishlist17"
    
    class var sharedInstance : WishListDataManager{
        
        struct Singleton {
            static let instance = WishListDataManager()
        }
        return Singleton.instance
    }
    
    func setUpDB(callback:(Bool, [Item]!)->()){
        let configurationPath = NSBundle.mainBundle().pathForResource("worklight", ofType: "plist")
        let configuration = NSDictionary(contentsOfFile: configurationPath!)
        let protocolString = configuration?["protocol"] as! String
        let host = configuration?["host"] as! String
        let port = configuration?["port"] as! String
        
        var manager:IMFDataManager
        
        if NSUserDefaults.standardUserDefaults().boolForKey("isCustomServerURL") {
            manager = IMFDataManager.initializeWithUrl(NSUserDefaults.standardUserDefaults().objectForKey("DataProxyCustomServerURL") as! String)
        }else{
//            manager = IMFDataManager.initializeWithUrl("\(protocolString)://\(host):\(port)/\(cloudantProxyPath)")
             manager = IMFDataManager.initializeWithUrl("http://9.182.149.248:9080/imfdata")
        }
        
        manager.remoteStore(self.remoteStoreName, completionHandler: { (createdStore:CDTStore!, err:NSError!) -> Void in
            if nil != err{
                //error
                println("Error in creating remote store :  \(err.debugDescription)")
                var error:UIAlertView = UIAlertView(title: "BoxStore", message: "There was an error while retrieving the wish list", delegate: nil, cancelButtonTitle: "OK")
                error.show()
            }else{
                self.dataStore = createdStore
                self.dataStore.mapper.setDataType("Item", forClassName: NSStringFromClass(Item.classForCoder()))
                
                println("Successfully created store : \(self.dataStore?.name)")
                
                manager.setCurrentUserPermissions(DB_ACCESS_GROUP_ADMINS, forStoreName: self.remoteStoreName) { (success:Bool, error:NSError!) -> Void in
                    if nil != error {
                        // Handle error
                    } else {
                        self.getWishListItems(callback)
                    }
                }
            }
        })
        
    }
    func getWishListItems(callback:(Bool, [Item]!)->()) {
        
        if self.dataStore == nil {
            self.setUpDB(callback)
        }else{
            let query: CDTQuery = CDTCloudantQuery(dataType: "Item")
            
            self.dataStore.performQuery(query, completionHandler: { (results, error) -> Void in
                if nil != error {
                    // Handle error
                    println("could not retrieve all the data from remote store \(error.debugDescription)")
                } else {
                    callback(true, (results as! [Item]))
                    
                    println("got all records")
                }
            })
        }
    }
    
    func saveItemToWishList(item: Item, callback:()->()){
        
        self.dataStore?.save(item, completionHandler: { (object, err) -> Void in
            if nil != err{
                println("could not save object to cloudant store \(err.debugDescription)")
                var saveFailure:UIAlertView = UIAlertView(title: "ParkStore", message: "Could not save object to cloudant store", delegate: nil, cancelButtonTitle: "OK")
                saveFailure.show()
            }else{
                println("successfully saved object to cloudant store")
                callback()
            }
        })
    }
}
