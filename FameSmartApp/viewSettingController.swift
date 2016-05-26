//
//  viewSettingController.swift
//  FameSmartApp
//
//  Created by Eric on 14-12-1.
//  Copyright (c) 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//


//*********************
//
//   viewController of  system setting
//
//*********************

import UIKit
import AVFoundation

class ViewSettingController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func addDeviceBtn(sender : AnyObject) {
        FAME.isAddDeviceFromSetting = true
        let next :UIViewController = GBoard.instantiateViewControllerWithIdentifier("viewLogin5") as UIViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func linkPhoneBtn(sender : AnyObject) {
        FAME.isLinkPhoneFromSetting = true
        let next :UIViewController = GBoard.instantiateViewControllerWithIdentifier("viewLogin4") as UIViewController
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    
    @IBAction func loginOutBtn(sender : AnyObject) {
        let alert :UIAlertView = UIAlertView()
        alert.delegate = self
        alert.title = Defined_ALERT_loginOut
        alert.message = Defined_ALERT_loginOut2
        alert.addButtonWithTitle(Defined_ALERT_OK)
        alert.addButtonWithTitle(Defined_ALERT_CANCEL)
        alert.show()
    }
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        print("click at \(buttonIndex)")
        if buttonIndex == 0 {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
    }
}


class ViewSettingPwdController: UIViewController ,UITextFieldDelegate,UIAlertViewDelegate {
    
    @IBOutlet var pwdUser : UIButton!
    @IBOutlet var userPwd1 : UITextField!
    @IBOutlet var userPwd2 : UITextField!
    
    @IBOutlet var userPwd3 : UITextField!
    
    @IBOutlet var pwdLabel : UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.userPwd1.delegate = self
        self.userPwd2.delegate = self
        self.userPwd3.delegate = self
        
        self.userPwd1.returnKeyType = UIReturnKeyType.Next
        self.userPwd2.returnKeyType = UIReturnKeyType.Next
        self.userPwd3.returnKeyType = UIReturnKeyType.Done
        
        
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.view.frame.origin.y = -50
            }, completion:{(finished:Bool) -> Void in })
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        print(textField.tag)
        if textField.tag == 1 {
            self.userPwd2.becomeFirstResponder()
        }else if textField.tag == 2 {
            self.userPwd3.becomeFirstResponder()
        }else if textField.tag == 3{
            self.view.endEditing(false)
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.view.frame.origin.y = 0
                }, completion:nil)
        }
        return true
    }
    @IBAction func tapped(sender : AnyObject) {
        self.view.endEditing(true)
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.view.frame.origin.y = 0
            }, completion:nil)
    }
    @IBAction func editPwd(sender : AnyObject) {
        if self.userPwd1.text == FAME.user_pwd {
            if self.userPwd2.text == "" {
                let alert = UIAlertView()
                alert.title = Defined_setting_title
                alert.message =  Defined_setting_error3
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            }else{
                //POST
                
                
                let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 6, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(self.userPwd1.text)\",\"user_newpwd\": \"\(self.userPwd2.text)\",\"user_newpwd1\": \"\(self.userPwd3.text)\"}",cmplx:true)
                print(received)
                if( received != nil){
                    
                    switch received.valueForKey("result") as! UInt {
                    case 0:
                        let alert = UIAlertView()
                        alert.title = Defined_setting_title
                        alert.message =  Defined_setting_success
                        alert.addButtonWithTitle(Defined_ALERT_OK)
                        alert.show()
                        FAME.user_pwd = self.userPwd2.text
                        
                        self.userPwd1.text = ""
                        self.userPwd2.text = ""
                        self.userPwd3.text = ""
                        
                    case 3:
                        let alert = UIAlertView()
                        alert.title = Defined_setting_title
                        alert.message =  Defined_setting_error4
                        alert.addButtonWithTitle(Defined_ALERT_OK)
                        alert.show()
                        
                        self.userPwd2.text = ""
                        self.userPwd3.text = ""
                        
                    case 4:
                        let alert = UIAlertView()
                        alert.title = Defined_setting_title
                        alert.message =  Defined_setting_error5
                        alert.addButtonWithTitle(Defined_ALERT_OK)
                        alert.show()
                        
                        self.userPwd2.text = ""
                        self.userPwd3.text = ""
                        
                    default:
                        let alert = UIAlertView()
                        alert.title = Defined_setting_title
                        alert.message =  Defined_setting_error2
                        alert.addButtonWithTitle(Defined_ALERT_OK)
                        alert.show()
                        self.userPwd1.text = ""
                        self.userPwd2.text = ""
                        self.userPwd3.text = ""
                    }
                }
                //end POST
                
            }
        }else{
            let alert = UIAlertView()
            alert.title = Defined_setting_title
            alert.message =  Defined_setting_error1
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
        }
    }

    

}




class ViewSettingMTimerController: UIViewController {
    var BGView:UIView!
    var pickView:UIView!
    var picker:UIDatePicker!
    
    var selecltBtnId:Int = 0
    
    @IBOutlet weak var BtnDate: UIButton!
    @IBOutlet weak var BtnTime: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.createPop()
        
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        let date = FAME.getDateFormLocal()
        
        self.picker.setDate(date, animated: true)
        
        self.BtnDate.setTitle("\(Defined_Timer_Date) \(FAME.stringFromDate(date, type: 1))", forState: UIControlState.Normal)
        self.BtnTime.setTitle("\(Defined_Timer_Time) \(FAME.stringFromDate(date, type: 2))", forState: UIControlState.Normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func btnDateFun(sender: UIButton) {
        self.selecltBtnId = 0
        self.showPop()
    }
    
    @IBAction func btnTimeFun(sender: UIButton) {
        self.selecltBtnId = 1
        self.showPop()
        
    }
    
    
    
    func selectedActBtn( sender : AnyObject){
        print("selectedActBtn")
        print(self.picker.date)
        FAME.theTimeInterval = self.picker.date.timeIntervalSinceDate(NSDate())
        
        self.BtnDate.setTitle("\(Defined_Timer_Date) \(FAME.stringFromDate(self.picker.date, type: 1))", forState: UIControlState.Normal)
        self.BtnTime.setTitle("\(Defined_Timer_Date) \(FAME.stringFromDate(self.picker.date, type: 2))", forState: UIControlState.Normal)
        
        self.hidePop()
        
        if FAME.updateDateToServer(self.picker.date) {
            print("OK")
        }else{
            print("failed")
        }
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
        
        
        self.picker = UIDatePicker()

        
        self.picker.frame = CGRect(x: 20, y: 45, width: pickView.frame.width - 40 , height: 162)
        
        self.pickView.addSubview(self.picker)

        
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
        self.picker.setDate(FAME.getDateFormLocal(), animated: true)
        if self.selecltBtnId == 0 {
            self.picker.datePickerMode = UIDatePickerMode.Date
        }else{
            self.picker.datePickerMode = UIDatePickerMode.CountDownTimer
        }
        self.picker.setDate(FAME.getDateFormLocal(), animated: true)
        
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

