
//  AppDelegate.swift
//  FameSmartApp
//
//  Created by Eric on 14-8-1.
//  Copyright (c) 2014年 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UIAlertViewDelegate {
    
    var window: UIWindow?
    
    //func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool{
        // Override point for customization after application launch.
        
        
        //UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent;
        
        
        
        //is the ios8
        
        let version = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        
        if version >= 8 {
            FAME.IS_IOS8 = true
        }else{
            FAME.IS_IOS8 = false
        }
        //register for push notifications
        if FAME.IS_IOS8 {
            let settins:UIUserNotificationSettings = UIUserNotificationSettings(forTypes:[.Badge, .Sound, .Alert], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settins)
            
            let pushSettiong = UIApplication.sharedApplication().currentUserNotificationSettings()
            if (pushSettiong != nil) {
                let pushType = pushSettiong!.types
                if (FAME.defaults.valueForKey("PushState") != nil){
                    let pushState = FAME.defaults.valueForKey("PushState") as! Bool
                    if !pushState{
                        FAME.bPushEnable = false
                        
                    }
                    
                }
                if pushType == UIUserNotificationType.None{
                    FAME.bPushEnable = false
                    
                    print("PUSH disabled")
                }else{
                        
                    FAME.bPushEnable = true
                    print("PUSH enabled")
                }
                
            }
            
            //UIApplication.sharedApplication().registerForRemoteNotifications()
            
            
            
        }
        else{
            application.registerForRemoteNotificationTypes([.Badge,.Alert,.Sound])
            
            let pushType = UIApplication.sharedApplication().enabledRemoteNotificationTypes()
            if (pushType == UIRemoteNotificationType.None){
                FAME.bPushEnable = false
                print("PUSH disabled")
            }else{
                FAME.bPushEnable = true
                print("PUSH enabled")
            }
        }
        
        if !FAME.bPushEnable {
            let alert = UIAlertView()
            alert.title = Defined_PUSH_Title
            alert.message =  Defined_PUSH_failed
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
        }
        
        
        return true
    }
    func application(application: UIApplication , didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings ) {
        
        //application.registerForRemoteNotifications ()
        print("userNotificationSettings setted")
    }
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData){
        print("PUSH register success: \(deviceToken)")
        let str = String(deviceToken)
        
        let str1 = (str as NSString).substringWithRange(NSMakeRange(1, 71))
        var str2 = ""
        let array = str1.componentsSeparatedByString(" ")
        for (var i = 0;i < array.count; i++){
            str2 = str2 + array[i]
        }
        
        print("111111\(str2)")
        //if str2 != nil {
            httpRequert().sendToken(str2 as String)
        //}
        
    }
    

    
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError){
        print("PUSH register failed: \(error)")
    }
    
    //当应用运行在后台时
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]){
        print("PUSH register userInfo: \(userInfo)")
        
        
        
        let notif    = userInfo as NSDictionary
        
        let apsDic   = notif.objectForKey("aps") as! NSDictionary
        let alertDic = apsDic.objectForKey ( "alert" ) as! String
        
        
        if alertDic.componentsSeparatedByString("解除").count > 1{
            
        }
        
        else{
            //
            if (FAME.defaults.valueForKey("alarm") != nil){
                FAME.msgs.removeAll()
                FAME.msgs = (FAME.defaults.valueForKey("alarm") as! Array).reverse()
            }

            FAME.msgs .append(alertDic)
            FAME.defaults.setObject(FAME.msgs.reverse(), forKey: "alarm")
            //print("111111\(FAME.msgs)")
      
//            let alertView = UIAlertView (title: " 远程推送通知 " , message: alertDic, delegate: nil , cancelButtonTitle: " 返回 " )
//            alertView.delegate = self
//            alertView.show()
            
            let alert = UIAlertView()
            alert.title = " 远程推送通知 "
            alert.delegate = self
            alert.message =  alertDic
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
            
            NSNotificationCenter.defaultCenter().postNotificationName("msgChange", object: FAME.msgs.reverse())
        }
        
        
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        //print("555555555")
//        let next :UIViewController = GBoard.instantiateViewControllerWithIdentifier("msg") as UIViewController
//        self.window?.rootViewController?.presentViewController(next, animated: true, completion: nil)
        //navigationController?.pushViewController(next, animated: true)
        
    }
       
    //Receive
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification){
        print("PUSH  didReceiveLocalNotification: \(notification)")
        
        
    }
    
    // Called when your app has been activated by the user selecting an action from a local notification.
    // A nil action identifier indicates the default action.
    // You should call the completion handler as soon as you've finished handling the action.
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void){
        
        print("PUSH  handleActionWithIdentifier local: \(notification)")
        
        
        
    }
    
    // Called when your app has been activated by the user selecting an action from a remote notification.
    // A nil action identifier indicates the default action.
    // You should call the completion handler as soon as you've finished handling the action.
    
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void){
        print("PUSH  handleActionWithIdentifier remote: \(userInfo)")
        
        
        
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
    
    
}

