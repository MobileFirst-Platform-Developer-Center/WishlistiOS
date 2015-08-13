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

class LandingViewController: UIViewController {

    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let revealViewController = self.revealViewController()
        if revealViewController != nil {
            self.sideBarButton.target = revealViewController
            self.sideBarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(revealViewController.panGestureRecognizer())
        }
        
        WLPush.sharedInstance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
