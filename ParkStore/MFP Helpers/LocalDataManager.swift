//
//  LocalDataManager.swift
//  ParkStore
//
//  Created by Chethan Kumar on 02/06/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import Foundation

class LocalDataManager:NSObject{
    var localStore:CDTStore?
    var itemsFromAdapter:[Item] = []
    var itemsFromLocalStore:[Item] = []
    
    class var sharedInstance : LocalDataManager{
        
        struct Singleton {
            static let instance = LocalDataManager()
        }
        return Singleton.instance
    }
    
    func setUpLocalDB(){
        var manager:IMFDataManager
        manager = IMFDataManager.initializeWithUrl("http:localhost:9080/data")
        var err:NSErrorPointer = NSErrorPointer()
        localStore = manager.localStore("wishlist", error: err)
        if err==nil {
            //Error
        }else{
            self.localStore?.mapper.setDataType("Item", forClassName: NSStringFromClass(Item.classForCoder()))
            
//            localStore?.createIndexWithDataType("Item", fields: <#[AnyObject]!#>, completionHandler: { (err:NSError!) -> Void in
//            })
//            getAllLocalItems()
        }
        
        
    }
    
    func getAllLocalItems(callback:(Bool, [Item]!)->()){
        if self.localStore == nil {
            self.setUpLocalDB()
        }else{
            let query: CDTQuery = CDTCloudantQuery(dataType: "Item")
            
            self.localStore!.performQuery(query, completionHandler: { (results, error) -> Void in
                if nil != error {
                    // Handle error
                    println("could not retrieve all the data from local store \(error.debugDescription)")
                } else {
//                    callback(true, (results as! [Item]))
                    self.itemsFromLocalStore.removeAll(keepCapacity: false)
                    for item in results as![Item]{
                        self.itemsFromLocalStore.append(item)
                    }
                    
                    for item in self.itemsFromLocalStore{
                        println("Item : :  \(item.title)")
                    }
                    println("got all records")
                    callback(true, (self.itemsFromLocalStore))
                }
            })
        }
    }
    
    func getAllItemsFromAdapter(callback:(Bool, [Item]!)->()){
        if self.localStore == nil{
            self.setUpLocalDB()
        }
        let adapterName : String = "LocalStoreAdapter"
        let procedureName : String = "localstore/getAllItems"
        
        let url :NSURL = NSURL(string: "adapters/\(adapterName)/\(procedureName)")!
        
        var resourceRequest : WLResourceRequest = WLResourceRequest()
        resourceRequest = WLResourceRequest(URL: url, method: "GET")
        resourceRequest.sendWithCompletionHandler { (wlResponse:WLResponse!, err: NSError!) -> Void in
            if err != nil{
                UIAlertView(title: "ParkStore", message: "An error occured while retrieving data from adapter.", delegate: nil, cancelButtonTitle: "OK").show()
            }else{
                var responseJSONString = wlResponse.responseText as NSString
                println("Raw data from adapter \(responseJSONString.description)")
                var data: NSData = responseJSONString.dataUsingEncoding(NSUTF8StringEncoding)!
                var error: NSError?
                
                // convert NSData to 'AnyObject'
                let JSONObj = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0),
                    error: &error) as! NSArray
                self.itemsFromAdapter.removeAll(keepCapacity: false)
                for responseDict in JSONObj{
                    let title = responseDict.objectForKey("title") as! NSString
                    let store = responseDict.objectForKey("store") as! NSString
                    let price = responseDict.objectForKey("price") as! NSNumber
                    let image = responseDict.objectForKey("image") as! NSString
                    let productId = responseDict.objectForKey("productId") as! NSString
                    println("Item :: title: \(title), store : \(store), price :\(price), image : \(image) productId : \(productId)")
                    var item:Item = Item()
                    item.productId = productId
                    item.title = title
                    item.store = store
                    item.imgURL = image
                    item.price = price
                    self.itemsFromAdapter.append(item)
                }
                self.syncLocalStoreWithAdapter(callback)
//                callback(true, (self.itemsFromAdapter))
            }
        }
    }
    
    func syncLocalStoreWithAdapter(callback:(Bool, [Item]!)->()){
        if self.localStore == nil {
            self.setUpLocalDB()
        }else{
            if self.itemsFromLocalStore.count == 0{
                 self.addItemsFromAdapterToLocalStore(callback)
            }
            for (var i=0; i<self.itemsFromLocalStore.count; i++) {
                self.localStore?.mapper.setDataType("Item", forClassName: NSStringFromClass(Item.classForCoder()))
                self.localStore?.delete(self.itemsFromLocalStore[i], completionHandler: { (deletedObjectId:String!, deletedRevisionId:String!, err:NSError!) -> Void in
                    if err != nil{
                        println("An error occured while deleting all the localstore documents")
                    }else{
                        if((i+1) == self.itemsFromLocalStore.count ){
                            self.addItemsFromAdapterToLocalStore(callback)
                        }
                        println("Deleted a document")
                    }
                })
            }
        }
    }
    
    func addItemsFromAdapterToLocalStore(callback:(Bool, [Item]!)->()){
        for (var i=0; i<self.itemsFromAdapter.count; i++) {
            self.localStore?.mapper.setDataType("Item", forClassName: NSStringFromClass(Item.classForCoder()))
            self.localStore?.save(self.itemsFromAdapter[i], completionHandler: { (obj:AnyObject!, err:NSError!) -> Void in
                if err != nil{
                    println("An error occured while saving documents to local store \(err.localizedDescription)")
                }else{
                    if((i+1) == self.itemsFromAdapter.count ){
                        self.getAllLocalItems(callback)
                    }
                    println("Saved a document")
                }
            })
        }
    }
    
    func saveItemToLocalList(item: Item, callback:()->()){
        self.localStore?.mapper.setDataType("Item", forClassName: NSStringFromClass(Item.classForCoder()))
        self.localStore?.save(item, completionHandler: { (obj:AnyObject!, err:NSError!) -> Void in
            if err != nil{
                println("An error occured while saving document to local store \(err.localizedDescription)")
            }else{
                println("Saved a document")
                callback()
            }
        })
    }
}
