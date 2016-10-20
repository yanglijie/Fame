//
//  viewApplsController.swift
//  FameSmartApp
//
//  Created by Eric on 14-8-12.
//  Copyright (c) 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

import UIKit


//*********************
//
//   viewController of  lights  and sensors
//
//*********************

class ViewControllerLight: UIViewController,UITableViewDataSource,UITableViewDelegate, ViewControllerSS_nameDelegate,UIAlertViewDelegate {
    
    var BGView:UIView!
    var pickView:UIView!
    
    var pickView1:UIView!
    var pickView2:UIView!
    
    var showId:Int = 0
    
    var viewSlider:UISlider!
    var picker:UIPickerView!
    var selecedCell:UITableViewCell2!
    var btnAdd:UIButton!
    var btnDe:UIButton!
    var timeLabel:UILabel!
    var timeLabel2:UILabel!
    var tmpStr:String!
    var lightIdArr:Array<Int> = []
    var selectDevid1:Int = 0
    var selectDevid2:Int = 0
    
    var act = 0
    var seletedStr1:String! = ""
    var seletedStr2:String! = ""
    var seletedStr3:String! = ""
    var seletedBtn :UIButton2!
    
    var ieee:String! = ""
    var subValue:String! = ""
    
    var roomIndex : Int = 0
    
    
    var view1 = UIScrollView()
    var indexCount : Array<Dictionary<String,String>> = []
    var indexRoom : Int! = 1000
    var right : Bool = false
    
    
    var sensors:Array<Dictionary<String,String>> = []
    var lights:Array<Dictionary<String,String>> = []
    
    
    var LinkView:UIView!
    
    var ChooseLinkView:UIView!
    
    var thread:NSThread!
    
    //门锁ActionId
    var lockId:Int = 0
    
    func TimersetLink(){
        let cmdStr = "{\"cmd\": 36, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"operation\":0,\"dev_id1\":\(selectDevid1),\"dev_id2\":\(selectDevid2)}}"
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90)
        
