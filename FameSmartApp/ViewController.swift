//
//  ViewController.swift
//  FameSmartApp
//
//  Created by Eric on 14-8-1.
//  Copyright (c) 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//


//*********************
//
//      ViewControllers about the resgist and login
//
//*********************


import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class ViewControllerWelcome: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController.setNavigationBarHidden(true, animated: false)
        // Do any additional setup after loading the view, typically from a nib.
        /*
        var localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Testing notifications on iOS7"
        localNotification.alertBody = "Woww it works!!"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 3)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        */
        
        //dt().initFromFile()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerFunction()
    {
        
        
            //network error
            //viewAnimate().showTip(self.tip, content: Defined_network_failed)
            let next = GBoard.instantiateViewControllerWithIdentifier("navLogin") as UIViewController
            self.presentViewController(next, animated: true, completion: nil)
            
        
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
   
        
        let timmer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector:"timerFunction", userInfo:nil, repeats:false)
    }
}

class ViewControllerLogin0: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController.navigationBar.backgroundColor = UIColor.clearColor()
        //self.navigationController.navigationBar.topItem.title = "123"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "empty.png"), forBarMetrics: UIBarMetrics.Default)
        
        let timmer:NSTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target:self, selector:"timerFunction", userInfo:nil, repeats:false)
 
        //self.navigationController.setNavigationBarHidden(true, animated: true)
    }
    func timerFunction(){
        let userName = FAME.getProfile(0)
        let userPass = FAME.getProfile(1)
        FAME.user_name = userName
        FAME.user_pwd = userPass
        
        var received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 10, \"user_name\": \"\(userName)\",\"user_pwd\": \"\(userPass)\", \"client_type\": \"ios\"}",cmplx:true)
        //received = nil
        if FAME.outTag == 1{
            received = nil
        }
        if (received != nil) {
            switch received.valueForKey("result") as! NSNumber {
                
            case 0 :
                print("login successed")
                
                let next = GBoard.instantiateViewControllerWithIdentifier("navMain") as UIViewController
                //next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
                self.presentViewController(next, animated: false, completion: {
                    self.navigationController?.popToRootViewControllerAnimated(false)
                })
                
                
                if (FAME.defaults.valueForKey("PushState") != nil){
                    let pushState = FAME.defaults.valueForKey("PushState") as! Bool
                    if pushState{
                        UIApplication.sharedApplication().registerForRemoteNotifications()
                        
                    }
                    
                }
//                else{
//                    UIApplication.sharedApplication().registerForRemoteNotifications()
//                }
                
                FAME.user_uid = received.valueForKey("user_uid") as! UInt
                
                if received.valueForKey("device_count") as! Int == 0 {
                    print("no devices linked")
                    
                }else{
                    let devices : NSArray = received.valueForKey("devices") as! NSArray
                    let devicesObj : NSDictionary = devices[0] as! NSDictionary
                    FAME.user_did = devicesObj.valueForKey("did") as! UInt
                    FAME.user_ieee_addr = devicesObj.valueForKey("ieee_addr") as! String
                    FAME.user_dname = devicesObj.valueForKey("dname") as! String
                    
                    
                    //UIApplication.sharedApplication().registerForRemoteNotifications()
                    
                    
                    //get the devicetable
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                        let DTValue = FAME.getDeviceTable()
                        if (DTValue != nil) {
                            if DTValue == 0 {
                                print("DeviceTable is OK")
                                
                                
                                //self.showNavMain()
                            }else{
                                print("DeviceTable is null")
                                FAME.getDeviceTable()
                                FAME.lastDTversion = FAME.DTversion
                                let next = GBoard.instantiateViewControllerWithIdentifier("viewLogin5") as UIViewController
                                self.navigationController?.pushViewController(next, animated: true)
                                FAME.isAddDeviceFromSetting = false
                                
                            }
                        }else{
                            print("get DT failed")

                        }

                    }
                    
                }
                
            default:
                
                print("get DT failed")
                //                viewAnimate().shrkInput(userName)
                //                viewAnimate().shrkInput(userPass)
                
            }
            
            
            
        }else{
           
            print("get DT failed")
            
        }
        

    }
}




