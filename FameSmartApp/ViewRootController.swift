//
//  ViewRootController.swift
//  FameSmartApp
//
//  Created by Eric on 14-8-5.
//  Copyright (c) 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//




//*********************
//
//      ViewController of the main view
//
//*********************

import UIKit
import AVFoundation
import Starscream


class ViewControllerMain: UIViewController ,UIAlertViewDelegate {
    
    var showAnimate :Bool = true
    
    var isFameWork = false
    @IBOutlet var btnP : UIButton!
    @IBOutlet var btnVM : UIButton!
    @IBOutlet var btnSA : UIButton!
    @IBOutlet var btnSU : UIButton!
    @IBOutlet var btnSS : UIButton!
    @IBOutlet var btnUM : UIButton!
    @IBOutlet var btnAU : UIButton!
    @IBOutlet var btnHU : UIButton!
    
    @IBOutlet var speechButton : UIButton!
    @IBOutlet var viewSpeech : UIView!
    @IBOutlet var userImg : UIImageView!
    
    @IBOutlet var homeImg : UIImageView!
    
    
    @IBOutlet var speechBGview : UIView!
    @IBOutlet var viewVolTip : UIView!
    @IBOutlet var userName : UIButton!
    @IBOutlet var speechText1 : UILabel!
    
    @IBOutlet var speechText2 : UILabel!
    @IBOutlet var homeName : UIButton!
    
    @IBAction func btnBack(sender : AnyObject) {
        
        let alert :UIAlertView = UIAlertView()
        alert.delegate = self
        alert.title = Defined_ALERT_loginOut
        alert.message = Defined_ALERT_loginOut2
        alert.addButtonWithTitle(Defined_ALERT_OK)
        alert.addButtonWithTitle(Defined_ALERT_CANCEL)
        alert.show()
        
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func swiped(sender : AnyObject) {
        print("swiped down")
        //self.clolseSpeechV()
    }
    
    @IBAction func swipedUp(sender : AnyObject) {
        print("swiped Up")
        // self.showSpeechV()
    }
    
    @IBOutlet var ViewBtns : UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //play()
        
        //FAME.getDateFormServer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "play1:", name: "play", object: nil)
        
        
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
        
        
        
        print("UUID----->\(getUUID.getUUID())")
        
        
        self.btnP.hidden = true
        self.btnVM.hidden = true
        self.btnSA.hidden = true
        self.btnSU.hidden = true
        self.btnSS.hidden = true
        self.btnUM.hidden = true
        self.btnAU.hidden = true
        self.btnHU.hidden = true
        self.userName.hidden = true
        self.homeName.hidden = true
        self.userImg.hidden = true
        self.homeImg.hidden = true
        
        
        
        
        
        
        
        
        
        
        /*
        var initString :NSString =  "appid=\(APPID_VALUE),timeout=\(TIMEOUT_VALUE)"
        IFlySpeechUtility.createUtility(initString)
        self.iFlySpeechRecognizer  = RecognizerFactory.CreateRecognizer(self, domain: "iat") as IFlySpeechRecognizer
        self.iFlySpeechRecognizer.setParameter("plain", forKey: IFlySpeechConstant.RESULT_TYPE())
        self.iFlySpeechRecognizer.setParameter("40", forKey: IFlySpeechConstant.VAD_EOS())
        self.iFlySpeechRecognizer.setParameter("0", forKey: IFlySpeechConstant.ASR_PTT())
        
        self.isCanceled = false
        self.viewVolTip.frame.size.width = 0
        
        
        
        //TTS
        self.iFlySpeechSynthesizerInstance = IFlySpeechSynthesizer.sharedInstance() as IFlySpeechSynthesizer
        self.iFlySpeechSynthesizerInstance.delegate = self
        self.iFlySpeechSynthesizerInstance.setParameter("70", forKey: IFlySpeechConstant.SPEED())
        self.iFlySpeechSynthesizerInstance.setParameter("50", forKey: IFlySpeechConstant.VOLUME())
        self.iFlySpeechSynthesizerInstance.setParameter("vinn", forKey: IFlySpeechConstant.VOICE_NAME())
        self.iFlySpeechSynthesizerInstance.setParameter("8000", forKey: IFlySpeechConstant.SAMPLE_RATE())
        
        self.iFlySpeechSynthesizerInstance.setParameter(nil, forKey: IFlySpeechConstant.TTS_AUDIO_PATH())
        
        self.ttsHasError = false
        NSThread.sleepForTimeInterval(0.05)
        println("buffering")
        //self.iFlySpeechSynthesizerInstance.startSpeaking(self.toBeSyn.text)
        */
        self.mainInit()
    }
    
    func mainInit(){
        print("MAIN_INIT")
        let myThreadInit = NSThread(target: self, selector: "Timerset", object: nil)
        myThreadInit.start()
    }
    
