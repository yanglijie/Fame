//
//  ViewMsgController.swift
//  FameSmartApp
//
//  Created by Eric on 15-10-6.
//  Copyright (c) 2015年 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerMsg: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var msgs :Array<String> = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func NoticOn(sender: UISwitch) {

        print(sender.on)
        FAME.defaults.setObject(sender.on, forKey: "PushState")
        if !sender.on{
            FAME.showMessage("推送已经关闭")
            FAME.devicetoken = ""
            UIApplication.sharedApplication().unregisterForRemoteNotifications()
        }
        else{
            FAME.showMessage("推送打开")
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        let button = UIButton(frame: CGRectMake(0,0,80,35))
        button.setBackgroundImage(UIImage(named: "yuba_spinner_press.png"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "curtain_04_10.png"), forState: UIControlState.Highlighted)
        button.setTitle("清空", forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("deleteAll:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        
        
        if (FAME.defaults.valueForKey("\(FAME.user_name)") != nil){
            msgs = FAME.defaults.valueForKey("\(FAME.user_name)") as! Array
   
        }
        
        if msgs.count == 0{
            let textLabel = UILabel (frame:CGRectMake(20,self.view.frame.size.height * 0.25,self.view.frame.size.width - 20,20))
            textLabel.text = "无报警信息"
            
            //textLabel.backgroundColor = UIColor.blackColor()
            textLabel.textColor = UIColor.whiteColor()
            textLabel.font = UIFont.systemFontOfSize(17)
            self.view.addSubview(textLabel)
        }
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "raload:", name: "msgChange", object: nil)
        
        
        
        
    }
//    deinit {
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: "msgChange", object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self)
//        
//    }
    
    func raload(notification:NSNotification){
        
        //print("123344")
        msgs = FAME.defaults.valueForKey("\(FAME.user_name)") as! Array
        //print("44444444\(msgs)")
        
        tableView.reloadData()
        
        //
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "msgChange", object: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        print(FAME.defaults.valueForKey("PushState"))
        let stateOn = self.view.viewWithTag(2) as! UISwitch
        if (FAME.defaults.valueForKey("PushState") != nil){
            stateOn.on = FAME.defaults.valueForKey("PushState") as! Bool
            if !stateOn.on{
                //UIApplication.sharedApplication().unregisterForRemoteNotifications()
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return msgs.count

    }
    
    func deleteAll(sender:AnyObject!){
        msgs = []
        self.msgTabel?.reloadData()
        FAME.defaults.setObject(msgs, forKey: "\(FAME.user_name)")
        print("清空了")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "msgCell")
        cell.textLabel?.text = msgs[indexPath.row]
        cell.textLabel?.textColor = UIColor.whiteColor()
        //cell.textLabel?.font = UIFont.systemFontOfSize(15)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        
        return UITableViewCellEditingStyle.Delete
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 20
        
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    @IBOutlet weak var msgTabel: UITableView!
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        //***********************
        msgs.removeAtIndex(indexPath.row)
        //self.msgTabel?.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Top)
        self.msgTabel?.reloadData()
        
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        
        return Defined_Delete
        
    }
}