class ViewControllerLogin1: UIViewController, UITextFieldDelegate {
    var orgY:Float!
    @IBAction func didTapped(sender : AnyObject) {
        self.view.endEditing(false)
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.view.frame.origin.y = CGFloat(self.orgY)
            }, completion:nil)
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        
    
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.view.frame.origin.y = CGFloat(self.orgY - 100)
            }, completion:{(finished:Bool) -> Void in })
        return true
    }
    func textFieldShouldEndEditing(textField: UITextField) -> Bool{

        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
            print(textField.tag)
        if textField.tag == 1 {
            self.userPwd.becomeFirstResponder()
        }else if textField.tag == 2{
            self.view.endEditing(false)
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.view.frame.origin.y = CGFloat(self.orgY)
                }, completion:nil)
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.orgY = Float(self.view.frame.origin.y)
        self.userName.delegate = self
        self.userPwd.delegate = self
       
        self.userName.returnKeyType = UIReturnKeyType.Next
        self.userPwd.returnKeyType = UIReturnKeyType.Done
        
        
        self.userName.text = FAME.getProfile(0)
        self.userPwd.text = FAME.getProfile(1)
        
        
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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    override func viewWillDisappear(animated: Bool){
        super.viewWillDisappear(animated)
        
        
        
    }
    
    @IBOutlet var userName : UITextField!
    
    @IBOutlet var userPwd : UITextField!
    
    @IBOutlet var tip : UILabel!

    @IBOutlet var logo : UIView!
    
    @IBOutlet var loginBtn : UIView!
    
    @IBOutlet var viewInput2 : UIView!
    
    @IBOutlet var viewInput1 : UIView!
    
    @IBOutlet weak var view3: UIView!
    
    @IBOutlet weak var localBtn: UIButton!
    
    @IBAction func localLogin(sender: AnyObject){
       
        let ip:String! = ViewControllerLogin1.getlocalIP()[0] as String!
        Surl = "http://\(ip)/cgi-bin/sm_user_intf.cgi"

        print(Surl)
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 0}",cmplx:true)
        
        //self.showNavMain()
        
    }
    
    @IBAction func doLogin(sender : AnyObject) {
        
        FAME.user_name = self.userName.text
        FAME.user_pwd = self.userPwd.text
        
        let userName = FAME.getProfile(0)
        if userName != self.userName.text{
            FAME.msgs.removeAll()
            FAME.defaults.setObject(FAME.msgs.reverse(), forKey: "\(FAME.user_name)")
        }

        //save to local
        
        FAME.saveProfile(FAME.user_name, pwd: FAME.user_pwd)
        

        //var dl=HttpClient()
        
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 10, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"client_type\": \"ios\"}",cmplx:true)

        
        if (received != nil) {
            switch received.valueForKey("result") as! NSNumber {
                
            case 0 :
                print("login successed")
                
                self.showNavMain()
                
                if (FAME.defaults.valueForKey("PushState") != nil){
                    let pushState = FAME.defaults.valueForKey("PushState") as! Bool
                    if pushState{
                        UIApplication.sharedApplication().registerForRemoteNotifications()
                        
                    }
                    
                }
//                else{
//                    UIApplication.sharedApplication().registerForRemoteNotifications()
//                }
                
                FAME.user_uid = received.valueForKey("user_uid") as! UInt
            
                if received.valueForKey("device_count") as! Int == 0 {
                    print("no devices linked")
                    
                }else{
                    let devices : NSArray = received.valueForKey("devices") as! NSArray
                    let devicesObj : NSDictionary = devices[0] as! NSDictionary
                    FAME.user_did = devicesObj.valueForKey("did") as! UInt
                    FAME.user_ieee_addr = devicesObj.valueForKey("ieee_addr") as! String
                    FAME.user_dname = devicesObj.valueForKey("dname") as! String
                    
                    //UIApplication.sharedApplication().registerForRemoteNotifications()
                    
                    
                    //get the devicetable
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                        let DTValue = FAME.getDeviceTable()
                        
                        if (DTValue != nil) {
                            if DTValue == 0 {
                                print("DeviceTable is OK")
                                
                            }else{
                                print("DeviceTable is null")
                                FAME.getDeviceTable()
                                FAME.lastDTversion = FAME.DTversion
                                let next = GBoard.instantiateViewControllerWithIdentifier("viewLogin5") as UIViewController
                                self.navigationController?.pushViewController(next, animated: true)
                                FAME.isAddDeviceFromSetting = false
                                
                            }
                        }
                        else{
                            print("get DT failed")
                            
                            viewAnimate().shrkInput(self.userName)
                            viewAnimate().shrkInput(self.userPwd)
                            viewAnimate().showTip(self.tip, content: Defined_login_dt_failed)
                        }
 
                    }
                    
                }
                
            default:
                
                viewAnimate().shrkInput(self.userName)
                viewAnimate().shrkInput(self.userPwd)
                viewAnimate().showTip(self.tip, content: Defined_login_failed)
            }
            
            
            
        }else{
            //network error
            viewAnimate().showTip(self.tip, content: Defined_network_failed)
            
        }
    }
    
    static func getlocalIP() -> [String]{
        
        var addresses = [String]()
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs> = nil
        if getifaddrs(&ifaddr) == 0 {
            
            // For each interface ...
            for (var ptr = ifaddr; ptr != nil; ptr = ptr.memory.ifa_next) {
                let flags = Int32(ptr.memory.ifa_flags)
                var addr = ptr.memory.ifa_addr.memory
                
                // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
                if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                    if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                        
                        // Convert interface address to a human readable string:
                        var hostname = [CChar](count: Int(NI_MAXHOST), repeatedValue: 0)
                        if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                            if let address = String.fromCString(hostname) {
                                addresses.append(address)
                            }
                        }
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return addresses
    }
    
    
    func showNavMain(){
        
        let screenHeight = self.view.bounds.height
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        var Frame = self.logo.frame
        var destFrame = CGRect(x: Frame.origin.x, y: Frame.origin.y+130, width: Frame.width, height: Frame.height)

        
        UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.logo.frame = destFrame
            }, completion:{
                (finished:Bool) -> Void in
                if finished {
                    let Frame = self.view.frame
                    destFrame = CGRect(x: Frame.origin.x, y: Frame.origin.y+130, width: Frame.width * 2, height: Frame.height * 2)
                    
                    UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                        self.logo.frame = self.view.bounds
                        self.logo.alpha = 0
                        }, completion: {
                            (finished:Bool) -> Void in
                            if finished {
                                
                                //isoPUSH
                                if(FAME.deviceToken != nil){
                                    httpRequert().sendToken(FAME.deviceToken!)
                                }
                                
                                
                                //show the MainView
                                let next = GBoard.instantiateViewControllerWithIdentifier("navMain") as UIViewController
                                //next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
                                self.presentViewController(next, animated: false, completion: {
                                        self.logo.alpha = 1
                                        self.navigationController?.popToRootViewControllerAnimated(false)
                                    })
                                
                            }
                        })
                }
            })
        
        
        //loginBtn
        Frame = self.loginBtn.frame
        
        destFrame = CGRect(x: Frame.origin.x, y: Frame.origin.y+screenHeight, width: Frame.width, height: Frame.height)
        
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.loginBtn.frame = destFrame
            }, completion: nil)
        
        //localBtn
        Frame = self.localBtn.frame
        
        destFrame = CGRect(x: Frame.origin.x, y: Frame.origin.y+screenHeight, width: Frame.width, height: Frame.height)
        
        UIView.animateWithDuration(1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.localBtn.frame = destFrame
            }, completion: nil)
        
        
        //viewInput1
        Frame = self.viewInput2.frame
        destFrame = CGRect(x: Frame.origin.x, y: Frame.origin.y-screenHeight, width: Frame.width, height: Frame.height)
        
        UIView.animateWithDuration(1, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.viewInput2.frame = destFrame
            }, completion: nil)
        
        
        //viewInput2
        Frame = self.viewInput1.frame
        destFrame = CGRect(x: Frame.origin.x, y: Frame.origin.y-screenHeight, width: Frame.width, height: Frame.height)
        
        UIView.animateWithDuration(1, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.viewInput1.frame = destFrame
            }, completion: nil)
        
        //view3
        Frame = self.view3.frame
        destFrame = CGRect(x: Frame.origin.x, y: Frame.origin.y+screenHeight, width: Frame.width, height: Frame.height)
        
        UIView.animateWithDuration(1, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.view3.frame = destFrame
            }, completion: nil)
        
        
    }
}

