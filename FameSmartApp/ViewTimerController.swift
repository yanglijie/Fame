//
//  ViewMainController.swift
//  FameSmartApp
//
//  Created by Eric on 14-8-1.
//  Copyright  2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//



//*********************
//
//      viewcontroller of timer
//
//*********************

import UIKit

class ViewControllerSUTimer: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var tempDic:Array<Dictionary<String,String>> = []
    var currentDic:Array<Dictionary<String,String>> = []
    var currentArray:Int = 2
    @IBOutlet weak var TableView: UITableView!
    
    
    @IBAction func tapswitch(sender: UISwitch2) {
        
        if sender.on {
            self.enableTime(true, id: sender.act_id)
        }else{
            self.enableTime(false, id: sender.act_id)
        }
        
    }
    
    func enableTime(enable:Bool,id:Int){
        
        var cmd = 13
        if enable {
            cmd = 12
        }
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 38, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": {\"cmd\": \(cmd),\"param\": {\"index\": \(id)}}}",timeout : 90)
        if (received != nil){
            self.refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        self.currentArray = 2
        self.currentDic = FAME.timerArray2
        //self.refresh()
        
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        FAME.tempTimerView = self.TableView
        self.refresh()
        
    }
    
    func refresh(){
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
    }
    func refreshLocal(){
        if (currentArray == 1 ){
            self.currentDic = FAME.timerArray1
        }else if (currentArray == 2 ){
            self.currentDic = FAME.timerArray2
        }else if (currentArray == 3 ){
            self.currentDic = FAME.timerArray3
        }else {
            self.currentDic = FAME.timerArray4
        }

        self.TableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.currentDic.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        tableView
        let cell = tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        //cell.backgroundColor = UIColor.clearColor()
        let tagInt = self.currentDic[indexPath.row]["action_id"] as String!
        cell.tag = Int(tagInt)!
        
        //name
        let UIname = cell.viewWithTag(2) as! UILabel
        UIname.text = self.currentDic[indexPath.row]["name"]
        
        let UIroom = cell.viewWithTag(3) as! UILabel
        UIroom.text = self.currentDic[indexPath.row]["room"]
        
        let UItime = cell.viewWithTag(4) as! UILabel
        UItime.text = self.currentDic[indexPath.row]["time_string"]
        
        
        let UIday = cell.viewWithTag(5) as! UILabel
        UIday.text = self.currentDic[indexPath.row]["timerRepeat_day_string"]
        
        
        //Switch

        let indexString = self.currentDic[indexPath.row]["index"]!
        
        let UIenable = cell.viewWithTag(6) as! UISwitch2!
        
        UIenable.id = indexPath.row
        UIenable.act_id = Int(indexString)!
        
        if (self.currentDic[indexPath.row]["enable"]! == "1"){
            UIenable.on = true
        }else{
            UIenable.on = false
        }
        
        
        return cell
        
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 60
        
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        print(indexPath)
        FAME.tempTimerArrayID = indexPath.row
        FAME.tempTimerArrayContent = self.currentDic[indexPath.row]
        
        let next = GBoard.instantiateViewControllerWithIdentifier("viewCell") as UIViewController
        //next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func modelBtnFun1(sender: AnyObject) {
        self.currentArray = 1
        self.refreshLocal()
    }
    
    @IBAction func modelBtnFun2(sender: AnyObject) {
        self.currentArray = 2
        self.refreshLocal()
    }

    @IBAction func modelBtnFun3(sender: AnyObject) {
        self.currentArray = 3
        self.refreshLocal()
    }
    
    @IBOutlet weak var addTimer: UIButton!
    
    
    @IBAction func modelBtnFun4(sender: AnyObject) {
        self.currentArray = 4
        self.refreshLocal()
        print("sensor")
    }
    
    
    func Timerset(){
    
        //var received
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 38, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": {\"cmd\": 7}}",timeout : 90)
        
        
        if (received != nil){
            print(received)
            FAME.timerArray1.removeAll(keepCapacity: false)
            FAME.timerArray2.removeAll(keepCapacity: false)
            FAME.timerArray3.removeAll(keepCapacity: false)
            FAME.timerArray4.removeAll(keepCapacity: false)
            let detail:NSDictionary = received.valueForKey("detail") as! NSDictionary
            
                
            
            for values:AnyObject in detail.valueForKey("timers") as! NSArray {
                print(values)
                let timerObj = values as!NSDictionary
                let timerIndex :Int!  = timerObj.valueForKey("index") as! Int
                let timerAction_id :Int!  = timerObj.valueForKey("action_id") as! Int
                let timerEnable :Int!  = timerObj.valueForKey("enable") as! Int
                let timerTime :String!  = timerObj.valueForKey("time") as! String
                let timerRepeat_type :Int!  = timerObj.valueForKey("repeat_type") as! Int
                let timerRepeat_day :Array<Int>!  = timerObj.valueForKey("repeat_day") as! Array<Int>
                
                var timerRepeat_day_string = ""
                let tempArr = Defined_timer_week_name
                
                //println(timerRepeat_day)
                
                for var i = 0 ;i < 7;i++ {
                    if timerRepeat_day[i] == 1 {
                        timerRepeat_day_string = "\(timerRepeat_day_string)\(tempArr[i])"
                    }
                }
                
                
                //println(timerRepeat_day_string)
                //println(FAME.idForNames)
                let timeDic = FAME.idForNames[timerAction_id] as Dictionary!
                
                if timeDic != nil {
                    let timerName = timeDic["name"]!
                    
                    let timerRoom = timeDic["room"]!
                    
                    let nsdatef1:NSDateFormatter = NSDateFormatter()
                    nsdatef1.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let nsdatef2:NSDateFormatter = NSDateFormatter()
                    nsdatef2.dateFormat = "HH:mm"
                    let timeDate :NSDate! = nsdatef1.dateFromString(timerTime)
                    var timeTimeString:String = nsdatef2.stringFromDate(NSDate())
                    
                    if timeDate != nil {
                        timeTimeString = nsdatef2.stringFromDate(timeDate)
                    }
                    
                    
                    
                    //println(timeDate)
                    
                    
                    let timeNew = ["index":"\(timerIndex)","action_id":"\(timerAction_id)","room":"\(timerRoom)","name":"\(timerName)","time":"\(timerTime)","time_string":"\(timeTimeString)","repeat_type":"\(timerRepeat_type)","repeat_day":"\(timerRepeat_day)","timerRepeat_day_string":"\(timerRepeat_day_string)","enable":"\(timerEnable)","d0":"\(timerRepeat_day[0])","d1":"\(timerRepeat_day[1])","d2":"\(timerRepeat_day[2])","d3":"\(timerRepeat_day[3])","d4":"\(timerRepeat_day[4])","d5":"\(timerRepeat_day[5])","d6":"\(timerRepeat_day[6])"]
                    
                    
                    
                    if(timerAction_id < 20){
                        FAME.timerArray1.append(timeNew)
                    }else if(timerAction_id<300){
                        FAME.timerArray2.append(timeNew)
                    }else if( timerAction_id<400){
                        FAME.timerArray3.append(timeNew)
                    }else{
                        FAME.timerArray4.append(timeNew)
                    }

                
                }
                
            }
            
            //println(FAME.idForNames)
            print("timerArray1")
            print(FAME.timerArray1)
            print("timerArray2")
            print(FAME.timerArray2)
            print("timerArray3")
            print(FAME.timerArray3)
            print("timerArray4")
            print(FAME.timerArray4)
            
            self.refreshLocal()
        }
        
    
    }
    @IBAction func btnAddTimerFun(sender: AnyObject) {
        
        FAME.tempTimerArrayID = -1

        let  today:NSDate = NSDate()
        
        let nsdatef1:NSDateFormatter = NSDateFormatter()
        nsdatef1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nsdatef2:NSDateFormatter = NSDateFormatter()
        nsdatef2.dateFormat = "HH:mm"
        
        let timetring :String = nsdatef1.stringFromDate(today)
        let timeTimeString:String = nsdatef2.stringFromDate(today)
        
        let timeNew = ["index":"-1","action_id":"-1","room":"-1","name":"null","time":"\(timetring)","time_string":"\(timeTimeString)","repeat_type":"1","repeat_day":"[0,0,0,0,0,0,0]","timerRepeat_day_string":"","enable":"1","d0":"0","d1":"0","d2":"0","d3":"0","d4":"0","d5":"0","d6":"0"]
        
        FAME.tempTimerArrayContent = timeNew
        
        let next = GBoard.instantiateViewControllerWithIdentifier("viewCell") as UIViewController
        self.navigationController?.pushViewController(next, animated: true)
        
        
        
    }
    
}





