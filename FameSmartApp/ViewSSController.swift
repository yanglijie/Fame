//
//  ViewSSController.swift
//  FameSmartApp
//
//  Created by Eric on 14-8-12.
//  Copyright 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

//*********************
//
//   viewController of  sensors
//
//*********************


import UIKit
import AVFoundation
class ViewControllerSS: UIViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate,ViewControllerSS7air6Delegate,ViewControllerSS_nameDelegate {
    var BGView:UIView!
    var pickView:UIView!
    
    var pickView1:UIView!
    var pickView2:UIView!
    
    var showId:Int = 0
    var index:Int = 0
    
    var linkId:Int = 0
    var linkString:String!
    
    var viewSlider:UISlider!
    var picker:UIPickerView!
    var selecedCell:UITableViewCell2!
    var btnAdd:UIButton!
    var btnDe:UIButton!
    var timeLabel:UILabel!
    var timeLabel2:UILabel!
    var tmpStr:String!
    
    var Links1:Array<Dictionary<String,AnyObject>> = []
    var Links2 : Array<Dictionary<String,AnyObject>> = []
    var Links3 : Array<Dictionary<String,AnyObject>> = []
    
    var ieee:String! = ""

    
    
    
//    @IBAction func longPressFun(sender: UILongPressGestureRecognizer) {
//        /*
//        if sender.state == UIGestureRecognizerState.Began {
//        let point:CGPoint = sender.locationInView(self.tabelVeiw)
//        let indexPath:NSIndexPath! = self.tabelVeiw.indexPathForRowAtPoint(point)
//        if(indexPath != nil){
//        let cell:UITableViewCell2! = self.tabelVeiw.cellForRowAtIndexPath(indexPath) as UITableViewCell2
//        println(cell.dev_id)
//        
//        }
//        }
//        */
//    }
    
    var ids = 0
    var id1 = -2
    var id2 = 1
    
    
    
    
    
    var act = 0
    var seletedStr1:String! = ""
    var seletedStr2:String! = ""
    var seletedStr3:String! = ""
    var seletedBtn :UIButtonIndex2!
    
    var sensors:Array<Dictionary<String,String>> = []
    
    //代理
    func showMessage(){
        FAME.showMessage("门限设置成功");
    }
    func reloadName() {
        FAME.showMessage("名字修改成功");
//        let subCell:AnyObject = self.tabelVeiw.visibleCells[index]
//            //print(subCell)
//        let cell = subCell as! UITableViewCell2
//        let name = cell.viewWithTag(2) as! UILabel
//        name.text = FAME.dev_ss_Rname + FAME.dev_ss_name
        
        refreshData()
        tabelVeiw.reloadData()

    }
    @IBAction func tap(sender : UISwitch2) {
        print(sender.on)
        
        //var act_id = sender.act_id
        let id = sender.dev_id * 10 + FAME.tempSensorId
//        let subCell:AnyObject = self.tabelVeiw.visibleCells[sender.index])
//        let cell = subCell as! UITableViewCell2
//        let view = cell.viewWithTag(1) as! UIImageView
        let view = sender.superview?.viewWithTag(1) as! UIImageView
        if sender.on {
            FAME.sensorsCellState["\(id)"] = 1
            view.image = UIImage(named: Defined_SS_icons1[FAME.tempSensorId])
            httpRequert().sendRequest(sender.act_id)
            
        }else{
            FAME.sensorsCellState["\(id)"] = 0
            view.image = UIImage(named: Defined_SS_icons[FAME.tempSensorId])
            httpRequert().sendRequest(sender.act_id + 1)
            
        }
        print(FAME.sensorsCellState)
    }
    
    

    
    @IBOutlet var tabelVeiw : UITableView!
    
    func refreshData(){
        switch FAME.tempSensorId {
        case 1:
            self.sensors = FAME.sensors23
        case 2:
            self.sensors = FAME.sensors24
        case 3:
            self.sensors = FAME.sensors26
        case 4:
            self.sensors = FAME.sensors25
        case 5:
            self.sensors = FAME.sensors28
        case 8:
            self.sensors = FAME.sensors47
        case 7:
            self.sensors = FAME.sensors32
        default:
            break
        }
    }
    func refreshLights(){
        print("refreshLights")
        //self.TableView!.reloadData()
        let myThread = NSThread(target: self, selector: "Timerset2", object: nil)
        myThread.start()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.automaticallyAdjustsScrollViewInsets = false ;
        
        
        self.refreshData()

        if self.sensors.count == 0 {
            
            let textLabel = UILabel (frame:CGRectMake(self.view.frame.size.width/8,view.frame.size.height/10,self.view.frame.size.width*3/4,view.frame.size.height*4/5))
            textLabel.text = Defined_Tips_none
            
            //textLabel.backgroundColor = UIColor.blackColor()
            textLabel.textColor = UIColor.whiteColor()
            textLabel.textAlignment = NSTextAlignment.Center
            textLabel.numberOfLines = 0;
            textLabel.font = UIFont.systemFontOfSize(25)
            self.view.addSubview(textLabel)
            
        
        }
        else {
            tabelVeiw.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshLights")
            tabelVeiw.mj_header.beginRefreshing()
        }
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshLights:")
//        self.navigationItem.rightBarButtonItem = addButton
        
        
        self.createPop()
        
        
        
        self.Links1 = []

        if FAME.Links.count > 0 {
            
            for obj:Dictionary<String,AnyObject> in FAME.Links   {
                if (obj["show"] as! Int) != 2 {
                    self.Links1.append(obj)

                }
            }
            
            
            
            let links:Array<Dictionary<String,AnyObject>>! = self.Links1[0]["sub"] as! Array<Dictionary<String,AnyObject>>!
            if links != nil {
                self.Links2 = links
            }else{
                self.Links2 = [["name":"","act_id":0]]
            }
            
            self.Links3 = [["name":Defined_mode_on,"act_id":1],["name":Defined_mode_off,"act_id":0]]
            
            self.seletedStr1 = self.Links1[0]["name"] as! String!
            self.seletedStr2 = self.Links2[0]["name"] as! String!
            self.seletedStr3 = self.Links3[0]["name"] as! String!

        }
        
        
        
    }
    