    func Timerset(){
        print("ok")
        //FAME.refreshLightState()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "empty.png"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName:UIFont.boldSystemFontOfSize(22)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        self.viewSpeech.frame.origin.y =  self.view.frame.height - 20
        
        
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool){
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    
    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        
        self.userName.setTitle(FAME.user_name, forState: UIControlState.Normal)
        
        
        if showAnimate {
            
            self.showAnimate = false
            let viewHeight = self.view.frame.height
            let viewWidth = self.view.frame.width
            
            
            self.btnP.frame.origin.y += viewHeight
            self.btnVM.frame.origin.y += viewHeight
            self.btnSA.frame.origin.y += viewHeight
            self.btnSU.frame.origin.y += viewHeight
            self.btnSS.frame.origin.y += viewHeight
            self.btnUM.frame.origin.y += viewHeight
            self.btnAU.frame.origin.y += viewHeight
            self.btnHU.frame.origin.y += viewHeight
            
            self.userImg.frame.origin.x += viewWidth
            self.homeImg.frame.origin.x += viewWidth
            
            
            self.btnP.hidden = false
            self.btnVM.hidden = false
            self.btnSA.hidden = false
            self.btnSU.hidden = false
            self.btnSS.hidden = false
            self.btnUM.hidden = false
            self.btnAU.hidden = false
            self.btnHU.hidden = false
            
            self.userImg.hidden = false
            self.homeImg.hidden = false
            
            self.userName.alpha = 0
            self.homeName.alpha = 0
            self.userName.hidden = false
            self.homeName.hidden = false
            
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnP.frame.origin.y -= viewHeight
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.05, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnSA.frame.origin.y -= viewHeight
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnVM.frame.origin.y -= viewHeight
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.15, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnSU.frame.origin.y -= viewHeight
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnSS.frame.origin.y -= viewHeight
                self.userImg.frame.origin.x -= viewWidth
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.25, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnUM.frame.origin.y -= viewHeight
                self.homeImg.frame.origin.x -= viewWidth
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnAU.frame.origin.y -= viewHeight
                self.userName.alpha = 1
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.35, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnHU.frame.origin.y -= viewHeight
                self.homeName.alpha = 1
                }, completion: nil)
            
        }else{
            
        }
        
        
        
        
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        print("click at \(buttonIndex)")
        //FAME.saveProfile("", pwd: "")
        if buttonIndex == 0 {
            //self.dismissViewControllerAnimated(true, completion: nil)
            
            //self.navigationController?.popToRootViewControllerAnimated(false)
            
            print("FAME.devicetoken====\(FAME.devicetoken)")
            
            if FAME.devicetoken != "" {
                let myThread = NSThread(target: self, selector: "Timerset1", object: nil)
                myThread.start()
            }
            else{
                FAME.user_name = ""
                FAME.outTag = 1
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func Timerset1(){
        
        
        let cmdStr = "{\"cmd\":51, \"user_name\": \"\(FAME.user_name)\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"push_enable\": 0, \"devicetoken\": \"\(FAME.devicetoken)\"}"
        if (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr) != nil){
            print("SEND REQUEST SUCCESSED")
            
            //FAME.outTag = 1
            
        }else{
            print("SEND REQUEST FAILED!")
            
        }
        
    }
    
}

class ViewControllerBase: UIViewController {
    
    var popView : UIView = UIView()
    var isShow = false
    
    //保存背景图数据
    var backgrounds:Array<UIView>!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //self.view.backgroundColor = UIColor.grayColor()
        
        createPopView()
        
        let btnShake = UIButton(frame: CGRect(x: self.view.frame.width - 65 , y: self.view.frame.height - 65  , width: 50, height: 50))
        btnShake.setBackgroundImage(UIImage(named: "sub_tag.png"), forState: UIControlState.Normal)
        btnShake.tag = 20
        btnShake.addTarget(self, action: "tapShake:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(btnShake)
        
        
        
        
    }
    
    func tapShake(sender : AnyObject!){
        
        
        print("345666")
        
        menuStateChange()

    }
    
    func menuStateChange(){

        //一个单位的延迟时间
        let diff = 0.05

        if !isShow{
            popView.hidden = false
            for i in 0..<3{
                let cell = self.view.viewWithTag(1000 + i)
                //cell?.hidden = false
                UIView.animateWithDuration(0.3, delay: Double(i + 1) * diff, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                    cell!.frame.origin = CGPoint(x: 0, y:  180-(60 * (i + 1)) )
                    
                    }, completion: nil)
            }
        }
        else{
            
            animatePoPView()

        }
        isShow = !isShow
    }
    func tapClick(sender : AnyObject!){
        
        
        print("点击了\(sender.tag - 1000)")
        
        //切换中控
        if sender.tag == 1000{
            
            print("FAME.didArray====\(FAME.didArray)")
            if FAME.didArray.count == 1{
                FAME.showMessage("你只绑定了一个中控，没有中控可以切块")
            }
            else{
                let i = FAME.didArray[0] as! UInt
                let j = FAME.didArray[1] as! UInt
                if FAME.user_did == i{
                    FAME.user_did = j
                }
                    
                else{
                    FAME.user_did = i
                }
                
                getDeviceTableData()
            }
        }
        
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        animatePoPView()
        isShow = false
        
    }
    func animatePoPView(){
        let diff = 0.05
        
        for i in 0..<3{
            let cell = self.view.viewWithTag(1000 + i)
            
            UIView.animateWithDuration(0.3, delay: Double(i + 1) * diff, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                
                cell!.frame.origin = CGPoint(x: 0, y: 180)
                
                }, completion: { (finished:Bool) -> Void in
                    self.popView.hidden = true
            })
        }
    }
    func createPopView(){
        
        
        //popView.frame = CGRect(x: self.view.frame.width - 65 , y: self.view.frame.height - 65  , width: 50, height: 100)
        popView.frame = CGRect(x: self.view.frame.width - 65 , y: self.view.frame.height - 245 , width: 50, height: 230)
        //popView.backgroundColor = UIColor.grayColor()
        popView.hidden = true
        self.view.addSubview(popView)

        for i in 0..<3{
            
            let btn = UIButton(frame: CGRect(x: 0 , y: 180 , width: 50, height: 50 ))
            btn.tag = i + 1000
            //btn.hidden = true
            btn.setBackgroundImage(UIImage(named: "sub_tag.png"), forState: UIControlState.Normal)
            btn.addTarget(self, action: "tapClick:", forControlEvents: UIControlEvents.TouchUpInside)
            self.popView.addSubview(btn)
            
        }
        
        
        
    }
    
    
    func getDeviceTableData(){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            let DTValue = FAME.getDeviceTable()
            
            if (DTValue != nil) {
                if DTValue == 0 {
                    print("DeviceTable is OK")
                    
                }else{
                    print("DeviceTable is null")
                    //FAME.getDeviceTable()
                    FAME.lastDTversion = FAME.DTversion
                    let next = GBoard.instantiateViewControllerWithIdentifier("viewLogin5") as UIViewController
                    self.navigationController?.pushViewController(next, animated: true)
                    
                    FAME.isAddDeviceFromSetting = false
                    
                }
            }
            else{
                print("get DT failed")
                
            }
            
        }
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



