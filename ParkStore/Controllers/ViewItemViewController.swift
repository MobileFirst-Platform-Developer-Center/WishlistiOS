//
//  ViewItemViewController.swift
//  Wish List
//
//  Created by Hector Rodriguez on 4/22/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class ViewItemViewController: UIViewController {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var item : Item!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = item.title as String

        CatalogDataManager.sharedInstance.imageFromURL(item.imgURL as String, callback: { (image) -> () in
            self.itemImageView.image = image
        })
        storeLabel.text = item.store as String
        priceLabel.text = item.getLocalizedPrice()
        // Do any additional setup after loading the view.
    }

}