class ViewControllerLogin2: UIViewControllerQRcode, UITextFieldDelegate {
    var model_id:UInt = 2
    @IBAction func didTapped(sender : AnyObject) {
        self.view.endEditing(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.inputType.returnKeyType = UIReturnKeyType.Next
        self.inputType.delegate = self
        self.inputHv.returnKeyType = UIReturnKeyType.Next
        self.inputHv.delegate = self
        self.inputCK.returnKeyType = UIReturnKeyType.Done
        self.inputCK.delegate = self
        
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{

        print(textField.tag)
        if textField.tag == 1 {
            self.inputHv.becomeFirstResponder()
        }else if textField.tag == 2{
            self.inputCK.becomeFirstResponder()

        }else{
            self.view.endEditing(false)
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor=UIColor.whiteColor()
        print(self.navigationController?.navigationBar.barTintColor)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "empty.png"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    @IBAction func showQRcode(sender : AnyObject) {

        let next :ViewControllerQRcode = GBoard.instantiateViewControllerWithIdentifier("viewQR") as! ViewControllerQRcode
        next.pView = self
        next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        self.presentViewController(next, animated: true, completion: nil)
    }
    @IBOutlet var inputHv : UITextField!
    
    @IBOutlet var inputCK : UITextField!
    
    @IBOutlet var viewCK : UIView!
    
    @IBOutlet var inputType : UITextField!
    
    @IBOutlet var tip : UILabel!
    
    
    @IBAction func getTheType(sender : AnyObject) {
    
        let hvStr = "FameSmart:\(self.inputHv.text!)"
        let hvMd5Str:String = hvStr.md5().uppercaseString as String
        let md5Str:String! = self.inputCK.text
        print(hvStr)
        print(hvMd5Str)
        print(md5Str)
        
        if md5Str == hvMd5Str {
            print("MD5 OK")
            if (self.inputType.text == ""){
                //get the Type
                let dl = httpRequert()
                if let received = dl.downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 23, \"ieee_addr\": \"\(self.inputHv.text!)\"}"){
                    
                    self.model_id = received.valueForKey("model_id") as! UInt
                    self.inputType.text = received.valueForKey("model_name") as? String
                    
                }else{
                    self.inputType.text = Defined_Unkown_Device
                }
                
                
            }
            
        }
        

    }
    
    @IBAction func ckMd5(sender : AnyObject) {
        let hvStr = "FameSmart:\(self.inputHv.text!)"
        let hvMd5Str:String = hvStr.md5().uppercaseString as String
        let md5Str:String! = self.inputCK.text
        print(hvStr)
        print(hvMd5Str)
        print(md5Str)
        
        if md5Str == hvMd5Str {
            print("MD5 OK")
            
            
            
            //check the type
            if (self.model_id == 2 )||(self.model_id == 3 ) {
                FAME.user_ieee_addr = self.inputHv.text!
                FAME.user_ieee_ck = self.inputCK.text!
                let next = GBoard.instantiateViewControllerWithIdentifier("viewLogin3") as UIViewController
                self.navigationController?.pushViewController(next, animated: true)
                
            }else{
                
                viewAnimate().shrkInput(self.inputType!)
                viewAnimate().showTip(self.tip!, content: Defined_register_not_router)
                
            }
            
            

        }else{
            print("MD5 error")
            self.inputCK.textColor = UIColor.redColor()
            self.inputHv.textColor = UIColor.redColor()
            viewAnimate().shrkInput(self.inputCK)
            viewAnimate().shrkInput(self.inputHv)
        }
    }
    
    override func deQRcode(str: String){
        print("get QRCode:\(str)")
        
        //let ieee = str.substringWithRange(5, B: 23)
        //let verify = str.substringWithRange(36, B: 32)
        
        let ieee = FAME.subString(str, A: 5, B: 23)
        let verify = FAME.subString(str, A: 36, B: 32)
        
        self.inputHv.text! = ieee
        self.inputCK.text! = verify
        
            //get the Type
            if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 23, \"ieee_addr\": \"\(self.inputHv.text!)\"}"){
                
                self.inputType.text = recevied.valueForKey("model_name") as? String
                self.model_id = recevied.valueForKey("model_id") as! UInt
                
            }else{
                self.inputType.text = Defined_Unkown_Device
            }
            
        }
}

class ViewControllerQRcode: UIViewController , AVCaptureMetadataOutputObjectsDelegate ,UIAlertViewDelegate{
    
    var scanRectView:UIView!
    //扫描线
    let scanLine = UIImageView()
    
    var timer: NSTimer!
    
    var device:AVCaptureDevice!
    var input:AVCaptureDeviceInput!
    var output:AVCaptureMetadataOutput!
    var session:AVCaptureSession!
    var preview:AVCaptureVideoPreviewLayer!
    var pView: UIViewControllerQRcode!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        //创建定时器，用于实现扫描线动画
        
        
        setupCamera()
        
        
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupCamera(){
        //do{
            
        //Device
        self.device=AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        //input
        do{

            self.input = try AVCaptureDeviceInput(device: self.device) as AVCaptureDeviceInput

            self.timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: "moveScannerLayer:", userInfo: nil, repeats: true)
        //output
        self.output=AVCaptureMetadataOutput()
        self.output.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        //self.output.setMetadataObjectsDelegate(self, queue: dispatch_get_current_queue()!)
        //Session
        self.session = AVCaptureSession()
        
        if UIScreen.mainScreen().bounds.size.height<500 {
            self.session.sessionPreset = AVCaptureSessionPreset640x480
        }else{
            self.session.sessionPreset = AVCaptureSessionPresetHigh
        }
        
        self.session.addInput(self.input)
        self.session.addOutput(self.output)
            
        
            
        let arr:NSArray = NSArray(array: [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code])
        self.output.metadataObjectTypes = arr as [AnyObject]
        //self.output.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        
        //计算中间可探测区域
        let windowSize:CGSize = UIScreen.mainScreen().bounds.size;
        let scanSize:CGSize = CGSizeMake(windowSize.width*3/4,
        windowSize.width*3/4);
        var scanRect:CGRect = CGRectMake((windowSize.width-scanSize.width)/2,
        (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
        //计算rectOfInterest 注意x,y交换位置
        scanRect = CGRectMake(scanRect.origin.y/windowSize.height,
        scanRect.origin.x/windowSize.width,
        scanRect.size.height/windowSize.height,
        scanRect.size.width/windowSize.width);
        
        //设置可探测区域
        self.output.rectOfInterest = scanRect
            
        //preview
        self.preview = AVCaptureVideoPreviewLayer(session: self.session)
        self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.preview.frame = UIScreen.mainScreen().bounds
        
        
        self.view.layer.insertSublayer(self.preview, atIndex: 0)
        
        //设置扫描范围
        output.rectOfInterest = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        
        //添加中间的探测区域绿框
        self.scanRectView = UIView();
        
        
        self.view.addSubview(self.scanRectView)
        self.scanRectView.frame = CGRectMake(0, 0, scanSize.width, scanSize.height);
        self.scanRectView.center = CGPointMake(
            CGRectGetMidX(UIScreen.mainScreen().bounds),
            CGRectGetMidY(UIScreen.mainScreen().bounds));
        self.scanRectView.layer.borderColor = UIColor.whiteColor().CGColor
        self.scanRectView.layer.borderWidth = 1;
        
        //设置扫描线
        scanLine.frame = CGRect(x: 0, y: 0, width: scanRectView.frame.size.width, height: 10)
        scanLine.image = UIImage(named: "QRCodeScanLine")
        //scanLine.backgroundColor = UIColor.redColor()
        self.scanRectView .addSubview(scanLine)
        createBackGroundView()

        //开始捕获
        self.session.startRunning()
           
        
        }
        catch{
            
            
            let errorAlert = UIAlertView(title: "提醒",
                    message: "请在iPhone的\"设置-隐私-相机\"选项中,允许本程序访问您的相机",
                    delegate: self,
                    cancelButtonTitle: "确定")
            errorAlert.show()
           
            //
        }
        
    }
    //消息框确认后消失
    func alertView(alertView: UIAlertView, willDismissWithButtonIndex buttonIndex: Int) {
        //继续扫描
        //self.session.startRunning()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!){

        
        let metadataObj:AVMetadataMachineReadableCodeObject  = metadataObjects[0] as! AVMetadataMachineReadableCodeObject

        self.session.stopRunning()
        
        print(metadataObj.stringValue)
        //tmpInput.text = metadataObj.stringValue
        if metadataObj.stringValue != nil{
            self.session.stopRunning()
            self.timer.fire()
        }
        
        self.pView.deQRcode(metadataObj.stringValue)
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        // println(metadataObjects)
    }
    func createBackGroundView() {
        let windowSize:CGSize = UIScreen.mainScreen().bounds.size;
        
        let label1 = UILabel(frame: CGRect(x: 0, y: 20, width:windowSize.width, height: 44))
        label1.textAlignment = .Center
        label1.font = UIFont.systemFontOfSize(24)
        label1.textColor = UIColor.redColor()
        label1.text = "请点击该处返回"
        
        self.view .addSubview(label1)
        
        let height = ( windowSize.height - (windowSize.width * 0.75) )/2
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: windowSize.width, height:height))
        let bottomView = UIView(frame: CGRect(x: 0, y: windowSize.width * 0.75 + height, width: windowSize.width, height: height))
        
        let leftView = UIView(frame: CGRect(x: 0, y: height, width: windowSize.width * 0.125, height: windowSize.width * 0.75))
        let rightView = UIView(frame: CGRect(x: windowSize.width * 0.875, y: height, width: windowSize.width * 0.125, height: windowSize.width * 0.75))
        
        topView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        bottomView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        leftView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        rightView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        let label = UILabel(frame: CGRect(x: 0, y: bottomView.frame.size.height - 30, width:windowSize.width, height: 21))
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(14)
        label.textColor = UIColor.whiteColor()
        label.text = "将二维码/条形码放入扫描框内，即自动扫描"
        
        self.view .addSubview(label)
        
        //bottomView.addSubview(label)
        
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
        self.view.addSubview(leftView)
        self.view.addSubview(rightView)
        
    }
    //让扫描线滚动
    func moveScannerLayer(_timer : NSTimer) {
//        let windowSize:CGSize = UIScreen.mainScreen().bounds.size;
//        let top = windowSize.height - (windowSize.width * 0.75) 
//        scanLine.frame = CGRect(x: 0, y: 0, width: windowSize.width*0.75, height: 10)
//        UIView.animateWithDuration(2) { () -> Void in
//            self.scanLine.frame = CGRect(x: self.scanLine.frame.origin.x, y: self.scanLine.frame.origin.y + top - 4, width: self.scanLine.frame.size.width, height: self.scanLine.frame.size.height)
//        }
        
        scanLine.frame = CGRect(x: 0, y: 0, width: self.scanRectView.frame.size.width, height: 12)
        UIView.animateWithDuration(2) { () -> Void in
            self.scanLine.frame = CGRect(x: self.scanLine.frame.origin.x, y: self.scanLine.frame.origin.y + self.scanRectView.frame.size.height - 10, width: self.scanLine.frame.size.width, height: self.scanLine.frame.size.height)
            
        }
        
    }

    
    
    override func viewWillDisappear(animated: Bool){
        super.viewWillDisappear(animated)

    }
}


class ViewControllerLogin3: UIViewController,UITextFieldDelegate {
 
