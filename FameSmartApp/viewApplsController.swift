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

class ViewControllerLight: UIViewController,UITableViewDataSource,UITableViewDelegate, ViewControllerSS_nameDelegate{
    
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
    
    var index:Int = 0
    var roomIndex : Int = 0
    
    
    var view1 = UIScrollView()
    var indexCount : Array<Dictionary<String,String>> = []
    var indexRoom : Int! = 1000
    var right : Bool = true
    
    
    var sensors:Array<Dictionary<String,String>> = []
    var lights:Array<Dictionary<String,String>> = []
    
    func reloadName() {
        FAME.showMessage("名字修改成功");


        //
        refreshData()
        data(roomIndex)
        
//        print("11111=\(roomIndex)")
//        print("4444444\(indexCount)")
        
        if indexCount.count > 0{
            for subCell:AnyObject in self.TableView!.visibleCells {
                //print(subCell)
                let cell = subCell as! UITableViewCell2
                subValue = indexCount[cell.index]["subValue"] as String!
                if cell.dev_id == FAME.dev_id{
                    let name = cell.viewWithTag(1) as! UILabel
                    if FAME.tempSensorId == 1 || FAME.tempSensorId == 6{
                        name.text = FAME.dev_ss_Rname + FAME.dev_ss_name  + subValue
                    }else{
                        name.text = FAME.dev_ss_Rname + FAME.dev_ss_name
                    }
                }
            }
        }
        else{
            TableView.reloadData()
        }
        
    }
    
