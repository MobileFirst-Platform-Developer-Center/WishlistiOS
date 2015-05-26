//
//  LandingViewController.swift
//  Wish List
//
//  Created by Hector Rodriguez on 4/23/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

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