    @IBOutlet var userName : UITextField!
    @IBOutlet var userPwd1 : UITextField!
    @IBOutlet var userPwd2 : UITextField!

    @IBOutlet var tip : UILabel!
    @IBAction func didTapped(sender : AnyObject) {
        self.view.endEditing(false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.userName.returnKeyType = UIReturnKeyType.Next
        self.userName.delegate = self
        self.userPwd1.returnKeyType = UIReturnKeyType.Next
        self.userPwd1.delegate = self
        self.userPwd2.returnKeyType = UIReturnKeyType.Done
        self.userPwd2.delegate = self
        
        
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
        self.tip.alpha = 0
        
    }
    @IBAction func doRegist(sender : AnyObject) {
        FAME.user_name = self.userName.text
        FAME.user_pwd = self.userPwd1.text
        var ani = viewAnimate()
        
       
        
        if self.userPwd1.text == self.userPwd2.text {
            //do regist
            let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 3, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\",\"user_pwd1\": \"\(FAME.user_pwd)\",\"user_vcode\": \"\", \"user_email\": \"web@lyzic.com\"}",cmplx:true)
            print(received)
            if (received != nil){
            
                switch received.valueForKey("result") as! UInt {
                case 1:
                    viewAnimate().showTip(self.tip, content: Defined_register_SQL_failed)
                case 2:
                    viewAnimate().showTip(self.tip, content: Defined_register_User_existed)
                    viewAnimate().shrkInput(self.userName, notChangeColoer: false)
                    
                case 3:
                    
                    viewAnimate().showTip(self.tip, content: Defined_register_userName_less)
                    viewAnimate().shrkInput(self.userName, notChangeColoer: false)
                    
                    
                case 4:
                    
                    viewAnimate().showTip(self.tip, content: Defined_register_userPwd_less)
                    viewAnimate().shrkInput(self.userPwd1, notChangeColoer: false)
                    viewAnimate().shrkInput(self.userPwd2, notChangeColoer: false)
                case 5:
                    viewAnimate().showTip(self.tip, content: Defined_register_userPwd_diff)
                    viewAnimate().shrkInput(self.userPwd2, notChangeColoer: false)
                    
                    
                case 6:
                    viewAnimate().showTip(self.tip, content: "E-mail is wrong")
                    
                    
                case 0:
                    print("regist successed")
                    
                    //link the device
                    FAME.user_uid = received.valueForKey("uid") as! UInt
                    if let received2 = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 13, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\",\"ieee_addr\": \"\(FAME.user_ieee_addr)\",\"verify_code\": \"\(FAME.user_ieee_ck)\", \"dname\": \"My SmartHome\"}") {
                        
                        print("linked")
                        self.tip.text = nil
                        FAME.user_did = received2.valueForKey("did") as! UInt
                        //get the DT
                        
                        FAME.isAddingDevice = false
                        FAME.addDeviceArray = []
                        FAME.delDeviceArray = []
                        
                        let DTValue = FAME.getDeviceTable()
                        if (DTValue != nil) {
                            if DTValue == 0 {
                                print("DeviceTable is OK")
                                //show the MainView
                                let next = GBoard.instantiateViewControllerWithIdentifier("navMain") as UIViewController
                                self.presentViewController(next, animated: false, completion: {
                                    var Objs = self.navigationController?.popToRootViewControllerAnimated(false)
                                    })
                            }else{
                                print("DeviceTable is null")
                                FAME.getDeviceTable()
                                FAME.lastDTversion = FAME.DTversion
                                FAME.isLinkPhoneFromSetting = false
                                let next = GBoard.instantiateViewControllerWithIdentifier("viewLogin5") as UIViewController
                                self.navigationController?.pushViewController(next, animated: true)
                                FAME.isAddDeviceFromSetting = false
                            }
                        }else{
                            print("get DT failed")
                            FAME.getDeviceTable()
                            FAME.lastDTversion = FAME.DTversion
                            FAME.isLinkPhoneFromSetting = false
                            self.navigationController?.setNavigationBarHidden(true, animated: true)
                            let next = GBoard.instantiateViewControllerWithIdentifier("viewLogin5") as UIViewController
                            self.navigationController?.pushViewController(next, animated: true)
                        }
                        
                    }else{
                        print("link-device failed")
                    }
                    
                    
                default:
                    viewAnimate().showTip(self.tip, content: Defined_register_failed)
                }
            }else{
                //network error
                viewAnimate().showTip(self.tip, content: Defined_network_failed)

            }
        }else{
            
            viewAnimate().showTip(self.tip, content: Defined_register_userPwd_diff)
            viewAnimate().shrkInput(self.userPwd2, notChangeColoer: false)
            
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{

        print(textField.tag)
        if textField.tag == 1 {
            self.userPwd1.becomeFirstResponder()
        }else if textField.tag == 2{
            self.userPwd2.becomeFirstResponder()
            
        }else{
            self.view.endEditing(false)
        }
        return true
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool{
        textField.textColor = UIColor.whiteColor()
        return true
    }
}


class ViewControllerLogin4: UIViewController , UITextFieldDelegate,UIAlertViewDelegate{

    
    var timer :NSTimer!
    //var remainingSeconds = 0
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnSkip: UIButton!
    
    @IBOutlet weak var getVer: UIButton!
    
    @IBAction func didTapped(sender : AnyObject) {
        self.view.endEditing(false)
    }
    @IBOutlet var inputTel : UITextField!
   
    @IBOutlet var inputVcode : UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        inputTel.delegate = self
        self.inputTel.returnKeyType = UIReturnKeyType.Done
        self.inputTel.delegate = self
        self.inputVcode.returnKeyType = UIReturnKeyType.Done
        self.inputVcode.delegate = self
        
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
    }
    
    var remainingSeconds: Int = 0 {
        willSet {
            self.getVer.setTitle("\(newValue)秒", forState: .Normal)
            
            if newValue <= 0 {
                self.getVer.setTitle("获取验证码", forState: .Normal)
                isCounting = false
            }
        }
    }
    var isCounting = false{
        willSet {
            if newValue {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime:", userInfo: nil, repeats: true)
                
                remainingSeconds = 120
                
            } else {
                self.timer?.invalidate()
                self.timer = nil
                
            }
            
            self.getVer.enabled = !newValue
        }
    }
    func updateTime(timer: NSTimer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    @IBAction func getVerify(sender: UIButton) {
        
        isCounting = true
        let myThread = NSThread(target: self, selector: "Timerset1", object: nil)
        myThread.start()
 
    
    }
    func Timerset1(){
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 4, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\",\"user_phone\": \"\(self.inputTel.text!)\"}",cmplx:true)
        print(received)
        if( received != nil){
            if received.valueForKey("result") as! UInt == 0{
                
               
                
            }
            else{
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    FAME.showMessage("输入的手机号不正确")
                })
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
      //  self.navigationController.setNavigationBarHidden(true, animated: true)
        if FAME.isLinkPhoneFromSetting {
            self.btnNext.setTitle("绑定", forState: UIControlState.Normal)
            self.btnSkip.hidden = true
        }else{
            self.btnNext.setTitle("绑定&下一步", forState: UIControlState.Normal)
            self.btnSkip.hidden = false
        }
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        print(textField.tag)
        //if textField.tag == 1 {
            //self.inputVcode.becomeFirstResponder()
        //}else{
            self.view.endEditing(false)
        //}
        return true
    }

    @IBAction func didShowLogin5(sender : AnyObject) {

//        let next = GBoard.instantiateViewControllerWithIdentifier("viewLogin5") as UIViewController
//        self.navigationController?.pushViewController(next, animated: true)
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let myThread = NSThread(target: self, selector: "Timerset2", object: nil)
        myThread.start()
        
    }
    func Timerset2(){
        let cmdStr = "{\"cmd\": 5, \"user_phone\": \"\(self.inputTel.text! )\",\"user_smscode\": \"\(self.inputVcode.text!)\"}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                let alert = UIAlertView()
                alert.title = Defined_setting_title
                alert.delegate = self
                alert.message =  Defined_telphone_success
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            })
            
        }
        else{
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                let alert = UIAlertView()
                alert.title = Defined_setting_title
                alert.message =  Defined_telphone_error
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            })

        }
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    @IBAction func showLogin5(sender : AnyObject) {

        let next = GBoard.instantiateViewControllerWithIdentifier("viewLogin5") as UIViewController
        self.navigationController?.pushViewController(next, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}

class ViewControllerLogin7: UIViewController , UITextFieldDelegate,UIAlertViewDelegate{
    
    
    @IBOutlet weak var verityText: UITextField!
    
    @IBOutlet weak var verityButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        inputTel.delegate = self
        self.verityText.returnKeyType = UIReturnKeyType.Done
        self.verityText.delegate = self
       
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
    }
    
  
    @IBAction func verityActive(sender: UIButton) {
        
   
        
            let myThread = NSThread(target: self, selector: "Timerset1", object: nil)
            myThread.start()
   
        
        
    }
    func Timerset1(){
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 7, \"user_name\": \"\(FAME.user_name )\"}",cmplx:true)
        print(received)
        if( received != nil){
            if received.valueForKey("result") as! UInt == 0{
                
                print("phone\(received.valueForKey("phone"))")
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    self.isCounting = true
                })
                
            }
            else{
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                   
                    let alert = UIAlertView()
                    alert.title = Defined_setting_title
                    alert.delegate = self
                    alert.message =  Defined_telphone_success1
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()

                })
            }
        }
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.navigationController?.popViewControllerAnimated(true)
    }
   
    @IBAction func sureClick(sender: AnyObject) {
        
        
        
        let myThread = NSThread(target: self, selector: "Timerset2", object: nil)
        myThread.start()
        
    }
    func Timerset2(){
        let cmdStr = "{\"cmd\": 8, \"user_name\": \"\(FAME.user_name )\",\"user_smscode\": \"\(self.verityText.text!)\"}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                let next = GBoard.instantiateViewControllerWithIdentifier("Login8") as UIViewController
                self.navigationController?.pushViewController(next, animated: true)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            })
            
        }
        else{
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                FAME.showMessage("输入的验证码不正确")
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        verityText.resignFirstResponder()
    }
    var timer :NSTimer!
    var remainingSeconds: Int = 0 {
        willSet {
            verityButton.setTitle("\(newValue)秒", forState: .Normal)
            
            if newValue <= 0 {
                verityButton.setTitle("获取验证码", forState: .Normal)
                isCounting = false
            }
        }
    }
    var isCounting = false{
        willSet {
            if newValue {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime:", userInfo: nil, repeats: true)
                
                remainingSeconds = 120
                
            } else {
                self.timer?.invalidate()
                self.timer = nil
                
            }
            
            verityButton.enabled = !newValue
        }
    }
    func updateTime(timer: NSTimer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }

    
}

