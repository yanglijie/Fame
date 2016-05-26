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

class ViewControllerSS: UIViewController,UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
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
    
    var Links1:Array<Dictionary<String,AnyObject>> = []
    var Links2 : Array<Dictionary<String,AnyObject>> = []
    
    

    
    
    
    @IBAction func longPressFun(sender: UILongPressGestureRecognizer) {
        /*
        if sender.state == UIGestureRecognizerState.Began {
        let point:CGPoint = sender.locationInView(self.tabelVeiw)
        let indexPath:NSIndexPath! = self.tabelVeiw.indexPathForRowAtPoint(point)
        if(indexPath != nil){
        let cell:UITableViewCell2! = self.tabelVeiw.cellForRowAtIndexPath(indexPath) as UITableViewCell2
        println(cell.dev_id)
        
        }
        }
        */
    }
    
    var ids = 0
    var id1 = -2
    var id2 = 1
    
    
    
    
    
    var act = 0
    var seletedStr1:String! = ""
    var seletedStr2:String! = ""
    var seletedStr3:String! = ""
    var seletedBtn :UIButton2!
    
    var sensors:Array<Dictionary<String,String>> = []
    
    @IBAction func tap(sender : UISwitch2) {
        print(sender.on)
        var act_id = sender.act_id
        let id = sender.dev_id * 10 + FAME.tempSensorId
        if sender.on {
            FAME.sensorsCellState["\(id)"] = 1
            httpRequert().sendRequest(sender.act_id)
            
        }else{
            FAME.sensorsCellState["\(id)"] = 0
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
            self.sensors = FAME.sensors25
        case 4:
            self.sensors = FAME.sensors26
        default:
            break
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.refreshData()
        self.createPop()
        
        self.Links1 = []
        if FAME.Links.count > 0 {
            
            for obj:Dictionary<String,AnyObject> in FAME.Links   {
                if (obj["show"] as! Int) >= 0 {
                    self.Links1.append(obj)
                }
            }
            
            
            
            let links:Array<Dictionary<String,AnyObject>>! = self.Links1[0]["sub"] as! Array<Dictionary<String,AnyObject>>!
            if links != nil {
                self.Links2 = links
            }else{
                self.Links2 = [["name":"","act_id":0]]
            }
            self.seletedStr1 = self.Links1[0]["name"] as! String!
            self.seletedStr2 = self.Links2[0]["name"] as! String!
            self.seletedStr3 = Defined_mode_on
        }
    }
    
    func Timerset(){
        let event_id = FAME.tempSensorId
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
        
        if action_id < 2 {
            let cmdStr = "{\"cmd\": 33, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"event_id\":\(e_id),\"filter_data\":[\(dev_id),11,17,\(alarm_value)],\"action_id\":\(0),\"active\":0}}"
            if var recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
                print("link device successed")
                let alert = UIAlertView()
                alert.title = Defined_link_title
                alert.message =  Defined_link_update
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            }else{
                print("link event failed")
                let alert = UIAlertView()
                alert.title = Defined_link_title
                alert.message =  Defined_link_failed
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            }
        }else{
            let cmdStr = "{\"cmd\": 33, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"event_id\":\(e_id),\"filter_data\":[\(dev_id),11,17,\(alarm_value)],\"action_id\":\(action_id),\"active\":1}}"
            if var recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
                print("link device successed")
                let alert = UIAlertView()
                alert.title = Defined_link_title
                alert.message =  Defined_link_update
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
                
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
        
        let btnS1 = UIButton(frame: CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight))
        btnS1.setTitle(Defined_SS_Title1, forState: UIControlState.Normal)
        btnS1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //btnS1.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS1.tag = 1
        btnS1.addTarget(self, action: Selector("btns1Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnS2 = UIButton(frame: CGRect(x: btnX, y: btnY + 50, width: btnWidth, height: btnHeight))
        btnS2.setTitle(Defined_SS_Title2, forState: UIControlState.Normal)
        btnS2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnS2.tag = 2
        //btnS2.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS2.addTarget(self, action: Selector("btns2Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnS3 = UIButton(frame: CGRect(x: btnX, y: btnY + 100, width: btnWidth, height: btnHeight))
        btnS3.setTitle(Defined_SS_Title3, forState: UIControlState.Normal)
        btnS3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //btnS3.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS3.tag = 3
        btnS3.addTarget(self, action: Selector("btns3Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let btnS4 = UIButton(frame: CGRect(x: btnX, y: btnY + 150, width: btnWidth, height: btnHeight))
        btnS4.setTitle(Defined_SS_Title4, forState: UIControlState.Normal)
        btnS4.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //btnS3.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS4.tag = 3
        btnS4.addTarget(self, action: Selector("btns4Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        
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
        
        
        self.pickView1.addSubview(btnS1)
        self.pickView1.addSubview(btnS2)
        self.pickView1.addSubview(btnS3)
        self.pickView1.addSubview(btnS4)
        
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
    
    func btns1Fun(sender:UIButton){
        self.showId = 0
        self.showVIew2()
    }
    func btns2Fun(sender:UIButton){
        self.showId = 1
        self.showVIew2()
    }
    func btns3Fun(sender:UIButton){
        self.showId = 2
        self.showVIew2()
    }
    func btns4Fun(sender:UIButton){
        self.hidePop()
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
        if var recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: self.tmpStr,timeout:8){
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
    @IBAction func showSheet(sender : UIButton2) {
        self.seletedBtn = sender
        self.showPop()
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        print("pickerView selected:\(row)")
        if component == 0 {
            self.seletedStr1 = self.Links1[row]["name"] as! String!
            
            
            
            let links = self.Links1[row]["sub"] as! Array<Dictionary<String,AnyObject>>!
            if links != nil {
                self.Links2 = links
                
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
            
            self.seletedStr3 = Defined_mode_on
            self.id2 = 1
            
        }else  if component == 1 {
            
            if let act_id :Int! = self.Links2[row]["act_id"] as! Int!{
                self.id1 = act_id
            }
            self.seletedStr2 = self.Links2[row]["name"] as! String!
            
        }else{
            if row == 0 {
                self.seletedStr3 = Defined_mode_on
                self.id2 = 1
            }else{
                self.id2 = 0
                self.seletedStr3 = Defined_mode_off
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
            return 2
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
                if row == 0 {
                    return Defined_mode_on
                }else{
                    return Defined_mode_off
                }
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        FAME.tempTableView = self.tabelVeiw
        
        let myThread = NSThread(target: self, selector: "Timerset2", object: nil)
        myThread.start()
        
        
    }
    func Timerset2(){
        
        var paramArray = NSMutableArray()
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
        
        var received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 19, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": [\(param)]}",timeout : 90)
        
        if (received != nil){
            //got the state
            for values:AnyObject in received.valueForKey("states") as! NSArray {
                print(values)
                let AddedObj = values as! NSDictionary
                let ADDieee_addr :Int!  = AddedObj.valueForKey("id") as! Int
                let ADDflag :Int!  = AddedObj.valueForKey("state") as! Int
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
                print(subCell)
                let cell = subCell as! UITableViewCell2
                let view = cell.viewWithTag(3) as! UISwitch2!
                
                let state :Int! = FAME.sensorsCellState["\(cell.id)"]
                if (state != nil) {
                    print("state:\(state)")
                    if state == 1 {
                        view.on = true
                    }else {
                        view.on = false
                    }
                }
            }
        }else{
            print("get the state failed")
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
        cell.backgroundColor = UIColor.clearColor()
        print(self.sensors)
        let dev_Str:String! = self.sensors[indexPath.row]["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)
        
        cell.dev_id = dev_id
        
        cell.id = dev_id * 10 + FAME.tempSensorId
        //name
        let name = cell.viewWithTag(2) as! UILabel
        name.text = self.sensors[indexPath.row]["name"]
        
        //icon
        
        let view = cell.viewWithTag(1) as! UIImageView
        view.image = UIImage(named: Defined_SS_icons[FAME.tempSensorId])
        
        //Switch
        let tag = cell.viewWithTag(3) as! UISwitch2!
        let act_Str:String! = self.sensors[indexPath.row]["act_id"] as String!
        
        
        
        let state :Int! = FAME.sensorsCellState["\(cell.id)"]
        if (state != nil) {
            print("id:\(cell.id) state:\(state)")
            if state == 1 {
                tag.on = true
            }else {
                tag.on = false
            }
        }
        
        
        
        let act_id:Int! = Int(act_Str)
        tag.act_id = act_id
        tag.dev_id = dev_id
        tag.id = cell.id
        
        //button
        
        let linkBtn = cell.viewWithTag(4) as! UIButton2!
        
        linkBtn.act_id = act_id
        linkBtn.dev_id = dev_id
        print("linkBtn.Dev_id:\(linkBtn.dev_id)")
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
        
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
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String!{
        
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
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
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
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
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
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
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
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
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
    var otherView:UIView!
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
        
        var tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
        //设置手势点击数,双击：点2下
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self ;
        self.popView.addGestureRecognizer(tapGesture)
        
        
        let popView1 = UIView(frame: CGRect(x: (self.view.frame.width*0.3)/2, y: (self.view.frame.height*0.5)/2 , width: self.view.frame.width*0.7, height: self.view.frame.height*0.5));
        popView1.backgroundColor=UIColor.whiteColor();
        self.popView .addSubview(popView1);
        
        //self.popView.alpha=0.0;
        
        let titleLable = UILabel(frame: CGRect(x: popView1.frame.size.width*0.1, y: 0, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6*0.95))
        titleLable.text = FAME.dev_ss_name;
        titleLable.font = UIFont.boldSystemFontOfSize(20);
        titleLable.textColor = UIColor.blueColor();
        popView1 .addSubview(titleLable);
        
        let view1 = UIView(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6*0.95, width: popView1.frame.size.width*0.8, height: 1))
        view1.backgroundColor = UIColor.blackColor();
        popView1 .addSubview(view1);
        
        let nameUIButton = UIButton(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6*0.95))
        let nameLable = UILabel (frame: CGRect(x: 0, y: 0, width: popView1.frame.size.width*0.8, height: popView1.frame.size.height/6*0.95))
        nameLable.text = Defined_SS_air_Title1;
        nameUIButton .addSubview(nameLable);
        nameUIButton.addTarget(self, action: Selector("btns1Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        popView1 .addSubview(nameUIButton);
        
        let view2 = UIView(frame: CGRect(x: popView1.frame.size.width*0.1, y: popView1.frame.size.height/6*2*0.95, width: popView1.frame.size.width*0.8, height: 1))
        view2.backgroundColor = UIColor.blackColor();
        popView1 .addSubview(view2);
        
        
        

    }
    func btns1Fun(sender:UIButton){
        self.popView.hidden = true;
        let next = GBoard.instantiateViewControllerWithIdentifier("viewSS_name") as UIViewController
        
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
        //self.TableView!.reloadData()
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
        cell.backgroundColor = UIColor.clearColor()
        
        
        
        let showId = self.airSensors[indexPath.row]
        
        
        
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target:self
            , action: "handleLongpressGesture:")
        longpressGesutre.minimumPressDuration = 1.0;
        cell .addGestureRecognizer(longpressGesutre)
        FAME.dev_ss_name = showId["name"]
        self .popPushView();
        
        
        let dev_Str:String! = showId["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)
        
        let index_Str:String! = showId["index"] as String!
        let index:Int! = Int(index_Str)
        
        let type_Str:String! = showId["dev_type"] as String!
        let type:Int! = Int(type_Str)
        
        
        cell.tag = dev_id * 10 + index
        
        cell.dev_id = dev_id
        cell.id = type
        //name
        let name = cell.viewWithTag(1) as! UILabel
        name.text = showId["name"]

        
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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.airDetail = NSDictionary();
        let view = self.view.viewWithTag(200) as UIView!
        view.layer.borderColor=UIColor.whiteColor().CGColor;
        view.layer.borderWidth = 1;
        view.layer.cornerRadius=10;
        self.showView();
        
        
        
    }
    func showView(){
        let cmdStr = "{\"cmd\": 42, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"dev_id\":\(FAME.dev_id)}}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
            print("link device successed")
            
            
            self.airDetail=recevied["detail"] as! NSDictionary;
            let detail=self.airDetail;
            
            let viewpm2_5 = self.view.viewWithTag(300) as! UILabel!;
            let index_Str:NSNumber! = detail["pm2_5"] as! NSNumber!;
            if index_Str == 0{
                viewpm2_5.text = "0.0";
            }
            else{
                viewpm2_5.text=self.StringSplit(String(index_Str));
            }
            let hcho = self.view.viewWithTag(302) as! UILabel!;
            let index_Str1:NSNumber! = detail["hcho"] as! NSNumber!;
            if index_Str1 == 0{
                hcho.text = "0.0mg/M3";
            }
            else{
                hcho.text="\(self.StringSplit(String(index_Str1)))mg/M3"
            }
            let temperature = self.view.viewWithTag(304) as! UILabel!;
            let index_Str2:NSNumber! = detail["temperature"] as! NSNumber!;
            if index_Str2 == 0{
                temperature.text = "0.0C";
            }
            else{
                temperature.text="\(self.StringSplit(String(index_Str2)))C"
            }
            let humidity = self.view.viewWithTag(306) as! UILabel!;
            let index_Str3:NSNumber! = detail["humidity"] as! NSNumber!;
            if index_Str3 == 0{
                humidity.text = "0.0%RH";
            }
            else{
                humidity.text="\(self.StringSplit(String(index_Str3)))%RH"
            }

            
            let update_time = self.view.viewWithTag(308) as! UILabel!;
            update_time.text="更新时间：\(detail["update_time"] as! String)";
            
            
            
        }else{
            
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
        if bool == 1{
            let splitedArray=str.componentsSeparatedByString(".");
            
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
        else{
            return str;
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
    }


}
class ViewControllerSS_name: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let dev_name = self.view.viewWithTag(18) as! UITextField!;
        dev_name.text = FAME.dev_ss_name ;
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
    }
    
}

