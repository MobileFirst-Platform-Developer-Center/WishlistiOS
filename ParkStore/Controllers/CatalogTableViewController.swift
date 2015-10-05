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

class CatalogTableViewController: UITableViewController {
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    var items : [Item] = []
    var selectedItem : Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CatalogDataManager.sharedInstance.getCatalogData { (success, items) -> () in
            if success {
                self.items = items
                self.tableView.reloadData()
            }else{
                let error:UIAlertView = UIAlertView(title: "WishList", message: "There was an error while retrieving the catalog", delegate: nil, cancelButtonTitle: "OK")
                error.show()
            }
        }
        let revealViewController = self.revealViewController()
        if revealViewController != nil {
            self.sideBarButton.target = revealViewController
            self.sideBarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(revealViewController.panGestureRecognizer())
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
        
        cell.addFromCatalogBtn.tag = indexPath.row
        cell.addFromCatalogBtn.addTarget(self, action: Selector("addButtonClicked:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        return cell
    }
    
    func addButtonClicked(sender:UIButton){
        let item = self.items[sender.tag] as Item
        print("tapped add with data \(item.title) \(item.store) \(item.price) \(item.productId) \(item.imgURL)")
        Reachability.isConnectedToCloudantDataProxy { (response) -> () in
            if response{
                WishListDataManager.sharedInstance.getWishListItems { (success, items) -> () in
                    if success {
                        WishListDataManager.sharedInstance.saveItemToWishList(item, callback: { () -> () in
                            print("Added data to wishlist from catalog")
                            UIAlertView(title: "Wishlist", message: "Added Item to Wishlist", delegate: nil, cancelButtonTitle: "OK").show()
                        })
                    }
                }
            }else{
                LocalDataManager.sharedInstance.getAllItemsFromAdapter{ (success, items) ->()  in
                    if success{
                        //TODO
                        LocalDataManager.sharedInstance.saveItemToLocalStoreList(item, callback: { (success, _: [Item]!) -> () in
                            UIAlertView(title: "Wishlist", message: "Added Item to Wishlist", delegate: nil, cancelButtonTitle: "OK").show()
                        })

                    }
                }
            }
        }

        
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedItem = items[indexPath.row]
        WishListDataManager.sharedInstance.saveItemToWishList(selectedItem, callback: { () -> () in
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let wishListTableViewController = mainStoryboard.instantiateViewControllerWithIdentifier("WishListTableViewController") as! WishListTableViewController
            self.navigationController?.pushViewController(wishListTableViewController, animated: true)
        })
        return indexPath
    }


}