class ViewControllerLogin8: UIViewController , UITextFieldDelegate,UIAlertViewDelegate{
    
    
    @IBOutlet weak var newPass: UITextField!

    @IBOutlet weak var surePass: UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        inputTel.delegate = self
        self.newPass.returnKeyType = UIReturnKeyType.Done
        self.newPass.delegate = self
        self.newPass.secureTextEntry = true
        
        self.surePass.returnKeyType = UIReturnKeyType.Done
        self.surePass.delegate = self
        self.surePass.secureTextEntry = true
        
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
    }

    
    @IBAction func sureClick(sender: AnyObject) {
        
        let myThread = NSThread(target: self, selector: "Timerset2", object: nil)
        myThread.start()
        
    }
    func Timerset2(){
        
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 9, \"user_newpwd\": \"\(self.newPass.text! )\",\"user_newpwd1\": \"\(self.surePass.text!)\"}",cmplx:true)
        print(received)
        if( received != nil){
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                switch received.valueForKey("result") as! UInt {
                case 0:
                    let alert = UIAlertView()
                    alert.title = Defined_setting_title
                    alert.delegate = self
                    alert.message =  Defined_setting_success
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()
                    FAME.saveProfile(FAME.user_name, pwd: "")
                    
                case 2:
                    let alert = UIAlertView()
                    alert.title = Defined_setting_title
                    alert.message =  Defined_setting_error6
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()
                    self.navigationController?.popViewControllerAnimated(true)
                    
                case 3:
                    let alert = UIAlertView()
                    alert.title = Defined_setting_title
                    alert.message =  Defined_setting_error4
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()
                    
                    self.newPass.text = ""
                    self.surePass.text = ""
                    
                case 4:
                    let alert = UIAlertView()
                    alert.title = Defined_setting_title
                    alert.message =  Defined_setting_error5
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()
                    
                    self.newPass.text = ""
                    self.surePass.text = ""
                    
                    
                default:
                    let alert = UIAlertView()
                    alert.title = Defined_setting_title
                    alert.message =  Defined_setting_error2
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()
                    self.newPass.text = ""
                    self.surePass.text = ""
                    
                }

            })
            
        }

        
}

    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        FAME.outTag = 1
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        surePass.resignFirstResponder()
        newPass.resignFirstResponder()
    }
    
    
    
}