        if( received != nil){
            if received.valueForKey("error_code") as! UInt == 0{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    FAME.showMessage("联动配置成功")
                    
                })
            }
            else{
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    FAME.showMessage("联动配置失败")
                    
                })
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                FAME.showMessage("联动配置失败")
                
            })
        }
    }
    func reloadName() {
        FAME.showMessage("名字修改成功");

        refreshData()
        data(roomIndex)

        TableView.reloadData()
        
        
    }
    
    func handleLongpressGesture(sender: UILongPressGestureRecognizer) {


        if sender.state == UIGestureRecognizerState.Began {
            let point:CGPoint = sender.locationInView(self.TableView)
            let indexPath:NSIndexPath! = self.TableView.indexPathForRowAtPoint(point)
            if(indexPath != nil){
                let cell:UITableViewCell2! = self.TableView.cellForRowAtIndexPath(indexPath) as! UITableViewCell2

                FAME.dev_id = cell.dev_id
                
                let type_Str:String! = indexCount[indexPath.row]["dev_type"] as String!
                let type:Int! = Int(type_Str)
                FAME.dev_type = type
                
                FAME.dev_ss_name = indexCount[indexPath.row]["name1"]
                FAME.dev_ss_Rname = indexCount[indexPath.row]["roomName"]
                lockId = Int(indexCount[indexPath.row]["act_id"] as String!)!
                if FAME.dev_type == 11{
                    
                    selectDevid1 = cell.dev_id
                }
                
                
                if FAME.tempSensorId == 1{
                    let index1 = indexCount[indexPath.row]["index"] as String!
                    FAME.variation_index = Int(index1)
                    
                    FAME.subNames[FAME.dev_id]![FAME.variation_index] = indexCount[indexPath.row]["subValue"]!
                   
                    
                    
                }

              
                for(var i = 0; i < FAME.rooms.count ; i++){
                    if FAME.dev_ss_Rname == FAME.rooms[i]{
                        roomIndex = i
                    }
                }
                
                self.ieee = indexCount[indexPath.row]["ieee"] as String!
                
                createPop()
                self.BGView.hidden = false
                
            }
        }

    }
    func tapPress( sender : AnyObject){
        
        self.BGView.hidden = true
        
    }
    func tapPress2( sender : AnyObject){
        
        LinkView.hidden = true
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
        //btnS3.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS3.tag = 3
        
        if FAME.dev_type == 11{
            
            btnS3.setTitle(Defined_SS_air_Title3, forState: UIControlState.Normal)
            btnS3.addTarget(self, action: Selector("btns4Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        }
        else if FAME.dev_type == 31{
            
            btnS3.setTitle("常开状态设置", forState: UIControlState.Normal)
            btnS3.addTarget(self, action: Selector("btns41Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        else{
            btnS3.setTitle(Defined_SS_Title4, forState: UIControlState.Normal)
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
    
    //常开状态设置
    func btns41Fun(sender:UIButton){
        self.BGView.hidden = true
        print("常开状态设置")
        
        let alert :UIAlertView = UIAlertView()
        alert.delegate = self
        alert.title = "友情提示"
        alert.message = "切换常开状态"
        alert.addButtonWithTitle("设置常开")
        alert.addButtonWithTitle("取消常开")
        alert.show()
        
        print(lockId)
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        print("click at \(buttonIndex)")
        if buttonIndex == 0{
            httpRequert().sendRequest(lockId + 3)
            print("设置常开")
            
        }
        else{
            httpRequert().sendRequest(lockId + 2)
            print("取消常开")
        }
        
    }
    //设置联动
    func btns4Fun(sender:UIButton){
        self.BGView.hidden = true
        print("设置联动")
        
        let select = FAME.linkYB[0]["dev_id"] as String!
        selectDevid2 = Int(select)!
        
        print("select1= \(selectDevid1)select2= \(selectDevid2)")
        
        createLinkView()
        LinkView.hidden = false
        
    }
    //取消
    func btns3Fun(sender:UIButton){
        self.BGView.hidden = true
        
    }
    //修改名字
    func btns1Fun(sender:UIButton){
        self.BGView.hidden = true
        let next = GBoard.instantiateViewControllerWithIdentifier("viewSS_name") as! ViewControllerSS_name
        next.delegate = self 
        
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
                print("用户名：\(login.text!)===\(FAME.user_name)34637169")
                
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

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
        //NSThread.currentThread().cancel()
        
        //thread .cancel()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        
//        if NSThread.currentThread().executing{
//            print("杀死")
//            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//            
//            //NSThread.exit()
//        }
        
    }
    // returns the number of 'columns' to display.
    

    var imageName : String! = ""
    @IBOutlet var TableView : UITableView!
    //开
    @IBAction func lightTap(sender : UIButton2) {
        print(FAME.lightsCellState)
        let view = sender.superview?.viewWithTag(2) as! UIImageView
        view.image = UIImage(named: "socket_10.png")
        let imgObj = sender.superview?.viewWithTag(99) as! UIImageView
        imgObj.image = UIImage(named: Defined_SA_icons1[FAME.tempSensorId])
        
        if FAME.tempSensorId == 1 || FAME.tempSensorId == 6{
            FAME.lightsCellState["\(sender.id)"] = 1
        }
        else{
            FAME.socketsCellState["\(sender.id)"] = 1
        }
        httpRequert().sendRequest(sender.act_id)
//        print("sender.act_id开\(sender.id)")
        print("sender.act_id开\(sender.act_id)")
        //print(FAME.lightsCellState)

    }
    @IBAction func lightTap2(sender : UIButton2) {
        
        let view = sender.superview?.viewWithTag(2) as! UIImageView
        view.image = UIImage(named: "socket_06.png")
        let imgObj = sender.superview?.viewWithTag(99) as! UIImageView
        imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
        if FAME.tempSensorId == 1 || FAME.tempSensorId == 6{
            FAME.lightsCellState["\(sender.id)"] = 0
        }
        else{
            FAME.socketsCellState["\(sender.id)"] = 0
        }
        httpRequert().sendRequest(sender.act_id)
//        print("sender.act_id关\(sender.id)")
        print("sender.act_id关\(sender.act_id)")
        //print(FAME.lightsCellState)
        
    }
    func refreshData(){
        switch FAME.tempSensorId {
        case 1:
            self.lights = FAME.lights7
        case 5:
            self.lights = FAME.socket13
        case 6:
            self.lights = FAME.lights11
        case 7:
            self.lights = FAME.socket31
        case 9:
            self.lights = FAME.socket33
            
        default:
            break
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        if self.lights.count == 0 {
            
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
            data(0)
            swipeView()
            
            
            if FAME.tempSensorId == 6{
                
                selectDevid()
                view1.hidden = true
            }
            else{
                TableView.transform = CGAffineTransformMakeTranslation(WIDTH/3 , 0)
            }
            
            

            TableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshLights")
            TableView.mj_header.beginRefreshing()
            
            
            
        }

        
        
        
    }
    func selectDevid(){
        var paramArray:Array<Int> = []
        var lastId = "0"
        for value in indexCount {
            let AddedObj = value as NSDictionary
            let dev_id:String! = AddedObj["dev_id"] as! String
            if lastId != dev_id {
                paramArray.append(Int(dev_id)!)
                lastId = dev_id as String
            }
            
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        FAME.tempTableView = self.TableView
   
        
    }
    
    func refreshLights(){
        print("refreshLights")
        //self.TableView!.reloadData()
        if indexCount.count == 0{
            self.TableView.mj_header.endRefreshing()
            FAME.showMessage("刷新成功")
        }
        else{
            
            thread = NSThread(target: self, selector: "Timerset", object: nil)
            thread.start()
            
        }
        
        
        
    }
    
    func Timerset(){
        //get the state

        
        //create the post string
       UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        
        
        if FAME.tempSensorId == 1 || FAME.tempSensorId == 6{
            FAME.lights = indexCount
            if FAME.refreshLightState() {
                
                self.TableView.mj_header.endRefreshing()
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    //FAME.showMessage("刷新成功")
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                })
                
                
                //print("3333333\(FAME.lightsCellState)")
                
                //set the state
                for subCell:AnyObject in self.TableView!.visibleCells {
                    //print(subCell)
                    let cell = subCell as! UITableViewCell2
                    let view = cell.viewWithTag(2) as! UIImageView
                    let imgObj = cell.viewWithTag(99) as! UIImageView
                    //print(FAME.lightsCellState)
                    let state :Int! = FAME.lightsCellState["\(cell.id)"]
                    
                    //print("id == \(cell.id)")
                    
                    
                    let type:Int! = cell.type
                    
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        if (state != nil) {
                            
                            //print("state:\(state)")
                            if state == 1 {
                                view.image = UIImage(named: "socket_10.png")
                                if type == 11 {
                                    imgObj.image = UIImage(named: "panel_icon1.png")
                                }
                                else{
                                    imgObj.image = UIImage(named: Defined_SA_icons1[FAME.tempSensorId])
                                }
                            }else {
                                view.image = UIImage(named: "socket_06.png")
                                if type == 11 {
                                    imgObj.image = UIImage(named: "panel_icon.png")
                                }
                                else{
                                    imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
                                }
                            }
                        }
                        else{
                            if type == 11 {
                                imgObj.image = UIImage(named: "panel_icon.png")
                            }
                            else{
                                imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
                            }
                        }
                    })
                }
            }
            else{
                self.TableView.mj_header.endRefreshing()
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    FAME.showMessage("刷新失败，网络超时 请检查中控")
                })
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }

        }
        else{
            let paramArray = NSMutableArray()
            var lastId = "0"
            
            for value in lights {
                let AddedObj = value as NSDictionary
                let dev_id:NSString! = AddedObj["dev_id"] as! NSString
                if lastId != dev_id {
                    paramArray.addObject(dev_id)
                    lastId = dev_id as String
                }
            }
            
            
            let param = paramArray.componentsJoinedByString(",")
            let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 19, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": [\(param)]}",timeout : 60)
            
            if (received != nil){
                
                self.TableView.mj_header.endRefreshing()
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    //FAME.showMessage("刷新成功")
                })
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                //got the state
                for values:AnyObject in received.valueForKey("states") as! NSArray {
                    print(values)
                    let AddedObj = values as! NSDictionary
                    let ADDieee_addr :Int!  = AddedObj.valueForKey("id") as! Int
                    let ADDflag :Int!  = AddedObj.valueForKey("state") as! Int
                    var id = ADDieee_addr * 10
                    if FAME.tempSensorId == 9{
                        FAME.lightsCellState["\(id)"] = ADDflag
                    }
                    else{
                        if ADDflag >= 1 {
                            id = ADDieee_addr * 10
                            FAME.lightsCellState["\(id)"] = 1
                        }else{
                            id = ADDieee_addr * 10
                            FAME.lightsCellState["\(id)"] = 0
                        }

                    }
                }
                //set the state
                
                for subCell:AnyObject in self.TableView!.visibleCells {
                    //print(subCell)
                    let cell = subCell as! UITableViewCell2
                    let view = cell.viewWithTag(2) as! UIImageView
                    let imgObj = cell.viewWithTag(99) as! UIImageView
                    let view1 = cell.viewWithTag(86) as! UIImageView
                    //print(FAME.lightsCellState)
                    let state :Int! = FAME.lightsCellState["\(cell.id)"]
                    
                    print("id == \(cell.id)")
                    
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        if (state != nil) {
                            if FAME.tempSensorId == 9{
                                let number = String(state,radix:2)
                                //print("state:\(state)")
                                
                                switch Int(number)! {
                                case 0:
                                    //完全关闭
                                    view.image = UIImage(named: "socket_06.png")
                                    imgObj.image = UIImage(named: "cta_stop.png")
                                case 10000:
                                    //节能模式
                                    view.image = UIImage(named: "socket_10.png")
                                    imgObj.image = UIImage(named: "cta_unuse.png")
                                case 10011:
                                    //3速打开
                                    view.image = UIImage(named: "socket_10.png")
                                    imgObj.image = UIImage(named: "cta_open.png")
                                    view1.image = UIImage(named: "speed3.png")
                                case 11001:
                                    //2速打开
                                    view.image = UIImage(named: "socket_10.png")
                                    imgObj.image = UIImage(named: "cta_open.png")
                                    view1.image = UIImage(named: "speed2.png")
                                case 10101:
                                    //1速打开
                                    view.image = UIImage(named: "socket_10.png")
                                    imgObj.image = UIImage(named: "cta_open.png")
                                    view1.image = UIImage(named: "speed1.png")
                                default:
                                    view.image = UIImage(named: "socket_06.png")
                                    imgObj.image = UIImage(named: "cta_close.png")
                                    break
                                }
                                
                            }
                            else{
                                if state == 1 {
                                    view.image = UIImage(named: "socket_10.png")
                                    imgObj.image = UIImage(named: Defined_SA_icons1[FAME.tempSensorId])
                                }else {
                                    view.image = UIImage(named: "socket_06.png")
                                    imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
                                }
                            }
                            
                        }
                        else{
                            view.image = UIImage(named: "socket_06.png")
                            if FAME.tempSensorId == 9{
                                imgObj.image = UIImage(named: "cta_close.png")
                            }
                            else{
                                imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
                            }
                            
                        }
                    })
                }
            }else{
                print("get the state failed")
                self.TableView.mj_header.endRefreshing()
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    FAME.showMessage("刷新失败，网络超时 请检查中控")
                })
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }

        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.indexCount.count
        //return FAME.lights.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        tableView
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell2
        cell.backgroundColor = UIColor.clearColor()
        
        
        
        //let showId = self.lightIdArr[indexPath.row]
        
        
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target:self
            , action: "handleLongpressGesture:")
        longpressGesutre.minimumPressDuration = 1.0
        
        cell .addGestureRecognizer(longpressGesutre)
        
        cell.selectionStyle = .Gray
        
        
        let dev_Str:String! = indexCount[indexPath.row]["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)
        
        let index_Str:String! = indexCount[indexPath.row]["index"] as String!
        let index:Int! = Int(index_Str)
        
        let type_Str:String! = indexCount[indexPath.row]["dev_type"] as String!
        let type:Int! = Int(type_Str)
        cell.type = type
        
        
        //cell.tag = dev_id * 10 + index
        
        cell.dev_id = dev_id
        
        cell.id = dev_id * 10 + index
        
        //name
        let name = cell.viewWithTag(1) as! UILabel
        name.text = indexCount[indexPath.row]["name"]
        
        
        
        
        //image      2015-05-21
        let imgObj = cell.viewWithTag(99) as! UIImageView
        
        
        
        //on off
        let tag:AnyObject! = cell.viewWithTag(3)
        if (tag != nil) {
            let tagOn = cell.viewWithTag(3) as! UIButton2!
            let tagOff = cell.viewWithTag(4) as! UIButton2!
            let act_Str:String! = indexCount[indexPath.row]["act_id"] as String!
            
            let act_id:Int = Int(act_Str)!
            //print("2222222\(act_id)")
            tagOn.act_id = act_id + 1
            tagOff.act_id = act_id
            tagOn.id = cell.tag
            tagOff.id = cell.tag
            
            
            
            let view = cell.viewWithTag(2) as! UIImageView
            let state :Int! = FAME.lightsCellState["\(cell.id)"]
            //let state :Int? = NSUserDefaults.standardUserDefaults().valueForKey("\(tagOn.id)") as? Int
          let view1 = cell.viewWithTag(86) as! UIImageView
          
            
            if (state != nil) {
                //print("state:\(state)")
                
                if FAME.tempSensorId == 9{
                    let number = String(state,radix:2)
                    //print("state:\(state)")
                    
                    switch Int(number)! {
                    case 0:
                        //完全关闭
                        view.image = UIImage(named: "socket_06.png")
                        imgObj.image = UIImage(named: "cta_stop.png")
                        
                    case 10000:
                        //节能模式
                        view.image = UIImage(named: "socket_10.png")
                        imgObj.image = UIImage(named: "cta_unuse.png")
                    case 10011:
                        //3速打开
                        view.image = UIImage(named: "socket_10.png")
                        imgObj.image = UIImage(named: "cta_open.png")
                        view1.image = UIImage(named: "speed3.png")
                    case 11001:
                        //2速打开
                        view.image = UIImage(named: "socket_10.png")
                        imgObj.image = UIImage(named: "cta_open.png")
                        view1.image = UIImage(named: "speed2.png")
                    case 10101:
                        //1速打开
                        view.image = UIImage(named: "socket_10.png")
                        imgObj.image = UIImage(named: "cta_open.png")
                        view1.image = UIImage(named: "speed1.png")
                    default:
                        view.image = UIImage(named: "socket_06.png")
                        imgObj.image = UIImage(named: "cta_close.png")
                        break
                    }
                    
                }

                else{
                    if state == 1 {
                        view.image = UIImage(named: "socket_10.png")
                        if type == 11 {
                            imgObj.image = UIImage(named: "panel_icon1.png")
                        }
                        else{
                            imgObj.image = UIImage(named: Defined_SA_icons1[FAME.tempSensorId])
                        }
                    }else {
                        view.image = UIImage(named: "socket_06.png")
                        if type == 11 {
                            imgObj.image = UIImage(named: "panel_icon.png")
                        }
                        else{
                            imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
                        }
                    }
                }
                
            }else{
                view.image = UIImage(named: "socket_06.png")
                if type == 11 {
                    imgObj.image = UIImage(named: "panel_icon.png")
                }
                else if FAME.tempSensorId == 9{
                    imgObj.image = UIImage(named: "cta_close.png")
                }
                else{
                    imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
                }
            }
            
            tagOn.hidden = false
            tagOff.hidden = false
            view.hidden = false
            
            //conLight
            
            
            
            if type == 11 {
                tagOn.hidden = true
                tagOff.hidden = true
                view.hidden = true

                
                
                
                print("set the \(name) hide")
            }
            
        }
        

        
        return cell
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
        
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //self .performSelector("deselect", withObject: nil, afterDelay: 0.5)
        
        TableView.transform = CGAffineTransformMakeTranslation(0 , 0)
        
        view1.hidden = true
        self.right = true
        
    }
    func deselect(){
        
        if (TableView.indexPathForSelectedRow != nil){
            TableView.deselectRowAtIndexPath(TableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
//    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
//        
//        return UITableViewCellEditingStyle.Delete
//    }
//    
//    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
//    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        print(indexPath.row)
//        //***********************
//        
//        let showId = self.lightIdArr[indexPath.row]
//        let ieee : String! = FAME.lights[showId]["ieee"]
//        
//        FAME.delDeviceByIeee(ieee)
//        
//        //tableView.reloadData()
//    }
//    
//    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
//        
//        return Defined_Delete
//        
//    }
    
    
    //侧滑
    
    func swipeView(){
        view1 = UIScrollView(frame: CGRectMake(0, 64, WIDTH/3, HEIGHT))
        view1.backgroundColor = UIColor.grayColor()
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
        TableView.addGestureRecognizer(swipeLeftGesture)
        
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipeGesture:")
        TableView.addGestureRecognizer(swipeGesture)
    }
    
    func handleSwipeGesture(sender: UISwipeGestureRecognizer){
        
        //判断是上下左右
        
        if right{
            
            
            TableView.transform = CGAffineTransformMakeTranslation(WIDTH/3 , 0)
            view1.hidden = false
            self.right = false
            
        }
        else{
            
            TableView.transform = CGAffineTransformMakeTranslation(0 , 0)
            
            view1.hidden = true
            self.right = true
        }
        
        
    }
    
    func data(indeex : Int) {
        //super.viewWillAppear(animated)
        if indexCount.count != 0{
            indexCount.removeAll()
        }
        for i in 0..<lights.count{
            //FAME.lights[i]["room"]
            
            if Int(lights[i]["room"]!)! == indeex{
                
                indexCount.append(lights[i])
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
        
        self.TableView.mj_header.endRefreshing()
        data(sender.tag - 1000)
        
        TableView.reloadData()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        indexRoom = sender.tag
        //print("11111\(sender.tag)")
    }

    func createLinkView(){
        LinkView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.width, height: self.view.frame.height))
        LinkView.backgroundColor = UIColor.clearColor()
        LinkView.hidden = true
        self.view .addSubview(LinkView)
        //cancel
        
        let longPressRec = UITapGestureRecognizer()
        longPressRec.addTarget(self, action: "tapPress2:")
        
        LinkView.addGestureRecognizer(longPressRec)
        
        LinkView.userInteractionEnabled = true
        
        let backView = UIView(frame: CGRect(x: self.view.frame.width * 0.15, y: self.view.frame.height * 0.4 , width: self.view.frame.width * 0.7, height: self.view.frame.height * 0.3))
        backView.backgroundColor = UIColor.whiteColor()
        LinkView .addSubview(backView)
        
        let lable = UILabel(frame: CGRect(x: 20, y: 10 , width: backView.frame.width - 40, height: backView.frame.height * 0.2))
        lable.tag = 122
        lable.text = FAME.dev_ss_Rname + FAME.dev_ss_name
        lable.textColor = UIColor.greenColor()
        backView .addSubview(lable)
        
        let view2 = UIView(frame: CGRect(x: 20, y: 10 + backView.frame.height * 0.2 , width: backView.frame.width - 40, height: 1))
        view2.backgroundColor = UIColor.blackColor()
        backView .addSubview(view2)
        
        let btnS2 = UIButton(frame: CGRect(x: 20, y: backView.frame.height * 0.4, width: backView.frame.width - 40, height: backView.frame.height * 0.17))
        btnS2.backgroundColor = UIColor.grayColor()
        btnS2.addTarget(self, action: Selector("btns5Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        backView .addSubview(btnS2)
        
        let lable1 = UILabel(frame: CGRect(x: 5, y: 0 , width: btnS2.frame.width * 0.7, height: btnS2.frame.height))
        
        lable1.text = FAME.linkYB[0]["name"]
        btnS2 .addSubview(lable1)
        let image = UIImageView(frame: CGRect(x: btnS2.frame.width - btnS2.frame.height * 0.5 - 10, y: btnS2.frame.height * 0.25 , width: btnS2.frame.height * 0.5, height: btnS2.frame.height * 0.5))
        image.image = UIImage(named: "about_us_icon.png")
        btnS2 .addSubview(image)
        
        
        
        let btnS3 = UIButton(frame: CGRect(x: 20, y: backView.frame.height * 0.75, width: backView.frame.width - 40, height: backView.frame.height * 0.17))
        btnS3.setTitle("确定", forState: UIControlState.Normal)
        btnS3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnS3.setBackgroundImage(UIImage(named: "yuba_spinner_press.png"), forState: UIControlState.Normal)
        btnS3.setBackgroundImage(UIImage(named: "curtain_04_10.png"), forState: UIControlState.Highlighted)
        btnS3.addTarget(self, action: Selector("btns6Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        backView .addSubview(btnS3)
    }
    
    //设置联动
    func btns5Fun(sender:UIButton){
        
        
        createChooseLink()
        ChooseLinkView.hidden = false
        
    }
    //确定联动
    func btns6Fun(sender:UIButton){
        
        LinkView.hidden = true
        
        let myThread = NSThread(target: self, selector: "TimersetLink", object: nil)
        myThread.start()
        
    }
    //选择关联的浴霸
    func btns7Fun(sender:UIButton){
        
        ChooseLinkView.hidden = true
        let linkString = FAME.linkYB[sender.tag - 45]["name"]
        
        let lable = self.view.viewWithTag(122) as! UILabel
        lable.text = linkString
        
        let select = FAME.linkYB[sender.tag - 45]["dev_id"] as String!
        selectDevid2 = Int(select)!
        
        print("select1= \(selectDevid1)select2= \(selectDevid2)")
        
        
    }
    func tapPress1( sender : AnyObject){
 
        ChooseLinkView.hidden = true
        
    }
    
    func createChooseLink(){
        ChooseLinkView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.width, height: self.view.frame.height))
        ChooseLinkView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        ChooseLinkView.hidden = true
        self.view .addSubview(ChooseLinkView)
        //cancel
        
        let longPressRec = UITapGestureRecognizer()
        longPressRec.addTarget(self, action: "tapPress1:")
        
        ChooseLinkView.addGestureRecognizer(longPressRec)
        
        ChooseLinkView.userInteractionEnabled = true
        
        let btnDiff = HEIGHT * 0.06
        let btnTop0:CGFloat = HEIGHT * 0.52 - btnDiff
        var y = btnTop0
        print("3444343434====\(FAME.linkYB)")
        for i in 0..<FAME.linkYB.count{
            y = y + btnDiff
            let btnS2 = UIButton(frame: CGRect(x: WIDTH * 0.15 + 20, y: y  , width: WIDTH * 0.7 - 40, height: btnDiff))

            btnS2.backgroundColor = UIColor.whiteColor()

            btnS2.tag = 45
            
            btnS2.setTitle(FAME.linkYB[i]["name"], forState: UIControlState.Normal)
            btnS2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            btnS2.addTarget(self, action: Selector("btns7Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
            ChooseLinkView .addSubview(btnS2)
            
        }
        
        
        
    }
    
}


class ViewControllerApplas: UIViewController,UIAlertViewDelegate {

    var actId :Int!
    @IBOutlet var btnImg : UIImageView!
    
    @IBOutlet weak var btnTmp1: UIButton!
    
    @IBOutlet weak var btnTmp2: UIButton!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    
    @IBOutlet weak var btn4: UIButton!
    
    
    var isLearn:Bool = true
    
    func refreshData(){
        
    }
    @IBAction func downUp(sender : UIButton) {
        if(FAME.saActid4 == 16){
            self.btnImg.image = UIImage(named: "appl_16_button1_press2.png")
        }
        if(FAME.saActid4 == 17){
            self.btnImg.image = UIImage(named: "appl_17_button1_press2.png")
        }
        if(FAME.saActid4 == 18){
            self.btnImg.image = UIImage(named: "appl_18_button1_press2.png")
        }
        
    }
    @IBAction func downLeft(sender : UIButton) {
        if(FAME.saActid4 == 16){
            self.btnImg.image = UIImage(named: "appl_16_button1_press5.png")
        }
        if(FAME.saActid4 == 17){
            self.btnImg.image = UIImage(named: "appl_17_button1_press5.png")
        }
        if(FAME.saActid4 == 18){
            self.btnImg.image = UIImage(named: "appl_18_button1_press5.png")
        }
    }
    @IBAction func downRight(sender : UIButton) {
        if(FAME.saActid4 == 16){
            self.btnImg.image = UIImage(named: "appl_16_button1_press3.png")
        }
        if(FAME.saActid4 == 17){
            self.btnImg.image = UIImage(named: "appl_17_button1_press3.png")
        }
        if(FAME.saActid4 == 18){
            self.btnImg.image = UIImage(named: "appl_18_button1_press3.png")
        }
    }
    @IBAction func downDown(sender : UIButton) {
        if(FAME.saActid4 == 16){
            self.btnImg.image = UIImage(named: "appl_16_button1_press4.png")
        }
        if(FAME.saActid4 == 17){
            self.btnImg.image = UIImage(named: "appl_17_button1_press4.png")
        }
        if(FAME.saActid4 == 18){
            self.btnImg.image = UIImage(named: "appl_18_button1_press4.png")
        }
    }
    @IBAction func downOk(sender : UIButton) {
        if(FAME.saActid4 == 16){
            self.btnImg.image = UIImage(named: "appl_16_button1_press1.png")
        }
        if(FAME.saActid4 == 17){
            self.btnImg.image = UIImage(named: "appl_17_button1_press1.png")
        }
        if(FAME.saActid4 == 18){
            self.btnImg.image = UIImage(named: "appl_18_button1_press1.png")
        }
    }
    
    @IBAction func downCancel(sender : UIButton) {
        self.btnImg.image = UIImage(named: "radio_03.png")
    }
    
    @IBAction func downApplay(sender : UIButton) {
        if(FAME.saActid4 == 16){
            self.btnImg.image = UIImage(named: "appl_16_button1_normal.png")
        }
        if(FAME.saActid4 == 17){
            self.btnImg.image = UIImage(named: "appl_17_button1_normal.png")
        }
        if(FAME.saActid4 == 18){
            self.btnImg.image = UIImage(named: "appl_18_button1_normal.png")
        }
        print("OKOKOK")
  
        var act_id = sender.tag * 2 + FAME.tempApplsId - 2
        if self.isLearn {
            act_id = act_id + 1
        }
        print("actid=\(act_id)")
        httpRequert().sendRequest(act_id)
    }
    
    @IBAction func downApplayOut(sender : UIButton) {
        if(FAME.saActid4 == 16){
            self.btnImg.image = UIImage(named: "appl_16_button1_normal.png")
        }
        if(FAME.saActid4 == 17){
            self.btnImg.image = UIImage(named: "appl_17_button1_normal.png")
        }
        if(FAME.saActid4 == 18){
            self.btnImg.image = UIImage(named: "appl_18_button1_normal.png")
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        creatLearnView()
//        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "insertNewObject:")
//        self.navigationItem.rightBarButtonItem = addButton
        
    }
    func creatLearnView(){
        let button = UIButton(frame: CGRectMake(0,0,35,35))
        if self.isLearn{
            button.setBackgroundImage(UIImage(named: "appl_learn_normal.png"), forState: UIControlState.Normal)
        }
        else{
            button.setBackgroundImage(UIImage(named: "appl_learn_isleanrning.png"), forState: UIControlState.Normal)
        }
        button.addTarget(self, action: Selector("insertNewObject:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    func insertNewObject(sender:AnyObject!){
        print("learn")
        if self.isLearn {
            
            let alert = UIAlertView()
            alert.delegate = self
            alert.title = Defined_VC6_AlertTitle
            alert.message =  Defined_VC6_AlertMessage1
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.addButtonWithTitle(Defined_ALERT_CANCEL)
            alert.show()
            
            
            
        }else{
            self.isLearn = true
            creatLearnView()
            
        }
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex)
        if buttonIndex == 0{
            self.isLearn = false
            creatLearnView()
            FAME.showMessage("学习模式已经开启")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        print(FAME.saActid4)
        
        let array = FAME.button_names[FAME.dev_id]
        
        
        btn1.setTitle("\(array![9] as! String)", forState: UIControlState.Normal)
        btn2.setTitle("\(array![10] as! String)", forState: UIControlState.Normal)
        btn3.setTitle("\(array![11] as! String)", forState: UIControlState.Normal)
        btn4.setTitle("\(array![12] as! String)", forState: UIControlState.Normal)
        

        if(FAME.saActid4 == 17){
            print("电视机tvtvtv")
            
            btnImg.image = UIImage(named: "appl_17_button1_normal.png")
            
            self.btnTmp1.setBackgroundImage(UIImage(named:"tv_07-03.png"), forState:UIControlState.Normal)
            self.btnTmp1.setTitle("HOME", forState:UIControlState.Normal)
            
            self.btnTmp2.setBackgroundImage(UIImage(named:"tv_07-03.png"), forState:UIControlState.Normal)
            self.btnTmp2.setTitle(Defined_btn_return, forState:UIControlState.Normal)
            
        }
        if(FAME.saActid4 == 16){
            print("电视机tvtvtv")
            
            btnImg.image = UIImage(named: "appl_16_button1_normal.png")
        }
        
    }
    
}

class ViewControllerCurtains: UIViewController {
    var isLearn:Bool = false
    
    var BGView:UIView!
    var pickView:UIView!
    
    
    var viewSlider:UISlider!

    var btnAdd:UIButton!
    var btnDe:UIButton!
    var timeLabel:UILabel!
    var timeLabel2:UILabel!
    var tmpStr:String!
    
    var dev_id:Int!
    
    @IBOutlet weak var setButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setButton.layer.borderColor=UIColor(red: 102, green: 153, blue: 153, alpha: 0.4).CGColor
        setButton.layer.borderWidth = 1
        setButton.layer.cornerRadius = 2
        
        self.dev_id = FAME.saActid2
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func downApplay(sender : UIButton) {

        print("OKOKOK")
        
        let act_id = sender.tag  + FAME.tempApplsId - 1
        httpRequert().sendRequest(act_id)
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
        
        
        //btns
        //let btnX:CGFloat = 30
        //let btnWidth:CGFloat = self.view.frame.width - btnX * 2
        //let btnHeight:CGFloat = 30
        //let btnY:CGFloat = 25
        
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
        
        
        //Slider
        self.viewSlider = UISlider(frame: CGRect(x: 20, y: 45, width: self.pickView.frame.width - 40 , height: 50))
        self.viewSlider.minimumValue = 0
        self.viewSlider.maximumValue = 255
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
        
        
        self.pickView.addSubview(btn)
        self.pickView.addSubview(btn2)
        self.pickView.addSubview(self.viewSlider)
        self.pickView.addSubview(self.btnAdd)
        self.pickView.addSubview(self.btnDe)
        self.pickView.addSubview(self.timeLabel)
        self.pickView.addSubview(self.timeLabel2)
        
        self.pickView.tag = 501
        self.pickView.alpha = 0.95
        self.BGView.hidden = true
        self.pickView.hidden = true
        self.view.addSubview(self.BGView)
        self.view.addSubview(self.pickView)
    }
    func tapPress(sender:AnyObject!){
        self.hidePop()
    }
    
    @IBAction func showPopBtn(sender: AnyObject) {
        self.createPop()
        self.showPop()
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
    
    func selectedActBtn(sender : AnyObject){
        
        let int:Int = Int(self.viewSlider.value)

        
        self.tmpStr = "{\"cmd\": 41, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"position\":0,\"dev_id\":\(self.dev_id),\"step\":\(int)}}"
        
        let myThread = NSThread(target: self, selector: "privateCmd", object: nil)
        myThread.start()
        
        self.hidePop()

        
        
    }
    
    func cancleActBtn( sender : AnyObject){
        
        print("cancleActBtn")
        //roomSheet.dismissWithClickedButtonIndex(1, animated: true)
        
        self.hidePop()
    }
    
    func privateCmd(){
        if (httpRequert().downloadFromPostUrlSync(Surl,cmd: self.tmpStr,timeout:8) != nil){
            print("delay-set successed")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let alert = UIAlertView()
                alert.title = Defined_cur_title
                alert.message =  Defined_cur_update
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            })
            
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let alert = UIAlertView()
                alert.title = Defined_cur_title
                alert.message =  Defined_cur_failed
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            })
        }
    }
    
    func showPop(){
        
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


    
}

class ViewControllerAirC: UIViewController,UIAlertViewDelegate {
    var isLearn:Bool = true
    
    @IBOutlet weak var btn1: UIButton!
    
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        creatLearnView()
        
    }
    func creatLearnView(){
        let button = UIButton(frame: CGRectMake(0,0,35,35))
        if self.isLearn{
            button.setBackgroundImage(UIImage(named: "appl_learn_normal.png"), forState: UIControlState.Normal)
        }
        else{
            button.setBackgroundImage(UIImage(named: "appl_learn_isleanrning.png"), forState: UIControlState.Normal)
        }
        button.addTarget(self, action: Selector("insertNewObject:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    func insertNewObject(sender:AnyObject!){
        print("learn")
        if self.isLearn {

            let alert = UIAlertView()
            alert.delegate = self
            alert.title = Defined_VC6_AlertTitle
            alert.message =  Defined_VC6_AlertMessage1
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.addButtonWithTitle(Defined_ALERT_CANCEL)
            alert.show()
            
            
            
        }else{
            self.isLearn = true
            creatLearnView()
            
        }
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex)
        if buttonIndex == 0{
            self.isLearn = false
            creatLearnView()
            FAME.showMessage("学习模式已经开启")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        //print(FAME.saActid3)
        
        let array = FAME.button_names[FAME.dev_id]
        
        
        btn1.setTitle("\(array![9] as! String)", forState: UIControlState.Normal)
        btn2.setTitle("\(array![10] as! String)", forState: UIControlState.Normal)
        btn3.setTitle("\(array![11] as! String)", forState: UIControlState.Normal)
        btn4.setTitle("\(array![12] as! String)", forState: UIControlState.Normal)

        
        
        
    }
    
    @IBAction func downApplay(sender : UIButton) {
        print("OKOKOK")
        print(FAME.tempApplsId)
        var act_id = sender.tag * 2 + FAME.tempApplsId - 2
        if self.isLearn {
            act_id = act_id + 1
        }
        print("7777777act=\(act_id)")
        httpRequert().sendRequest(act_id)
    }
    
}


class ViewControllerMusicName: UIViewController {

    @IBOutlet weak var textFiled1: UITextField!
    @IBOutlet weak var textFiled2: UITextField!
    @IBOutlet weak var textFiled3: UITextField!
    @IBOutlet weak var textFiled4: UITextField!
    
    var subName:Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print(FAME.dev_id)
        let array = FAME.button_names[FAME.dev_id]
        
        
        textFiled1.text = array![9] as? String
        textFiled2.text = array![10] as? String
        textFiled3.text = array![11] as? String
        textFiled4.text = array![12] as? String
        
        
        
    }
   
    @IBAction func sureClick(sender: AnyObject) {
    
        
        let array = FAME.button_names[FAME.dev_id]!
        for i in 0..<(array.count - 4){
            let str = array[i] as! String
            subName.append(str)
            
        }
        subName.append(textFiled1.text!)
        subName.append(textFiled2.text!)
        subName.append(textFiled3.text!)
        subName.append(textFiled4.text!)
        print(subName)
        let cmdStr = "{\"cmd\": 48,\"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"dev_id\":\(FAME.dev_id), \"button_name\": \(subName)}"

        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
        
        //print(recevied)
            if recevied["result"] as! NSObject == 0
            {
            
            
                    FAME.getDeviceTable()
            self.navigationController?.popViewControllerAnimated(true);
            }
        }

    
    
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        //print(FAME.saActid3)
    }
    
   
    
}

