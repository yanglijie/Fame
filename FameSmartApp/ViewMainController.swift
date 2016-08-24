//
//  ViewMainController.swift
//  FameSmartApp
//
//  Created by Eric on 14-8-1.
//  Copyright (c) 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//


//*********************
//
//      viewController of  appls contorl ,models and sensors ..(main)
//
//*********************



import UIKit


var animationSS :Bool = true
var animationSA :Bool = true
var animationP :Bool = true



class ViewControllerMainSA: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let btns = Defined_SA_btns
        let btnImgs = ["sa1.png","sa2.png","sa3.png","sa4.png","sa5.png","sa6.png","model8.png","sa8.png","sa8.png"]
        
        
        //fix position

        let view0 :UIView = self.view.viewWithTag(10)!
        view0.frame.size.width = self.view.frame.size.width - 60
        
        //let viewWidth = self.view.frame.size.width - 60
        
        let divW:CGFloat = 0.27
        
        //let top:CGFloat =  (self.view.frame.size.height - 69)/4/2
        //let btnWidth  = view0.frame.size.width * divW
        let btnWidth  = view0.frame.width * divW
        //print("aaaaaaaa=\(self.view.frame.height)bbbbbbbb=\(view0.frame.size.width)")
        let btnHeight = btnWidth * 1.1
        
        let disX:CGFloat = ((1 - divW * 3) / 2 + divW) * view0.frame.width
        
        
        let disY:CGFloat = btnHeight + 30 + self.view.frame.height * 0.02
        let diffj:CGFloat = CGFloat(btns.count / 3)
        let top:CGFloat =  (self.view.frame.height - disY * diffj - 69) * 0.5
        
        let diffi:CGFloat = CGFloat(btns.count % 3)
        
        var diffX:CGFloat = diffi == 0 ? 0 : (view0.frame.width - diffi * btnWidth ) / 2
        diffX = diffi == 2 ? diffX - (1 - divW * 3) / 4  * view0.frame.width : diffX
        
        
        var btnX:CGFloat = 0
        var btnY:CGFloat = btns.count <= 3 ? top + 90 : top
        btnX = btns.count <= 3 ? diffX + btnX : btnX
        
        
        for idx in 0..<btns.count {
            //print("aaaaaaaa=\(btnX)")
            let btn = UIButton(frame: CGRect(x: btnX, y: btnY  , width: btnWidth, height: btnHeight))
            btn.setBackgroundImage(UIImage(named: btnImgs[idx]), forState: UIControlState.Normal)
            
            let btnLable = UILabel(frame: CGRect(x: btnX, y: btnY + btnHeight + 10, width: btnWidth, height: 20))
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
            
            if animationSA {
                var nsTime : NSTimeInterval!
                nsTime = NSTimeInterval(idx) * 0.05 + 0.1
                viewAnimate().popOut(btn, timeInterval: 0.3, delay: nsTime)
                
                nsTime = NSTimeInterval(idx) * 0.05 + 0.3
                viewAnimate().popOut(btnLable, timeInterval: 0.3, delay: nsTime)
            }
        }
        
       // animationSA = false
        
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
        
        //self.refreshLights()
        
    }
    
    func refreshLights(){
        print("refreshLights")
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
        
    }
    
    func Timerset(){
        FAME.refreshLightState()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        self.navigationController?.title = "modes"
        
    }
    
    func tap(sender : AnyObject!){
        print("btn tapped \(sender.tag)")
        FAME.tempSensorId = sender.tag
        
        /*
        var str:String = "viewSA1"
        switch FAME.tempSensorId {
            
        case 1 :
            str = "viewSA1"
        case 2 :
            str = "viewSS"
        case 3 :
            str = "viewSS"
        case 4 :
            str = "viewSS"
        case 5 :
            str = "viewSS"

        default:
            break
            
        }
        
        */
        var viewId = sender.tag
        if viewId == 2 || viewId == 3 || viewId == 4 {
            viewId = 2
            FAME.showLights = true
        }
        else{
            viewId = 1
            FAME.showLights = false
            
        }
        
        let next :UIViewController! = GBoard.instantiateViewControllerWithIdentifier("viewSA\(viewId)") as UIViewController!
        next.title = "\(Defined_SA_btns1[sender.tag - 1])"
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
}