    func Timerset(){
        //let event_id = FAME.tempSensorId
        let dev_id = Int(self.seletedBtn.dev_id)
        let action_id = self.ids
        var alarm_value = 1
        
        var e_id = (dev_id - 85) * 3 + 1
        if self.showId == 0{
            alarm_value = 1
            e_id = (dev_id - 85) * 3 + 1
        }else{
            alarm_value = 0
            e_id = (dev_id - 85) * 3 + 3
        }
        
        
        
        
        
        if FAME.link_id == 0 {
            let cmdStr = "{\"cmd\": 33, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"event_id\":\(e_id),\"filter_data\":[\(dev_id),11,17,\(alarm_value)],\"action_id\":\(action_id),\"active\":0}}"
            if (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90) != nil){
                print("link device successed")
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alert = UIAlertView()
                    alert.title = Defined_link_title1
                    alert.message =  Defined_link_update
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()

                })
                }
            else{
                print("link event failed")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alert = UIAlertView()
                    alert.title = Defined_link_title1
                    alert.message =  Defined_link_update
                    alert.addButtonWithTitle(Defined_ALERT_CANCEL)
                    alert.show()
                    
                })
            }
        }
        else{
            //print("6666666alarm_value=\(alarm_value)")
            let cmdStr = "{\"cmd\": 33, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"event_id\":\(e_id),\"filter_data\":[\(dev_id),11,17,\(alarm_value)],\"action_id\":\(action_id),\"active\":1}}"
            if  (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90) != nil){
                print("link device1 successed")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    let alert = UIAlertView()
                    alert.title = Defined_link_title
                    alert.message =  Defined_link_update
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()
                    
                })
                
            }else{
                
                print("link event failed")
            }
        }
    }
    
    func tapPress(sender:AnyObject!){
        self.hidePop()
    }
    
    func createPop(){
        
        self.BGView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.width, height: self.view.frame.height))
        self.BGView.backgroundColor = UIColor.clearColor()
        self.BGView.tag = 500
        
        
        //cancel
        
        let longPressRec = UITapGestureRecognizer()
        longPressRec.addTarget(self, action: "tapPress:")
        
        self.BGView.addGestureRecognizer(longPressRec)
        
        self.BGView.userInteractionEnabled = true
        
        
        
        
        self.pickView = UIView(frame: CGRect(x: 0, y: self.view.frame.height + 5 , width: self.view.frame.width, height: 300))
        self.pickView.backgroundColor = UIColor.whiteColor()
        
        self.pickView1 = UIView(frame: CGRect(x: 0, y: 0 , width: self.pickView.frame.width, height: self.pickView.frame.height ))
        self.pickView1.backgroundColor = UIColor.clearColor()
        
        self.pickView2 = UIView(frame: CGRect(x: self.pickView.frame.width, y: 0 , width: self.pickView.frame.width, height: self.pickView.frame.height ))
        self.pickView2.backgroundColor = UIColor.clearColor()
        
        
        //btns
        let btnX:CGFloat = 30
        let btnWidth:CGFloat = self.view.frame.width - btnX * 2
        let btnHeight:CGFloat = 30
        let btnY:CGFloat = 25
        
        if FAME.tempSensorId == 4 || FAME.tempSensorId == 3 || FAME.tempSensorId == 5 || FAME.tempSensorId == 8{
            
            let btnS1 = UIButton(frame: CGRect(x: btnX, y: btnY + 25, width: btnWidth, height: btnHeight))
            btnS1.setTitle(Defined_SS_air_Title1, forState: UIControlState.Normal)
            btnS1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            //btnS1.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS1.tag = 1
            btnS1.addTarget(self, action: Selector("btns71Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            let btnS2 = UIButton(frame: CGRect(x: btnX, y: btnY + 75, width: btnWidth, height: btnHeight))
            btnS2.setTitle(Defined_SS_air_Title2, forState: UIControlState.Normal)
            btnS2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btnS2.tag = 2
            //btnS2.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS2.addTarget(self, action: Selector("btns72Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            let btnS3 = UIButton(frame: CGRect(x: btnX, y: btnY + 125, width: btnWidth, height: btnHeight))
            btnS3.setTitle(Defined_SS_air_Title3, forState: UIControlState.Normal)
            btnS3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            //btnS3.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS3.tag = 3
            btnS3.addTarget(self, action: Selector("btns1Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.pickView1.addSubview(btnS1)
            self.pickView1.addSubview(btnS2)
            self.pickView1.addSubview(btnS3)
            
        }

        
        else if FAME.tempSensorId == 7{
            let btnS1 = UIButton(frame: CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight))
            btnS1.setTitle(Defined_SS_air_Title1, forState: UIControlState.Normal)
            btnS1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            //btnS1.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS1.tag = 1
            btnS1.addTarget(self, action: Selector("btns71Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            let btnS2 = UIButton(frame: CGRect(x: btnX, y: btnY + 40, width: btnWidth, height: btnHeight))
            btnS2.setTitle(Defined_SS_air_Title2, forState: UIControlState.Normal)
            btnS2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btnS2.tag = 2
            //btnS2.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS2.addTarget(self, action: Selector("btns72Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            let btnS3 = UIButton(frame: CGRect(x: btnX, y: btnY + 80, width: btnWidth, height: btnHeight))
            btnS3.setTitle(Defined_SS_air_Title3, forState: UIControlState.Normal)
            btnS3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            //btnS3.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS3.tag = 3
            btnS3.addTarget(self, action: Selector("btns1Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            let btnS4 = UIButton(frame: CGRect(x: btnX, y: btnY + 120, width: btnWidth, height: btnHeight))
            btnS4.setTitle(Defined_SS_air_Title4, forState: UIControlState.Normal)
            btnS4.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            //btnS3.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS4.tag = 4
            btnS4.addTarget(self, action: Selector("btns74Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            let btnS5 = UIButton(frame: CGRect(x: btnX, y: btnY + 160, width: btnWidth, height: btnHeight))
            btnS5.setTitle(Defined_SS_air_Title5, forState: UIControlState.Normal)
            btnS5.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            //btnS3.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS5.tag = 5
            btnS5.addTarget(self, action: Selector("btns75Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            self.pickView1.addSubview(btnS1)
            self.pickView1.addSubview(btnS2)
            self.pickView1.addSubview(btnS3)
            self.pickView1.addSubview(btnS4)
            self.pickView1.addSubview(btnS5)

        }
        else{
            let btnS1 = UIButton(frame: CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight))
            btnS1.setTitle(Defined_SS_Title1, forState: UIControlState.Normal)
            btnS1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            //btnS1.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS1.tag = 1
            btnS1.addTarget(self, action: Selector("btns1Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            let btnS2 = UIButton(frame: CGRect(x: btnX, y: btnY + 40, width: btnWidth, height: btnHeight))
            btnS2.setTitle(Defined_SS_Title2, forState: UIControlState.Normal)
            btnS2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btnS2.tag = 2
            //btnS2.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS2.addTarget(self, action: Selector("btns2Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            let btnS3 = UIButton(frame: CGRect(x: btnX, y: btnY + 80, width: btnWidth, height: btnHeight))
            btnS3.setTitle(Defined_SS_Title3, forState: UIControlState.Normal)
            btnS3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            //btnS3.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS3.tag = 3
            btnS3.addTarget(self, action: Selector("btns3Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            let btnS4 = UIButton(frame: CGRect(x: btnX, y: btnY + 120, width: btnWidth, height: btnHeight))
            btnS4.setTitle(Defined_SS_air_Title1, forState: UIControlState.Normal)
            btnS4.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            //btnS3.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS4.tag = 4
            btnS4.addTarget(self, action: Selector("btns71Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            let btnS5 = UIButton(frame: CGRect(x: btnX, y: btnY + 160, width: btnWidth, height: btnHeight))
            btnS5.setTitle(Defined_SS_air_Title2, forState: UIControlState.Normal)
            btnS5.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btnS5.tag = 5
            //btnS2.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
            btnS5.addTarget(self, action: Selector("btns72Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            self.pickView1.addSubview(btnS1)
            self.pickView1.addSubview(btnS2)
            self.pickView1.addSubview(btnS3)
            self.pickView1.addSubview(btnS4)
            self.pickView1.addSubview(btnS5)

        }
        //picker
        
        
        
        let btn = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: 20, width: 40, height: 20))
        btn.setTitle("\(Defined_ALERT_OK)", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.tag = 1
        btn.addTarget(self, action: Selector("selectedActBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let btn2 = UIButton(frame: CGRect(x: 20, y: 20, width: 40, height: 20))
        btn2.setTitle(Defined_ALERT_CANCEL, forState: UIControlState.Normal)
        btn2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn2.tag = 2
        btn2.addTarget(self, action: Selector("cancleActBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let lable = UILabel(frame: CGRect(x: 60, y: 20, width: pickView.frame.width - 120, height: 20))

        lable.text = ""
        //lable.hidden = true
        lable.textAlignment = .Center
        lable.tag = 400
        self.pickView2.addSubview(lable)
        
        self.picker = UIPickerView(frame: CGRect(x: 20, y: 40, width: pickView.frame.width - 40 , height: 230))
        
        self.picker.dataSource = self
        self.picker.delegate = self
        
        
        
        //Slider
        self.viewSlider = UISlider(frame: CGRect(x: 20, y: 45, width: self.pickView.frame.width - 40 , height: 50))
        self.viewSlider.minimumValue = 1
        self.viewSlider.maximumValue = 254
        self.viewSlider.value = 5
        self.viewSlider.addTarget(self, action: "sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.btnAdd = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: 100, width: 40, height: 40))
        self.btnAdd.setTitle("+", forState: UIControlState.Normal)
        self.btnAdd.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.btnAdd.tag = 1
        self.btnAdd.addTarget(self, action: Selector("actAddBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.btnDe = UIButton(frame: CGRect(x:  20, y: 100, width: 40, height: 40))
        self.btnDe.setTitle("-", forState: UIControlState.Normal)
        self.btnDe.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.btnDe.tag = 1
        self.btnDe.addTarget(self, action: Selector("actDeBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        self.timeLabel = UILabel(frame:CGRect(x: 20, y: 100, width: self.pickView.frame.width / 2 - 25, height: 50))
        self.timeLabel.textAlignment = NSTextAlignment.Right
        self.timeLabel.text = "1"
        
        self.timeLabel2 = UILabel(frame:CGRect(x: self.pickView.frame.width / 2, y: 100, width: self.pickView.frame.width / 2 - 20, height: 50))
        self.timeLabel2.textAlignment = NSTextAlignment.Left
        self.timeLabel2.text = "min"
        
        
        
        self.pickView.addSubview(self.pickView1)
        self.pickView.addSubview(self.pickView2)
        
        
        
        
        self.pickView2.addSubview(self.picker)
        self.pickView2.addSubview(btn)
        self.pickView2.addSubview(btn2)
        self.pickView2.addSubview(self.viewSlider)
        self.pickView2.addSubview(self.btnAdd)
        self.pickView2.addSubview(self.btnDe)
        self.pickView2.addSubview(self.timeLabel)
        self.pickView2.addSubview(self.timeLabel2)
        
        self.pickView.tag = 501
        self.pickView.alpha = 0.95
        self.BGView.hidden = true
        self.pickView.hidden = true
        self.view.addSubview(self.BGView)
        self.view.addSubview(self.pickView)
    }
    
    func showVIew2(){

        
        if self.showId == 2 {
            self.picker.hidden = true
            self.btnAdd.hidden = false
            self.btnDe.hidden = false
            self.timeLabel.hidden = false
            self.timeLabel2.hidden = false
            self.viewSlider.hidden = false
            
            
        }
        else{
            
            self.picker.hidden = false
            self.viewSlider.hidden = true
            self.btnAdd.hidden = true
            self.btnDe.hidden = true
            self.timeLabel.hidden = true
            self.timeLabel2.hidden = true
        }
        
        
        UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
            self.pickView1.frame = CGRect(x: 0 - self.view.frame.width, y: self.pickView1.frame.origin.y , width: self.view.frame.width, height: self.pickView1.frame.height)
            
            self.pickView2.frame = CGRect(x: 0, y: self.pickView2.frame.origin.y , width: self.view.frame.width, height: self.pickView2.frame.height)
            
            }, completion: nil)
        
        
        let myThread1 = NSThread(target: self, selector: "linkShow", object: nil)
        myThread1.start()
        
        
    }
    //设置联动
    func btns1Fun(sender:UIButton){
        self.showId = 0
        FAME.link_id = 1
        self.showVIew2()
        
    }
    //恢复后的联动
    func btns74Fun(sender:UIButton){
        self.showId = 1
        FAME.link_id = 1
        self.showVIew2()
    }
    //设置延时联动
    func btns2Fun(sender:UIButton){
        self.showId = 1
        FAME.link_id = 1
        self.showVIew2()
    }
    //设置延时时间
    func btns3Fun(sender:UIButton){
        self.showId = 2
        self.showVIew2()
    }
    //取消
    func btns4Fun(sender:UIButton){
        self.hidePop()
    }
    //修改名字
    func btns71Fun(sender:UIButton){
        self.hidePop()
        
        let next = GBoard.instantiateViewControllerWithIdentifier("viewSS_name") as! ViewControllerSS_name
        next.delegate = self ;
        
        self.navigationController?.pushViewController(next, animated: true)
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
    }
    //删除设备
    func btns72Fun(sender:UIButton){
        self.hidePop()
        let alertController = UIAlertController(title: "友情提示", message: "请输入密码删除该设备", preferredStyle: UIAlertControllerStyle.Alert);
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .Default,
            handler: {
                action in
                //也可以用下标的形式获取textField let login = alertController.textFields![0]
                let login = alertController.textFields!.first! as UITextField
                print("用户名：\(login.text)")

                if login.text! == "\(FAME.user_name)34637169"
                {
                    
                    FAME.delDeviceByIeee(self.ieee)
                    
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                }
                else{
                    FAME.showMessage("输入的密码不正确")
                }
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    
    
    //修改门限值
    func btns75Fun(sender:UIButton){
        self.hidePop()
        let next = GBoard.instantiateViewControllerWithIdentifier("viewSS_air6") as! ViewControllerSS7air6
        next.delegate = self ;
        self.navigationController?.pushViewController(next, animated: true)
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
    }
    
    
    
    func actAddBtn(sender:UIButton){
        
        self.viewSlider.setValue(self.viewSlider.value + 1 , animated: true)
        let int:Int = Int(self.viewSlider.value)
        self.timeLabel.text = "\(int)"
        
    }
    
    func actDeBtn(sender:UIButton){
        
        self.viewSlider.setValue(self.viewSlider.value - 1 , animated: true)
        let int:Int = Int(self.viewSlider.value)
        self.timeLabel.text = "\(int)"
    }
    
    func sliderChanged(sender:UISlider){
        print(sender.value)
        let int:Int = Int(self.viewSlider.value)
        self.timeLabel.text = "\(int)"
        
    }
    
    func showPop(){
        self.pickView2.frame.origin.x = self.view.frame.width
        
        self.pickView1.frame.origin.x = 0
        
        self.pickView.hidden = false
        self.BGView.hidden = false
        let newFrame = CGRect(x: 0, y: self.view.frame.height - 240 , width: self.view.frame.width, height: 240)
        UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
            self.pickView.frame = newFrame
            }, completion: nil)
        
    }
    func hidePop() {
        let newFrame = CGRect(x: 0, y: self.view.frame.height + 5 , width: self.view.frame.width, height: 240)
        UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
            self.pickView.frame = newFrame
            }, completion: {
                (finished:Bool) -> Void in
                self.pickView.hidden = true
                self.BGView.hidden = true
                
        })
        self.linkString = ""
    }
    
    func privateCmd(){
        if (httpRequert().downloadFromPostUrlSync(Surl,cmd: self.tmpStr,timeout:8) != nil){
            print("delay-set successed")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let alert = UIAlertView()
                alert.title = Defined_delay_title
                alert.message =  Defined_delay_update
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            })
            
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let alert = UIAlertView()
                alert.title = Defined_delay_title
                alert.message =  Defined_delay_failed
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            })
        }
    }
    
    func selectedActBtn(sender : AnyObject){
        
        if self.showId == 2 {
            
            let int:Int = Int(self.viewSlider.value)
            print(self.seletedBtn)
            
            self.tmpStr = "{\"cmd\": 37, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"operation\":0,\"dev_id\":\(self.seletedBtn.dev_id),\"delay_time\":\(int)}}"
            
            let myThread = NSThread(target: self, selector: "privateCmd", object: nil)
            myThread.start()
            
            
            self.hidePop()
        }
      else{
            print("selectedActBtn")
            if self.id1 < 0 {
                linkString = ""
                self.ids = -1
            }
            else{
                print("\(self.seletedStr1)  \(self.seletedStr2) \(self.seletedStr3)")
                linkString = self.seletedStr1 + self.seletedStr2 + " " + self.seletedStr3
                
                
                self.ids = self.id1 + self.id2
                
            }
            
            self.hidePop()
            let myThread = NSThread(target: self, selector: "Timerset", object: nil)
            myThread.start()
        }
        
        

        
    }
    
    func cancleActBtn( sender : AnyObject){
        
        print("cancleActBtn")
        //roomSheet.dismissWithClickedButtonIndex(1, animated: true)
        
        self.hidePop()
    }
    @IBAction func showSheet(sender : UIButtonIndex2) {
        self.seletedBtn = sender
        index = sender.index ;

        self.ieee = self.sensors[index]["ieee"] as String!
        FAME.dev_id = sender.dev_id

        
        FAME.dev_ss_name = self.sensors[index]["name1"] as String!
        FAME.dev_ss_Rname = self.sensors[index]["roomName"] as String!
        

        
        self.showPop()
        
        
        
        
    }
    
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
//        
//        print("pickerView selected:\(row)")
//        if component == 0 {
//            self.seletedStr1 = self.Links1[row]["name"] as! String!
//            
//            
//            
//            let links = self.Links1[row]["sub"] as! Array<Dictionary<String,AnyObject>>!
//            if links != nil {
//                self.Links2 = links
//                
//            }else{
//                self.Links2 = [["name":"","act_id":-2]]
//            }
//            
//            if self.Links2.count > 1 {
//                
//            }else if self.Links2.count == 1{
//                if let act_id :Int! = self.Links2[0]["act_id"] as! Int!{
//                    self.id1 = act_id
//                }
//                self.seletedStr2 = self.Links2[0]["name"] as! String!
//            }else{
//                self.id1 = 0
//                self.seletedStr2 = ""
//            }
//            
//            pickerView.reloadComponent(1)
//            pickerView.reloadComponent(2)
//            pickerView.selectRow(0, inComponent: 1, animated: false)
//            pickerView.selectRow(0, inComponent: 2, animated: false)
//            
//            if let act_id :Int! = self.Links2[0]["act_id"] as! Int!{
//                self.id1 = act_id
//            }
//            self.seletedStr2 = self.Links2[0]["name"] as! String!
//            
//            self.seletedStr3 = Defined_mode_on
//            self.id2 = 0
//            
//        }else  if component == 1 {
//            
//            if let act_id :Int! = self.Links2[row]["act_id"] as! Int!{
//                self.id1 = act_id
//            }
//            self.seletedStr2 = self.Links2[row]["name"] as! String!
//            
//        }else{
//            if row == 0 {
//                self.seletedStr3 = Defined_mode_on
//                self.id2 = 0
//            }else{
//                self.id2 = 1
//                self.seletedStr3 = Defined_mode_off
//            }
//        }
//
//        print("\(self.id1 + self.id2)")
//        
//    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        print("pickerView selected:\(row)")
        if component == 0 {
            self.seletedStr1 = self.Links1[row]["name"] as! String!
            
            
            
            let links = self.Links1[row]["sub"] as! Array<Dictionary<String,AnyObject>>!
            if links != nil {
                self.Links2 = links
                
                
                //if appls
                let dev_type = self.Links1[row]["dev_type"] as! Int!
                if(dev_type != nil){
                    print("!!!!!!!!!!!APPPP!!!!!!!!!")
                    
                    self.Links3 = []
                    var btns_str = []
                    switch (dev_type){
                    case 16:
                        btns_str = Defined_appl_16
                    case 17:
                        btns_str = Defined_appl_17
                    case 18:
                        btns_str = Defined_appl_18
                    case 19:
                        btns_str = Defined_appl_19
                    case 20:
                        btns_str = Defined_appl_20
                    case 21:
                        btns_str = Defined_appl_21
                    default:
                        btns_str = Defined_appl_16
                    }
                    var inid = 0
                    for(btn_str) in btns_str{
                        self.Links3.append(["name":btn_str,"act_id":inid * 2 + 1])
                        inid++
                    }
                    
                    
                }else{
                    
                    let show = self.Links1[row]["show"] as! Int!
                    //let cur = self.Links1[row]["curtains"] as! Int!
                    
                    if(show == 4){
                        self.Links3 = [["name":"打开","act_id":0],["name":"停止","act_id":1],["name":"暂停","act_id":2]]
                    }
                    else if(show == 2){
                        self.Links3 = [["name":"布防","act_id":0],["name":"撒防","act_id":1]]
                    }
                    else if(show == 0){
                        self.Links3 = [["name":"","act_id":0]]
                    }
                    else{
                        self.Links3 = [["name":Defined_mode_on,"act_id":1],["name":Defined_mode_off,"act_id":0]]
                    }
                }
                
            }else{
                
                self.Links2 = [["name":"","act_id":-2]]
            }
            
            if self.Links2.count > 1 {
                
            }else if self.Links2.count == 1{
                
                
                
                if let act_id :Int! = self.Links2[0]["act_id"] as! Int!{
                    self.id1 = act_id
                }
                self.seletedStr2 = self.Links2[0]["name"] as! String!
            }else{
                self.id1 = 0
                self.seletedStr2 = ""
            }
            
            pickerView.reloadComponent(1)
            pickerView.reloadComponent(2)
            pickerView.selectRow(0, inComponent: 1, animated: false)
            pickerView.selectRow(0, inComponent: 2, animated: false)
            
            if let act_id :Int! = self.Links2[0]["act_id"] as! Int!{
                self.id1 = act_id
            }
            self.seletedStr2 = self.Links2[0]["name"] as! String!
            
            self.seletedStr3 = self.Links3[0]["name"] as! String!
            
            if let act_id2 :Int! = self.Links3[0]["act_id"] as! Int!{
                self.id2 = act_id2
            }
            
        }else if component == 1 {
            
            if let act_id :Int! = self.Links2[row]["act_id"] as! Int!{
                self.id1 = act_id
            }
            self.seletedStr2 = self.Links2[row]["name"] as! String!
            
        }else{
            self.seletedStr3 = self.Links3[row]["name"] as! String!
            
            if let act_id2 :Int! = self.Links3[row]["act_id"] as! Int!{
                self.id2 = act_id2
            }
        }
        
        print(self.id1 + self.id2)
    }

    
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        
        return 3
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        //var objRooms :NSArray = FAME.device_table.valueForKey("rooms") as NSArray
        if component == 0 {
            return self.Links1.count
        }else if component == 1{
            
            return self.Links2.count
        }else{
            return self.Links3.count
        }
        
    }
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        let width = self.view.frame.size.width
        if component == 0 {
            return width * 0.4
        }else if component == 0{
            return width * 0.4
        }else{
            return width * 0.2
        }
    }
    
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
//        
//        
//        if component == 0 {
//            
//            //return FAME.linkMoled[row]["name"]
//
//            return self.Links1[row]["name"] as! String!
//        }else if component == 1{
//            //let obj = self.Links1[row]
//            return self.Links2[row]["name"] as! String!
//        }else{
//            
//            if pickerView.selectedRowInComponent(0) == 0 {
//                return ""
//            }else{
//                
//                if row == 0{
//                    
//                    return Defined_mode_on
//                }else{
//                    return Defined_mode_off
//                }
//            }
//        }
//    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        if component == 0 {
            
            //return FAME.linkMoled[row]["name"]
            return self.Links1[row]["name"] as! String!
        }else if component == 1{
            //let obj = self.Links1[row]
            return self.Links2[row]["name"] as! String!
        }else{
            if pickerView.selectedRowInComponent(0) == 0 {
                return ""
            }
            else{
                return self.Links3[row]["name"] as! String!
            }
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView{
        var viewLable :UILabel!
        if !(viewLable != nil){
            viewLable=UILabel()
            viewLable.adjustsFontSizeToFitWidth = true
            viewLable.font = UIFont.systemFontOfSize(12)
        }
        //return String(objRooms[row] as NSString)
        viewLable.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)
        
        return viewLable
        
    }
    func linkShow(){
        
        let dev_id = Int(self.seletedBtn.dev_id)
        //let action_id = self.ids
        
        var e_id = (dev_id - 85) * 3 + 1
        if self.showId == 0{
            
            e_id = (dev_id - 85) * 3 + 1
            
        }else{
            
            e_id = (dev_id - 85) * 3 + 3
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let cmdStr = "{\"cmd\": 34, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"event_id\":\(e_id)}}"
            
            if let received = (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90)){
                //if received.valueForKey("result") as! UInt == 0{
                    
                    var linkid:Int!
                    linkid = received.valueForKey("detail")?.valueForKey("action_id") as! Int
//                    if linkid <= 0{
//                        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
//                            let lable = self.view.viewWithTag(400) as! UILabel
//                            lable.text = ""
//                        })
//                    }
                
                    if (FAME.idForNamesMode[linkid] != nil) {
                        self.linkString = FAME.idForNamesMode[linkid]
                        print(self.linkString)
                        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                            let lable = self.view.viewWithTag(400) as! UILabel
                            lable.text = FAME.idForNamesMode[linkid]
                         })
                    }
                    else {
                        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                            let lable = self.view.viewWithTag(400) as! UILabel
                            lable.text = ""
                        })
                    }
                    
                //}
                
            }

            
            
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        
        FAME.tempTableView = self.tabelVeiw
        
        
        
        
//        let myThread = NSThread(target: self, selector: "Timerset2", object: nil)
//        myThread.start()
        
        
    }
//    func alarmK(){
//        // \(FAME.user_did)
//        let cmdStr = "{\"cmd\": 39, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": 108}"
//        if  (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90) != nil){
//            print("link device successed")
//            
//           
//            
//        }
//        
//    }
    func Timerset2(){
        
        let paramArray = NSMutableArray()
        var lastId = "0"
        
        for value in self.sensors {
            let AddedObj = value as NSDictionary
            let dev_id:NSString! = AddedObj["dev_id"] as! NSString
            if lastId != dev_id {
                paramArray.addObject(dev_id)
                lastId = dev_id as String
            }
        }
        
        let param = paramArray.componentsJoinedByString(",")
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 19, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": [\(param)]}",timeout : 60)
            
            if (received != nil){
                
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                
                self.tabelVeiw.mj_header.endRefreshing()
                //FAME.showMessage("刷新成功")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    
                    //got the state
                    for values:AnyObject in received.valueForKey("states") as! NSArray {
                        print(values)
                        let AddedObj = values as! NSDictionary
                        let ADDieee_addr :Int!  = AddedObj.valueForKey("id") as! Int
                        let ADDflag :Int!  = AddedObj.valueForKey("state") as! Int
                        //let nameFlag :String?  = AddedObj.valueForKey("name") as! String
                        var id = ADDieee_addr * 10
                        
                        
                        if ADDflag >= 1 {
                            id = ADDieee_addr * 10  + FAME.tempSensorId
                            FAME.sensorsCellState["\(id)"] = 1
                        }else{
                            id = ADDieee_addr * 10 + FAME.tempSensorId
                            FAME.sensorsCellState["\(id)"] = 0
                        }
                        
                    }
                    //set the state
                    
                    for subCell:AnyObject in self.tabelVeiw.visibleCells {
                        //print(subCell)
                        let cell = subCell as! UITableViewCell2
                        let view = cell.viewWithTag(3) as! UISwitch2!
                        let view1 = cell.viewWithTag(1) as! UIImageView
                        let state :Int! = FAME.sensorsCellState["\(cell.id)"]
                        print("cell.id  \(cell.id)")
                        if (state != nil) {
                            print("state:\(state)")
                            if state == 1 {
                                view.on = true
                                view1.image = UIImage(named: Defined_SS_icons1[FAME.tempSensorId])
                                //                        let myThread = NSThread(target: self, selector: "alarmK", object: nil)
                                //                        myThread.start()
                            }else {
                                view.on = false
                                view1.image = UIImage(named: Defined_SS_icons[FAME.tempSensorId])
                            }
                        }
                        else{
                            view.on = false
                            view1.image = UIImage(named: Defined_SS_icons[FAME.tempSensorId])
                        }
                    }
    
                    
                })
                
            }
            else{
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                self.tabelVeiw.mj_header.endRefreshing()
                FAME.showMessage("刷新失败，网络超时 请检查中控")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                })
                print("get the state failed")
            }

            
        }
        
    }
   
    override func viewWillDisappear(animated: Bool){
        super.viewWillDisappear(animated)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.tabelVeiw.setEditing(false, animated: false)
    }
   
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        self.refreshData()
        return self.sensors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        tableView
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell2
        //cell.backgroundColor = UIColor.clearColor()
        if FAME.tempSensorId == 7{
            cell.selectionStyle = UITableViewCellSelectionStyle.Gray
        }
        else{
            cell.selectionStyle = UITableViewCellSelectionStyle.None
        }
        //print(self.sensors)
        let dev_Str:String! = self.sensors[indexPath.row]["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)
        //FAME.dev_id = dev_id
        
        cell.dev_id = dev_id
        
        cell.id = dev_id * 10 + FAME.tempSensorId
        //name
        let name = cell.viewWithTag(2) as! UILabel
 
        let name_Str:String! = self.sensors[indexPath.row]["name1"] as String!
        let roomName_Str:String! = self.sensors[indexPath.row]["roomName"] as String!
//        FAME.dev_ss_name = name_Str
//        FAME.dev_ss_Rname = roomName_Str
        name.text = roomName_Str + name_Str ;
      
        //icon
        
        let view = cell.viewWithTag(1) as! UIImageView
        
        
        //Switch
        let tag = cell.viewWithTag(3) as! UISwitch2!
        let act_Str:String! = self.sensors[indexPath.row]["act_id"] as String!
        let state :Int! = FAME.sensorsCellState["\(cell.id)"]
        if (state != nil) {
            print("id:\(cell.id) state:\(state)")
            if state == 1 {
                tag.on = true
                view.image = UIImage(named: Defined_SS_icons1[FAME.tempSensorId])
            }else {
                tag.on = false
                view.image = UIImage(named: Defined_SS_icons[FAME.tempSensorId])
            }
        }
        else{
            view.image = UIImage(named: Defined_SS_icons[FAME.tempSensorId])
        }
        let act_id:Int! = Int(act_Str)
        tag.act_id = act_id
        tag.dev_id = dev_id
        tag.id = cell.id
        
        //button
        
        let linkBtn = cell.viewWithTag(4) as! UIButtonIndex2!
        linkBtn.index = indexPath.row
        linkBtn.act_id = act_id
        linkBtn.dev_id = dev_id
        print("linkBtn.Dev_id:\(linkBtn.dev_id)")
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
        
    }


    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        print(indexPath)
        self.performSelector("deselect", withObject: nil, afterDelay: 0.5)
        switch FAME.tempSensorId {
        case 7:
            let showId = self.sensors[indexPath.row]
            let next = GBoard.instantiateViewControllerWithIdentifier("viewSS7Details") as UIViewController
            //next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
            next.title=showId["name"]
            let dev_Str:String! = showId["dev_id"] as String!
            FAME.dev_id = Int(dev_Str)
            self.navigationController?.pushViewController(next, animated: true)
            let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
            self.navigationItem.backBarButtonItem = item;
        default:
            break
        }

//        let next = GBoard.instantiateViewControllerWithIdentifier("viewCell") as UIViewController
//        //next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
//        
//        self.navigationController?.pushViewController(next, animated: true)
    }

    
    func deselect(){
        if (tabelVeiw.indexPathForSelectedRow != nil){
            tabelVeiw.deselectRowAtIndexPath(tabelVeiw.indexPathForSelectedRow!, animated: true)
        }
        
    }
    
    //*****DELETE
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        print(self.sensors[indexPath.row]["ieee"])
        let ieee : String! = self.sensors[indexPath.row]["ieee"]
        
        let dic:NSMutableDictionary = ["hvaddr":"\(ieee)"]
        
        FAME.delDeviceArray.removeAllObjects()
        FAME.delDeviceArray.addObject(dic)
        
        FAME.doDeleteDev()
        
        
        tableView.reloadData()
        
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        
        return Defined_Delete
        
    }
    
    
    
    
}