class ViewControllerLogin5: UIViewControllerQRcode,UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
    var BGView:UIView!
    var pickView:UIView!
    var selectRoom:Int = 0
    var model_id:UInt = 0
    var hasAdd = false
    @IBOutlet var inputHv : UITextField!
    @IBOutlet var bgImg : UIImageView!
    @IBOutlet var inputCK : UITextField!
    @IBOutlet var inputType : UITextField!
    @IBOutlet var btnRoom : UIButton!
    @IBOutlet var tip : UILabel!
    

    @IBAction func didTapped(sender : AnyObject) {
        self.view.endEditing(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.inputType.returnKeyType = UIReturnKeyType.Next
        self.inputType.delegate = self
        self.inputHv.returnKeyType = UIReturnKeyType.Next
        self.inputHv.delegate = self
        self.inputCK.returnKeyType = UIReturnKeyType.Done
        self.inputCK.delegate = self
        
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
        
        self.createPop()
        
        
        FAME.getDeviceTable()
        FAME.lastDTversion = FAME.DTversion
        print("lastDTversion \(FAME.lastDTversion)")
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        print(textField.tag)
        if textField.tag == 1 {
            self.inputHv.becomeFirstResponder()
        }else if textField.tag == 2{
            self.inputCK.becomeFirstResponder()
            
        }else{
            self.view.endEditing(false)
        }
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        print(FAME.device_table)
        if (FAME.device_table != nil) {
            //device_table existed
            
        }else{
            //nodevice_table
            //create it from the orgDt.txt
            let jsonPath = NSBundle.mainBundle().bundlePath
            let jsonData = NSData(contentsOfFile: "\(jsonPath)/orgDT.txt")
            do{
            let json :NSMutableDictionary! = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! NSMutableDictionary as NSMutableDictionary!
            print(json)
                FAME.device_table = json
                FAME.updateDeviceTable()
            }catch{
                print("failed to create the device_tabel from file")
            }
        }

    }
    func willPresentActionSheet(actionSheet: UIActionSheet) // before animation and showing view
    {

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
        
        btn.addTarget(self, action: Selector("selectedRoomBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let picker = UIPickerView(frame: CGRect(x: 20, y: 5, width: pickView.frame.width - 40 , height: 230))
        
        picker.dataSource = self
        picker.delegate = self
        
        self.pickView.addSubview(picker)
        self.pickView.addSubview(btn)
        
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
    
    
    @IBAction func selectRoom(sender : AnyObject) {
     //   roomSheet.showInView(self.view)
        //roomSheet.bounds.origin.y += 100
     //   roomSheet.bounds.size.height = 240
     //   roomSheet.frame.size.height = 240
     self.showPop()
        
     //   var next :UIViewController = GBoard.instantiateViewControllerWithIdentifier("viewPicker") as UIViewController
     //   next.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
     //   next.view.backgroundColor = UIColor.clearColor()
        
     //   self.presentViewController(next, animated: true, completion: nil)
        
        
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int){
        print("aSheet:\(actionSheet) Index:\(buttonIndex)")
         let objRooms :NSArray = FAME.device_table.valueForKey("rooms") as! NSArray
        if buttonIndex < objRooms.count {
            self.selectRoom = buttonIndex
            self.btnRoom.setTitle(objRooms[buttonIndex] as? String, forState: UIControlState.Normal)
            
        }
        
        
    }
    
    func actionSheetCancel(actionSheet: UIActionSheet){
        // println("aSheet:\(actionSheet) ")
    }

    @IBAction func selectedRoomBtn( sender : AnyObject){
        
        print("selectedRoomBtn")
        
        let objRooms :NSArray = FAME.device_table.valueForKey("rooms") as! NSArray
    
        self.btnRoom.setTitle(String(objRooms[self.selectRoom] as! NSString), forState: UIControlState.Normal)
        
        self.hidePop()
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        
        print("pickerView selected:\(row)")
        self.selectRoom = row
        
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        let objRooms :NSArray = FAME.device_table.valueForKey("rooms") as! NSArray
        
        return objRooms.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        let objRooms :NSArray = FAME.device_table.valueForKey("rooms") as! NSArray
        
        return String(objRooms[row] as! NSString)
        
    }
    
    @IBAction func showQRcode(sender : AnyObject) {
        
        let next :ViewControllerQRcode = GBoard.instantiateViewControllerWithIdentifier("viewQR") as! ViewControllerQRcode
        next.pView = self
        next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
        self.presentViewController(next, animated: true, completion: nil)
    }
    
    override func deQRcode(str: String){
        print("ViewControllerLogin5 get:\(str)")
        
        //let ieee = str.substringWithRange(5, B: 23)
        //let verify = str.substringWithRange(36, B: 32)
        
        let ieee = FAME.subString(str, A: 5, B: 23)
        let verify = FAME.subString(str, A: 36, B: 32)

        print("111111\(ieee)")
        self.inputHv.text = ieee as String
        self.inputCK.text = verify
//        FAME.fameIeee = ieee
//        FAME.verify = verify
            //get the Type
            let dl = httpRequert()
            print("222222\(self.inputHv.text!)")
            if let received = dl.downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 23, \"ieee_addr\": \"\(self.inputHv.text!)\"}"){
                
                self.model_id = received.valueForKey("model_id") as! UInt
                self.inputType.text = received.valueForKey("model_name") as? String
                
            }else{
                self.inputType.text = Defined_Unkown_Device
            }
        

    }
    
    @IBAction func getTheType(sender : AnyObject) {
        let hvStr = "FameSmart:\(self.inputHv.text!)"
        let hvMd5Str:String = hvStr.md5().uppercaseString as String
        let md5Str:String = self.inputCK.text!
        print(hvStr)
        print(hvMd5Str)
        print(md5Str)
        
        if md5Str == hvMd5Str {
            print("MD5 OK")
            if (self.inputType.text == ""){
                //get the Type
                let dl = httpRequert()
                if let received = dl.downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 23, \"ieee_addr\": \"\(self.inputHv.text!)\"}"){
                    
                    self.model_id = received.valueForKey("model_id") as! UInt
                    self.inputType.text = received.valueForKey("model_name") as? String
                    
                }else{
                    self.inputType.text = Defined_Unkown_Device
                }

            }
        
        }
        
    }
    @IBAction func plusToDT(sender : AnyObject) {
        let hvStr = "FameSmart:\(self.inputHv.text!)"
        let hvMd5Str:String = hvStr.md5().uppercaseString as String
        let md5Str:String = self.inputCK.text! as String
        var flag:NSNumber!
        print(hvStr)
        print(hvMd5Str)
        print(md5Str)
        
        if md5Str == hvMd5Str {
            print("MD5 OK")
            
            
            
            let dic:NSMutableDictionary = ["name":"\(self.inputType.text!)","hvaddr":"\(self.inputHv.text!)","ckId":"\(self.inputCK.text!)","modelId":self.model_id,"room":"\(self.btnRoom.currentTitle!)","roomId":self.selectRoom]
            
            
            print(FAME.addDeviceArray)
            var ckBool = true
            for value : AnyObject in FAME.addDeviceArray {
                let hvaddr:String = value.valueForKey("hvaddr") as! String
                //print(<#T##items: Any...##Any#>)
                if hvaddr == self.inputHv.text!{
                    ckBool = false
                }
                
            }
            
            
            
            //deviceTable
            for value : AnyObject in FAME.device_table.valueForKey("lights") as! NSArray {
                let DTValue = value as! NSDictionary
                let DTieee : String!  =  DTValue.valueForKey("ieee") as! String
                if self.inputHv.text == DTieee {
                    flag = DTValue.valueForKey("flag") as! NSNumber!
                    if(flag == 1){
                    }else{
                         ckBool = false
                    }
                }
            }
            for value2 : AnyObject in FAME.device_table.valueForKey("sensors") as! NSArray {
                let DTValue2 = value2 as! NSDictionary
                let DTieee2 : String!  =  DTValue2.valueForKey("ieee") as! String
                if self.inputHv.text == DTieee2 {
                    flag = DTValue2.valueForKey("flag") as! NSNumber!
                    if(flag == 1){
                    }else{
                        ckBool = false
                    }
                }
            }
            
            for value3 : AnyObject in FAME.device_table.valueForKey("curtains") as! NSArray {
                let DTValue3 = value3 as! NSDictionary
                let DTieee3 : String!  =  DTValue3.valueForKey("ieee") as! String
                if self.inputHv.text == DTieee3 {
                    flag = DTValue3.valueForKey("flag") as! NSNumber!
                    if(flag == 1){
                    }else{
                        ckBool = false
                    }
                }
            }
            
            for value4 : AnyObject in FAME.device_table.valueForKey("appls") as! NSArray {
                let DTValue4 = value4 as! NSDictionary
                let DTieee4 : String!  =  DTValue4.valueForKey("ieee") as! String
                if self.inputHv.text == DTieee4 {
                    flag = DTValue4.valueForKey("flag") as! NSNumber!
                    if(flag == 1){
                    }else{
                        ckBool = false
                    }
                }
            }
            

            
            
            
            
            if ckBool {
                FAME.addDeviceArray.addObject(dic)
            
                let width = self.view.frame.width
                
                UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.inputType.frame.origin.x += width
                    }, completion: {
                        (finished:Bool) -> Void in
                        self.inputType.text = nil
                        self.inputType.frame.origin.x -= width
                    })
                
                UIView.animateWithDuration(0.5, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.inputHv.frame.origin.x += width
                    }, completion: {
                        (finished:Bool) -> Void in
                        self.inputHv.text = nil
                        self.inputHv.frame.origin.x -= width
                    })
                
                UIView.animateWithDuration(0.5, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    self.inputCK.frame.origin.x += width
                    }, completion: {
                        (finished:Bool) -> Void in
                        self.inputCK.text = nil
                        self.inputCK.frame.origin.x -= width
                    })
                
                viewAnimate().showTip(self.tip, content: Defined_add_successed,color:UIColor.greenColor())
                
                
                
                
                print("hvaddr OK")
                
                self.delay(1) { () -> () in
                    
                    let next :UIViewController = GBoard.instantiateViewControllerWithIdentifier("viewLogin6") as UIViewController
                    self.navigationController?.pushViewController(next, animated: true)
                }
                
                
            }else{
                print("hvaddr existed")
                viewAnimate().showTip(self.tip, content: Defined_add_existed)
                viewAnimate().shrkInput(self.inputCK)
                viewAnimate().shrkInput(self.inputHv)
                viewAnimate().shrkInput(self.inputType)
                
            }
            
            
            
            
            
        }else{
            print("MD5 error")
            
            viewAnimate().showTip(self.tip, content: Defined_add_md5_failed)
            viewAnimate().shrkInput(self.inputCK)
            viewAnimate().shrkInput(self.inputHv)
        }
    }
    func delay(time:Double,closure:() -> ()){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }

    @IBAction func showLogin6(sender : AnyObject) {
        let next :UIViewController = GBoard.instantiateViewControllerWithIdentifier("viewLogin6") as UIViewController
        self.navigationController?.pushViewController(next, animated: true)
        
    }
}


