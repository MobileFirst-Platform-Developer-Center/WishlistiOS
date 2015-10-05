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
import CloudantToolkit
import IMFData
import IBMMobileFirstPlatformFoundation

class LocalDataManager:NSObject{
    var localStore:CDTStore?
    var itemsFromAdapter:[Item] = []
    var itemsFromLocalStore:[Item] = []
// 
    class var sharedInstance : LocalDataManager{

        struct Singleton {
            static let instance = LocalDataManager()
        }
        return Singleton.instance
    }

    func setUpLocalDB(){
        var manager:IMFDataManager
        manager = IMFDataManager.initializeWithUrl("http:localhost:9080/data")
        let err:NSErrorPointer = NSErrorPointer()
        do {
            localStore = try manager.localStore("wishlist")
        } catch let error as NSError {
            err.memory = error
            localStore = nil
        }
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
                    print("could not retrieve all the data from local store \(error.debugDescription)")
                } else {
//                    callback(true, (results as! [Item]))
                    self.itemsFromLocalStore.removeAll(keepCapacity: false)
                    for item in results as![Item]{
                        self.itemsFromLocalStore.append(item)
                    }

                    for item in self.itemsFromLocalStore{
                        print("Item : :  \(item.title)")
                    }
                    print("got all records")
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
                print("Raw data from adapter \(responseJSONString.description)")
                var data: NSData = responseJSONString.dataUsingEncoding(NSUTF8StringEncoding)!
                var error: NSError?

                // convert NSData to 'AnyObject'
                let JSONObj = (try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))) as! NSArray
                self.itemsFromAdapter.removeAll(keepCapacity: false)
                for responseDict in JSONObj{
                    let title = responseDict.objectForKey("title") as! NSString
                    let store = responseDict.objectForKey("store") as! NSString
                    let price = responseDict.objectForKey("price") as! NSNumber
                    let image = responseDict.objectForKey("image") as! NSString
                    let productId = responseDict.objectForKey("productId") as! NSString
                    print("Item :: title: \(title), store : \(store), price :\(price), image : \(image) productId : \(productId)")
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
                        print("An error occured while deleting all the localstore documents")
                    }else{
                        if((i+1) == self.itemsFromLocalStore.count ){
                            self.addItemsFromAdapterToLocalStore(callback)
                        }
                        print("Deleted a document")
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
                    print("An error occured while saving documents to local store \(err.localizedDescription)")
                }else{
                    if((i+1) == self.itemsFromAdapter.count ){
                        self.getAllLocalItems(callback)
                    }
                    print("Saved a document")
                }
            })
        }
    }

    func saveItemToLocalList(item: Item, callback:()->()){
        self.localStore?.mapper.setDataType("Item", forClassName: NSStringFromClass(Item.classForCoder()))
        self.localStore?.save(item, completionHandler: { (obj:AnyObject!, err:NSError!) -> Void in
            if err != nil{
                print("An error occured while saving document to local store \(err.localizedDescription)")
            }else{
                print("Saved a document")
                callback()
            }
        })
    }
    
    func saveItemToLocalStoreList(item: Item, callback:(Bool, [Item]!)->()){
       let resourceReq = WLResourceRequest(URL:  NSURL(string: "adapters/LocalStoreAdapter/localstore/addItem"), method: "PUT" )
        resourceReq.sendWithBody(item.getString()) { (response:WLResponse!, err:NSError!) -> Void in
            if err != nil{
            //err
                print("An error occured while adding data to the local store adapter")
            } else{
                    print("Added an item to the adapter")
               self.getAllItemsFromAdapter(callback)
                callback(true,self.itemsFromAdapter)
            }
            
        }
        
    }
    
}