extension String
{
    
    func substringWithRange(start: Int, end: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if end < 0 || end > self.characters.count
        {
            print("end index \(end) out of bounds")
            return ""
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(end))
        return self.substringWithRange(range)
    }
    func substringWithRange(start: Int, location: Int) -> String
    {
        if (start < 0 || start > self.characters.count)
        {
            print("start index \(start) out of bounds")
            return ""
        }
        else if location < 0 || start + location > self.characters.count
        {
            print("end index \(start + location) out of bounds")
            return ""
        }
        let range = Range(start: self.startIndex.advancedBy(start), end: self.startIndex.advancedBy(start + location))
        return self.substringWithRange(range)
    }

}



















class ViewControllerSS2: UIViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    var roomSheet = UIActionSheet()
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
        
        self.roomSheet.title = " "
        self.roomSheet.delegate = self
        let btn = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: 10, width: 40, height: 20))
        btn.setTitle(Defined_ALERT_OK, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.tag = 1
        btn.addTarget(self, action: Selector("selectedActBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btn2 = UIButton(frame: CGRect(x: 20, y: 10, width: 40, height: 20))
        btn2.setTitle(Defined_ALERT_CANCEL, forState: UIControlState.Normal)
        btn2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn2.tag = 2
        btn2.addTarget(self, action: Selector("cancleActBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let picker = UIPickerView(frame: CGRect(x: 20, y: -10, width: self.view.frame.width - 40 , height: 160))
        
        picker.dataSource = self
        picker.delegate = self
        
        
        roomSheet.addSubview(picker)
        roomSheet.addSubview(btn)
        roomSheet.addSubview(btn2)
        
        
    }
    func selectedActBtn( sender : AnyObject){
        print("selectedActBtn")
        roomSheet.dismissWithClickedButtonIndex(2, animated: true)
    }
    
    func cancleActBtn( sender : AnyObject){
        
        print("cancleActBtn")
        roomSheet.dismissWithClickedButtonIndex(1, animated: true)
        
    }
    
    @IBAction func showSheet(sender : AnyObject) {
        self.roomSheet.showInView(self.view)
        self.roomSheet.bounds.size.height = 240
        self.roomSheet.frame.size.height = 240
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        
        return 2
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        //var objRooms :NSArray = FAME.device_table.valueForKey("rooms") as NSArray
        if component == 0 {
            return FAME.linkMoled.count
        }else{
            return 2
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        //var objRooms :NSArray = FAME.device_table.valueForKey("rooms") as NSArray
        
        //return String(objRooms[row] as NSString)
        if component == 0 {
            return FAME.linkMoled[row]["name"]
        }else{
            if row == 0 {
                return Defined_mode_on
            }else{
                return Defined_mode_off
            }
        }
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        tableView
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        print(indexPath)
        let next = GBoard.instantiateViewControllerWithIdentifier("viewCell") as UIViewController
        //next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        
        self.navigationController?.pushViewController(next, animated: true)
    }
}

class ViewControllerSS3: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
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
        
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        tableView
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        print(indexPath)
        let next = GBoard.instantiateViewControllerWithIdentifier("viewCell") as UIViewController
        //next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        
        self.navigationController?.pushViewController(next, animated: true)
    }
}


class ViewControllerSS4: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
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
        
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        tableView
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        print(indexPath)
        let next = GBoard.instantiateViewControllerWithIdentifier("viewCell") as UIViewController
        //next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        
        self.navigationController?.pushViewController(next, animated: true)
    }
}