class ViewControllerForgetPass: UIViewController , UITextFieldDelegate,UIAlertViewDelegate{
    
    
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var verityText: UITextField!
    
    @IBOutlet weak var verityButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //        inputTel.delegate = self
        self.verityText.returnKeyType = UIReturnKeyType.Done
        self.verityText.delegate = self
        
//        self.userText.returnKeyType = UIReturnKeyType.Done
//        self.userText.delegate = self
        
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
    }
    
    
    @IBAction func verityActive(sender: UIButton) {
        
        
        
        let myThread = NSThread(target: self, selector: "Timerset1", object: nil)
        myThread.start()
        
        
        
    }
    func Timerset1(){
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 7, \"user_name\": \"\(userText.text! )\"}",cmplx:true)
        print(received)
        if( received != nil){
            if received.valueForKey("result") as! UInt == 0{
                
                print("phone\(received.valueForKey("phone"))")
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    self.isCounting = true
                })
                
            }
            else{
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    
                    let alert = UIAlertView()
                    alert.title = Defined_setting_title
                    alert.delegate = self
                    alert.message =  Defined_telphone_success1
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()
                    
                })
            }
        }
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        //self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func sureClick(sender: AnyObject) {
        
        
        
        let myThread = NSThread(target: self, selector: "Timerset2", object: nil)
        myThread.start()
        
    }
    func Timerset2(){
        let cmdStr = "{\"cmd\": 8, \"user_name\": \"\(userText.text! )\",\"user_smscode\": \"\(self.verityText.text!)\"}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90){
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                let next = GBoard.instantiateViewControllerWithIdentifier("Login8") as UIViewController
                self.navigationController?.pushViewController(next, animated: true)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            })
            
        }
        else{
            
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                FAME.showMessage("输入的验证码不正确")
            })
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        verityText.resignFirstResponder()
    }
    var timer :NSTimer!
    var remainingSeconds: Int = 0 {
        willSet {
            verityButton.setTitle("\(newValue)秒", forState: .Normal)
            
            if newValue <= 0 {
                verityButton.setTitle("获取验证码", forState: .Normal)
                isCounting = false
            }
        }
    }
    var isCounting = false{
        willSet {
            if newValue {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTime:", userInfo: nil, repeats: true)
                
                remainingSeconds = 120
                
            } else {
                self.timer?.invalidate()
                self.timer = nil
                
            }
            
            verityButton.enabled = !newValue
        }
    }
    func updateTime(timer: NSTimer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    
}






