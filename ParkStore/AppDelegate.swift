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
import IBMMobileFirstPlatformFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        WLClient.sharedInstance().registerChallengeHandler(ParkStoreChallengeHandler())
        if let customServerUrl = NSUserDefaults.standardUserDefaults().objectForKey("MFPCustomServerURL"){
            WLClient.sharedInstance().setServerUrl(NSURL(string: customServerUrl as! String))
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Device Token \(deviceToken.description)")
        WLPush.sharedInstance().tokenFromClient = deviceToken.description
        WLPush.sharedInstance().onReadyToSubscribeListener = OnReadyToSubscribeDelegate()
        WLClient.sharedInstance().wlConnectWithDelegate(ConnnectionDelegate())
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("Got remote Notification. Data : \(userInfo.description)")
        WLAnalytics.sharedInstance().log("Received remote task via push notification", withMetadata: NSDictionary() as [NSObject : AnyObject])
        //TODO Add task
        //construct item
//        WishListDataManager.sharedInstance.saveItemToWishList(item: Item) { () -> () in
        
        }
    }
    
    class ConnnectionDelegate : NSObject, WLDelegate{
        
        func onFailure(response: WLFailResponse!) {
            print("Connection Failure \(response.responseText)")
        }
        
        func onSuccess(response: WLResponse!) {
            print("Connection successfull \(response.responseText)" )
        }
    }
    
    class OnReadyToSubscribeDelegate :NSObject, WLOnReadyToSubscribeListener{
        func OnReadyToSubscribe() {
            WLPush.sharedInstance().subscribeTag("nirvana", nil, PushNotificationDelegate())
        }
    }
    
    class PushNotificationDelegate :NSObject, WLDelegate{
        func onSuccess(response: WLResponse!) {
            print("Successfully subscribed to Push notification tag")
        }
        
        func onFailure(response: WLFailResponse!) {
            print("Could not subscribe to Tags \(response.responseText)")
        }
    }



