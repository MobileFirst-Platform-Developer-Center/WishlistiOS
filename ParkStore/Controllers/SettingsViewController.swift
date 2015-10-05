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

import Foundation
import UIKit
import IBMMobileFirstPlatformFoundation

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
        let customServerUrl: String = "\(customServerHostPort.text)/\(mfpRuntimeName.text)"
        let dataproxyUrl: String = "\(customServerHostPort.text)/datastore"
            WLClient.sharedInstance().setServerUrl(NSURL(string: customServerUrl))
            NSUserDefaults.standardUserDefaults().setObject(customServerUrl, forKey: "MFPCustomServerURL")
            NSUserDefaults.standardUserDefaults().setObject( dataproxyUrl, forKey: "DataProxyCustomServerURL")
        
        NSUserDefaults.standardUserDefaults().setValue(customServerHostPort.text, forKey: "MFPCustomServerHostPort")
        NSUserDefaults.standardUserDefaults().setValue(mfpRuntimeName.text, forKey: "MFPCustomServerRuntime")
        
    }
}
