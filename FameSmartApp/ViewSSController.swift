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
        let subCell:AnyObject = self.tabelVeiw.visibleCells[index]
            //print(subCell)
        let cell = subCell as! UITableViewCell2
        let name = cell.viewWithTag(2) as! UILabel
        name.text = FAME.dev_ss_Rname + FAME.dev_ss_name ;

    }
    @IBAction func tap(sender : UISwitch2) {
        print(sender.on)
        //var act_id = sender.act_id
        let id = sender.dev_id * 10 + FAME.tempSensorId
        let subCell:AnyObject = self.tabelVeiw.visibleCells[index]
        //print(subCell)
        let cell = subCell as! UITableViewCell2
        let view = cell.viewWithTag(1) as! UIImageView
        
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
        case 7:
            self.sensors = FAME.sensors32
        default:
            break
        }
    }
    func refreshLights(sender:AnyObject!){
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
            tabelVeiw.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "Timerset2")
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
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()
                    
                })
            }
        }else{
            let cmdStr = "{\"cmd\": 33, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"event_id\":\(e_id),\"filter_data\":[\(dev_id),11,17,\(alarm_value)],\"action_id\":\(action_id),\"active\":1}}"
            if  (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90) != nil){
                print("link device successed")
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
        
        if FAME.tempSensorId == 7{
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
        lable.text = self.linkString
        lable.hidden = true
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
        self.timeLabel2.text = "sec"
        
        
        
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
        }else{
            
            let lable1 = self.view.viewWithTag(400) as! UILabel!
            lable1.text = self.linkString
            lable1.hidden = false
            
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
    }
    //设置联动
    func btns1Fun(sender:UIButton){
        self.showId = 0
        FAME.link_id = 1
        self.showVIew2()
    }
    //恢复联动
    func btns74Fun(sender:UIButton){
        self.showId = 0
        FAME.link_id = 0
        self.showVIew2()
    }
    //设置延时联动
    func btns2Fun(sender:UIButton){
        self.showId = 1
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
                
                self.view.endEditing(false)
                
                if login.text! == "\(FAME.user_name)34637169"
                {
                    let cmdStr = "{\"cmd\": 30, \"user_name\": \"\(FAME.user_name)\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":[{\"ieee_addr\":\"\(self.ieee)\"}]}"
                    if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
                        
                        print(recevied)
                        let cmdStr1 = "{\"cmd\": 35, \"user_name\": \"\(FAME.user_name)\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did)}"
                        if let recevied1 = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr1,timeout:90){
                            print(recevied1)
                            
                            let dic:NSMutableDictionary = ["hvaddr":"\(self.ieee)"]
                            
                            
                            
                            FAME.delDeviceArray.removeAllObjects()
                            FAME.delDeviceArray.addObject(dic)
                            
                            FAME.doDeleteDev()
                            self.navigationController?.popToRootViewControllerAnimated(true)
                            //NSNotificationCenter.defaultCenter().postNotificationName("play", object: nil)
                            
                        }
                    }
                    
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
        
    }
    
    func privateCmd(){
        if (httpRequert().downloadFromPostUrlSync(Surl,cmd: self.tmpStr,timeout:8) != nil){
            print("delay-set successed")
            let alert = UIAlertView()
            alert.title = Defined_delay_title
            alert.message =  Defined_delay_update
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
            
        }else{
            let alert = UIAlertView()
            alert.title = Defined_delay_title
            alert.message =  Defined_delay_failed
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
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
        }else{
            print("selectedActBtn")
            print("\(self.seletedStr1)  \(self.seletedStr2) \(self.seletedStr3)")
            linkString = self.seletedStr1 + self.seletedStr2 + " " + self.seletedStr3
            self.hidePop()
            
            self.ids = self.id1 + self.id2
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

        let name_Str:String! = self.sensors[index]["name1"] as String!
        let roomName_Str:String! = self.sensors[index]["roomName"] as String!
        FAME.dev_ss_name = name_Str
        FAME.dev_ss_Rname = roomName_Str

        //print("2222222\(FAME.dev_ss_Rname)")
        
        self.showPop()
        
        let myThread1 = NSThread(target: self, selector: "linkShow", object: nil)
        myThread1.start()
        
        
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
                        self.Links3.append(["name":btn_str,"act_id":inid * 2])
                        inid++
                    }
                    print("3333333\(self.Links3)")
                    
                }else{
                    let cur = self.Links1[row]["curtains"] as! Int!
                    if(cur != nil){
                        self.Links3 = [["name":Defined_mode_on,"act_id":0],["name":Defined_mode_off,"act_id":1]]
                    }else{
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
            }else{
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
                if received.valueForKey("result") as! UInt == 0{
                    
                    var linkid:Int!
                    linkid = received.valueForKey("detail")?.valueForKey("action_id") as! Int
                    
                    self.linkString = FAME.idForNamesMode[linkid]
                    print(self.linkString)
//                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
//                     let lable = self.view.viewWithTag(400) as! UILabel
//                     lable.text = FAME.idForNamesMode[linkid]
//                    })
                    
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
                FAME.showMessage("刷新成功")
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
        cell.selectionStyle = UITableViewCellSelectionStyle.None ;
        //print(self.sensors)
        let dev_Str:String! = self.sensors[indexPath.row]["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)
        FAME.dev_id = dev_id ;
        
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
        linkBtn.index = indexPath.row ;
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
    var airDetail: NSDictionary!;
    var refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.airDetail = NSDictionary();
        let view = self.view.viewWithTag(200) as UIView!
        view.layer.borderColor=UIColor.whiteColor().CGColor;
        view.layer.borderWidth = 1;
        view.layer.cornerRadius=10;
        
        

        
        
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
        
        
    }
    func Timerset(){
        let cmdStr = "{\"cmd\": 42, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"dev_id\":\(FAME.dev_id)}}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
            print("link device successed")
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.airDetail=recevied["detail"] as! NSDictionary;
                let detail=self.airDetail;
                
                let viewpm2_5 = self.view.viewWithTag(300) as! UILabel!;
                let index_Str:Double! = detail["pm2_5"] as! Double!;
                if index_Str == 0{
                    viewpm2_5.text = "0.0";
                }
                else{
                    viewpm2_5.text="\(self.StringSplit(String(index_Str)))";
                }
                
                let viewpm_lable = self.view.viewWithTag(301) as! UILabel!;
                if index_Str <= 70{
                    viewpm_lable.text = "空气质量佳";
                }
                if index_Str >= 130{
                    viewpm_lable.text = "空气质量差";
                }
                else{
                    viewpm_lable.text = "空气质量良";
                }
                
                
                let hcho = self.view.viewWithTag(302) as! UILabel!;
                let index_Str1:Double! = detail["hcho"] as! Double!;
                if index_Str1 == 0{
                    hcho.text = "0.0  mg/M³";
                }
                else{
                    hcho.text="\(self.StringSplit(String(index_Str1)))  mg/M³"
                }
                
                let hcho_lable = self.view.viewWithTag(303) as! UILabel!;
                if index_Str1 >= 0.08{
                    hcho_lable.text = "偏高";
                }
                else{
                    hcho_lable.text = "正常";
                }
                
                
                let temperature = self.view.viewWithTag(304) as! UILabel!;
                let index_Str2:Double! = detail["temperature"] as! Double!;
                if index_Str2 == 0{
                    temperature.text = "0.0  ºC";
                }
                else{
                    temperature.text="\(self.StringSplit(String(index_Str2)))  ºC"
                }
                
                let temperature_lable = self.view.viewWithTag(305) as! UILabel!;
                if index_Str2 >= 50{
                    temperature_lable.text = "偏高";
                }
                else if index_Str2 <= -30{
                    temperature_lable.text = "偏低";
                }
                else{
                    temperature_lable.text = "正常";
                }
                
                let humidity = self.view.viewWithTag(306) as! UILabel!;
                let index_Str3:Double! = detail["humidity"] as! Double!;
                if index_Str3 == 0{
                    humidity.text = "0.0  %RH";
                }
                else{
                    humidity.text="\(self.StringSplit(String(index_Str3)))  %RH"
                }
                let humidity_lable = self.view.viewWithTag(307) as! UILabel!;
                if index_Str3 >= 99{
                    humidity_lable.text = "偏高";
                }
                else if index_Str3 <= 20{
                    humidity_lable.text = "偏低";
                }
                else{
                    humidity_lable.text = "正常";
                }
                
                let update_time = self.view.viewWithTag(308) as! UILabel!;
                update_time.text="更新时间：\(detail["update_time"] as! String)";
                
                
                FAME.showMessage("空气质量刷新成功")

            })
            
            
            
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                FAME.showMessage("空气质量刷新失败")
            })
            
            print("link event failed")
        }

    }
    
    func StringSplit(str: String) -> String{
        var string :String;
        var bool :Int = 0 ;
        for i in str.characters {
            if i == "." {
                bool = bool + 1;
            }
        }
        //if bool == 1{
            let splitedArray=str.componentsSeparatedByString(".");
            if splitedArray.count == 1{
                return str
            }
            else{
            
                let ns3:Int!;
                if (splitedArray[1] as NSString).length == 0 {
                    ns3=0;
                }
                else if (splitedArray[1] as NSString).length == 1 {
                    return str;
                }
                else{
                    ns3 = Int((splitedArray[1] as NSString).substringWithRange(NSMakeRange(1, 1)));
                }
                var ns4:Int! = 0;
                if ns3 >= 5 {
                    ns4=Int((splitedArray[1] as NSString).substringWithRange(NSMakeRange(0, 1)));
                    ns4 = ns4 + 1;
                }
                else{
                    ns4=Int((splitedArray[1] as NSString).substringWithRange(NSMakeRange(0, 1)));
                }
                string=splitedArray[0] as String + "." + String(ns4);
                return string;
            }

//        }
//        else{
//            return str;
//        }
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = FAME.dev_ss_name
        self.nameArray = FAME.rooms;
        
        for(var i = 0; i < self.nameArray.count ; i++){
            if FAME.dev_ss_Rname == self.nameArray[i]{
                count = i ;
            }
        }
        
        let dev_name = self.view.viewWithTag(18) as! UITextField!;
        dev_name.text = FAME.dev_ss_name ;
        
        let room_button = self.view.viewWithTag(19) as! UIButton!;
        room_button .addTarget(self, action: Selector("roomClick:"), forControlEvents: UIControlEvents.TouchUpInside);
        
        
        let sure_button = self.view.viewWithTag(21) as! UIButton!;
        sure_button .addTarget(self, action: Selector("sureClick:"), forControlEvents: UIControlEvents.TouchUpInside);
        
        let room_name = self.view.viewWithTag(20) as! UILabel!;
        room_name.text = FAME.dev_ss_Rname;
        
        
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
        let dev_name = self.view.viewWithTag(18) as! UITextField!;
 
//        let room_name = self.view.viewWithTag(20) as! UILabel!;
//        room_name.text = self.nameArray[count];
        let name:String = dev_name.text as String!
        
        FAME.dev_ss_name = name ;
        
        
        
        let cmdStr = "{\"cmd\": 47,\"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"dev_id\":\(FAME.dev_id), \"name\": \"\(name)\",\"room\":\(count)}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
            
            //print(recevied)
            if recevied["result"] as! NSObject == 0
            {
                //fame.showMessage("111111");
                
                self.delegate?.reloadName();
                self.navigationController?.popViewControllerAnimated(true);
            }
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
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
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
                self.delegate?.showMessage() ;
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
class ViewControllerSS6: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
 
    var BGView:UIView!
    var pickView:UIView!
    var picker:UIPickerView!
    var seletedStr:String! = ""
    var selectCount:Int!
    
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view, typically from a nib.
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshLights:")
//        self.navigationItem.rightBarButtonItem = addButton
        
        if FAME.sensors30.count == 0 {
            let view1 = self.view.viewWithTag(51) as UIView!
            view1.hidden = true
            let view2 = self.view.viewWithTag(52) as UIView!
            view2.hidden = true
            let textLabel = UILabel (frame:CGRectMake(self.view.frame.size.width/8,self.view.frame.size.height/10,self.view.frame.size.width*3/4,self.view.frame.size.height*4/5))
            textLabel.text = Defined_Tips_none
            
            //textLabel.backgroundColor = UIColor.blackColor()
            textLabel.textColor = UIColor.whiteColor()
            textLabel.textAlignment = NSTextAlignment.Center
            textLabel.numberOfLines = 0;
            textLabel.font = UIFont.systemFontOfSize(25)
            self.view.addSubview(textLabel)
            return ;
            
        }

        let lable1 = self.view.viewWithTag(77) as! UILabel!
        lable1.text = FAME.sensors30[0]["name"]! as String
        
        let view = self.view.viewWithTag(51) as UIView!
        view.layer.borderColor=UIColor.whiteColor().CGColor;
        view.layer.borderWidth = 1;
        view.layer.cornerRadius=10;
        
        let setButton = self.view.viewWithTag(70) as! UIButton!
        setButton.addTarget(self, action: Selector("actSetBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        for i in 501...506 {
            let searchButton = self.view.viewWithTag(i) as! UIButton!
            searchButton.addTarget(self, action: Selector("actAddBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
        
        

        
        
    }
    func Timerset(){
        let act_id = FAME.sensors30[0]["act_id"]! as String
        let act_idInt:Int! = Int(act_id)
        print(act_idInt)
        
        let cmdStr = "{\"cmd\": 32, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"action_id\":\(act_idInt + 2)}}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
            
            
        }
    }
    func actSetBtn(sender:UIButton!){
        
        print("点击了设定按钮")
        
        
        
        
    }
    func actAddBtn(sender:UIButton!){
        
        print("点击了选择按钮")
        self .createPop() ;
        self.selectCount = sender.tag - 430 ;
        
    }
    func selectedActBtn(sender : AnyObject){
        
        print(self.selectCount)
        self.BGView.hidden = true ;
        let lable1 = self.view.viewWithTag(self.selectCount) as! UILabel!;
        lable1.text = self.seletedStr;
        
        
        
        
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
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        self.seletedStr = FAME.models[row]["name"] as String!
        print("pickerView selected:\(self.seletedStr)")
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}


