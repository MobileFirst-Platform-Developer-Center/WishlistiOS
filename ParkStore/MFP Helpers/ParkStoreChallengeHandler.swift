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