class ViewControllerMainP: UIViewController {
    var canShowDetail = true
    var count:NSTimeInterval = 0
    var btns_count:Int = 0
    func longPress(sender : AnyObject!) {
        
        if self.canShowDetail {
            print(sender)
            let next : viewModesSettingController! = GBoard.instantiateViewControllerWithIdentifier("viewModesSetting") as! viewModesSettingController
            
            self.navigationController?.pushViewController(next, animated: true)
            self.canShowDetail = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
        
//        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "tapShake:")
//        self.navigationItem.rightBarButtonItem = addButton
        
        
        var btns:Array<String>!
        if let modesObj:AnyObject? = FAME.device_table.valueForKey("modes") {
             btns = modesObj as! Array<String>
            count = NSTimeInterval(btns.count)
        }
        
        
        
        
        let btnImgs = ["model1.png","model2.png","model3.png","model4.png","model5.png","model6.png","model7.png","model8.png","model9.png"]
        
        //fix position
        self.btns_count = btns.count
        
        let view0:UIView = self.view.viewWithTag(10)!
        
        
        
        view0.frame.size.width = self.view.frame.size.width - 60
        let divW:CGFloat = 0.27
        //let top:CGFloat =  60
        let btnWidth  = view0.frame.width * divW
        let btnHeight = btnWidth * 1.1
        
        
        
        let disX:CGFloat = ((1 - divW * 3) / 2 + divW) * view0.frame.width
        
        //var disY:CGFloat = view0.frame.height * 0.25
        
        
        let disY:CGFloat = btnHeight + 30 + self.view.frame.height * 0.02
        let diffj:CGFloat = CGFloat(btns.count / 3) + 1
        
        let top:CGFloat =  (self.view.frame.height - disY * diffj - 69) * 0.5

        
        let diffi:CGFloat = CGFloat(btns.count % 3)
        
        var diffX:CGFloat = diffi == 0 ? 0 : (view0.frame.width - diffi * btnWidth ) / 2
        diffX = diffi == 2 ? diffX - (1 - divW * 3) / 4  * view0.frame.width : diffX
        
        
        var btnX:CGFloat = 0
        //var btnY:CGFloat = 0
        var btnY:CGFloat = btns.count <= 3 ? top + 90 : top
        

//        if self.btns_count <= 0 {
//            btnY = top + 90
//        }else if self.btns_count <= 3 {
//            btnY = top
//        }else{
//            btnY = top - 30
//            disY = disY * 0.85
//            
//        }
        
        btnX = btns.count <= 3 ? diffX + btnX : btnX
        
        
        let btnShake = UIButton(frame: CGRect(x: view0.frame.size.width - top/3 * 2 + 30 , y: top/3/2  , width: top/3 * 2, height: top/3 * 2))
        
        
        //let btnShake = UIButton(frame: CGRect(x: view0.frame.size.width - top/3 * 2 , y: 0  , width: 50, height: 50))
        btnShake.setBackgroundImage(UIImage(named: "shake.png"), forState: UIControlState.Normal)
        btnShake.addTarget(self, action: "tapShake:", forControlEvents: UIControlEvents.TouchUpInside)
        view0.addSubview(btnShake)
        

        for idx in 0..<btns.count + 3 {
            
            let btn = UIButton(frame: CGRect(x: btnX, y: btnY  , width: btnWidth, height: btnHeight))
            btn.setBackgroundImage(UIImage(named: btnImgs[idx]), forState: UIControlState.Normal)
            
            let btnLable = UILabel(frame: CGRect(x: btnX, y: btnY + btnHeight + 10, width: btnWidth, height: 20))
            
            
            //gesture
            if idx < self.btns_count {
                let longPressRec = UILongPressGestureRecognizer()
                longPressRec.addTarget(self, action: "longPress:")
                btn.addGestureRecognizer(longPressRec)
                btn.userInteractionEnabled = true
                
                btnLable.text = btns[idx]
            }else{
                btnLable.text = Defined_MODE_NAME[idx - self.btns_count]
            }
            
            
            btnLable.textColor = UIColor.whiteColor()
            btnLable.textAlignment = NSTextAlignment.Center
            
            if idx % 3 == 2 {
                btnX = diffX
                btnY = btnY + disY
            }else{
                btnX = btnX + disX
            }
            
            
            btn.addTarget(self, action: "tap:", forControlEvents: UIControlEvents.TouchUpInside)
            
            btn.addTarget(self, action: "tapDown:", forControlEvents: UIControlEvents.TouchDown)
            
            
            btn.tag = idx + 1
            
            view0.addSubview(btn)
            view0.addSubview(btnLable)
            
            if animationP {
                var nsTime : NSTimeInterval!
                nsTime = NSTimeInterval(idx) * 0.05 + 0.1
                viewAnimate().popOut(btn, timeInterval: 0.3, delay: nsTime)
                
                nsTime = NSTimeInterval(idx) * 0.05 + 0.3
                viewAnimate().popOut(btnLable, timeInterval: 0.3, delay: nsTime)
            }
            
        }
        

        if animationP {
            var nsTime : NSTimeInterval!
            nsTime = self.count * 0.05 + 0.3
            self.view.viewWithTag(8)?.alpha = 0
            self.view.viewWithTag(9)?.alpha = 0
            UIView.animateWithDuration(0.3, delay: nsTime, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                    //self.view.viewWithTag(8).frame.origin.y += 200
                    //self.view.viewWithTag(9).frame.origin.y += 200
                    self.view.viewWithTag(8)?.alpha = 1
                    self.view.viewWithTag(9)?.alpha = 1
                }, completion: {
                    (finished : Bool) -> Void in
                    
                })
        }
        
       // animationP = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.canShowDetail = true
        
    }
    
