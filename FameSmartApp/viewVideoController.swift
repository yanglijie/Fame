//
//  ViewMsgController.swift
//  FameSmartApp
//
//  Created by Eric on 15-10-6.
//  Copyright (c) 2015年 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerVideo: UIViewController,UITableViewDelegate,UITableViewDataSource{
    var cells:Array<String> = ["看家宝","海康威视","米视通","萤石"]
    var apps:Array<String> = ["v380://","https://itunes.apple.com/us/app/shi-pin-qu/id571195405","p2pcamlive://","https://itunes.apple.com/us/app/shi-pin-qu/id571195405?ls=1&mt=8"]
    var urls:Array<String> = ["http://www.anm7.com/","https://itunes.apple.com/us/app/shi-pin-qu/id571195405","https://itunes.apple.com/cn/app/easyn-p/id893617705","https://itunes.apple.com/us/app/shi-pin-qu/id571195405?ls=1&mt=8"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.cells.count
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "videoCell")
        cell.textLabel?.text = self.cells[indexPath.row]
        //cell.backgroundColor = UIColor.clearColor()
        
        cell.backgroundColor = UIColor(red: 147/255.0, green: 147/255.0, blue:147/255.0, alpha: 1.0)

        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
       // var brun = UIApplication.sharedApplication().openURL(NSURL(string: apps[indexPath.row])!)
        //if ( !brun){
            
            UIApplication.sharedApplication().openURL(NSURL(string: urls[indexPath.row])!)
       // }
        
    }
    
   
}