class ViewControllerSS5: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
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
        
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        tableView
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        print(indexPath)
        let next = GBoard.instantiateViewControllerWithIdentifier("viewCell") as UIViewController
        //next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

class ViewControllerSS7: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {
    
    var airSensors:Array<Dictionary<String,String>> = []
    var popView:UIView!
    

    @IBOutlet weak var tableView: UITableView!
    //关
    @IBAction func lightTap2(sender: UIButton2) {
        
        let view = sender.superview?.viewWithTag(3) as! UIImageView
        view.image = UIImage(named: "socket_06.png")
        FAME.lightsCellState["\(sender.id)"] = 0
        httpRequert().sendRequest(sender.act_id)
        //print("sender.act_id=\(sender.act_id)")
        print(FAME.lightsCellState)
    }
    //开
    @IBAction func lightTap(sender: UIButton2) {
        
        let view = sender.superview?.viewWithTag(3) as! UIImageView
        view.image = UIImage(named: "socket_10.png")
        FAME.lightsCellState["\(sender.id)"] = 1
        httpRequert().sendRequest(sender.act_id)
        //print("sender.act_id=\(sender.act_id)")
        print(FAME.lightsCellState)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.showsVerticalScrollIndicator = false
        
  
        self.airSensors = FAME.sensors32;
       
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshLights:")
        self.navigationItem.rightBarButtonItem = addButton
 
        
    }
    //弹出视图
    func popPushView(){
        
        self.popView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.width, height: self.view.frame.height));
        self.popView.backgroundColor=UIColor.clearColor();
        self.view .addSubview(self.popView);
        
        self.popView.hidden = true;
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        //设置手势点击数,双击：点2下
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self ;
        self.popView.addGestureRecognizer(tapGesture)
        
        
        let popView1 = UIView(frame: CGRect(x: (self.view.frame.width*0.3)/2, y: (self.view.frame.height*0.5)/2 , width: self.view.frame.width*0.7, height: self.view.frame.height*0.5));
        popView1.backgroundColor=UIColor.whiteColor();
        self.popView .addSubview(popView1);
        
        //self.popView.alpha=0.0;
        
        let titleLable = UILabel(frame: CGRect(x: popView1.frame.size.width*0.1, y: 0, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6))
        titleLable.text = FAME.dev_ss_name;
        titleLable.font = UIFont.boldSystemFontOfSize(20);
        titleLable.textColor = UIColor.blueColor();
        popView1 .addSubview(titleLable);
        
        let view1 = UIView(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6*0.95, width: popView1.frame.size.width*0.8, height: 1))
        view1.backgroundColor = UIColor.blackColor();
        popView1 .addSubview(view1);
        
        let nameUIButton = UIButton(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6*0.95))
        let nameLable = UILabel (frame: CGRect(x: 0, y: 0, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6))
        nameLable.text = Defined_SS_air_Title1;
        nameUIButton .addSubview(nameLable);
        nameUIButton.addTarget(self, action: Selector("btns1Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        popView1 .addSubview(nameUIButton);
        
        let view2 = UIView(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6*2, width: popView1.frame.size.width*0.8, height: 1))
        view2.backgroundColor = UIColor.grayColor();
        popView1 .addSubview(view2);
        
        let diss_dev = UIButton(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6*2, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6))
        let dissLable = UILabel (frame: CGRect(x: 0, y: 0, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6))
        dissLable.text = Defined_SS_air_Title2;
        diss_dev .addSubview(dissLable);
        diss_dev.addTarget(self, action: Selector("btns2Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        popView1 .addSubview(diss_dev);
        
        let view3 = UIView(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6*3, width: popView1.frame.size.width*0.8, height: 1))
        view3.backgroundColor = UIColor.grayColor();
        popView1 .addSubview(view3);

        let Button3 = UIButton(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6*3, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6))
        let Lable3 = UILabel (frame: CGRect(x: 0, y: 0, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6*0.95))
        Lable3.text = Defined_SS_air_Title3;
        Button3 .addSubview(Lable3);
        Button3.addTarget(self, action: Selector("btns3Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        popView1 .addSubview(Button3);
        
        let view4 = UIView(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6*4, width: popView1.frame.size.width*0.8, height: 1))
        view4.backgroundColor = UIColor.grayColor();
        popView1 .addSubview(view4);

        let Button4 = UIButton(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6*4, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6))
        let Lable4 = UILabel (frame: CGRect(x: 0, y: 0, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6))
        Lable4.text = Defined_SS_air_Title4;
        Button4 .addSubview(Lable4);
        Button4.addTarget(self, action: Selector("btns4Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        popView1 .addSubview(Button4);
        
        let view5 = UIView(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6*5, width: popView1.frame.size.width*0.8, height: 1))
        view5.backgroundColor = UIColor.grayColor();
        popView1 .addSubview(view5);

        let Button5 = UIButton(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6*5, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6))
        let Lable5 = UILabel (frame: CGRect(x: 0, y: 0, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6*0.95))
        Lable5.text = Defined_SS_air_Title5;
        Button5 .addSubview(Lable5);
        Button5.addTarget(self, action: Selector("btns5Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        popView1 .addSubview(Button5);


        
        
        

    }
    func btns1Fun(sender:UIButton){
        self.popView.hidden = true;
        let next = GBoard.instantiateViewControllerWithIdentifier("viewSS_name") as UIViewController
        
        self.navigationController?.pushViewController(next, animated: true)
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
    }
    //删除设备
    func btns2Fun(sender:UIButton){
        let alertController = UIAlertController(title: "友情提示", message: "请输入密码删除该设备", preferredStyle: UIAlertControllerStyle.Alert);
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
        }
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .Default,
            handler: {
                action in
                //也可以用下标的形式获取textField let login = alertController.textFields![0]
                let login = alertController.textFields!.first! as UITextField
                print("用户名：\(login.text)")
                let cmdStr = "{\"cmd\": 30, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":[{\"ieee_addr\":\"\(login.text! as String)\"}]}"
                if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
                    
                    print(recevied)
                }

                
                
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        self.popView.hidden = true;
        
    }
    func btns3Fun(sender:UIButton){
        self.popView.hidden = true;
        let next = GBoard.instantiateViewControllerWithIdentifier("viewSS_link") as UIViewController
        
        self.navigationController?.pushViewController(next, animated: true)
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
    }
    func btns4Fun(sender:UIButton){
        self.popView.hidden = true;
        let next = GBoard.instantiateViewControllerWithIdentifier("viewSS_link") as UIViewController
        
        self.navigationController?.pushViewController(next, animated: true)
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
    }
    func btns5Fun(sender:UIButton){
        self.popView.hidden = true;
        let next = GBoard.instantiateViewControllerWithIdentifier("viewSS_air6") as UIViewController
        
        self.navigationController?.pushViewController(next, animated: true)
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
    }

    func handleLongpressGesture(gesture:UILongPressGestureRecognizer!){
        
        //点击手势
        if gesture.state == UIGestureRecognizerState.Began {
            let point:CGPoint = gesture.locationInView(self.tableView)
            let indexPath:NSIndexPath! = self.tableView.indexPathForRowAtPoint(point)
            if indexPath == nil{
                return;
            }
            
            print("handleLongpressGesture")
            self.popView.hidden = false;
        }
        
        
    }
    func handleTapGesture(sender:AnyObject!){
        print("handleTapGesture")
        self.popView.hidden = true;


        
    }
    func refreshLights(sender:AnyObject!){
        print("refreshLights")
        //self.tableView!.reloadData()
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
        
    }
    func Timerset(){
        //get the state
        
        //create the post string
        
        if FAME.refreshLightState() {
            //set the state
            for subCell:AnyObject in self.tableView!.visibleCells {
                print(subCell)
                let cell = subCell as! UITableViewCell
                let view = cell.viewWithTag(3) as! UIImageView
                let state :Int! = FAME.lightsCellState["\(cell.tag)"]
                if (state != nil) {
                    print("state:\(state)")
                    if state == 1 {
                        view.image = UIImage(named: "socket_10.png")
                    }else {
                        view.image = UIImage(named: "socket_06.png")
                    }
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)

        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        //return 3
        return self.airSensors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        tableView
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell2


        let showId = self.airSensors[indexPath.row]
        
        
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target:self
            , action: "handleLongpressGesture:")
        longpressGesutre.minimumPressDuration = 1.0;
        cell .addGestureRecognizer(longpressGesutre)
        FAME.dev_ss_name = showId["name"]
        FAME.dev_ss_Rname = showId["roomName"]
        
        self .popPushView();
        
        
        let dev_Str:String! = showId["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)
        FAME.dev_id = dev_id ;
        
        let index_Str:String! = showId["index"] as String!
        let index:Int! = Int(index_Str)
        
        let type_Str:String! = showId["dev_type"] as String!
        let type:Int! = Int(type_Str)
        
        let name_Str:String! = showId["name"] as String!
        let roomName_Str:String! = showId["roomName"] as String!
        
        
        cell.tag = dev_id * 10 + index
        
        cell.dev_id = dev_id
        cell.id = type
        //name
        let name = cell.viewWithTag(1) as! UILabel
        name.text = roomName_Str + name_Str ;

        
        //on off
 
            let tagOn = cell.viewWithTag(30) as! UIButton2!
            let tagOff = cell.viewWithTag(40) as! UIButton2!
            let act_Str:String! = showId["act_id"] as String!
            
            let act_id:Int = Int(act_Str)!
            tagOn.act_id = act_id + 1
            tagOff.act_id = act_id
            tagOn.id = cell.tag
            tagOff.id = cell.tag
            
            let view = cell.viewWithTag(3) as! UIImageView
            let state :Int! = FAME.lightsCellState["\(cell.tag)"]
            //let state :Int! = Int(showId["state"] as String!)
            if (state != nil) {
                print("state:\(state)")
                if state == 1 {
                    view.image = UIImage(named: "socket_10.png")
                }else {
                    view.image = UIImage(named: "socket_06.png")
                }
            }else{
                view.image = UIImage(named: "socket_06.png")
            }
        
        print("tagOn.act_id=\(tagOn.act_id)")
        print("tagOff.act_id=\(tagOff.act_id)")
        return cell
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        if indexPath.section == 0{
            let showId = self.airSensors[indexPath.row]
            let next = GBoard.instantiateViewControllerWithIdentifier("viewSS7Details") as UIViewController
            //next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
            next.title=showId["name"]
            let dev_Str:String! = showId["dev_id"] as String!
            FAME.dev_id = Int(dev_Str)
            self.navigationController?.pushViewController(next, animated: true)
            let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
            self.navigationItem.backBarButtonItem = item;
        }
        
    }

}

class ViewControllerSS7Detail: UIViewController {
    
    var viewUp = UIView()
    
    @IBOutlet var subView: UIView!
    var airDetail: NSDictionary!;
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createNav()
        
        self.airDetail = NSDictionary();
        let view = self.view.viewWithTag(200) as UIView!
        view.layer.borderColor=UIColor.whiteColor().CGColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius=10
        
        createUpView()
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Down //不设置是右
        subView.addGestureRecognizer(swipeLeftGesture)

        
        
        
    }
    func createNav(){
        let button = UIButton(frame: CGRectMake(0,0,60,35))
        button.setTitle("设置", forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("setClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    func setClick(sender:AnyObject!){
        
        
        
    }
    func handleSwipeGesture(sender: UISwipeGestureRecognizer){
        refreshModes()
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        refreshModes()
        
        
    }
    func refreshModes(){
        viewUp.hidden = false
        subView.transform = CGAffineTransformMakeTranslation(0 , 80)
        
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
    }
    func Timerset(){
        let cmdStr = "{\"cmd\": 42, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"dev_id\":\(FAME.dev_id)}}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
            print("link device successed")
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.viewUp.hidden = true
                self.subView.transform = CGAffineTransformMakeTranslation(0 , 0)
                
                self.airDetail=recevied["detail"] as! NSDictionary;
                let detail=self.airDetail
                
                let viewpm2_5 = self.view.viewWithTag(300) as! UILabel!;
                let index_Str:Int! = detail["pm2_5"] as! Int!
                
//                var index_Str:Double! = detail["pm2_5"] as! Double!
//                index_Str = round(index_Str * 10) / 10
                
                viewpm2_5.text="\(index_Str)"
                
                let viewpm_lable = self.view.viewWithTag(301) as! UILabel!
                
                if index_Str <= 70{
                    viewpm_lable.text = "空气质量佳"
                }
                else if index_Str >= 130{
                    viewpm_lable.text = "空气质量差"
                }
                else{
                    viewpm_lable.text = "空气质量良"
                }
                
                
                let hcho = self.view.viewWithTag(302) as! UILabel!
                var index_Str1:Double! = detail["hcho"] as! Double!
                index_Str1 = round(index_Str1 * 100) / 100
                hcho.text="\(index_Str1)  mg/M³"
               
                
                let hcho_lable = self.view.viewWithTag(303) as! UILabel!
                if index_Str1 > 0.08{
                    hcho_lable.text = "偏高"
                }
                else{
                    hcho_lable.text = "正常"
                }
                
                
                let temperature = self.view.viewWithTag(304) as! UILabel!
                var index_Str2:Double! = detail["temperature"] as! Double!
                index_Str2 = round(index_Str2 * 10) / 10
                temperature.text="\(index_Str2)  ºC"
                
                let temperature_lable = self.view.viewWithTag(305) as! UILabel!;
                if index_Str2 <= 35 && index_Str2 > 23{
                    temperature_lable.text = "正常"
                }
                else if index_Str2 <= 23 && index_Str2 > 15{
                    temperature_lable.text = "偏低"
                }
                else if index_Str2 <= 42 && index_Str2 > 35{
                    temperature_lable.text = "炎热"
                }
                else if index_Str2 > 42{
                    temperature_lable.text = "酷热"
                }
                else{
                    temperature_lable.text = "寒冷"
                }
                
                let humidity = self.view.viewWithTag(306) as! UILabel!;
                var index_Str3:Double! = detail["humidity"] as! Double!
                index_Str3 = round(index_Str3 * 10) / 10
                humidity.text="\(index_Str3)  %RH"
                
                let humidity_lable = self.view.viewWithTag(307) as! UILabel!
                if index_Str3 >= 70{
                    humidity_lable.text = "潮湿"
                }
                else if index_Str3 <= 30{
                    humidity_lable.text = "干燥"
                }
                else{
                    humidity_lable.text = "正常"
                }
                
                let update_time = self.view.viewWithTag(308) as! UILabel!;
                update_time.text="更新时间：\(detail["update_time"] as! String)"
                
                
                //FAME.showMessage("空气质量刷新成功")

            })
            
            
            
        }else{
            
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                FAME.showMessage("空气质量刷新失败")
                
                self.viewUp.hidden = true
                self.subView.transform = CGAffineTransformMakeTranslation(0 , 80)
                
            })
            
            print("link event failed")
        }

    }
    
    
    func createUpView(){
        
        viewUp = UIView(frame: CGRect(x: 0, y: 64 , width: self.view.frame.width, height: 80))
        viewUp.backgroundColor = UIColor(red: 0, green: 139, blue: 139, alpha: 0.1)
        viewUp.hidden = true
        self.view.addSubview(viewUp)
        
        let imgV = UIImageView(frame: CGRectMake(80, 30, 20, 20))
        
        imgV.animationDuration = 2.0
        viewUp .addSubview(imgV)
        
        var images = [UIImage]()
        
        for i in 0...11{
            let img = UIImage(named: "loading_login\(i + 1)")
            images.append(img!)
        }
        imgV.animationImages = images
        imgV.animationRepeatCount = 0
        imgV.startAnimating()
        
        
        let lable = UILabel(frame: CGRect(x: 0, y: 30 , width: self.view.frame.width, height: 20))
        lable.text = "正在刷新中......."
        lable.textAlignment = .Center
        viewUp.addSubview(lable)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    


}
protocol ViewControllerSS_nameDelegate{
    func reloadName();
}
class ViewControllerSS_name: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate {
    var popView:UIView!
    var nameArray:Array<String> = []
    var count:Int! = 0
    var delegate :ViewControllerSS_nameDelegate?
    
