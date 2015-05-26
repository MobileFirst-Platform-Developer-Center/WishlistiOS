//
//  SettingsViewController.swift
//  Wish List
//
//  Created by Hector Rodriguez on 4/22/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import UIKit

class ServerPathViewController: UIViewController {

    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var sideBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let revealViewController = self.revealViewController()
        if revealViewController != nil {
            self.sideBarButton.target = revealViewController
            self.sideBarButton.action = "revealToggle:"
            self.view.addGestureRecognizer(revealViewController.panGestureRecognizer())
        }
    }

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        
        ///Dismiss this viewcontroller
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func defaultButtonTapped(sender: AnyObject) {
        serverTextField.text = "Default"
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = event.allTouches()?.first as! UITouch
        
        if !(touch.view is UITextField){
            view.endEditing(true)
        }
        super.touchesBegan(touches, withEvent: event)
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
