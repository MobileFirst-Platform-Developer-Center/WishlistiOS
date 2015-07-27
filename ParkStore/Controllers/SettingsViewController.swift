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
    @IBOutlet weak var mfpRuntimeName: UITextField!
    @IBOutlet weak var customServerHostPort: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        customServerHostPort.text = NSUserDefaults.standardUserDefaults().objectForKey("MFPCustomServerHostPort") as? String
        mfpRuntimeName.text = NSUserDefaults.standardUserDefaults().objectForKey("MFPCustomServerRuntime") as? String
        let revealViewController = self.revealViewController()
        if revealViewController != nil {
            self.sideBarButton.target = revealViewController
            self.sideBarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(revealViewController.panGestureRecognizer())
        }
    }
    
    @IBAction func saveSettings(sender: AnyObject) {
        var customServerUrl: String = "\(customServerHostPort.text)/\(mfpRuntimeName.text)"
        var dataproxyUrl: String = "\(customServerHostPort.text)/datastore"
            WLClient.sharedInstance().setServerUrl(NSURL(string: customServerUrl))
            NSUserDefaults.standardUserDefaults().setObject(customServerUrl, forKey: "MFPCustomServerURL")
            NSUserDefaults.standardUserDefaults().setObject( dataproxyUrl, forKey: "DataProxyCustomServerURL")
        
        NSUserDefaults.standardUserDefaults().setValue(customServerHostPort.text, forKey: "MFPCustomServerHostPort")
        NSUserDefaults.standardUserDefaults().setValue(mfpRuntimeName.text, forKey: "MFPCustomServerRuntime")
        
    }
}