class RootTabBarController: UITabBarController {
    
    @IBOutlet weak var tabbar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageArray1 = ["main_nor@2x.png","device_nor.png","water_nor.png","sun_nor.png"]
        let imageArray = ["main_pre@2x.png","device_pre.png","water_pre.png","sun_pre.png"]
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()], forState:.Normal)
        
        tabbar.backgroundColor = UIColor.clearColor()
        tabbar.backgroundImage = UIImage(named: "bottom_bg.png")
        tabbar.tintColor = UIColor.whiteColor()
        
        print(tabbar.items)
        let array : NSArray = tabbar.items!
        for i in 0..<array.count{
            let item : UITabBarItem = array[i] as! UITabBarItem
            item.image = UIImage(named: imageArray1[i])!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            item.selectedImage = UIImage(named: imageArray[i])!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            
            
        }
    }
    
    
}



class MainViewController: UIViewController,UIAlertViewDelegate,EditViewController_nameDelegate,WebSocketDelegate{
    
    var scrollView = UIScrollView()
    var funcArr = ["12","13","8","9"]
    var modeDis:Dictionary<String,Dictionary<String,String>> = [:]
    
    var stateDis = NSDictionary()
    
    func reloadMode() {
        print(FAME.modeArr)
        let view : UIView = self.view.viewWithTag(2)! as UIView
        view.removeFromSuperview()
        let view2 : UIView = self.view.viewWithTag(101)! as UIView
        view2.removeFromSuperview()
        self.refreshView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首 页"
        
        FAME.modeArr = []
        FAME.devicDis = []
        dataModeDis()
        createView()
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
         
        socket.delegate = self
        socket.connect()
        
    }
    //延迟方法
    func delay(time:Double,closure:() -> ()){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    // MARK: Websocket Delegate Methods.
    
    func websocketDidConnect(ws: WebSocket) {
        print("websocket is connected")
        
        print(FAME.user_did)
        socket.writeString("{\"type\":\"login\",\"did\":\(FAME.user_did)}")
        
    }
    
    func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
            self.delay(2) { () -> () in
                socket.connect()
            }
            
        } else {
            print("websocket disconnected")
        }
    }
    
    func websocketDidReceiveMessage(ws: WebSocket, text: String) {
        print("Received text: \(text)")
        let data = text.dataUsingEncoding(NSUTF8StringEncoding)
        let dic = try? NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as! NSDictionary
        //print(dic)
        let type = dic!["type"] as! String
        //let statrDic = dic!["content"] as! NSDictionary
        //print(type)
        if type == "msg"{
        NSNotificationCenter.defaultCenter().postNotificationName("socketLight", object: nil)
            print("msgmsgmsgmsg---------")
            stateDis = dic!
            print(stateDis)
            
            refreshLightState()
        }
        
    }
    
    func websocketDidReceiveData(ws: WebSocket, data: NSData) {
        print("Received data: \(data.length)")
        
    }
    
    func refreshLightState(){
        
        let ieee_addr = stateDis["ieee_addr"] as! String
        let dic = stateDis["content"] as! NSDictionary
        let stateArr = dic["state"] as! NSArray
        for i in 0..<FAME.devicDis.count{
            let dic1 = NSMutableDictionary(dictionary: FAME.devicDis[i] as! [NSObject : AnyObject])
            let ieee = dic1["ieee"] as! String
            
            if ieee_addr == ieee{
                FAME.devicDis.removeObjectAtIndex(i)
                
                let index = dic1["index"] as! Int
                dic1["state"] = stateArr[index]
                print("123333---->\(dic1)")
                let type = dic1["type"] as! Int
                let state = stateArr[index] as! Int
                let button : UIButton = self.view.viewWithTag(102 + i)! as! UIButton
                let png = FAME.deviceImage(type, state: state)
                button.setBackgroundImage(UIImage(named: png), forState: .Normal)
                
                FAME.devicDis.insertObject(dic1, atIndex: i)
            }
        }
        

    }
    func Timerset(){
        let cmdStr = "{\"cmd\": 57, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"name\": \"p_mode\"}"
        
        let result = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90)
        if (result != nil){
            let strDic = result["value"] as! NSDictionary
            //print(strDic)
            
            let modearr = strDic["mode"] as! NSArray
            let arr:NSMutableArray = []
            for j in 0..<modearr.count{
                
                arr.addObject("\(modearr[j])")
                
            }
            FAME.modeArr = arr
            
            
            let deviceArr = strDic["name"] as! NSMutableArray
            FAME.devicDis = deviceArr
            print(FAME.devicDis)
            
            let myThread = NSThread(target: self, selector: "TimersetRefresh", object: nil)
            myThread.start()
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.refreshView()
            })
        }
        
        
    }
    func TimersetRefresh(){
        var paramArray : Array<String> = []
        
        for value in FAME.devicDis {
            let ieee:String! = value["ieee"] as! String
            paramArray.append(ieee)
        }
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 61, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": \(paramArray)}",timeout : 60)
        
        if (received != nil){
            let detail = received["detail"] as! NSArray
            //print(detail)
            for value in detail{
                let AddedObj = value as! NSDictionary
                let iee = AddedObj["ieee_addr"] as! String
                let fun = AddedObj["state_json"] as? NSDictionary
                if (fun != nil){
                    let addIdArr = fun!["state"] as! NSArray
                    //print(addIdArr)
                    for i in 0..<FAME.devicDis.count{
                        let dic1 = NSMutableDictionary(dictionary: FAME.devicDis[i] as! [NSObject : AnyObject])
                        let ieee = dic1["ieee"] as! String
                        
                        if iee == ieee{
                            FAME.devicDis.removeObjectAtIndex(i)
                            let index = dic1["index"] as! Int
                            dic1["state"] = addIdArr[index]
                            FAME.devicDis.insertObject(dic1, atIndex: i)
                        }
                    }

                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.refreshView()
            })
        }
        
    }
    func dataModeDis(){
        let btnImgs = ["model1.png","model2.png","model3.png","model4.png","model5.png","model6.png","model7.png","model8.png","model9.png"]
        let btnImgs_press = ["mode1_icon_press.png","mode2_icon_press.png","mode3_icon_press.png","mode4_icon_press.png","mode5_icon_press.png","mode6_icon_press.png","mode7_icon_press.png","mode8_icon_press.png","mode9_icon_press.png"]
        var btns = Defined_MODE_NAMEB
        for i in 0..<btnImgs.count{
            if i < 6{
                modeDis["\(i + 8)"] = ["name":"\(btns[i])","pngName":"\(btnImgs[i])","pngName_press":"\(btnImgs_press[i])","act_id":"\(i + 8)"]
            }
            else{
                modeDis["\(i - 5)"] = ["name":"\(btns[i])","pngName":"\(btnImgs[i])","pngName_press":"\(btnImgs_press[i])","act_id":"\(i - 5)"]
            }
        }
        //print(modeDis)
        for i in 0..<funcArr.count{
            FAME.modeArr.addObject(funcArr[i])
        }
        
        FAME.devicDis.addObject(["name":"灯光","act_id":0,"type":7])
        FAME.devicDis.addObject(["name":"窗帘","act_id":0,"type":10])
        FAME.devicDis.addObject(["name":"灯光","act_id":0,"type":7])
        
    }
    func refreshView(){
        createModeView(scrollView,height: HEIGHT * 0.32,lableName: "喜欢的场景",tag: 1,modeArr: FAME.modeArr,modeDis:modeDis)
        
        let btnWidthE = (WIDTH-100)/4
        let countM = (FAME.modeArr.count - 1)/4 + 1
        let btnHeight = CGFloat(countM) * (btnWidthE * 1.1 + 40)
        
        //print(FAME.devicDis)
        createModeView(scrollView,height: HEIGHT * 0.4 + btnHeight,lableName: "常用的功能",tag: 100,modeArr:FAME.devicDis,modeDis:modeDis)
        
        scrollView.contentSize=CGSizeMake(self.view.frame.size.width,HEIGHT * 0.5 + btnHeight + CGFloat((FAME.devicDis.count - 1)/4 + 1) * (btnWidthE * 1.1 + 40))
    }
    func createView(){
        
        scrollView.frame = CGRect(x: 0, y: 20, width: WIDTH, height: HEIGHT - 49 - 20)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        //scrollView.backgroundColor = UIColor.grayColor()
        self.view.addSubview(scrollView)
        if let mainView = MainView.newInstance(){
            mainView.frame = CGRect(x: 10, y: 10, width: WIDTH - 20, height: HEIGHT * 0.3)
            mainView.backgroundColor = UIColor.clearColor()
            scrollView.addSubview(mainView)
            let time = FAME.getNowDate(1)
            mainView.M_data.text = time
            
        }
        
        
    }

    func createModeView(superView:UIView,height:CGFloat,lableName:String,tag:Int,modeArr:NSMutableArray,modeDis:Dictionary<String,Dictionary<String,String>>){
        
        let btnWidthE = (WIDTH-100)/4
        let countM = (modeArr.count - 1)/4 + 1
        let btnHeight = CGFloat(countM) * (btnWidthE * 1.1 + 40)
        
        let sView = UIView(frame: CGRect(x: 10, y: height , width: WIDTH - 20, height: HEIGHT * 0.1 + btnHeight))
        sView.tag = tag + 1
        superView.addSubview(sView)
        let view1 = UIView(frame: CGRect(x: 0, y: 0 , width: WIDTH - 20, height: HEIGHT * 0.1))
        let lable1 = UILabel(frame: CGRect(x: 0, y: 0, width: (WIDTH - 20) * 0.5, height: HEIGHT * 0.1))
        lable1.text = lableName
        lable1.textColor = UIColor.whiteColor()
        lable1.font = UIFont(name:"Zapfino", size:20)
        view1.addSubview(lable1)
        let button1 = UIButton(frame: CGRect(x: (WIDTH - 20) * 0.75, y: HEIGHT * 0.03, width: (WIDTH - 20) * 0.25, height: HEIGHT * 0.04))
        button1.tag = tag
        button1.setBackgroundImage(UIImage(named: "editbtn_bg2.png"), forState: UIControlState.Normal)
        button1.addTarget(self, action: Selector("editClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        view1.addSubview(button1)
        sView.addSubview(view1)
        
        
        
        let view2 = UIView(frame: CGRect(x: 0, y: HEIGHT * 0.08, width: WIDTH - 20, height: btnHeight))
        
        //view2.backgroundColor = UIColor.grayColor()
//        if tag == 1{
//            let image = UIImageView(frame: CGRect(x: 0, y: 0, width: WIDTH - 20, height: btnHeight))
//            image.image = UIImage(named: "bottom_bg.png")
//            image.layer.cornerRadius = 10
//            image.layer.masksToBounds = true
//            view2.addSubview(image)
//            
//            
//        }
        for i in 0..<modeArr.count{
            
            let button1 = UIButton(frame: CGRect(x: 10 + (btnWidthE + 20) * CGFloat(i % 4), y: 10 + (btnWidthE * 1.1 + 40) * CGFloat(i / 4) , width: btnWidthE, height: btnWidthE * 1.1))
            var png:String = "sa1.png"
            var text:String = "灯光"
            if tag == 1{
                png = modeDis[modeArr[i] as! String]!["pngName"]!
                text = modeDis[modeArr[i] as! String]!["name"]!
            }
            else{
                text = modeArr[i]["name"] as! String
            
                let type = modeArr[i]["type"] as? Int
                var state = modeArr[i]["state"] as? Int
                if state == nil{
                    state = 0
                }
                if (type != nil){
                    png = FAME.deviceImage(type!, state: state!)
                    //print(modeArr[i]["name"])
                }
                //png = FAME.deviceImage(Int(type)!)
                
            }
            button1.setBackgroundImage(UIImage(named: png), forState: .Normal)
            button1.tag = i + tag + 2
            button1.addTarget(self, action: Selector("modeClick:"), forControlEvents: UIControlEvents.TouchUpInside)
            let lable1 = CHWMarqueeView(frame: CGRect(x: 10 + (btnWidthE + 20) * CGFloat(i % 4), y: btnWidthE * 1.1 + 15 + (btnWidthE * 1.1 + 40) * CGFloat(i / 4), width: btnWidthE, height: 20), title: text)
            
            
//            let lable1 = UILabel(frame: CGRect(x: 10 + (btnWidthE + 20) * CGFloat(i % 4), y: btnWidthE * 1.1 + 15 + (btnWidthE * 1.1 + 40) * CGFloat(i / 4), width: btnWidthE, height: 20))
//            lable1.lineBreakMode = .ByTruncatingTail
//            lable1.contentMode = .Top
//            lable1.text = text
//            
//            lable1.textAlignment = .Center
//            lable1.textColor = UIColor.whiteColor()
//            lable1.font = UIFont(name:"Zapfino", size:15)
            view2.addSubview(lable1)
            view2.addSubview(button1)
            
        }

        sView.addSubview(view2)
        
        
    }
    func modeClick(sender:UIButton){
        //print(sender.tag)
        if sender.tag < 100{
            print(sender.tag)
            let name = modeDis[FAME.modeArr[sender.tag - 3] as! String]!["name"]!
            print(name)
            FAME.showMessage("\(name)启动")
        }
        else{
            print("123--->\(sender.tag)")
            print(FAME.devicDis[sender.tag - 102])
            let type : Int = FAME.devicDis[sender.tag - 102]["type"] as! Int
            let ieee = FAME.devicDis[sender.tag - 102]["ieee"] as! String
            if type == 10{
                
                FAME.dev_ieee = ieee
                FAME.saActid4 = type
                let next :UIViewController! = GBoard.instantiateViewControllerWithIdentifier("viewSA21") as UIViewController!
                next.title = FAME.devicDis[sender.tag - 102]["type"] as? String
                self.navigationController?.pushViewController(next, animated: true)
            }
            else if type == 7 || type == 8 || type == 9 {
                
                let dev = FAME.devicDis[sender.tag - 102]["dev_id"] as! Int
                let index = FAME.devicDis[sender.tag - 102]["index"] as! Int
                let state = FAME.devicDis[sender.tag - 102]["state"] as! Int
                var act_id = 0
                if state == 0{
                    act_id = 1
                }
                else{
                    act_id = 0
                }
                var type_t : String = "light"
                if type == 24 || type == 25 || type == 26 || type == 28{
                    type_t = "sensor"
                }
                
                let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 60, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\":{\"type\":\"\(type_t)\",\"dev_id\":\(dev),\"act_id\":\(act_id),\"idx\":\(index + 1)}}",timeout : 60)
                
                if (received != nil){
                    
//                    let png = FAME.deviceImage(type, state: act_id)
//                    sender.setBackgroundImage(UIImage(named: png), forState: .Normal)
                    
                }
                else{
                    
                }

                
            }
        }
 
    }
    
    //编辑按钮
    func editClick(sender:UIButton){
        
        let next = GBoard.instantiateViewControllerWithIdentifier("edit") as! EditViewController
        next.delegate = self
        FAME.editTag = sender.tag
        self.navigationController?.pushViewController(next, animated: true)
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //状态栏变黑底白字
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "empty.png"), forBarMetrics: UIBarMetrics.Default)
      
        self.navigationController?.navigationBarHidden = true