    var subName:Array<String> = []
    
    @IBOutlet weak var isShowView: UIView!
    @IBOutlet weak var roomView: UIView!
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        if FAME.tempSensorId == 1{
            isShowView.alpha = 1.0
            
            roomView.transform = CGAffineTransformMakeTranslation(0 , 25)
            
            print("222222=\(FAME.subNames[FAME.dev_id])dev_id = \(FAME.dev_id)")
            
            let variation_name = self.view.viewWithTag(17) as! UITextField!
            
            variation_name.text = FAME.subNames[FAME.dev_id]![FAME.variation_index] as? String
            
        }
        
        self.nameArray = FAME.rooms;
        
        for(var i = 0; i < self.nameArray.count ; i++){
            if FAME.dev_ss_Rname == self.nameArray[i]{
                count = i
            }
        }
        
        let dev_name = self.view.viewWithTag(18) as! UITextField!;
        dev_name.text = FAME.dev_ss_name

        let room_button = self.view.viewWithTag(19) as! UIButton
        room_button .addTarget(self, action: Selector("roomClick:"), forControlEvents: UIControlEvents.TouchUpInside);

        let sure_button = self.view.viewWithTag(21) as! UIButton!;
        sure_button .addTarget(self, action: Selector("sureClick:"), forControlEvents: UIControlEvents.TouchUpInside);
        