class ViewControllerSUTimerCell: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    //@IBOutlet weak var Date: UIDatePicker!
    
    @IBOutlet weak var DateView: UIView!
    @IBOutlet weak var subView: UIView!
    
    @IBOutlet weak var addTap: UIButton!
    var btns:Array<UIButton> = []
    var TimeArr:Array<Array<Int>> = [[],[]]
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func refreshTime(sender: AnyObject) {
        FAME.getDateFormServer()
        self.refreshTimeFun()
    }
    
    func refreshTimeFun(){
        
        let date = FAME.getDateFormLocal()
        self.timeLabel.text = FAME.stringFromDate(date, type: 2)
    }
    
    @IBOutlet weak var Date: UIDatePicker!
    
    var repeat_dayArr:Array<Int> = [0,0,0,0,0,0,0]
    var ids:Array<Dictionary<String,String>> = []
    var BGView:UIView!
    var pickView:UIView!
    var id0 = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        print(self.DateView.frame.origin.y)
        let diff:CGFloat = 5
        let bWidth:CGFloat = ((self.view.frame.width - 40) - 6 * diff) / 7
        var x:CGFloat = 20
        let y:CGFloat = self.DateView.frame.origin.y + self.DateView.frame.size.height + 10

        
        
        for i in 0...6 {
            
            print(i)
            let newFrame = CGRect(x: x, y: y, width: bWidth, height: 20)
            
            let btn:UIButton = UIButton(frame: newFrame)
            btn.setTitle(Defined_timer_week_name[i], forState: UIControlState.Normal)
            btn.tag = 11 + i

            btn.setBackgroundImage(UIImage(named: "socket_17.png"), forState: UIControlState.Normal)

            btn.addTarget(self, action: "tap:", forControlEvents: UIControlEvents.TouchUpInside)
            
            
            self.subView.addSubview(btn)
            self.btns.append(btn)
            x = x + diff + bWidth
        }
        
        self.ids.removeAll(keepCapacity: false)
        for (i,cellObj) in FAME.idForNames {
            let cell = cellObj as Dictionary<String,String>
            let cname = cell["name"]!
            let croom = cell["room"]!
            let newDic = ["name":"\(croom) \(cname)","act_id":cell["act_id"]!,"room":croom]
            self.ids.append(newDic)
        }
        self.createPop()
        self.refreshTimeFun()
    }
    
    func tap(sender : UIButton!){
        print("btn tapped \(sender.tag)")
        //httpRequert().sendRequest(sender.tag + 7)
        let idx = sender.tag - 11
        
        if ( self.repeat_dayArr[idx] == 0 ){
            self.repeat_dayArr[idx] = 1
            sender.setBackgroundImage(UIImage(named: "clock_04_03.png"), forState: UIControlState.Normal)
        }else{
            self.repeat_dayArr[idx] = 0
            sender.setBackgroundImage(UIImage(named: "socket_17.png"), forState: UIControlState.Normal)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        print("currentDic")
        print(FAME.tempTimerArrayContent)
        //time
        if !(FAME.tempTimerArrayContent.isEmpty){
  
        for i in 0...6 {
            let dayString = FAME.tempTimerArrayContent["d\(i)"]!
            print(Int(dayString)!)
            
            self.repeat_dayArr[i] = Int(dayString)!
            

            let btn = self.btns[i] as UIButton
            
            
            if (self.repeat_dayArr[i] == 0) {
                btn.setBackgroundImage(UIImage(named: "socket_17.png"), forState: UIControlState.Normal)
            }else{
               btn.setBackgroundImage(UIImage(named: "clock_04_03.png"), forState: UIControlState.Normal)
            }
            
        }
        
        }

        //self.Date.minimumDate = now
        
        //title

        
        if FAME.tempTimerArrayID >= 0 {
            
            let timerTime:String = FAME.tempTimerArrayContent["time"]!
            let timeDate :NSDate! = FAME.dateFromString(timerTime, type: 0)
            //let timeTimeString:String = FAME.stringFromDate(timeDate, type: 2)
            
            let name = FAME.tempTimerArrayContent["name"]!
            self.addTap.setTitle(name, forState: UIControlState.Normal)
            self.delTimeBtn.hidden = false
            //date
            self.Date.setDate(timeDate, animated: false)
            
        }else{
            self.delTimeBtn.hidden = true
            self.addTap.setTitle(Defined_clickToAdd_title, forState: UIControlState.Normal)
            self.Date.datePickerMode = UIDatePickerMode.CountDownTimer
            self.Date.setDate(NSDate(), animated: true)
        }
        
        self.btnOk.enabled = true
    }
    
    @IBOutlet weak var delTimeBtn: UIButton!
    @IBAction func addNameFun(sender: AnyObject) {
        self.showPop()
    }
    func selectedActBtn( sender : AnyObject){
        
        print("selectedActBtn")
        if self.id0 < 0 {
            self.id0 = 0
        }
        
        //roomSheet.dismissWithClickedButtonIndex(2, animated: true)
        self.addTap.setTitle(self.ids[self.id0]["name"], forState: UIControlState.Normal)
        FAME.tempTimerArrayContent["name"] = self.ids[self.id0]["name"]
        FAME.tempTimerArrayContent["action_id"] = self.ids[self.id0]["act_id"]
        FAME.tempTimerArrayContent["room"] = self.ids[self.id0]["room"]
        
        self.hidePop()
        print(FAME.tempTimerArrayContent)
    }
    
    func cancleActBtn( sender : AnyObject){
        
        print("cancleActBtn")
        //roomSheet.dismissWithClickedButtonIndex(1, animated: true)
        self.hidePop()
    }

    func createPop(){
        
        self.BGView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.width, height: self.view.frame.height))
        self.BGView.backgroundColor = UIColor.clearColor()
        self.BGView.tag = 500
        
        
        self.pickView = UIView(frame: CGRect(x: 0, y: self.view.frame.height + 5 , width: self.view.frame.width, height: 300))
        self.pickView.backgroundColor = UIColor.whiteColor()
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
        
        
        let picker = UIPickerView(frame: CGRect(x: 20, y: 5, width: pickView.frame.width - 40 , height: 230))
        
        picker.dataSource = self
        picker.delegate = self
        picker.tag = 2
        
        self.pickView.addSubview(picker)
        self.pickView.addSubview(btn)
        self.pickView.addSubview(btn2)
        
        
        self.pickView.tag = 501
        self.pickView.alpha = 0.95
        self.BGView.hidden = true
        self.pickView.hidden = true
        self.view.addSubview(self.BGView)
        self.view.addSubview(self.pickView)
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
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){

            print("pickerView selected:\(row)")
            self.id0 = row

    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{

            return 1

    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{

            return self.ids.count

        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
                    let name:String = self.ids[row]["name"]!
            return name


    }
    
    
    @IBOutlet weak var btnOk: UIButton!
    @IBAction func mOK(sender: UIButton) {
        if FAME.tempTimerArrayID >= 0 {
            self.btnOk.enabled = false
            let myThread = NSThread(target: self, selector: "moTimer", object: nil)
            myThread.start()
        } else {
            self.btnOk.enabled = false
            let myThread = NSThread(target: self, selector: "addTimer", object: nil)
            myThread.start()
            //self.navigationController?.popViewControllerAnimated(true)
        }
    }
    func moTimer(){
        let nC = FAME.tempTimerArrayContent
        let index = Int(nC["index"]!)!
        let enable = Int(nC["enable"]!)!
        let repeat_type = Int(nC["repeat_type"]!)!
        let action_id = nC["action_id"]!
        
        let nsdatef1:NSDateFormatter = NSDateFormatter()
        nsdatef1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        

        let time:String = "\(FAME.stringFromDate(self.Date.date, type: 4)):00"
        
        
        //self.btnAdd.enabled = false
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 38, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": {\"cmd\": 9, \"param\": {\"index\": \(index), \"action_id\": \(action_id), \"enable\": \(enable), \"repeat_type\": \(repeat_type), \"time\": \"\(time)\", \"repeat_day\":\(self.repeat_dayArr)}}}",timeout : 90)
            

        
        if (received != nil){
            print("OK")
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        //self.btnAdd.enabled = true
    }
    
    @IBOutlet weak var btnAdd: UIButton!
    func addTimer(){
        let nC = FAME.tempTimerArrayContent
        //let index = Int(nC["index"]!)!
        let enable = Int(nC["enable"]!)!
        let repeat_type = Int(nC["repeat_type"]!)!

        let action_id = nC["action_id"]!
        
        let time:String = "\(FAME.stringFromDate(self.Date.date, type: 4)):00"
        
        if ( Int(action_id)! > 0){
            //self.btnAdd.enabled = false
            let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 38, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": {\"cmd\": 8, \"param\": {\"action_id\": \(action_id), \"enable\": \(enable), \"repeat_type\": \(repeat_type), \"time\": \"\(time)\", \"repeat_day\":\(self.repeat_dayArr)}}}",timeout : 90)
            
            if (received != nil){
                print("OK")
                self.navigationController?.popViewControllerAnimated(true)
            }
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }

        //self.btnAdd.enabled = true
    }
    
    @IBAction func delTimer(sender: AnyObject) {
        let myThread = NSThread(target: self, selector: "deTimer", object: nil)
        myThread.start()
    }
    
    func deTimer(){
        let nC = FAME.tempTimerArrayContent
        let index = Int(nC["index"]!)!
        
        //self.btnAdd.enabled = false
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 38, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": {\"cmd\": 10, \"param\": {\"index\": \(index)}}}",timeout : 90)

        if (received != nil){
            print("OK")
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        //self.btnAdd.enabled = true
    }
    
    
}
