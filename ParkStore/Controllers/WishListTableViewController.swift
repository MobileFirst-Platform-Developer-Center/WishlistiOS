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

class WishListTableViewController: UITableViewController {
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    var items : [Item] = []
    var selectedItem : Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork(){
            Reachability.isConnectedToCloudantDataProxy { (response) -> () in
                if response{
                    WishListDataManager.sharedInstance.getWishListItems { (success, items) -> () in
                        if success {
                            self.items = items
                            self.tableView.reloadData()
                        }
                    }
                }else{
                    LocalDataManager.sharedInstance.getAllItemsFromAdapter{ (success, items) ->()  in
                        if success{
                            self.items = items
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }else{
            LocalDataManager.sharedInstance.getAllItemsFromAdapter{ (success, items) ->()  in
                if success{
                    self.items = items
                    self.tableView.reloadData()
                }
            }
        }
     
        let revealViewController = self.revealViewController()
        if revealViewController != nil {
            self.sideBarButton.target = revealViewController
            self.sideBarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(revealViewController.panGestureRecognizer())
        }
        
        if selectedItem != nil {
            self.items.append(selectedItem)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if Reachability.isConnectedToNetwork(){
            Reachability.isConnectedToCloudantDataProxy { (response) -> () in
                if response{
                    WishListDataManager.sharedInstance.getWishListItems { (success, items) -> () in
                        if success {
                            self.items = items
                            self.tableView.reloadData()
                        }
                    }
                }else{
                    LocalDataManager.sharedInstance.getAllItemsFromAdapter{ (success, items) ->()  in
                        if success{
                            self.items = items
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }else{
            LocalDataManager.sharedInstance.getAllItemsFromAdapter{ (success, items) ->()  in
                if success{
                    self.items = items
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemTableViewCell", forIndexPath: indexPath) as! ItemTableViewCell
        
        cell.itemTitleLabel.text = item.title as String
        cell.itemStoreLabel.text = item.store as String
        cell.itemPriceLabel.text = item.getLocalizedPrice()
        CatalogDataManager.sharedInstance.imageFromURL(item.imgURL as String, callback: { (image) -> () in
            cell.itemImageView.image = image
        })
        print(item.imgURL)
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedItem = items[indexPath.row]
        return indexPath
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController 
        
        if destinationViewController.isKindOfClass(ViewItemViewController){
            let viewItemViewController = destinationViewController as! ViewItemViewController
            viewItemViewController.item = selectedItem
        }
    }
    
    
}