        let room_name = self.view.viewWithTag(20) as! UILabel!;
        room_name.text = FAME.dev_ss_Rname;
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.title = FAME.dev_ss_name

        
        let tap = UITapGestureRecognizer(target: self, action: "tapClick:")
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        self.view .addGestureRecognizer(tap)
        
        
        
    }
    func tapClick(sender:AnyObject!){
        self.view.endEditing(false)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        print(textField.tag)
        
        self.view.endEditing(false)
        
        return true
    }
    func roomClick(sender:UIButton){
        
        print("点击了选择框");
        self.popPushView();
        
        
        
    }
    func sureClick(sender:UIButton){
        print("点击了确定按钮");
        let dev_name = self.view.viewWithTag(18) as! UITextField!
        
        //        let room_name = self.view.viewWithTag(20) as! UILabel!;
//        room_name.text = self.nameArray[count];
        let name:String = dev_name.text as String!
        

        FAME.dev_ss_name = name

        if FAME.tempSensorId == 1{
            let subname1 = self.view.viewWithTag(17) as! UITextField!
            let subname:String = subname1.text as String!
            //print("222222====\(subname)lllllll===\(FAME.variation_index)")
            
            FAME.subNames[FAME.dev_id]![FAME.variation_index] = subname
            for i in 0..<FAME.subNames[FAME.dev_id]!.count{
                
                if FAME.subNames[FAME.dev_id]![i].isEqual(""){
                    
                    subName.append("")
                }
                else{
                    subName.append("\(FAME.subNames[FAME.dev_id]![i])")
                }
            }
            //subName = FAME.subNames[FAME.dev_id]!
            print(subName)
            
        }
        else{
            subName = []
        }
        let cmdStr = "{\"cmd\": 47,\"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"dev_id\":\(FAME.dev_id), \"name\": \"\(name)\",\"room\":\(count), \"variation\": \(subName)}"
  
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
            
            //print(recevied)
            if recevied["result"] as! NSObject == 0
            {
                //fame.showMessage("111111");
                FAME.getDeviceTable()
                self.delegate?.reloadName();
                self.navigationController?.popViewControllerAnimated(true);
            }
        }
        else{
            FAME.showMessage("设备名修改失败")
        }
        
        
    }
    func popPushView(){
        self.popView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.width, height: self.view.frame.height));
        self.popView.backgroundColor=UIColor.clearColor();
        self.view .addSubview(self.popView);
        //self.popView.hidden = true;
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        //设置手势点击数,双击：点2下
        tapGesture.delegate=self
        tapGesture.numberOfTapsRequired = 1
        self.popView.addGestureRecognizer(tapGesture)
        
        
        let popTableView = UITableView(frame: CGRect(x: (self.view.frame.width*0.3)/2, y: (self.view.frame.height*0.5)/2 , width: self.view.frame.width*0.7, height: self.view.frame.height*0.5));
        popTableView.backgroundColor=UIColor.whiteColor();
        popTableView.dataSource = self;
        popTableView.delegate = self ;
        popTableView.showsVerticalScrollIndicator = false
        self.popView .addSubview(popTableView);
  
        
    }
    func handleTapGesture(sender:AnyObject!){
        print("handleTapGesture")
        self.popView.hidden = true;
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.nameArray.count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let identifier="identtifier";
        var cell=tableView.dequeueReusableCellWithIdentifier(identifier);
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier);
        }
        cell?.textLabel?.text = self.nameArray[indexPath.row];
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark ;
        return cell!;
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 50
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        let room_name = self.view.viewWithTag(20) as! UILabel!;
        room_name.text = self.nameArray[indexPath.row];
        
        FAME.dev_ss_Rname = self.nameArray[indexPath.row];
        
        count = indexPath.row ;
        self.popView.hidden = true;
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        if NSStringFromClass(touch.view!.classForCoder) == "UITableViewCellContentView"{
            return false
        }
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

protocol ViewControllerSS7air6Delegate{
    func showMessage();
}

//修改门限值
class ViewControllerSS7air6: UIViewController,UITextFieldDelegate {
    var delegate :ViewControllerSS7air6Delegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = FAME.dev_ss_name ;
        // Do any additional setup after loading the view, typically from a nib.
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshLights:")
        self.navigationItem.rightBarButtonItem = addButton
        let sureClick = self.view.viewWithTag(49) as! UIButton!;
        sureClick.addTarget(self, action: Selector("requestData:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: "tapClick:")
        tap.numberOfTapsRequired = 1
        //tap.delegate = self
        self.view .addGestureRecognizer(tap)
        
        
        
    }
    func tapClick(sender:AnyObject!){
        self.view.endEditing(false)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        print(textField.tag)
        
        self.view.endEditing(false)
        
        return true
    }
    
    func requestData(sender:AnyObject!){
        let PM = self.view.viewWithTag(45) as! UITextField!;
        let PM_number :Double! = Double(PM.text as String!);
        //print(PM_number) ;
        let hcho_threshold = self.view.viewWithTag(46) as! UITextField!;
        let hcho_number :Double! = Double(hcho_threshold.text as String!);
        let temperature_threshold = self.view.viewWithTag(47) as! UITextField!;
        let temp_number :Double! = Double(temperature_threshold.text as String!);
        let humidity_threshold = self.view.viewWithTag(48) as! UITextField!;
        let humi_number :Double! = Double(humidity_threshold.text as String!);

        
        let cmdStr = "{\"cmd\": 43, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"dev_id\":\(FAME.dev_id),\"temperature_threshold\": \(temp_number),\"humidity_threshold\":\(humi_number),\"hcho_threshold\": \(hcho_number),\"pm2_5_threshold\":\(PM_number)}}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
            
            if recevied["result"] as! NSObject == 0
            {
                self.delegate?.showMessage()
                self.navigationController?.popViewControllerAnimated(true);
            }
        }

    }
    func refreshLights(sender:AnyObject!){
        print("refreshLights")
        //self.TableView!.reloadData()
        //        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        //        myThread.start()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
        
    }
    func Timerset(){
        let cmdStr = "{\"cmd\": 44, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"dev_id\":\(FAME.dev_id)}}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
            
            if recevied["result"] as! NSObject == 0 && recevied["error_code"] as! NSObject == 0
            {
                let detail = recevied["detail"] as! NSObject

                let PM = self.view.viewWithTag(45) as! UITextField!
                let hcho_threshold = self.view.viewWithTag(46) as! UITextField!
                let temperature_threshold = self.view.viewWithTag(47) as! UITextField!
                let humidity_threshold = self.view.viewWithTag(48) as! UITextField!
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    PM.text = String(detail.valueForKey("pm2_5_threshold")!)
                    hcho_threshold.text = String(detail.valueForKey("hcho_threshold")!)
                    temperature_threshold.text = String(detail.valueForKey("temperature_threshold")!)
                    humidity_threshold.text = String(detail.valueForKey("humidity_threshold")!)
                })
            }
        }

    }
    
}

class ViewControllerSS_mode: UIViewController,UIAlertViewDelegate {
    
    var BGView:UIView!
    var pickView:UIView!
    var picker:UIPickerView!
    var seletedStr:String! = ""
    var selectCount:Int!
    var selectId:Int!
    var buttonTag:Int!
    
    var dev_id:Int!
    
    var ieee:String!
    
    var view1 = UIScrollView()
    var indexCount : Array<Dictionary<String,String>> = []
    
    var model:Dictionary<Int,String> = [:]
    
    var indexRoom : Int! = 1000
    var right : Bool = false
    
    
    var viewUp = UIView()
    
    
    
    //var model:Dictionary<String,String> = [:]
    
    @IBOutlet weak var tableView: UITableView!
    
    func handleLongpressGesture(sender: UILongPressGestureRecognizer) {
        
        
        if sender.state == UIGestureRecognizerState.Began {
            let point:CGPoint = sender.locationInView(self.tableView)
            let indexPath:NSIndexPath! = self.tableView.indexPathForRowAtPoint(point)
            if(indexPath != nil){
                //let cell:UITableViewCell2! = self.tableView.cellForRowAtIndexPath(indexPath) as! UITableViewCell2

                ieee = indexCount[indexPath.row]["ieee"] as String!
                let alert :UIAlertView = UIAlertView()
                alert.delegate = self
                alert.title = Defined_ALERT_del
                alert.message = Defined_ALERT_del2
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.addButtonWithTitle(Defined_ALERT_CANCEL)
                alert.show()
                
                
                
            }
        }

        
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        
        if buttonIndex == 0 {

            FAME.delDeviceByIeee(ieee)
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            
        }
    }

    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
//        let myThread = NSThread(target: self, selector: "dataArrId", object: nil)
//        myThread.start()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if FAME.sensors30.count == 0 {
            
            let textLabel = UILabel (frame:CGRectMake(self.view.frame.size.width/8,self.view.frame.size.height/10,self.view.frame.size.width*3/4,self.view.frame.size.height*4/5))
            textLabel.text = Defined_Tips_none
            