    func tapShake(sender : AnyObject!){
        
        
        let next = GBoard.instantiateViewControllerWithIdentifier("Shake") as! ViewShakeController
        next.delegate = self
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    func tap(sender : AnyObject!){
        print("btn tapped \(sender.tag)")
        if sender.tag > self.btns_count {
            httpRequert().sendRequest(sender.tag - self.btns_count)
        }else{
            httpRequert().sendRequest(sender.tag + 7)
        }
    }
    func tapDown(sender : AnyObject!){
        print("btn down \(sender.tag)")
        FAME.tempMode = sender.tag + 7
        
    }
}
extension ViewControllerMainP : ViewShakeControllerDelegate {
    
    func shakeAction() {
        FAME.showMessage("我的模式启动")
        httpRequert().sendRequest(13)
    }
    
}

class ViewControllerMainSS: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
        
        let btns = Defined_SS_btns
        let btnImgs = ["ss1.png","ss2.png","ss3.png","ss4.png","ss5.png","ss6.png","ss7.png","ss8.png"]
        
        //fix position
        
        let view0 = self.view.viewWithTag(10)!
        view0.frame.size.width = self.view.frame.size.width - 60
        let divW:CGFloat = 0.27
        //let top:CGFloat =  80
        let btnWidth = view0.frame.width * divW
        let btnHeight = btnWidth * 1.1
        
        let disX:CGFloat = ((1 - divW * 3) / 2 + divW) * view0.frame.width
        //let disY:CGFloat = view0.frame.height * 0.25
        
        let disY:CGFloat = btnHeight + 30 + self.view.frame.height * 0.02
        let diffj:CGFloat = CGFloat(btns.count / 3) + 1
        let top:CGFloat =  (self.view.frame.height - disY * diffj - 69) * 0.5
        
        
        let diffi:CGFloat = CGFloat(btns.count % 3)
        
        var diffX: CGFloat = diffi == 0 ? 0 : (view0.frame.width - diffi * btnWidth ) / 2
        diffX = diffi == 2 ? diffX - (1 - divW * 3) / 4  * view0.frame.width : diffX
        
        
        var btnX: CGFloat = 0
        var btnY: CGFloat = btns.count <= 3 ? top + 90 : top
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
        
      //  animationSS = false
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        //self.title = "wned"
        
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
        else{
            next = GBoard.instantiateViewControllerWithIdentifier("viewSS") as UIViewController
        }

        next.title = "\(Defined_SS_btns1[sender.tag])"
        FAME.tempSensorId = sender.tag
        self.navigationController?.pushViewController(next, animated: true)
        //self.navigationController.navigationBar.topItem.title = "Back"
    }
}


class ViewAboutUs2Controller: UIViewController {
    @IBAction func showURL(sender : AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://famesmart.com/")!)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("XXXXX")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func btnAboutUs(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://famesmart.com/aboutus.html")!)
    }
    
    @IBAction func btnLatestNews(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://famesmart.com/news.html")!)
    }
    
    @IBAction func btnNewArrival(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://famesmart.com/latestproduct.html")!)
    }
    
    @IBAction func btnQA(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://www.famesmart.com/update_json/fame/FameZigbee/TradeMark/Merchant0/faq.html")!)
        
    }
    

    
}


class ViewControllerMainUM: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
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
        
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
    }
    func Timerset(){
        let url = NSURL(string: "http://www.famesmart.com/product/usermanual.html")
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
    }
}






