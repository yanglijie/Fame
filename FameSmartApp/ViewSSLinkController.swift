//
//  ViewSSLinkController.swift
//  FameSmartApp
//
//  Created by famesmart on 16/5/31.
//  Copyright © 2016年 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

import UIKit
//配置联动设备
class ViewSSLinkController: UIViewController,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    
    var BGView:UIView!

    var pickView2:UIView!
    
    
    var picker:UIPickerView!
 
    var tmpStr:String!
    
    var Links1:Array<Dictionary<String,AnyObject>> = []
    var Links2 : Array<Dictionary<String,AnyObject>> = []
    

    var ids = 0
    var id1 = -2
    var id2 = 1
    
    
    
    
    
    var act = 0
    var seletedStr1:String! = ""
    var seletedStr2:String! = ""
    var seletedStr3:String! = ""
    var seletedBtn :UIButton2!
    
    var sensors:Array<Dictionary<String,String>> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = FAME.dev_ss_Rname + FAME.dev_ss_name ;
        // Do any additional setup after loading the view, typically from a nib.
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "refreshLights:")
        self.navigationItem.rightBarButtonItem = addButton
        let addClick = self.view.viewWithTag(53) as! UIButton!;
        addClick.addTarget(self, action: Selector("addDevLink:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        
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
    func addDevLink(sender:AnyObject!){

        print("点击添加");
        self.showVIew2() ;
        
    }
    func refreshLights(sender:AnyObject!){
        print("refreshLights")
        //self.TableView!.reloadData()
        //        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        //        myThread.start()
        
    }

    func tapPress(sender:AnyObject!){
        self.hidePop() ;
        print("单击");
    }
    func createPop(){
        
        self.BGView = UIView(frame: CGRect(x: 0, y: 0 , width: self.view.frame.width, height: self.view.frame.height))
        self.BGView.backgroundColor = UIColor.clearColor()
        
        
        //cancel
        
        let longPressRec = UITapGestureRecognizer()
        longPressRec.addTarget(self, action: "tapPress:")
        
        self.BGView.addGestureRecognizer(longPressRec)
        
        self.BGView.userInteractionEnabled = true
 

        
        self.pickView2 = UIView(frame: CGRect(x: 0, y: self.BGView.frame.height-300 , width: self.BGView.frame.width, height: 300 ))
        self.pickView2.backgroundColor = UIColor.whiteColor()
        
        
        
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
        
        
        self.picker = UIPickerView(frame: CGRect(x: 20, y: 40, width: pickView2.frame.width - 40 , height: 230))
        
        self.picker.dataSource = self
        self.picker.delegate = self
        self.picker.backgroundColor = UIColor.clearColor() ;
 
        
        //self.pickView.addSubview(self.pickView2)
        self.pickView2.addSubview(self.picker)
        self.pickView2.addSubview(btn)
        self.pickView2.addSubview(btn2)

        self.BGView.hidden = true
        self.view.addSubview(self.BGView)
        self.BGView.addSubview(self.pickView2)
    }
    func showVIew2(){
        
        //self.picker.hidden = false
        self.BGView.hidden = false
        UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {

            
            self.pickView2.frame = CGRect(x: 0, y: self.view.frame.height-300 , width: self.view.frame.width, height: 300)
            
            }, completion: nil)
    }
    

    
    func hidePop() {
        let newFrame = CGRect(x: 0, y: self.view.frame.height + 5 , width: self.view.frame.width, height: 240)
        UIView.animateWithDuration(0.5, delay: 0, options: [], animations: {
            self.pickView2.frame = newFrame
            }, completion: {
                (finished:Bool) -> Void in
                self.BGView.hidden = true
                
        })
        
    }

    func selectedActBtn(sender : AnyObject){
        
            
        print("\(self.seletedStr1)\(self.seletedStr2)\(self.seletedStr3)")
        let str:String! = "\(self.seletedStr1)\(self.seletedStr2)\(self.seletedStr3)";
        let addClick = self.view.viewWithTag(53) as! UIButton!;
        addClick.setTitle(str, forState: UIControlState.Normal)

        self.hidePop() ;
            
        
        
    }

    func cancleActBtn( sender : AnyObject){
        
        print("cancleActBtn")
        //roomSheet.dismissWithClickedButtonIndex(1, animated: true)
        
        self.hidePop()
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
        
    }
    
    
}