            //textLabel.backgroundColor =
            UIColor.blackColor()
            textLabel.textColor = UIColor.whiteColor()
            textLabel.textAlignment = NSTextAlignment.Center
            textLabel.numberOfLines = 0;
            textLabel.font = UIFont.systemFontOfSize(25)
            self.view.addSubview(textLabel)
            return
            
        }
  
        else{
            data(0)
            swipeView()
            createUpView()
            for i in 0..<FAME.models.count{
                let act:String = FAME.models[i]["act_id"]! as String
                let act_id:Int = Int(act)!
                let name:String = FAME.models[i]["name"]! as String
                self.model[act_id] = name
            }
            print(model)
            
            tableView.transform = CGAffineTransformMakeTranslation(WIDTH/3 , 0)
            
            tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshLights")
            tableView.mj_header.beginRefreshing()
            
        }

        
    }
    func refreshLights(){
        print("refreshLights")
        //self.TableView!.reloadData()
        if indexCount.count == 0{
            tableView.mj_header.endRefreshing()
            FAME.showMessage("刷新成功")
        }
        else{
            let myThread = NSThread(target: self, selector: "dataArrId", object: nil)
            myThread.start()
        }
        
        
    }
    func dataArrId(){
        var cellCount :Int = 0
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            //print(indexCount)
            for i in 0..<indexCount.count{
                let dev = indexCount[i]["dev_id"]! as String
                let dev_id1:Int! = Int(dev)
                FAME.boolCounts = 0
                FAME.requestEventActionIds(dev_id1)
                
                if FAME.boolCounts > 0{
                    cellCount = cellCount + 1
                }
                
            }
        
        //}
        
        if cellCount > 0{
            self.tableView.mj_header.endRefreshing()
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                //FAME.showMessage("刷新成功")
                let myThread = NSThread(target: self, selector: "Timerset", object: nil)
                myThread.start()

                print(FAME.action_ids)
            })
            //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        else{
            self.tableView.mj_header.endRefreshing()
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                FAME.showMessage("刷新失败，网络超时 请检查中控")
            })
            //UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        
        
        
    }
    
    func Timerset(){
        
        //UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        for subCell:AnyObject in tableView.visibleCells {
            //print(subCell)
            let cell = subCell as! UITableViewCell2
            
            dev_id = cell.dev_id
            print("dev_id == \(dev_id),====\(FAME.action_ids[dev_id])")
            if (FAME.action_ids[dev_id] != nil){
                for i in 0..<FAME.action_ids[dev_id]!.count{
                    
                    let lable = cell.viewWithTag(i + 71) as! UILabel
                    
                    for j in 0..<FAME.models.count{
                        let name = FAME.models[j]["name"] as String!
                        let id = FAME.models[j]["act_id"] as String!

                        if FAME.action_ids[dev_id]![i] == Int(id) {
                            
                            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                lable.text = name
                            })
                        }
//                        else{
//                            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
//                                lable.text = Defined_Event_Title
//                            })
//
//                        }
                    }
                }

            }
            
            
        }
 

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func actSetBtn(sender:UIButton2!){
        
        print("点击了设定按钮")
        
        if (tableView.mj_header != nil){
            tableView.mj_header.endRefreshing()
        }
        
        viewUp.hidden = false
        tableView.transform = CGAffineTransformMakeTranslation(0 , 80)

        dev_id = sender.dev_id
        
        let myThread = NSThread(target: self, selector: "Timerset1", object: nil)
        myThread.start()
        
        
        
        
        
    }
    func Timerset1(){
        var event_id : Int! = 0
        var count : Int! = 0
        let array : NSArray! = FAME.action_ids[dev_id]
        
        for i in 0..<array.count{
            if i < 3{
                event_id = (dev_id - 85) * 3 + 1 + i
            }
            else{
                event_id = (dev_id - 85) * 3 + 1 + i + 45
            }
            
            let cmdStr = "{\"cmd\": 33, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"event_id\":\(event_id),\"filter_data\":[\(dev_id),11,18,\(i)],\"action_id\":\(array[i]),\"active\":1}}"
            if (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90) != nil){
                print("link device successed")
                
                count = count + 1
                
            }
            
            
        }
        if count > 0{
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                self.viewUp.hidden = true
                self.tableView.transform = CGAffineTransformMakeTranslation(0 , 0)
                
                let alert = UIAlertView()
                alert.title = Defined_mode1_title
                alert.message = Defined_mode1_update
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            })
        }
        else{
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                self.viewUp.hidden = true
                self.tableView.transform = CGAffineTransformMakeTranslation(0 , 0)
                let alert = UIAlertView()
                alert.title = Defined_mode1_title
                alert.message = Defined_mode1_failed
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            })
        }

    }
    func actAddBtn(sender:UIButton2!){
        
        print("点击了选择按钮")
        self .createPop()
        self.selectCount = sender.tag - 430
        buttonTag = sender.tag - 501
        dev_id = sender.dev_id
        selectId = nil
        
    }
    func selectedActBtn(sender : AnyObject!){
        
        
        self.BGView.hidden = true ;
        let lable1 = self.view.viewWithTag(self.selectCount) as! UILabel!;
        if selectId == nil{
            lable1.text = Defined_Event_Title
            FAME.action_ids[dev_id]![buttonTag] = -1
        }
        else
        {
            lable1.text = self.seletedStr;
            FAME.action_ids[dev_id]![buttonTag] = selectId
        }
        print(FAME.action_ids[dev_id])
        
    }
    
    func cancleActBtn( sender : AnyObject){
        
        print("cancleActBtn")
        
        self.BGView.hidden = true ;
    }
    func tapPress( sender : AnyObject){
        
        print("cancleActBtn")
        //roomSheet.dismissWithClickedButtonIndex(1, animated: true)
        
        self.BGView.hidden = true ;
    }
    func createUpView(){
        
        viewUp = UIView(frame: CGRect(x: 0, y: 64 , width: self.view.frame.width, height: 80))
        viewUp.backgroundColor = UIColor(red: 0, green: 139, blue: 139, alpha: 0.1)
        viewUp.hidden = true
        self.view.addSubview(viewUp)
        
        let imgV = UIImageView(frame: CGRectMake(80, 30, 20, 20))
        
        imgV.animationDuration = 2.0
        viewUp .addSubview(imgV)
        
        var images = [UIImage]()
        
        for i in 0...11{
            let img = UIImage(named: "loading_login\(i + 1)")
            images.append(img!)
        }
        imgV.animationImages = images
        imgV.animationRepeatCount = 0
        imgV.startAnimating()
        
        
        let lable = UILabel(frame: CGRect(x: 0, y: 30 , width: self.view.frame.width, height: 20))
        lable.text = "正在配置中......."
        lable.textAlignment = .Center
        viewUp.addSubview(lable)
        
    }
    func createPop(){
        
        self.BGView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.width, height: self.view.frame.height))
        self.BGView.backgroundColor = UIColor.clearColor()
        
        
        //cancel
        
        let tapPressRec = UITapGestureRecognizer()
        tapPressRec.addTarget(self, action: "tapPress:")
        
        self.BGView.addGestureRecognizer(tapPressRec)
        
        self.BGView.userInteractionEnabled = true
        
        
        
        self.pickView = UIView(frame: CGRect(x: 0, y: self.BGView.frame.height-300 , width: self.BGView.frame.width, height: 300 ))
        self.pickView.backgroundColor = UIColor.whiteColor()
        
        
        
        //picker
        
        
        
        let btn = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: 20, width: 40, height: 20))
        btn.setTitle("\(Defined_ALERT_OK)", forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.tag = 1
        btn.addTarget(self, action: Selector("selectedActBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let btn2 = UIButton(frame: CGRect(x: 20, y: 20, width: 40, height: 20))
        btn2.setTitle(Defined_ALERT_CANCEL, forState: UIControlState.Normal)
        btn2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn2.tag = 2
        btn2.addTarget(self, action: Selector("cancleActBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self.picker = UIPickerView(frame: CGRect(x: 20, y: 40, width: pickView.frame.width - 40 , height: 230))
        
        self.picker.dataSource = self
        self.picker.delegate = self
        
        self.picker.backgroundColor = UIColor.clearColor() ;
        
        
        //self.pickView.addSubview(self.pickView2)
        self.pickView.addSubview(self.picker)
        self.pickView.addSubview(btn)
        self.pickView.addSubview(btn2)
        
        //self.BGView.hidden = true ;
        self.view.addSubview(self.BGView)
        self.BGView.addSubview(self.pickView)
    }
    //侧滑
    
    func swipeView(){
        view1 = UIScrollView(frame: CGRectMake(0, 64, WIDTH/3, HEIGHT))
        view1.backgroundColor = UIColor.grayColor()
        //view1.hidden = true
        self.view.addSubview(view1)
        let viewTitle = UILabel(frame: CGRectMake(0, 0, WIDTH/3, HEIGHT/10))
        viewTitle.text = "房间名"
        viewTitle.textColor = UIColor.whiteColor()
        viewTitle.textAlignment = .Center
        view1.addSubview(viewTitle)
        let view = UIView(frame: CGRectMake(0, HEIGHT/10 * 1.2 , WIDTH/3, 1))
        view.backgroundColor = UIColor.whiteColor()
        view1.addSubview(view)
        
        
        for i in 0..<FAME.rooms.count{
            
            let button = UIButton(frame: CGRectMake(0, HEIGHT/10 * 1.2 + HEIGHT/14 * CGFloat(i), WIDTH/3, HEIGHT/14))
            button.tag = i + 1000
            button.setTitle(FAME.rooms[i], forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("refreshh:"), forControlEvents: UIControlEvents.TouchUpInside)
            if i == 0{
                button.backgroundColor = UIColor(red: 0, green: 206, blue: 209, alpha: 1.0)
                
            }
            else{
                
                let view = UIView(frame: CGRectMake(0, HEIGHT/10 * 1.2 + HEIGHT/14 * CGFloat(i), WIDTH/3, 1))
                view.backgroundColor = UIColor.whiteColor()
                view1.addSubview(view)
            }
            view1.addSubview(button)
            
        }
        
        
        //左划
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left //不设置是右
        tableView.addGestureRecognizer(swipeLeftGesture)
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        tableView.addGestureRecognizer(swipeGesture)
    }
    
    func handleSwipeGesture(sender: UISwipeGestureRecognizer){
        
        //判断是上下左右
        
        if right{
            
            
            tableView.transform = CGAffineTransformMakeTranslation(WIDTH/3 , 0)
            view1.hidden = false
            self.right = false
            
        }
        else{
            
            tableView.transform = CGAffineTransformMakeTranslation(0 , 0)
            
            view1.hidden = true
            self.right = true
        }
        
        
    }
    
    func data(indeex : Int) {
        //super.viewWillAppear(animated)
        if indexCount.count != 0{
            indexCount.removeAll()
        }
        for i in 0..<FAME.sensors30.count{
            //FAME.lights[i]["room"]
            
            if Int(FAME.sensors30[i]["room"]!)! == indeex{
                
                indexCount.append(FAME.sensors30[i])
            }
            
        }
        //print(indexCount)
        
    }
    func refreshh(sender : UIButton!){
        let button = self.view.viewWithTag(indexRoom) as! UIButton
        
        if button.tag != sender.tag{
            sender.backgroundColor = UIColor(red: 0, green: 206, blue: 209, alpha: 1.0)
            button.backgroundColor = UIColor.clearColor()
        }
        
        
        data(sender.tag - 1000)
        
        tableView.reloadData()
        
        self.tableView.mj_header.endRefreshing()
        print(NSThread.currentThread())
        //NSThread.currentThread().cancel()
        let myThread = NSThread(target: self, selector: "startAnimations", object: nil)
        myThread.start()
        
        indexRoom = sender.tag
        //print("11111\(sender.tag)")
    }
    func startAnimations(){
        
        if NSThread.currentThread().name == "main"{
            //NSThread.exit()
        }
        
    }


}
extension ViewControllerSS_mode: UIPickerViewDataSource,UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        self.seletedStr = FAME.models[row]["name"] as String!
        let id = FAME.models[row]["act_id"] as String!
        selectId = Int(id)
        
        
        print("pickerView selected:\(self.seletedStr)   id=\(selectId)")
        
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int)->Int {
        return FAME.models.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return FAME.models[row]["name"] as String!
    }

}
extension ViewControllerSS_mode: UITableViewDataSource,UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return indexCount.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        tableView
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell2
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell2
        //cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None ;

        
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target:self
            , action: "handleLongpressGesture:")
        longpressGesutre.minimumPressDuration = 1.0;
        
        cell .addGestureRecognizer(longpressGesutre)
        
        cell.selectionStyle = .Blue
        
        
        cell.backgroundColor = UIColor.clearColor()
        let lable1 = cell.viewWithTag(77) as! UILabel!
        lable1.text = indexCount[indexPath.row]["name"]! as String
        
        
        
        
        let dev = indexCount[indexPath.row]["dev_id"]! as String
        let dev_id1:Int! = Int(dev)
        
        cell.dev_id = Int(dev_id1)
        
        let view = cell.viewWithTag(51) as UIView!
        view.layer.borderColor=UIColor.whiteColor().CGColor;
        view.layer.borderWidth = 1;
        view.layer.cornerRadius=10;
        
        let setButton = cell.viewWithTag(70) as! UIButton2
        
        setButton.addTarget(self, action: Selector("actSetBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        setButton.dev_id = Int(dev_id1)
        
        for i in 501...506 {
            let searchButton = cell.viewWithTag(i) as! UIButton2!
            searchButton.addTarget(self, action: Selector("actAddBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
            let lable = cell.viewWithTag(i - 430) as! UILabel
            if (FAME.action_ids[setButton.dev_id] != nil){
                let count:Int = FAME.action_ids[setButton.dev_id]![i - 501]
                lable.text = model[count]
            }
            else{
                lable.text = Defined_Event_Title
            }

            searchButton.dev_id = Int(dev_id1)
            
        }

        return cell
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return HEIGHT * 0.6
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        self .performSelector("deselect", withObject: nil, afterDelay: 0.5)
    }
    func deselect(){
        
        if (tableView.indexPathForSelectedRow != nil){
            tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        }
    }
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        print(indexPath.row)
//            //***********************
//    
//        let ieee : String! = indexCount[indexPath.row]["ieee"]
//    
//        FAME.delDeviceByIeee(ieee)
//        self.navigationController?.popToRootViewControllerAnimated(true)
//        
//        //tableView.reloadData()
//        
//    }
    
    
//    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//       
//        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
//        myThread.start()
//    }
}



class ViewControllerFBG: UIViewController ,UIAlertViewDelegate {
    
    var is_alert = false
    
    var BGView:UIView!
    var pickView:UIView!
    var ieee:String! = ""
    
    @IBOutlet weak var tableView: UITableView!
    var curtains:Array<Dictionary<String,String>> = []
    
    func refreshData(){
        switch FAME.tempSensorId {
        case 10:
            self.curtains = FAME.sensors49
        default:
            break
        }
    }
    func handleLongpressGesture(sender: UILongPressGestureRecognizer) {
        
        
        if sender.state == UIGestureRecognizerState.Began {
            let point:CGPoint = sender.locationInView(self.tableView)
            let indexPath:NSIndexPath! = self.tableView.indexPathForRowAtPoint(point)
            if(indexPath != nil){
                let cell:UITableViewCell2! = self.tableView.cellForRowAtIndexPath(indexPath) as! UITableViewCell2
                
                //index = cell.index
                FAME.dev_id = cell.dev_id
                
                FAME.dev_ss_Rname = curtains[indexPath.row]["roomName"] as String!
                FAME.dev_ss_name = curtains[indexPath.row]["name1"] as String!
                self.ieee = curtains[indexPath.row]["ieee"] as String!
                
                self.BGView.hidden = false
                
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.curtains = FAME.sensors49
        print("12344\(FAME.sensors49)")
        if curtains.count == 0 {
            
            let textLabel = UILabel (frame:CGRectMake(self.view.frame.size.width/8,view.frame.size.height/10,self.view.frame.size.width*3/4,view.frame.size.height*4/5))
            textLabel.text = Defined_Tips_none
            
            //textLabel.backgroundColor = UIColor.blackColor()
            textLabel.textColor = UIColor.whiteColor()
            textLabel.textAlignment = NSTextAlignment.Center
            textLabel.numberOfLines = 0;
            textLabel.font = UIFont.systemFontOfSize(25)
            self.view.addSubview(textLabel)
            
            //break
            
        }
            
        else{
            
            
            createPop()
            
            
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        
        
    }
    
    func tapPress( sender : AnyObject){
        
        self.BGView.hidden = true
    }
    
    func createPop(){
        
        self.BGView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.width, height: self.view.frame.height))
        self.BGView.backgroundColor = UIColor.clearColor()
        self.BGView.tag = 500
        
        
        //cancel
        
        let longPressRec = UITapGestureRecognizer()
        longPressRec.addTarget(self, action: "tapPress:")
        
        self.BGView.addGestureRecognizer(longPressRec)
        
        self.BGView.userInteractionEnabled = true
        
        
        
        
        self.pickView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 200 , width: self.view.frame.width, height: 200))
        self.pickView.backgroundColor = UIColor.whiteColor()
        
        
        
        
        //btns
        let btnX:CGFloat = 30
        let btnWidth:CGFloat = self.view.frame.width - btnX * 2
        let btnHeight:CGFloat = 30
        let btnY:CGFloat = 25
        
        let btnS1 = UIButton(frame: CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight))
        btnS1.setTitle(Defined_SS_air_Title1, forState: UIControlState.Normal)
        btnS1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //btnS1.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS1.tag = 1
        btnS1.addTarget(self, action: Selector("btns1Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnS2 = UIButton(frame: CGRect(x: btnX, y: btnY + 50, width: btnWidth, height: btnHeight))
        btnS2.setTitle(Defined_SS_air_Title2, forState: UIControlState.Normal)
        btnS2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnS2.tag = 2
        //btnS2.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS2.addTarget(self, action: Selector("btns2Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnS3 = UIButton(frame: CGRect(x: btnX, y: btnY + 100, width: btnWidth, height: btnHeight))
        
        btnS3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        
        btnS3.tag = 3
        
        if FAME.tempSensorId == 2{
            btnS3.setTitle(Defined_SS_Title4, forState: UIControlState.Normal)
            btnS3.addTarget(self, action: Selector("btns31Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        }
        else{
            btnS3.setTitle("更改设备名", forState: UIControlState.Normal)
            btnS3.addTarget(self, action: Selector("btns3Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        
        self.pickView.addSubview(btnS1)
        self.pickView.addSubview(btnS2)
        self.pickView.addSubview(btnS3)
        //self.pickView.addSubview(btnS4)
        
        self.BGView.addSubview(self.pickView)
        self.view.addSubview(self.BGView)
        self.BGView.hidden = true
        
    }
    //取消
    func btns31Fun(sender:UIButton){
        self.BGView.hidden = true
        
    }
    //更改设备名
    func btns3Fun(sender:UIButton){
        self.BGView.hidden = true
        print("更改设备名")
        let next = GBoard.instantiateViewControllerWithIdentifier("music")
        
        self.navigationController?.pushViewController(next, animated: true)
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        
        
        
    }
    
    //修改名字
    func btns1Fun(sender:UIButton){
        self.BGView.hidden = true
        let next = GBoard.instantiateViewControllerWithIdentifier("viewSS_name") as! ViewControllerSS_name
        next.delegate = self ;
        
        self.navigationController?.pushViewController(next, animated: true)
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
    }
    //删除设备
    func btns2Fun(sender:UIButton){
        self.BGView.hidden = true
        let alertController = UIAlertController(title: "友情提示", message: "请输入密码删除该设备", preferredStyle: UIAlertControllerStyle.Alert);
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .Default,
            handler: {
                action in
                //也可以用下标的形式获取textField let login = alertController.textFields![0]
                let login = alertController.textFields!.first! as UITextField
                print("用户名：\(login.text)=======\(FAME.user_name)34637169")
                
                self.presentedViewController?.dismissViewControllerAnimated(false, completion: nil)
                
                if login.text! == "\(FAME.user_name)34637169"
                {
                    FAME.delDeviceByIeee(self.ieee)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                    
                }
                else{
                    FAME.showMessage("输入的密码不正确")
                }
                
                
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}
extension ViewControllerFBG:ViewControllerSS_nameDelegate{
    func reloadName() {
        FAME.showMessage("名字修改成功");
        
        tableView.reloadData()
        
        
    }
}
extension ViewControllerFBG:UITableViewDataSource,UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return curtains.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell2
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target:self
            , action: "handleLongpressGesture:")
        longpressGesutre.minimumPressDuration = 1.0;
        
        cell .addGestureRecognizer(longpressGesutre)
        
        cell.selectionStyle = .Gray
        let dev_Str:String! = curtains[indexPath.row]["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)
        cell.dev_id = dev_id
        
        
        //name
        let name = cell.viewWithTag(1) as! UILabel
        name.text = curtains[indexPath.row]["name"]
        
        //image      2015-05-21
        let imgObj = cell.viewWithTag(99) as! UIImageView
        
        //if (self.dev_types[indexPath.row] == 15){     //  2015-05-18
            imgObj.image = UIImage(named: "skin_icon.png")      //  2015-05-18
//        }
//        else{
//            imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
//        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        self .performSelector("deselect", withObject: nil, afterDelay: 0.3)
        
        let next :UIViewController! = GBoard.instantiateViewControllerWithIdentifier("viewWeb") as UIViewController!
        FAME.dev_ieee = curtains[indexPath.row]["ieee"]
        next.title = curtains[indexPath.row]["name"]
        self.navigationController?.pushViewController(next, animated: true)
        //
        
        
    }
    func deselect(){
        
        if (tableView.indexPathForSelectedRow != nil){
            tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    
}

import JavaScriptCore

// 定义协议SwiftJavaScriptDelegate 该协议必须遵守JSExport协议
@objc protocol SwiftJavaScriptDelegate: JSExport {
    
    // js调用App的微信支付功能 演示最基本的用法
    func wxPay(orderNo: String)
    
    // js调用App的微信分享功能 演示字典参数的使用
    func wxShare(dict: [String: AnyObject])
    
    // js调用App方法时传递多个参数 并弹出对话框 注意js调用时的函数名
    func showDialog(title: String, message: String)
    
    // js调用App的功能后 App再调用js函数执行回调
    func callHandler(handleFuncName: String)
    
}

// 定义一个模型 该模型实现SwiftJavaScriptDelegate协议
@objc class SwiftJavaScriptModel: NSObject, SwiftJavaScriptDelegate {
    
    weak var controller: UIViewController?
    weak var jsContext: JSContext?
    
    func wxPay(orderNo: String) {
        
        print("订单号：", orderNo)
        
        // 调起微信支付逻辑
    }
    
    func wxShare(dict: [String: AnyObject]) {
        
        print("分享信息：", dict)
        
        // 调起微信分享逻辑
    }
    
    func showDialog(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
        self.controller?.presentViewController(alert, animated: true, completion: nil)
    }
    
    func callHandler(handleFuncName: String) {
        
        let jsHandlerFunc = self.jsContext?.objectForKeyedSubscript("\(handleFuncName)")
        let dict = ["name": "sean", "age": 18]
        jsHandlerFunc?.callWithArguments([dict])
    }
}


class ViewControllerFBGWeb: UIViewController , UIWebViewDelegate
{
    
    @IBOutlet weak var webView: UIWebView!
    
    var jsContext: JSContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button : UIButton = UIButton(frame: CGRectMake(0, 0, 40, 40))
        button.setImage(UIImage(named: "return_white.png"), forState: UIControlState.Normal)
        button.setTitle("返回", forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("backClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
        //self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Bookmarks, target: self, action: Selector("backClick:"))
        testJSContext()
        
        addWebView()
        
    }
    func backClick(sender:AnyObject!){
        
        if self.webView.canGoBack{
            print("1234")
            self.webView.goBack()
        }
        else{
            self.navigationController?.popViewControllerAnimated(true)
        }

    }
    func testJSContext() {
        
        // 通过JSContext执行js代码
        let context: JSContext = JSContext()
        let result1: JSValue = context.evaluateScript("1 + 3")
        print(result1)  // 输出4
        
        // 定义js变量和函数
        context.evaluateScript("var num1 = 10; var num2 = 20;")
        context.evaluateScript("function sum(param1, param2) { return param1 + param2; }")
        
        // 通过js方法名调用方法
        let result2 = context.evaluateScript("sum(num1, num2)")
        print(result2)  // 输出30
        
        // 通过下标来获取js方法并调用方法
        let squareFunc = context.objectForKeyedSubscript("sum")
        let result3 = squareFunc.callWithArguments([10, 20]).toString()
        print(result3)  // 输出30
        
    }
    
    func addWebView() {
        
        
        self.webView.delegate = self
        self.webView.scalesPageToFit = true

        
         //加载网络Html页面 请设置允许Http请求
        let url = NSURL(string: "http://www.famesmart.com/famecloud/re_intf.php?ieee=\(FAME.dev_ieee)")
        let request = NSURLRequest(URL: url!)
        
        self.webView.loadRequest(request)
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
//        self.jsContext = webView.valueForKeyPath("documentView.webView.mainFrame.javaScriptContext") as! JSContext
//        let model = SwiftJavaScriptModel()
//        model.controller = self
//        model.jsContext = self.jsContext
//        
//        // 这一步是将SwiftJavaScriptModel模型注入到JS中，在JS就可以通过WebViewJavascriptBridge调用我们暴露的方法了。
//        self.jsContext.setObject(model, forKeyedSubscript: "WebViewJavascriptBridge")
//        
//        
//         //注册到网络Html页面 请设置允许Http请求
//        let url = NSURL(string: "http://www.famesmart.com/famecloud/re_intf.php?ieee=\(FAME.dev_ieee)")
//        //let curUrl = self.webView.request?.URL?.absoluteString
//        //WebView当前访问页面的链接 可动态注册
//        self.jsContext.evaluateScript(try? String(contentsOfURL: url!, encoding: NSUTF8StringEncoding))
//        
//        self.jsContext.exceptionHandler = { (context, exception) in
//            print("exception：", exception)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        
        
        print(FAME.dev_ieee)
//        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
//        myThread.start()
    }
    func Timerset(){
        let url = NSURL(string: "http://www.famesmart.com/famecloud/re_intf.php?ieee=\(FAME.dev_ieee)")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
}




