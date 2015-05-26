//
//  AddItemViewController.swift
//  Wish List
//
//  Created by Hector Rodriguez on 4/22/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {

    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var storeTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    
    var dbCreateError : NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        view.endEditing(true)
        
        ///Create a new item
        var item = Item()
        item.title = titleTextField.text
        item.store = storeTextField.text
        item.price = (priceTextField.text as NSString).floatValue
        item.imgURL = "http://boxstore-catalog.mybluemix.net/MFPSampleWebService/images/gs6edge.png"
        
        saveToDB(item)
    }
    
    func saveToDB(item: Item){
        WishListDataManager.sharedInstance.saveItemToWishList(item, callback: { () -> () in
            ///Dismiss this viewcontroller
            self.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    @IBAction func imageButtonTapped(sender: AnyObject) {
        imageButton.selected = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = event.allTouches()?.first as! UITouch
        
        if !(touch.view is UITextField){
            view.endEditing(true)
        }
        super.touchesBegan(touches, withEvent: event)
    }
    
}

extension AddItemViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField.tag == 2 {
            let nonNumberSet = NSCharacterSet(charactersInString: "0123456789.").invertedSet
        
            return (count(string.stringByTrimmingCharactersInSet(nonNumberSet)) > 0)
        }else {
            return true
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag < 2 {
            let newTextField = self.view.viewWithTag(textField.tag+1)
            textField.resignFirstResponder()
            newTextField?.becomeFirstResponder()
            return true
        } else {
            textField.resignFirstResponder()
            return true
        }
    }
}
