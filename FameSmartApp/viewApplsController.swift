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

class ViewControllerLight: UIViewController,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
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
    
    @IBAction func longPressFun(sender: UILongPressGestureRecognizer) {
        
        if sender.state == UIGestureRecognizerState.Began {
            let point:CGPoint = sender.locationInView(self.TableView)
            let indexPath:NSIndexPath! = self.TableView.indexPathForRowAtPoint(point)
            if(indexPath != nil){
                let cell:UITableViewCell2! = self.TableView.cellForRowAtIndexPath(indexPath) as! UITableViewCell2
                print(cell.dev_id)
                if cell.id == 11 {
                    self.selectDevid1 = cell.dev_id
                    self.showPop()
                }
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
        let btnY:CGFloat = 0
        
        let btnS1 = UIButton(frame: CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight))
        btnS1.setTitle(Defined_SS_Title1, forState: UIControlState.Normal)
        btnS1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //btnS1.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS1.tag = 1
        btnS1.hidden = true
        btnS1.addTarget(self, action: Selector("btns1Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnS2 = UIButton(frame: CGRect(x: btnX, y: btnY + 50, width: btnWidth, height: btnHeight))
        btnS2.setTitle(Defined_SS_Title2, forState: UIControlState.Normal)
        btnS2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnS2.tag = 2
        btnS2.hidden = true
        //btnS2.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS2.addTarget(self, action: Selector("btns2Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnS3 = UIButton(frame: CGRect(x: btnX, y: btnY + 100, width: btnWidth, height: btnHeight))
        btnS3.setTitle(Defined_LS_Title3, forState: UIControlState.Normal)
        btnS3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //btnS3.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS3.tag = 3
        btnS3.addTarget(self, action: Selector("btns3Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let btnS4 = UIButton(frame: CGRect(x: btnX, y: btnY + 150, width: btnWidth, height: btnHeight))
        btnS4.setTitle(Defined_SS_Title4, forState: UIControlState.Normal)
        btnS4.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //btnS3.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS4.tag = 4
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
        self.timeLabel.text = "0"
        
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
        
        if self.showId != 2 {
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
            print("link-set successed")
            let alert = UIAlertView()
            alert.title = Defined_link_title
            alert.message =  Defined_link_update
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
            
        }else{
            let alert = UIAlertView()
            alert.title = Defined_link_title
            alert.message =  Defined_link_failed
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
        }
    }
    
    func selectedActBtn(sender : AnyObject){
        
        if self.showId == 2 {
            
            self.tmpStr = "{\"cmd\": 36, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"operation\":0,\"dev_id1\":\(self.selectDevid1),\"dev_id2\":\(self.selectDevid2)}}"
            
            let myThread = NSThread(target: self, selector: "privateCmd", object: nil)
            myThread.start()
            
            self.hidePop()
        }else{
            print("selectedActBtn")

        }

        
        
    }
    
    func cancleActBtn( sender : AnyObject){
        
        print("cancleActBtn")
        //roomSheet.dismissWithClickedButtonIndex(1, animated: true)
        
        self.hidePop()
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
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        print("pickerView selected:\(row)")
        let idStr :String! = FAME.linkYB[row]["dev_id"]
        print(idStr)
        self.selectDevid2 = Int(idStr)!
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        //var objRooms :NSArray = FAME.device_table.valueForKey("rooms") as NSArray
        return FAME.linkYB.count
    }
    
    /*
    func pickerView(pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat{
        var width = self.view.frame.size.width
        if component == 0 {
            return width * 0.7
        }else{
            return width * 0.3
        }
    }
    */
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return FAME.linkYB[row]["name"]

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
    

    
    @IBOutlet var TableView : UITableView!
    //开
    @IBAction func lightTap(sender : UIButton2) {
        print(FAME.lightsCellState)
        let view = sender.superview?.viewWithTag(2) as! UIImageView
        view.image = UIImage(named: "socket_10.png")
        FAME.lightsCellState["\(sender.id)"] = 1
        httpRequert().sendRequest(sender.act_id)
        print("222222220\(sender.act_id)");
        print(FAME.lightsCellState)
    }
    @IBAction func lightTap2(sender : UIButton2) {
        
        let view = sender.superview?.viewWithTag(2) as! UIImageView
        view.image = UIImage(named: "socket_06.png")
        FAME.lightsCellState["\(sender.id)"] = 0
        httpRequert().sendRequest(sender.act_id)
        
        print(FAME.lightsCellState)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FAME.showLights {
            self.lightIdArr = FAME.showLight1Arr
        }else{
            self.lightIdArr = FAME.showLight2Arr
        }
        
        self.createPop()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshLights:")
        self.navigationItem.rightBarButtonItem = addButton
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        FAME.tempTableView = self.TableView
        
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
            for subCell:AnyObject in self.TableView!.visibleCells {
                print(subCell)
                let cell = subCell as! UITableViewCell
                let view = cell.viewWithTag(2) as! UIImageView
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.lightIdArr.count
        //return FAME.lights.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        tableView
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell2
        cell.backgroundColor = UIColor.clearColor()
        
        let showId = self.lightIdArr[indexPath.row]
        
        
        
        let dev_Str:String! = FAME.lights[showId]["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)
        
        let index_Str:String! = FAME.lights[showId]["index"] as String!
        let index:Int! = Int(index_Str)
        
        let type_Str:String! = FAME.lights[showId]["dev_type"] as String!
        let type:Int! = Int(type_Str)
        
        
        cell.tag = dev_id * 10 + index
        
        cell.dev_id = dev_id
        cell.id = type
        //name
        let name = cell.viewWithTag(1) as! UILabel
        name.text = FAME.lights[showId]["name"]
        
        
        //image      2015-05-21
        let imgObj = cell.viewWithTag(99) as! UIImageView
        if(FAME.showLights == false){
            imgObj.image = UIImage(named: "light_icon3.png")
        }else{
            imgObj.image = UIImage(named: "light_icon.png")
        }
        
        
        //on off
        let tag:AnyObject! = cell.viewWithTag(3)
        if (tag != nil) {
            let tagOn = cell.viewWithTag(3) as! UIButton2!
            let tagOff = cell.viewWithTag(4) as! UIButton2!
            let act_Str:String! = FAME.lights[showId]["act_id"] as String!
            
            let act_id:Int = Int(act_Str)!
            tagOn.act_id = act_id + 1
            tagOff.act_id = act_id
            tagOn.id = cell.tag
            tagOff.id = cell.tag
            
            let view = cell.viewWithTag(2) as! UIImageView
            let state :Int! = FAME.lightsCellState["\(cell.tag)"]
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
        
        self.navigationController.pushViewController(next, animated: true)
    }
    */
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        //***********************
        
        let showId = self.lightIdArr[indexPath.row]
        let ieee : String! = FAME.lights[showId]["ieee"]
        
        FAME.delDeviceByIeee(ieee)
        
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        
        return Defined_Delete
        
    }
    
    
    
}






class ViewControllerSocket: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    func refreshData(){
        
    }
    
    @IBOutlet var TableView : UITableView!
    @IBAction func lightTap(sender : UIButton2) {
        let view = sender.superview?.viewWithTag(2) as! UIImageView
        view.image = UIImage(named: "socket_06.png")
        httpRequert().sendRequest(sender.act_id)
    }
    //开
    @IBAction func lightTap2(sender : UIButton2) {
        
        let view = sender.superview?.viewWithTag(2) as! UIImageView
        view.image = UIImage(named: "socket_10.png")
        httpRequert().sendRequest(sender.act_id)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.TableView.setEditing(true, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        FAME.tempTableView = self.TableView
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
    }
    
    func Timerset(){
        //get the state
        
        //create the post string
        
        let paramArray = NSMutableArray()
        for value in FAME.sockets {
            let AddedObj = value as NSDictionary
            let dev_id:NSString! = AddedObj["dev_id"] as! NSString
            paramArray.addObject(dev_id)
            
        }
        
      let param = paramArray.componentsJoinedByString(",")
        
      let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 19, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": [\(param)]}",timeout : 90)
        
        /*
        var jsonPath = NSBundle.mainBundle().bundlePath
        var jsonData = NSData(contentsOfFile: "\(jsonPath)/test.txt")
        println(jsonData)
        var json :NSMutableDictionary! = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSMutableDictionary!
        println(json)
        
        if json {
            received = json as NSDictionary
        }
        */
        
      if (received != nil){
            //got the state
            for values:AnyObject in received.valueForKey("states") as! NSArray {
                print(values)
                let AddedObj = values as! NSDictionary
                let ADDieee_addr :Int!  = AddedObj.valueForKey("id") as! Int
                let ADDflag :Int!  = AddedObj.valueForKey("state") as! Int
                let id = ADDieee_addr * 10
                FAME.socketsCellState["\(id)"] = ADDflag
            }
            //set the state
        
        for subCell:AnyObject in self.TableView.visibleCells {
            print(subCell)
            let cell = subCell as! UITableViewCell
            let view = cell.viewWithTag(2) as! UIImageView
            let state :Int! = FAME.socketsCellState["\(cell.tag)"]
            if (state != nil) {
                print("state:\(state)")
                if state == 1 {
                    view.image = UIImage(named: "socket_10.png")
                }else {
                    view.image = UIImage(named: "socket_06.png")
                }
            }
        }
      }else{
            print("get the state failed")
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(FAME.sockets.count)
        return FAME.sockets.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        print("sss cell")
        print(cell)
        
        let dev_Str:String! = FAME.sockets[indexPath.row]["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)
        
        cell.tag = dev_id * 10
        //name
        let name = cell.viewWithTag(1) as! UILabel
        name.text = FAME.sockets[indexPath.row]["name"]
        
        //on off
        let tagOn = cell.viewWithTag(3) as! UIButton2
        let tagOff = cell.viewWithTag(4) as! UIButton2
        let act_Str:String! = FAME.sockets[indexPath.row]["act_id"] as String!
        
        let act_id:Int! = Int(act_Str)
        tagOn.act_id = act_id
        tagOff.act_id = act_id + 1
        tagOn.id = cell.tag
        tagOff.id = cell.tag
        
        let view = cell.viewWithTag(2) as! UIImageView
        let state :Int! = FAME.socketsCellState["\(cell.tag)"]
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

        
        
        
        return cell
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
        
    }

    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle{
        
        return UITableViewCellEditingStyle.Delete
    }

    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        print(indexPath.row)
        print(FAME.sockets[indexPath.row]["ieee"])
        let ieee : String! = FAME.sockets[indexPath.row]["ieee"]
        
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

class ViewControllerApplas: UIViewController {

    
    @IBOutlet var btnImg : UIImageView!
    
    @IBOutlet weak var btnTmp1: UIButton!
    
    @IBOutlet weak var btnTmp2: UIButton!
    
    var isLearn:Bool = false
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
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "insertNewObject:")
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
            let alert = UIAlertView()
            alert.title = Defined_cur_title
            alert.message =  Defined_cur_update
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
            
        }else{
            let alert = UIAlertView()
            alert.title = Defined_cur_title
            alert.message =  Defined_cur_failed
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
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
    var isLearn:Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: "insertNewObject:")
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

        var act_id = sender.tag * 2 + FAME.tempApplsId - 2
        if self.isLearn {
            act_id = act_id + 1
        }
        httpRequert().sendRequest(act_id)
    }
    
}
