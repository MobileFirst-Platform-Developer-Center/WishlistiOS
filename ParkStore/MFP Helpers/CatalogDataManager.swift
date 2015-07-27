/*
Licensed Materials - Property of IBM
© Copyright IBM Corporation 2015. All Rights Reserved.
*/


import Foundation


class CatalogDataManager: NSObject{
    
    var imageCache = NSCache()
    
    class var sharedInstance : CatalogDataManager{
        
        struct Singleton {
            static let instance = CatalogDataManager()
        }
        return Singleton.instance
    }
    
    
    func getCatalogData(callback: ((Bool, [Item]!)->())){
        let adapterName : String = "CatalogAdapter"
        let procedureName : String = "getCatalog"
        
        let url :NSURL = NSURL(string: "adapters/\(adapterName)/\(procedureName)")!
        
        var resourceRequest : WLResourceRequest = WLResourceRequest()
        resourceRequest = WLResourceRequest(URL: url, method: "GET")
        resourceRequest.sendWithCompletionHandler { (wlresponse:WLResponse!, err:NSError!) -> Void in
            if(err != nil){
                
                callback(false, nil)
            }else{
                var responseJSON = wlresponse.responseJSON as NSDictionary
                var responseText = responseJSON.objectForKey("getAllProductsDetailsReturn") as! NSArray
                
//                var jsonData:NSData = responseText.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
                
//                var itemsArray:NSArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments, error: nil)as! NSArray
                
                var items : [Item] = []
                
//                for item  in itemsArray{
                for item  in responseText{
                    let itemDict:NSDictionary = item as! NSDictionary
                    
                    var item:Item = Item()
                    item.title =  itemDict.objectForKey("title") as! String
                    item.store = itemDict.objectForKey("store") as! String
                    let priceString = itemDict.objectForKey("price") as! NSString
                    item.price = priceString.floatValue
                    let imagePath = itemDict.objectForKey("photo") as! String
                    item.imgURL = "https://dl.dropboxusercontent.com/u/97674776/\(imagePath)"
                    
                    item.productId = itemDict.objectForKey("productID") as! String
                    items.append(item)
                }
                callback(true, items)
            }
            
        }
    }
    
    func imageFromURL(imageURL: String!, callback: (UIImage) ->()) {

        if self.imageCache.objectForKey(imageURL) == nil{
            request(.GET, imageURL).response() {
                (_, _, data, _) in
                if data == nil  {
                    return
                }
                if var image = UIImage(data: data! as! NSData) {
                    callback(image)
                    self.imageCache.setObject(image, forKey: imageURL)
                }
            }
        }else{
            callback(self.imageCache.objectForKey(imageURL) as! UIImage!)
        }
    }
}

