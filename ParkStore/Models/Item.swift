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

import UIKit

@objc public class Item: NSObject, CDTDataObject {
    var title : NSString = ""
    var store : NSString = ""
    var price : NSNumber = 0
    var imgURL : NSString = ""
    var productId : NSString = ""
    public var metadata:CDTDataObjectMetadata?

    
    func getLocalizedPrice() -> String {
        var currencyFormatter = NSNumberFormatter()
        currencyFormatter.locale = NSLocale.currentLocale()
        currencyFormatter.maximumFractionDigits = 2
        currencyFormatter.minimumFractionDigits = 2
        currencyFormatter.alwaysShowsDecimalSeparator = true
        currencyFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        return currencyFormatter.stringFromNumber(self.price)!
    }
    
    func getString() -> String{
        return "{'title':'\(self.title)','store':'\(self.store)','price':\(self.price),'image':'\(self.imgURL)','productId':'00006'}"
    }
}
