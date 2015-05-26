//
//  WishListTableViewController.swift
//  Wish List
//
//  Created by Hector Rodriguez on 4/22/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class WishListTableViewController: UITableViewController {
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    var items : [Item] = []
    var selectedItem : Item!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WishListDataManager.sharedInstance.getWishListItems { (success, items) -> () in
            if success {
                self.items = items
                self.tableView.reloadData()
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
        WishListDataManager.sharedInstance.getWishListItems { (success, items) -> () in
            if success {
                self.items = items
                self.tableView.reloadData()
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
        println(item.imgURL)
        return cell
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        selectedItem = items[indexPath.row]
        return indexPath
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController as! UIViewController
        
        if destinationViewController.isKindOfClass(ViewItemViewController){
            let viewItemViewController = destinationViewController as! ViewItemViewController
            viewItemViewController.item = selectedItem
        }
    }
    
    
}
