//
//  ParkStoreChallengeHandler.swift
//  ParkStore
//
//  Created by Chethan Kumar on 22/04/15.
//  Copyright (c) 2015 IBM. All rights reserved.
//

import Foundation


class ParkStoreChallengeHandler: ChallengeHandler{
    
    var logInViewController : LogInViewController!
    
    override init(){
        super.init(realm: "CustomLoginModule")
    }
    
    override func handleChallenge(response: WLResponse!) {
        if logInViewController == nil {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        logInViewController = mainStoryboard.instantiateViewControllerWithIdentifier("LogInViewController") as! LogInViewController
        logInViewController.challengeHandler = self
        // Present login view controller
        let root = UIApplication.sharedApplication().keyWindow?.rootViewController
        root?.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        root?.presentViewController(logInViewController, animated: true, completion: nil)
        }
    }
    
    override func onFailure(response: WLFailResponse!) {
        UIAlertView(title: "Invalid username or password", message: nil, delegate: nil, cancelButtonTitle: "OK").show()
        self.submitFailure(response)
    }
    
    override func onSuccess(response: WLResponse!) {
        println("--------LOGIN SUCCESS--------")
        println(response)
        logInViewController.dismissViewControllerAnimated(true, completion: nil)
        logInViewController = nil
        self.submitSuccess(response)
    }
    
    override func isCustomResponse(response: WLResponse!) -> Bool {
        println("---------CustomResponse---------")
        println(response.getResponseJson())
        if (response != nil && response.getResponseJson() != nil) {
            let jsonResponse = response.getResponseJson() as NSDictionary
            let authRequired = jsonResponse.objectForKey("authStatus") as! String!
            if authRequired != nil {
                return authRequired == "required"
            }
        }
        return false
    }
    
    func submitLogin(username: String, password: String) {
        self.submitLoginForm("/my_custom_auth_request_url", requestParameters: ["username":username,"password":password], requestHeaders: nil, requestTimeoutInMilliSeconds: 0, requestMethod: "POST")
    }
}

extension ParkStoreChallengeHandler: WLDelegate {
    
}