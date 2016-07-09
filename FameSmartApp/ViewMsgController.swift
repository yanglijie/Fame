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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "deleteAll:")
        self.navigationItem.rightBarButtonItem = addButton
        if (FAME.defaults.valueForKey("alarm") != nil){
            FAME.msgs = FAME.defaults.valueForKey("alarm") as! Array

            
        }
        
        
        print("44444444\(FAME.msgs)")
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return FAME.msgs.count

    }
    func deleteAll(sender:AnyObject!){
        FAME.msgs = []
        self.msgTabel?.reloadData()
        FAME.defaults.setObject(FAME.msgs, forKey: "alarm")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "msgCell")
        cell.textLabel?.text = FAME.msgs[indexPath.row]
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