class ViewControllerLogin6: UIViewController,UITableViewDataSource  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //print("2222222\(FAME.addDeviceArray)")
    }
    @IBAction func doAddDeviceBtn(sender : AnyObject) {
        //send to server

        if FAME.addDeviceArray.count == 0{
            let alert :UIAlertView = UIAlertView()
            alert.title = Defined_VC6_AlertTitle
            alert.message = Defined_VC6_AlertMessage2
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
        }
        else{
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            if FAME.doAddDevice() {
                
                if FAME.addDeviceArray.count > 0 {
                    let alert :UIAlertView = UIAlertView()
                    alert.delegate = self
                    alert.title = Defined_VC6_AlertTitle
                    alert.message = Defined_VC6_AlertMessage
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()
                    
                    
                }
                
                if FAME.isAddDeviceFromSetting {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                    
                }else{
                    
                    let next = GBoard.instantiateViewControllerWithIdentifier("navMain") as UIViewController
                    //next.modalTransitionStyle = UIModalTransitionStyle.PartialCurl
                    self.presentViewController(next, animated: false, completion:nil)
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
                
            }

        }
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        print("click at \(buttonIndex)")
        
        if buttonIndex == 0 {
            
            
            //print("FAME.loading.text = 正在联网操作中...")
        }
    }
    
    func alertViewCancel(alertView: UIAlertView){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)

        
    }
    
    @IBAction func navBack(sender : AnyObject) {
        
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        

        return FAME.addDeviceArray.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        //tableView.backgroundColor = UIColor.clearColor()
        let cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier("devCell")! as UITableViewCell
        cell.backgroundColor = UIColor.clearColor()
        
        

        let dic:NSDictionary = FAME.addDeviceArray[indexPath.row] as! NSDictionary
        let cellTableName:UILabel = cell.viewWithTag(1) as! UILabel
        cellTableName.text = (dic.valueForKey("name") as! String)

        let cellTableRoom:UILabel = cell.viewWithTag(2) as! UILabel
        cellTableRoom.text = (dic.valueForKey("room") as! String)
        
        
        return cell
        
    }
}
