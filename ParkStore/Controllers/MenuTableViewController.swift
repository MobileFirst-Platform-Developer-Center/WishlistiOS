//
//  MenuTableViewController.swift
//  Wish List
//
//  Created by Hector Rodriguez on 4/23/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    let menuItems = ["title", "home", "catalog", "wishlist", "server", "logout"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = menuItems[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell

        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logOutSegue" {
            //handle log out
        }
    }
}
