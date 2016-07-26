//
//  viewModesSetting.swift
//  FameSmartApp
//
//  Created by book on 14-9-1.
//  Copyright (c) 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//


//*********************
//
//      viewController of modesetting
//
//*********************
import UIKit

class viewModesSettingController: UIViewController,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate {

    var BGView:UIView!
    var pickView:UIView!
    
    var ids = [0,0,0,0,0,0,0,0]
    var id1 = -2
    var id2 = 0

    var act = 0
    var Links1:Array<Dictionary<String,AnyObject>> = []
    var Links2 : Array<Dictionary<String,AnyObject>> = []
    var Links3 : Array<Dictionary<String,AnyObject>> = []
    var seletedStr1:String! = ""
    var seletedStr2:String! = ""
    var seletedStr3:String! = ""
    var seletedBtn :UIButton!
    
    @IBOutlet var subView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let btnWidth = self.view.frame.size.width * 0.7
        let btnHeight = self.view.frame.size.height * 0.07
        let x = (self.view.frame.size.width - btnWidth)/2 - 30
        let btnDiff = self.view.frame.size.height * 0.09
        let btnTop0:CGFloat = self.view.frame.size.height * 0.06 - btnDiff
        var y = btnTop0
        for index in 0...7 {
            y = y + btnDiff
            let btn = UIButton(frame: CGRect(x: x, y: y, width: btnWidth, height: btnHeight))
            btn.setBackgroundImage(UIImage(named: "aboutFameBtn.png"), forState: UIControlState.Normal)
            btn.addTarget(self, action: "showSelectAct:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.setTitle(Defined_mode_link, forState: UIControlState.Normal)
            btn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            btn.tag = index
            self.subView.addSubview(btn)
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton

        
        self.createPop()
        
        self.Links1 = []
        if FAME.Links.count > 0 {
            
            for obj:Dictionary<String,AnyObject> in FAME.Links   {
                if (obj["show"] as! Int) != 0 {
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
    func insertNewObject(sender:AnyObject!){
        print("linked")
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
        
    }
    func refreshModes(){
        print("refresh")
        let myThread = NSThread(target: self, selector: "Timerset2", object: nil)
        myThread.start()
    }
    func Timerset2(){
        let cmdStr = "{\"cmd\": 32, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"action_id\":\(FAME.tempMode)}}"
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        if let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
            print("refresh successed")
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                FAME.showMessage("刷新成功")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            let detail:NSDictionary = received.valueForKey("detail") as! NSDictionary
            var index = 0
            for values:AnyObject in detail.valueForKey("sub_actions") as! NSArray {
                let idObj = values as! Int
                
                print(FAME.idForNamesMode[idObj])
                let btnTmp = self.subView.viewWithTag(index) as! UIButton
                if (FAME.idForNamesMode[idObj] != nil){
                    
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    btnTmp.setTitle("\(FAME.idForNamesMode[idObj]!)", forState: UIControlState.Normal)
                })
                
                
                self.ids[index] = idObj
                }
                index++
            }
            
        }else{
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                FAME.showMessage("刷新失败")
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
            
        }
    }
    func Timerset(){
        let paramArray=NSMutableArray()
        for value : Int in self.ids {
            if value > 10 {
                paramArray.addObject(value)
            }
        }
        
        let param = paramArray.componentsJoinedByString(",")
        
        let cmdStr = "{\"cmd\": 31, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"action_id\":\(FAME.tempMode),\"sub_actions\":[\(param)]}}"
        if (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90) != nil){
            print("link device successed")
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let alert = UIAlertView()
                alert.title = Defined_mode_title
                alert.message =  Defined_mode_update
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            })
            
            
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let alert = UIAlertView()
                alert.title = Defined_mode_title
                alert.message =  Defined_mode_failed
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()

            })
        }
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.refreshModes()
        
    }
    func selectedActBtn( sender : AnyObject){
        
        if self.id1 < 0 {
            self.seletedBtn.setTitle(Defined_mode_link, forState: UIControlState.Normal)
            self.ids[self.seletedBtn.tag] = 0
        }else{
            
            print("1111111\(self.seletedStr1) \(self.seletedStr2) \(self.seletedStr3)")
            
            self.seletedBtn.setTitle("\(self.seletedStr1) \(self.seletedStr2) \(self.seletedStr3)", forState: UIControlState.Normal)
            //FAME.idForNamesMode.updateValue(<#T##value: Value##Value#>, forKey: "\(self.seletedStr1) \(self.seletedStr2) \(self.seletedStr3)")
            self.ids[self.seletedBtn.tag] = self.id1 + self.id2
            print(self.ids)
        }
        print("selectedActBtn")
        //roomSheet.dismissWithClickedButtonIndex(2, animated: true)
        self.hidePop()
    }
    
    func cancleActBtn( sender : AnyObject){
        
        print("cancleActBtn")
        //roomSheet.dismissWithClickedButtonIndex(1, animated: true)
        self.hidePop()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSelectAct(sender : UIButton!) {
        
        //self.roomSheet.showInView(self.view)
        //self.roomSheet.bounds.size.height = 240
        //self.roomSheet.frame.size.height = 240
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
                    print(self.Links3)
                    
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
    
    func tapPress(sender:AnyObject!){
        self.hidePop()
    }
    
    func createPop(){
        
        self.BGView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.width, height: self.view.frame.height))
        self.BGView.backgroundColor = UIColor.clearColor()
        self.BGView.tag = 500
        
        
        let longPressRec = UITapGestureRecognizer()
        longPressRec.addTarget(self, action: "tapPress:")
        
        self.BGView.addGestureRecognizer(longPressRec)
        
        self.BGView.userInteractionEnabled = true
        
        
        self.pickView = UIView(frame: CGRect(x: 0, y: self.view.frame.height + 25 , width: self.view.frame.width, height: 300))
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
        picker.tag = 11
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
        
        let pv = self.pickView.viewWithTag(11) as! UIPickerView
        pv.selectRow(0, inComponent: 0, animated: false)
        self.Links2 = [["name":"","act_id":-2]]
        
        pv.reloadAllComponents()
        
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