    func handleLongpressGesture(sender: UILongPressGestureRecognizer) {


        if sender.state == UIGestureRecognizerState.Began {
            let point:CGPoint = sender.locationInView(self.TableView)
            let indexPath:NSIndexPath! = self.TableView.indexPathForRowAtPoint(point)
            if(indexPath != nil){
                let cell:UITableViewCell2! = self.TableView.cellForRowAtIndexPath(indexPath) as! UITableViewCell2
                
                index = cell.index
                FAME.dev_id = cell.dev_id
                let name = cell.viewWithTag(1) as! UILabel
                let name_Str:String! = name.text as String!
    
                
                FAME.dev_ss_Rname = name_Str.substringWithRange(0, end: 2)
                if FAME.tempSensorId == 1{
                    FAME.dev_ss_name = name_Str.substringWithRange(2, end: name_Str.characters.count - 1)
                }
                else{
                    FAME.dev_ss_name = (name_Str as NSString).substringFromIndex(2)
                }
              
                for(var i = 0; i < FAME.rooms.count ; i++){
                    if FAME.dev_ss_Rname == FAME.rooms[i]{
                        roomIndex = i
                    }
                }
                
                self.ieee = indexCount[cell.index]["ieee"] as String!
                
                self.BGView.hidden = false
                
            }
        }

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
        btnS3.setTitle(Defined_SS_Title4, forState: UIControlState.Normal)
        btnS3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //btnS3.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS3.tag = 3
        btnS3.addTarget(self, action: Selector("btns3Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        
        
        self.pickView.addSubview(btnS1)
        self.pickView.addSubview(btnS2)
        self.pickView.addSubview(btnS3)
        //self.pickView.addSubview(btnS4)
        
        self.BGView.addSubview(self.pickView)
        self.view.addSubview(self.BGView)
        self.BGView.hidden = true
        
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
                print("用户名：\(login.text)")
                
                self.presentedViewController?.dismissViewControllerAnimated(false, completion: nil)
                
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
                            
                            //FAME.delDeviceByIeee(ieee)
                            
                            self.navigationController?.popToRootViewControllerAnimated(true)
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

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
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
//        print("sender.act_id开\(sender.act_id)")
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
//        print("sender.act_id关\(sender.act_id)")
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
            TableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "Timerset")
            TableView.mj_header.beginRefreshing()
            
            data(0)
            swipeView()
            self.createPop()
<<<<<<< HEAD
            if FAME.tempSensorId == 6{
                view1.hidden = true
            }
            else{
                TableView.transform = CGAffineTransformMakeTranslation(WIDTH/3 , 0)
            }
            
            

            TableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshLights")
            TableView.mj_header.beginRefreshing()
            
            
=======
>>>>>>> parent of dde0066... 下拉刷新卡主线程已经解决了
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
        
        //print(lights)
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshLights:")
//        self.navigationItem.rightBarButtonItem = addButton
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        FAME.tempTableView = self.TableView
//        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
//        myThread.start()
        
        
    }
    
    func refreshLights(sender:AnyObject!){
        print("refreshLights")
        //self.TableView!.reloadData()
        if indexCount.count == 0{
            self.TableView.mj_header.endRefreshing()
            FAME.showMessage("刷新成功")
        }
        else{
            let myThread = NSThread(target: self, selector: "Timerset", object: nil)
            myThread.start()
        }
        

        
        
    }
    
    func Timerset(){
        //get the state

        
        //create the post string
       UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if FAME.tempSensorId == 1 || FAME.tempSensorId == 6{
            if FAME.refreshLightState() {
                
                self.TableView.mj_header.endRefreshing()
                FAME.showMessage("刷新成功")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
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
                    
                    if (state != nil) {
                        
                        //print("state:\(state)")
                        if state == 1 {
                            view.image = UIImage(named: "socket_10.png")
                            imgObj.image = UIImage(named: Defined_SA_icons1[FAME.tempSensorId])
                        }else {
                            view.image = UIImage(named: "socket_06.png")
                            imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
                        }
                    }
                    else{
                        imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
                    }
                }
            }
            else{
                self.TableView.mj_header.endRefreshing()
                FAME.showMessage("刷新失败，网络超时 请检查中控")
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
                FAME.showMessage("刷新成功")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                //got the state
                for values:AnyObject in received.valueForKey("states") as! NSArray {
                    print(values)
                    let AddedObj = values as! NSDictionary
                    let ADDieee_addr :Int!  = AddedObj.valueForKey("id") as! Int
                    let ADDflag :Int!  = AddedObj.valueForKey("state") as! Int
                    var id = ADDieee_addr * 10
                    if FAME.tempSensorId == 9{
                        FAME.socketsCellState["\(id)"] = ADDflag
                    }
                    else{
                        if ADDflag >= 1 {
                            id = ADDieee_addr * 10
                            FAME.socketsCellState["\(id)"] = 1
                        }else{
                            id = ADDieee_addr * 10
                            FAME.socketsCellState["\(id)"] = 0
                        }

                    }
                }
                //set the state
                
                for subCell:AnyObject in self.TableView!.visibleCells {
                    //print(subCell)
                    let cell = subCell as! UITableViewCell2
                    let view = cell.viewWithTag(2) as! UIImageView
                    let imgObj = cell.viewWithTag(99) as! UIImageView
                    //print(FAME.lightsCellState)
                    let state :Int! = FAME.socketsCellState["\(cell.id)"]
                    
                    print("id == \(cell.id)")
                    
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
                            case 11001:
                                //2速打开
                                view.image = UIImage(named: "socket_10.png")
                                imgObj.image = UIImage(named: "cta_open.png")
                            case 10101:
                                //1速打开
                                view.image = UIImage(named: "socket_10.png")
                                imgObj.image = UIImage(named: "cta_open.png")
                            default:
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
                        imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
                    }
                }
            }else{
                print("get the state failed")
                self.TableView.mj_header.endRefreshing()
                FAME.showMessage("刷新失败，网络超时 请检查中控")
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
        
        cell.index = indexPath.row ;
        
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target:self
            , action: "handleLongpressGesture:")
        longpressGesutre.minimumPressDuration = 1.0;
        
        cell .addGestureRecognizer(longpressGesutre)
        
        
        
        let dev_Str:String! = indexCount[indexPath.row]["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)
        
        let index_Str:String! = indexCount[indexPath.row]["index"] as String!
        let index:Int! = Int(index_Str)
        
        let type_Str:String! = indexCount[indexPath.row]["dev_type"] as String!
        let type:Int! = Int(type_Str)
        
        
        
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
                    case 11001:
                        //2速打开
                        view.image = UIImage(named: "socket_10.png")
                        imgObj.image = UIImage(named: "cta_open.png")
                    case 10101:
                        //1速打开
                        view.image = UIImage(named: "socket_10.png")
                        imgObj.image = UIImage(named: "cta_open.png")
                    default:
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
                
            }else{
                view.image = UIImage(named: "socket_06.png")
                imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
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
    /*
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!){
        
        println(indexPath)
        var next = GBoard.instantiateViewControllerWithIdentifier("viewCell") as UIViewController
        //next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        
<<<<<<< HEAD
        if (TableView.indexPathForSelectedRow != nil){
            TableView.deselectRowAtIndexPath(TableView.indexPathForSelectedRow!, animated: true)
        }
=======
        self.navigationController.pushViewController(next, animated: true)
>>>>>>> parent of dde0066... 下拉刷新卡主线程已经解决了
    }
    */
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
        view1.hidden = true
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
            
            let button = UIButton(frame: CGRectMake(0, HEIGHT/10 * 1.2 + HEIGHT/14 * CGFloat(i) * 1.15, WIDTH/3, HEIGHT/14))
            button.tag = i + 1000
            button.setTitle(FAME.rooms[i], forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("refreshh:"), forControlEvents: UIControlEvents.TouchUpInside)
            if i == 0{
                button.backgroundColor = UIColor(red: 0, green: 206, blue: 209, alpha: 1.0)
                
            }
            else{
                
                let view = UIView(frame: CGRectMake(0, HEIGHT/10 * 1.2 + HEIGHT/14 * CGFloat(i) * 1.16, WIDTH/3, 1))
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
        
        indexRoom = sender.tag
        //print("11111\(sender.tag)")
    }

    
    
}


class ViewControllerApplas: UIViewController {

    var actId :Int!
    @IBOutlet var btnImg : UIImageView!
    
    @IBOutlet weak var btnTmp1: UIButton!
    
    @IBOutlet weak var btnTmp2: UIButton!
    
    var isLearn:Bool = true
    
    func refreshData(){
        
    }
    @IBAction func downUp(sender : UIButton) {
        self.btnImg.image = UIImage(named: "radio_touch02_03.png")
    }
    @IBAction func downLeft(sender : UIButton) {
        self.btnImg.image = UIImage(named: "radio_touch05_03.png")
    }
    @IBAction func downRight(sender : UIButton) {
        self.btnImg.image = UIImage(named: "radio_touch03_03.png")
    }
    @IBAction func downDown(sender : UIButton) {
        self.btnImg.image = UIImage(named: "radio_touch04_03.png")
    }
    @IBAction func downOk(sender : UIButton) {
        self.btnImg.image = UIImage(named: "radio_touch_03.png")
    }
    
    @IBAction func downCancel(sender : UIButton) {
        self.btnImg.image = UIImage(named: "radio_03.png")
    }
    
    @IBAction func downApplay(sender : UIButton) {
        self.btnImg.image = UIImage(named: "radio_03.png")
        print("OKOKOK")
  
        var act_id = sender.tag * 2 + FAME.tempApplsId - 2
        if self.isLearn {
            act_id = act_id + 1
        }
   
        
        httpRequert().sendRequest(act_id)
    }
    
    @IBAction func downApplayOut(sender : UIButton) {
        self.btnImg.image = UIImage(named: "radio_03.png")
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    func insertNewObject(sender:AnyObject!){
        print("learn")
        if self.isLearn {
            self.isLearn = false
            let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "insertNewObject:")
            self.navigationItem.rightBarButtonItem = addButton
            
        }else{
            self.isLearn = true
            let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "insertNewObject:")
            self.navigationItem.rightBarButtonItem = addButton
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        print(FAME.saActid4)
        
        let applObj = FAME.appls[FAME.saActid4] as NSDictionary
        //let appName:String! = applObj["name"] as! String
        let appActid:String! = applObj["act_id"] as! String
        //self.actId = applObj["act_id"] as! Int
        //let appIeee:String! = applObj["ieee"] as! String
        let appType:String! = applObj["dev_type"] as! String
        
        print(appType)
        print("appActid:\(appActid)")
        if(Int(appType)! == 17){
            print("tvtvtv")

            self.btnTmp1.setBackgroundImage(UIImage(named:"tv_07-03.png"), forState:UIControlState.Normal)
            self.btnTmp1.setTitle("HOME", forState:UIControlState.Normal)
            
            self.btnTmp2.setBackgroundImage(UIImage(named:"tv_07-03.png"), forState:UIControlState.Normal)
            self.btnTmp2.setTitle(Defined_btn_return, forState:UIControlState.Normal)
            
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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createPop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        print(FAME.saActid2)
        
        let curObj = FAME.curtains[FAME.saActid2] as NSDictionary
        //let curName:String! = curObj["name"] as! String
        let curDevid:String! = curObj["dev_id"] as! String
        self.dev_id = Int(curDevid)!
    }
    
    @IBAction func downApplay(sender : UIButton) {

        print("OKOKOK")
        
        let act_id = sender.tag  + FAME.tempApplsId - 1
<<<<<<< HEAD
        //print("555555555=\(act_id)")
=======

>>>>>>> parent of dde0066... 下拉刷新卡主线程已经解决了
   
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

class ViewControllerAirC: UIViewController {
    var isLearn:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    func insertNewObject(sender:AnyObject!){
        print("learn")
        if self.isLearn {
            self.isLearn = false
            let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "insertNewObject:")
            self.navigationItem.rightBarButtonItem = addButton
            
        }else{
            self.isLearn = true
            let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target: self, action: "insertNewObject:")
            self.navigationItem.rightBarButtonItem = addButton
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        print(FAME.saActid3)
    }
    
    @IBAction func downApplay(sender : UIButton) {
        print("OKOKOK")
        print(FAME.tempApplsId)
        var act_id = sender.tag * 2 + FAME.tempApplsId - 2
        if self.isLearn {
            act_id = act_id + 1
        }
        httpRequert().sendRequest(act_id)
    }
    
}
