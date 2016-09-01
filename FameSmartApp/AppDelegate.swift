
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
        
        print("应用启动，并进行初始化时调用")
        //is the ios8
        
        
        
        let version = (UIDevice.currentDevice().systemVersion as NSString).floatValue
        
        if version >= 8 {
            FAME.IS_IOS8 = true
        }else{
            FAME.IS_IOS8 = false
        }
        //register for push notifications

            let settins:UIUserNotificationSettings = UIUserNotificationSettings(forTypes:[.Badge, .Sound, .Alert], categories: nil)
            UIApplication.sharedApplication().registerUserNotificationSettings(settins)
 
            let pushSettiong = UIApplication.sharedApplication().currentUserNotificationSettings()
            
            if (pushSettiong != nil) {
                let pushType = pushSettiong!.types
                
                if pushType == UIUserNotificationType.None{
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

            if (FAME.defaults.valueForKey("\(FAME.user_name)") != nil){
                FAME.msgs = FAME.defaults.valueForKey("\(FAME.user_name)") as! Array
                FAME.msgs.insert(alertDic, atIndex: 0)
                FAME.defaults.setObject(FAME.msgs, forKey: "\(FAME.user_name)")
                
        NSNotificationCenter.defaultCenter().postNotificationName("msgChange", object: FAME.msgs)
                
            }
            
            
           

            //判断程序现在是在前台运行还是后台
            if UIApplication.sharedApplication().applicationState == .Active{
                let alert = UIAlertView()
                alert.title = " 远程推送通知 "
                alert.message =  alertDic
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            }
            else{
                print("刚刚在后台")
                let next :UIViewController = GBoard.instantiateViewControllerWithIdentifier("msg") as UIViewController
                self.window?.rootViewController?.presentViewController(next, animated: true, completion: nil)
                
            }
            
            
        }
        
        
        
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
        print("应用从活动状态进入非活动状态时调用")
        
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        print("应用进入后台时调用")
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        print("应用进入前台时调用")
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        print("应用进入前台并处于活动状态时调用")
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        print("应用被终止时调用")
    }
    
    
}

