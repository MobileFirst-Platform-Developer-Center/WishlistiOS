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
        item.imgURL = "https://dl.dropboxusercontent.com/u/97674776/images/gs6edge.png"
        item.productId = "00006"
        saveToDB(item)
    }
    
    func saveToDB(item: Item){
        if Reachability.isConnectedToNetwork(){
            Reachability.isConnectedToCloudantDataProxy { (response) -> () in
                if response{
                    WishListDataManager.sharedInstance.saveItemToWishList(item, callback: { () -> () in
                        ///Dismiss this viewcontroller
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                }else{
                    //save to local adapter
                    LocalDataManager.sharedInstance.saveItemToLocalStoreList(item, callback: { (success, [Item]!) -> () in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    
                }
            }
        }
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
