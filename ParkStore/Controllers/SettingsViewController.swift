//
//  SettingsViewController.swift
//  ParkStore
//
//  Created by Chethan Kumar on 01/06/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UIViewController{
    
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    @IBOutlet weak var customDataProxyUrl: UITextField!
    @IBOutlet weak var customServerUrl: UITextField!
    @IBOutlet weak var customServerSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let revealViewController = self.revealViewController()
        if revealViewController != nil {
            self.sideBarButton.target = revealViewController
            self.sideBarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(revealViewController.panGestureRecognizer())
        }
    }
    
    @IBAction func saveSettings(sender: AnyObject) {
        if customServerSwitch.on{
            //on
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isCustomServerURL")
            WLClient.sharedInstance().setServerUrl(NSURL(string: customServerUrl.text))
            NSUserDefaults.standardUserDefaults().setURL(NSURL(string: customServerUrl.text)!, forKey: "MFPCustomServerURL")
            NSUserDefaults.standardUserDefaults().setObject( customDataProxyUrl.text, forKey: "DataProxyCustomServerURL")
        }else{
            //off
            NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isCustomServerURL")
            WLClient.sharedInstance().setServerUrl(NSURL(fileURLWithPath: Utils.getMfpServerUrl() as String))
        }
    }
}
