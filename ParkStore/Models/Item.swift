//
//  Item.swift
//  Wish List
//
//  Created by Hector Rodriguez on 4/22/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

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
}
