//
//  ViewMsgController.swift
//  FameSmartApp
//
//  Created by Eric on 15-10-6.
//  Copyright (c) 2015年 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerMsg: UIViewController {
    
    let tableView = UITableView()
    
    //var dataSource : Array<String> = []
    var dataSource = NSMutableArray()
    var sectionArray = NSMutableArray()
    var stateArray = NSMutableArray()
    
    var index_ : NSIndexPath = NSIndexPath()
    
    func initDateSource(){
        
        sectionArray = ["今天",
            "昨天",
            "最近一周",
            "最近一个月"]
        
        let data = FAME.getMonthDate(0)
        let arr = data.componentsSeparatedByString(" ")
        let sdate = arr[0] + " " + "00:00:00"
        let edate = FAME.getNowDate(2)
        var one = NSMutableArray()
        if (FAME.getMonthRecord(sdate, edate: edate) != nil){
            one = FAME.getMonthRecord(sdate, edate: edate)! as! NSMutableArray
            
        }
        else{
            let dic :Dictionary = ["id":"0","info":"无报警记录"]
            one.addObject(dic)
        }
        
        
        
        let data2 = FAME.getMonthDate(1)
        let arr2 = data2.componentsSeparatedByString(" ")
        let sdate2 = arr2[0] + " " + "00:00:00"
        let edate2 = arr2[0] + " " + "23:59:59"
        var two = NSMutableArray()
        if (FAME.getMonthRecord(sdate2, edate: edate2) != nil){
            two = FAME.getMonthRecord(sdate2, edate: edate2)! as! NSMutableArray
        }
        else{
            let dic :Dictionary = ["id":"0","info":"无报警记录"]
            two.addObject(dic)
        }
        
        let data3 = FAME.getMonthDate(8)
        let arr3 = data3.componentsSeparatedByString(" ")
        let edate3 = arr3[0] + " " + "00:00:00"
        var three = NSMutableArray()
        if (FAME.getMonthRecord(edate3, edate: sdate2) != nil){
            three = FAME.getMonthRecord(edate3, edate: sdate2)! as! NSMutableArray
        }
        else{
            let dic :Dictionary = ["id":"0","info":"无报警记录"]
            three.addObject(dic)
        }
        
        let data4 = FAME.getMonthDate(38)
        let arr4 = data4.componentsSeparatedByString(" ")
        let edate4 = arr4[0] + " " + "00:00:00"
        var four = NSMutableArray()
        if (FAME.getMonthRecord(edate4, edate: edate3) != nil){
            four = FAME.getMonthRecord(edate4, edate: edate3)! as! NSMutableArray
        }
        else{
            let dic :Dictionary = ["id":"0","info":"无报警记录"]
            four.addObject(dic)
        }
        
        
        
        dataSource = [one,two,three,four]
        
        
        for i in 0..<dataSource.count{
            if i == 0{
                stateArray.addObject("1")
            }
            else{
                stateArray.addObject("0")
            }
        }
        
        print("werr====\(stateArray)")
        
    }
    
    func switchClick(sender: UISwitch) {
        
        print(sender.on)
        FAME.defaults.setObject(sender.on, forKey: "\(FAME.user_name)1")
        if !sender.on{
            FAME.showMessage("推送已经关闭")
            //FAME.devicetoken = ""
            UIApplication.sharedApplication().unregisterForRemoteNotifications()
        }
        else{
            FAME.showMessage("推送打开")
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
    }
    func initTable(){
        
        tableView.frame = CGRect(x: 0, y: 108, width: WIDTH, height: HEIGHT - 64)
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.registerNib(UINib(nibName: "CallCell", bundle: nil), forCellReuseIdentifier: "CallCell")
        
        
        self.view.addSubview(tableView)
        
    }
    func Timerset_deleteAll(){
        let cmdStr = "{\"cmd\":50, \"user_name\": \"\(FAME.user_name)\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"ieee_addr\": \"\(FAME.user_ieee_addr)\",\"delete_all\":1}"
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr)
        if received != nil{
            print("SEND REQUEST SUCCESSED")
            
            if received.valueForKey("result") as! NSNumber == 0{
                
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    
                    self.dataSource.removeAllObjects()
                    self.tableView.reloadData()
                })
                
            }
        }
        
    }
    
    func deleteAll(sender:AnyObject!){
        
        print("清空了")
        //        let myThread = NSThread(target: self, selector: "Timerset_deleteAll", object: nil)
        //        myThread.start()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        //        let button = UIButton(frame: CGRectMake(0,0,80,35))
        //        button.setBackgroundImage(UIImage(named: "yuba_spinner_press.png"), forState: UIControlState.Normal)
        //        button.setBackgroundImage(UIImage(named: "curtain_04_10.png"), forState: UIControlState.Highlighted)
        //        button.setTitle("清空", forState: UIControlState.Normal)
        //        button.addTarget(self, action: Selector("deleteAll:"), forControlEvents: UIControlEvents.TouchUpInside)
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        
        
        createHeadView()
        initDateSource()
        
        initTable()
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "raload:", name: "msgChange", object: nil)
        
        
        
        
    }
    func createHeadView(){
        
        let view = UIView(frame: CGRectMake(0,64,WIDTH,44))
        let lable = UILabel(frame: CGRectMake(10,0,100,44))
        lable.textColor = UIColor.whiteColor()
        lable.text = "推送开启"
        lable.font = UIFont.systemFontOfSize(16)
        view.addSubview(lable)
        let switchOn = UISwitch(frame: CGRectMake(WIDTH - 80,6,80,20))
        //switchOn.transform = CGAffineTransformMakeScale(1.25, 0.75)
        switchOn.on = true
        switchOn.tag = 2
        //switchOn.onImage = UIImage(named: "split_right_1.png")
        switchOn.addTarget(self, action: Selector("switchClick:"), forControlEvents: UIControlEvents.ValueChanged)
        view.addSubview(switchOn)
        
        self.view.addSubview(view)
        
    }
    //    deinit {
    //        NSNotificationCenter.defaultCenter().removeObserver(self, name: "msgChange", object: nil)
    //        NSNotificationCenter.defaultCenter().removeObserver(self)
    //
    //    }
    
    func raload(notification:NSNotification){
        
        
        initDateSource()
        self.tableView.reloadData()
        
        
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
        
        print(FAME.defaults.valueForKey("\(FAME.user_name)1"))
        let stateOn = self.view.viewWithTag(2) as! UISwitch
        if (FAME.defaults.valueForKey("\(FAME.user_name)1") != nil){
            stateOn.on = FAME.defaults.valueForKey("\(FAME.user_name)1") as! Bool
            if !stateOn.on{
                //UIApplication.sharedApplication().unregisterForRemoteNotifications()
            }
        }
        
    }
    
}