//        let view:UIView = UIView(frame: CGRectMake(0, 0, WIDTH, 64))
//        view.backgroundColor = UIColor(red: 105/255, green: 139/255, blue: 105/255, alpha: 0.3)
//        self.view.addSubview(view)
//    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
    }
    
    override func viewWillDisappear(animated: Bool){
        
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
}


class DeviceViewController: UIViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "设 备"
        
        let lable:UILabel = UILabel(frame: CGRect(x: 0, y: 50, width: self.view.frame.size.width , height: 44))
        lable.text = "智 能 电 机"
        lable.textAlignment = .Center
        lable.textColor = UIColor.whiteColor()
        lable.font = UIFont.systemFontOfSize(20)
        self.view.addSubview(lable)
        
        createView()
        
        
        
    }
    func createView(){
        
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
        
        let btns = Defined_SA_btns
        let btnImgs = ["sa1.png","sa2.png","sa3.png","sa4.png","sa5.png","sa6.png","model8.png","sa8.png","sa8.png"]
        
        let scrollView:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 49))
        self.view.addSubview(scrollView)
        let view0:UIView = UIView(frame: CGRect(x: 30, y: 0, width: self.view.frame.size.width - 60, height: self.view.frame.size.height - 49 - 64))
        scrollView.addSubview(view0)
        
        //fix position
        
        //let view0 = self.view.viewWithTag(10)!
        view0.frame.size.width = self.view.frame.size.width - 60
        let divW:CGFloat = 0.27
        //let top:CGFloat =  80
        let btnWidth = view0.frame.width * divW
        let btnHeight = btnWidth * 1.1
        
        let disX:CGFloat = ((1 - divW * 3) / 2 + divW) * view0.frame.width
        //let disY:CGFloat = view0.frame.height * 0.25
        
        let disY:CGFloat = btnHeight + 30 + self.view.frame.height * 0.02
        // diffj 改了加1
        let diffj:CGFloat = CGFloat(btns.count / 3)
        let top:CGFloat =  (self.view.frame.height - disY * diffj - 69) * 0.5
        
        
        let diffi:CGFloat = CGFloat(btns.count % 3)
        
        var diffX: CGFloat = diffi == 0 ? 0 : (view0.frame.width - diffi * btnWidth ) / 2
        diffX = diffi == 2 ? diffX - (1 - divW * 3) / 4  * view0.frame.width : diffX
        
        
        var btnX: CGFloat = 0
        var btnY: CGFloat = btns.count < 3 ? top : top + view0.frame.height * 0.1
        btnX = btns.count <= 3 ? diffX + btnX : btnX
        
        
        for idx in 0..<btns.count {
            
            let btn = UIButton(frame: CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight))
            btn.setBackgroundImage(UIImage(named: btnImgs[idx]), forState: UIControlState.Normal)
            
            let btnLable = UILabel(frame: CGRect(x: CGFloat(btnX - 20), y: CGFloat(btnY + btnHeight + 10), width: CGFloat(btnWidth + 40), height: 20))
            btnLable.text = btns[idx]
            btnLable.textColor = UIColor.whiteColor()
            btnLable.textAlignment = NSTextAlignment.Center
            
            if idx % 3 == 2 {
                btnX = 0
                btnY = btnY + disY
            }else{
                btnX = btnX + disX
            }
            
            
            btn.addTarget(self, action: "tap:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.tag = idx + 1
            
            
            view0.addSubview(btn)
            view0.addSubview(btnLable)
            
            if animationSS {
                var nsTime : NSTimeInterval!
                nsTime = NSTimeInterval(idx) * 0.05 + 0.1
                viewAnimate().popOut(btn, timeInterval: 0.3, delay: nsTime)
                
                nsTime = NSTimeInterval(idx) * 0.05 + 0.3
                viewAnimate().popOut(btnLable, timeInterval: 0.3, delay: nsTime)
            }
        }
        scrollView.contentSize=CGSizeMake(self.view.frame.size.width,btnHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        //状态栏变黑底白字
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = true
        
        
    }
    func tap(sender : AnyObject!){
        print("btn tapped \(sender.tag)")
        FAME.tempSensorId = sender.tag
        
        var viewId = sender.tag
        if viewId == 2 || viewId == 3 || viewId == 4 {
            viewId = 2
            FAME.showLights = true
        }
        else if viewId == 8{
            viewId = 8
        }
        else{
            viewId = 1
            FAME.showLights = false
            
        }
        
        let next :UIViewController! = GBoard.instantiateViewControllerWithIdentifier("viewSA\(viewId)") as UIViewController!
        next.title = "\(Defined_SA_btns1[sender.tag - 1])"
        self.navigationController?.pushViewController(next, animated: true)
        
    }

    override func viewWillDisappear(animated: Bool){
        
        
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), forBarMetrics: UIBarMetrics.Default)
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    
    
}