extension ViewControllerMsg:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        //如果是展开状态
        if stateArray[section] as! String == "1"{
            let array = dataSource.objectAtIndex(section)
            
            return array.count
        }
        else{
            //如果是闭合，返回0
            return 0
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell")
        
        let cell : CallCell = tableView.dequeueReusableCellWithIdentifier("CallCell") as! CallCell
        
        let array : NSArray = dataSource[indexPath.section] as! NSArray
        
        let arr : NSDictionary = array[indexPath.row] as! NSDictionary
        cell.listLable.text = arr["info"] as? String
        
        
        //        let arr : NSArray = dataSource[indexPath.section] as! NSArray
        //        let str : String = arr[indexPath.row] as! String
        //
        //        cell.listLable.text = str
        
        
        cell.selectionStyle = UITableViewCellSelectionStyle.Default
        cell.contentView.backgroundColor = UIColor.clearColor()
        
        return cell
        
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section] as? String
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button : UIButton = UIButton(type: UIButtonType.Custom)
        button.frame = CGRect(x: 0, y: 0, width: WIDTH, height: 44)
        button.tag = section + 1
        
        button.backgroundColor = UIColor(red: 192/255, green: 192/255, blue: 192/255, alpha: 0.5)
        button.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 60)
        
        button.addTarget(self, action: Selector("buttonPress:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let imgView : UIImageView = UIImageView(frame: CGRect(x: 10, y: 11, width: 22, height: 22))
        imgView.image = UIImage(named: "ico_faq_d.png")
        button.addSubview(imgView)
        
        
        let _imgView : UIImageView = UIImageView(frame: CGRect(x: WIDTH - 30, y: 19, width: 10, height: 6))
        if stateArray[section] as! String == "0"{
            _imgView.image = UIImage(named: "ico_listdown.png")
        }
        else{
            _imgView.image = UIImage(named: "ico_listup.png")
        }
        button.addSubview(_imgView)
        
        let lable : UILabel = UILabel(frame:CGRect(x: 45, y: 11, width: 200, height: 20))
        lable.backgroundColor = UIColor.clearColor()
        lable.textColor = UIColor.whiteColor()
        lable.font = UIFont.systemFontOfSize(14)
        lable.text = sectionArray[section] as? String
        button.addSubview(lable)
        
        let imgView1 : UIImageView = UIImageView(frame: CGRect(x: 0, y: 43, width: WIDTH, height: 1))
        imgView1.image = UIImage(named: "line_real.png")
        button.addSubview(imgView1)
        
        
        return button
        
    }
    
    func buttonPress(sender:UIButton){
        //判断状态值
        if stateArray[sender.tag - 1] as! String == "1"{
            stateArray.replaceObjectAtIndex(sender.tag - 1, withObject: "0")
        }
        else{
            stateArray.replaceObjectAtIndex(sender.tag - 1, withObject: "1")
        }
        tableView.reloadSections(NSIndexSet(index: sender.tag - 1), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("选择了\(indexPath.section)行\(indexPath.row)列")
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let array : NSArray = dataSource[indexPath.section] as! NSArray
        
        let arr : NSDictionary = array[indexPath.row] as! NSDictionary
        let info = arr["info"] as? String
        
        let height = info?.stringHeihgtWidth(WIDTH - 180, width: 15)
        //print(height)
        if height > 10000.0{
            let counr = height!/10000 + 1
            return 40 * counr
        }
        else{
            return 44
        }
        
    }
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.00001
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        let array : NSArray = dataSource[indexPath.section] as! NSArray
        let arr : NSDictionary = array[indexPath.row] as! NSDictionary
        let id : String = arr["id"] as! String
        if Int(id) == 0{
            return false
        }
        else{
            return true
        }
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        
        let array : NSArray = dataSource[indexPath.section] as! NSArray
        let arr : NSDictionary = array[indexPath.row] as! NSDictionary
        let id : String = arr["id"] as! String
        index_ = indexPath
        FAME.delete_id = Int(id)
        let myThread = NSThread(target: self, selector: "Timerset_delete", object: nil)
        myThread.start()
        
        
        
        
    }
    func Timerset_delete(){
        let cmdStr = "{\"cmd\":50, \"user_name\": \"\(FAME.user_name)\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"ieee_addr\": \"\(FAME.user_ieee_addr)\",\"delete_all\":0,\"delete_ids\":[\(FAME.delete_id)]}"
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr)
        if received != nil{
            print("SEND REQUEST SUCCESSED")
            
            if received.valueForKey("result") as! NSNumber == 0{
                
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    let array : NSMutableArray = self.dataSource[self.index_.section] as! NSMutableArray
                    
                    
                    if array.count == 1{
                        array.removeObjectAtIndex(self.index_.row)
                        let dic :Dictionary = ["id":"0","info":"无报警记录"]
                        array.addObject(dic)
                    }
                    else{
                        array.removeObjectAtIndex(self.index_.row)
                    }
                    
                    self.tableView.reloadData()
                })
                
            }
        }
        
    }
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        
        return Defined_Delete
        
    }
    
    
}



//注：此方法用于计算文本高度，是个固定的语句，网上有很多方法可选，强烈注意:对于新手可能很多人会把这个扩展写类中，这样会报错，要写在类的外面才不会错（我就是犯了这种错）
extension String{
    func stringHeihgtWidth(fontSize:CGFloat,width:CGFloat)->CGFloat{
        let font = UIFont.systemFontOfSize(fontSize)
        let size = CGSizeMake(width,CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping
        let attributes = [NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy()]
        let text = self as NSString
        let rect = text.boundingRectWithSize(size,options: .UsesLineFragmentOrigin,attributes: attributes,context: nil)
        return rect.height
    }
}