class SensorsViewController: UIViewController,UIAlertViewDelegate {
    
    var animationSS :Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "传 感"
        
        
        
        createView()
        
    }
    func createView(){
        
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
        
        let btns = Defined_SS_btns
        let btnImgs = ["ss1.png","ss2.png","ss3.png","ss4.png","ss5.png","ss6.png","ss7.png","ss8.png","ss9.png","ss10.png"]
        
        let scrollView:UIScrollView = UIScrollView(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height - 49 - 20))
        self.view.addSubview(scrollView)
        
        
        let lable:UILabel = UILabel(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width , height: 44))
        lable.text = "智 能 传 感"
        lable.textAlignment = .Center
        lable.textColor = UIColor.whiteColor()
        lable.font = UIFont.systemFontOfSize(20)
        scrollView.addSubview(lable)
        
        let view0:UIView = UIView(frame: CGRect(x: 30, y: 0, width: self.view.frame.size.width - 60, height: self.view.frame.size.height))
        scrollView.addSubview(view0)
        
        
        //fix position
        
        //let view0 = self.view.viewWithTag(10)!
        view0.frame.size.width = self.view.frame.size.width - 60
        let divW:CGFloat = 0.27
        //let top:CGFloat =  80
        let btnWidth = view0.frame.width * divW
        let btnHeight = btnWidth * 1.1
        
        let disX:CGFloat = ((1 - divW * 3) / 2 + divW) * view0.frame.width
        //let disY:CGFloat = view0.frame.height * 0.25
        
        let disY:CGFloat = btnHeight + 30 + self.view.frame.height * 0.02
        // diffj 改了加1
        let diffj:CGFloat = CGFloat(btns.count / 3)
        let top:CGFloat =  (self.view.frame.height - disY * diffj - 69) * 0.3
        
        
        let diffi:CGFloat = CGFloat(btns.count % 3)
        
        var diffX: CGFloat = diffi == 0 ? 0 : (view0.frame.width - diffi * btnWidth ) / 2
        diffX = diffi == 2 ? diffX - (1 - divW * 3) / 4  * view0.frame.width : diffX
        
        
        var btnX: CGFloat = 0
        var btnY: CGFloat = btns.count < 3 ? top : top + view0.frame.height * 0.1
        btnX = btns.count <= 3 ? diffX + btnX : btnX
        
        
        for idx in 0..<btns.count {
            
            let btn = UIButton(frame: CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight))
            btn.setBackgroundImage(UIImage(named: btnImgs[idx]), forState: UIControlState.Normal)
            
            let btnLable = UILabel(frame: CGRect(x: CGFloat(btnX - 20), y: CGFloat(btnY + btnHeight + 10), width: CGFloat(btnWidth + 40), height: 20))
            btnLable.text = btns[idx]
            btnLable.textColor = UIColor.whiteColor()
            btnLable.textAlignment = NSTextAlignment.Center
            
            if idx % 3 == 2 {
                btnX = 0
                btnY = btnY + disY
            }else{
                btnX = btnX + disX
            }
            
            
            btn.addTarget(self, action: "tap:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.tag = idx
            
            
            view0.addSubview(btn)
            view0.addSubview(btnLable)
            
            if animationSS {
                var nsTime : NSTimeInterval!
                nsTime = NSTimeInterval(idx) * 0.05 + 0.1
                viewAnimate().popOut(btn, timeInterval: 0.3, delay: nsTime)
                
                nsTime = NSTimeInterval(idx) * 0.05 + 0.3
                viewAnimate().popOut(btnLable, timeInterval: 0.3, delay: nsTime)
            }
        }
        scrollView.contentSize=CGSizeMake(self.view.frame.size.width,btnHeight + btnY + 49)

    }
    
    func tap(sender : AnyObject!){
        print("btn tapped \(sender.tag)")
        var next :UIViewController!
        
        if sender.tag == 0 {
            next = GBoard.instantiateViewControllerWithIdentifier("viewSS1") as UIViewController
        }
            
            //情景模式面板
        else if sender.tag == 6 {
            next = GBoard.instantiateViewControllerWithIdentifier("viewSS6") as UIViewController
            
        }
            //光纤
        else if sender.tag == 9 {
            next = GBoard.instantiateViewControllerWithIdentifier("viewSS9") as UIViewController
            
        }
        else{
            next = GBoard.instantiateViewControllerWithIdentifier("viewSS") as UIViewController
        }
        
        next.title = "\(Defined_SS_btns1[sender.tag])"
        
        
        FAME.tempSensorId = sender.tag
        self.navigationController?.pushViewController(next, animated: true)
        
        //self.navigationController.navigationBar.topItem.title = "Back"
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        //状态栏变黑底白字
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = true
        
        
    }
    
    override func viewWillDisappear(animated: Bool){
        
        
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



class MineViewController: UIViewController,UIAlertViewDelegate {
    
    @IBOutlet weak var bgImage: UIImageView!
    
    
    @IBAction func outUserClick(sender: UIButton) {
        
        
        let alert :UIAlertView = UIAlertView()
        alert.delegate = self
        alert.title = Defined_ALERT_loginOut
        alert.message = Defined_ALERT_loginOut2
        alert.addButtonWithTitle(Defined_ALERT_OK)
        alert.addButtonWithTitle(Defined_ALERT_CANCEL)
        alert.show()
        
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        
        
        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        print("click at \(buttonIndex)")
        //FAME.saveProfile("", pwd: "")
        if buttonIndex == 0 {
            print("FAME.devicetoken====\(FAME.devicetoken)")
            
            if FAME.devicetoken != "" {
                let myThread = NSThread(target: self, selector: "Timerset1", object: nil)
                myThread.start()
            }

            FAME.user_name = ""

            
            let next = GBoard.instantiateViewControllerWithIdentifier("navLogin") as UIViewController
            self.presentViewController(next, animated: false, completion: nil)
            
            
            
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    func Timerset1(){
        
        
        let cmdStr = "{\"cmd\":51, \"user_name\": \"\(FAME.user_name)\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"push_enable\": 0, \"devicetoken\": \"\(FAME.devicetoken)\"}"
        if (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr) != nil){
            print("SEND REQUEST SUCCESSED")
            
        }else{
            print("SEND REQUEST FAILED!")
            
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "我 的"
        
        //createNav()
        createView()
        
        
        
    }
    func createView(){
        let scrollView = UIScrollView(frame: CGRect(x: 20, y: 64, width: WIDTH - 40, height: HEIGHT - 64 - 49))
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        self.view.addSubview(scrollView)
        let arr = ["修改密码","找回密码","绑定手机"]
        let arr2 = ["添加设备","定时","安全监测","情景模式","视频监控","修改系统时间","使用手册","关于凡米","退出账号"]
        createLableAndButton(scrollView, arr: arr, title: "账号密码", fram: CGRect(x: 0, y: 0, width: WIDTH - 60, height: HEIGHT/14 ), tag: 20)
        createLableAndButton(scrollView, arr: arr2, title: "设备管理", fram: CGRect(x: 0, y: HEIGHT/14 * 4 + 40, width: WIDTH - 60, height: HEIGHT/14), tag: 30)
        scrollView.contentSize=CGSizeMake(WIDTH - 60,HEIGHT/14 * 14 + 120)
    }
    
    func createNav(){
        let button = UIButton(frame: CGRectMake(0,0,60,35))
        button.setTitle("设置", forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("setClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    func setClick(sender:AnyObject!){
        
        
        
    }
    func ButtonClick(sender: UIButton) {
        print(sender.tag)
        
        

        switch(sender.tag){
            case 20:
                let next = GBoard.instantiateViewControllerWithIdentifier("mine31") as! ViewSettingPwdController
                self.navigationController?.pushViewController(next, animated: true)
                
                break;
            case 21:
                let next = GBoard.instantiateViewControllerWithIdentifier("mine32") as! ViewControllerLogin7
                self.navigationController?.pushViewController(next, animated: true)
                break;
            case 22:
                let next = GBoard.instantiateViewControllerWithIdentifier("viewLogin4") as! ViewControllerLogin4
                self.navigationController?.pushViewController(next, animated: true)
                break;
            case 30:
                let next = GBoard.instantiateViewControllerWithIdentifier("viewLogin5") as! ViewControllerLogin5
                self.navigationController?.pushViewController(next, animated: true)
                break;
            case 31:
                let next = GBoard.instantiateViewControllerWithIdentifier("mine20") as! ViewControllerSUTimer
                self.navigationController?.pushViewController(next, animated: true)
                break;
            case 32:
                let next = GBoard.instantiateViewControllerWithIdentifier("msg") as! ViewControllerMsg
                self.navigationController?.pushViewController(next, animated: true)
                break;
            //情景模式
            case 33:
                let next = GBoard.instantiateViewControllerWithIdentifier("mineP") as! ViewControllerMainP
                self.navigationController?.pushViewController(next, animated: true)
                break;
            case 34:
                let next = GBoard.instantiateViewControllerWithIdentifier("mine21") as! ViewControllerVideo
                self.navigationController?.pushViewController(next, animated: true)
                break;
            case 35:
                let next = GBoard.instantiateViewControllerWithIdentifier("mine34") as! ViewSettingMTimerController
                self.navigationController?.pushViewController(next, animated: true)
                break;
            //使用手册
            case 36:
                let next = GBoard.instantiateViewControllerWithIdentifier("mine23") as! ViewControllerMainUM
                self.navigationController?.pushViewController(next, animated: true)
                break;
            case 37:
                let next = GBoard.instantiateViewControllerWithIdentifier("mine22") as! ViewAboutUs2Controller
                self.navigationController?.pushViewController(next, animated: true)
                break;
            case 38:
                let alert :UIAlertView = UIAlertView()
                alert.delegate = self
                alert.title = Defined_ALERT_loginOut
                alert.message = Defined_ALERT_loginOut2
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.addButtonWithTitle(Defined_ALERT_CANCEL)
                alert.show()
                break;
            default:
                break;
        }
        
        

        
    }
    func createLableAndButton(superView:UIView,arr:NSArray,title:String,fram:CGRect,tag:Int){
        
        let lable = UILabel(frame: fram)
        lable.text = title
        lable.textColor = UIColor.whiteColor()
        superView.addSubview(lable)
        
        for i in 0..<arr.count{
            let button = UIButton(frame: CGRectMake(0,lable.frame.origin.y + CGFloat(i + 1) * (8 + HEIGHT/14),WIDTH - 40,HEIGHT/14))
            button.tag = i + tag
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.setTitle(arr[i] as? String, forState: UIControlState.Normal)
            button.titleLabel?.font = UIFont(name: "", size: 15)
            button.setBackgroundImage(UIImage(named: "btn_select.png"), forState: UIControlState.Normal)
            button.addTarget(self, action: Selector("ButtonClick:"), forControlEvents: UIControlEvents.TouchUpInside)
            superView.addSubview(button)
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        //        let image = UIImage()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        //        self.navigationController?.navigationBar.setBackgroundImage(image, forBarMetrics: UIBarMetrics.Default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
        //        self.navigationController?.navigationBar.translucent = true
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
        
        
    }
    
    override func viewWillDisappear(animated: Bool){
        
        
        super.viewWillDisappear(animated)
        //self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: ""), forBarMetrics: UIBarMetrics.Default)
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        
    }
    
    @IBAction func changePass(sender: UIButton) {
        
        let next = GBoard.instantiateViewControllerWithIdentifier("Pwd1") as UIViewController
        next.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(next, animated: true)
        next.hidesBottomBarWhenPushed = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}



