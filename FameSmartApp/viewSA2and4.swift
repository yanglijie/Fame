//
//  viewSA2and4.swift
//  FameSmartApp
//
//  Created by book on 15-5-7.
//

import UIKit


class ViewControllerMainSA2: UIViewController ,UIAlertViewDelegate {
    var btns:[String]=[]
    var act_ids:[Int]=[]
    var dev_types:[Int] = []
    var ieees:[String]=[]
    var tmp_tag = 0
    var is_alert = false
    func longPress(sender : UIButton!) {
        
        print("longpress")
        print(sender)
        //self.tmp_tag = sender.tag
        if (!self.is_alert){
            self.is_alert = true
            let alert :UIAlertView = UIAlertView()
            alert.delegate = self
            alert.title = Defined_ALERT_del
            alert.message = Defined_ALERT_del2
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.addButtonWithTitle(Defined_ALERT_CANCEL)
            alert.show()
            
        }
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        print("click at \(buttonIndex)")
        let ieee : String! = self.ieees[self.tmp_tag - 1]
        print("del ieee:\(ieee)")
        self.is_alert = false
        if buttonIndex == 0 {
            print("del")
            
            let ieee : String! = self.ieees[self.tmp_tag - 1]
            print("del ieee:\(ieee)")
            let dic:NSMutableDictionary = ["hvaddr":"\(ieee)"]
            FAME.delDeviceArray.removeAllObjects()
            FAME.delDeviceArray.addObject(dic)
            FAME.doDeleteDev()
            print(FAME.device_table)
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            
        }
    }
    
    func tapDown(sender : AnyObject!){
        print("btn down-- \(sender.tag)")
        self.tmp_tag = sender.tag
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        btns=[]
        act_ids=[]
        dev_types = []  //  2015-05-18
        for value in FAME.curtains {
            let curtainObj = value as NSDictionary
            let curName:String! = curtainObj["name"] as! String
            let curActid:String! = curtainObj["act_id"] as! String
            let curIeee:String! = curtainObj["ieee"] as! String
            let curType:String! = curtainObj["dev_type"] as! String
            self.btns.append(curName)
            self.act_ids.append(Int(curActid)!)
            self.dev_types.append(Int(curType)!)
            self.ieees.append(curIeee)
        }

        //btns = Defined_SA_btns

        print("......")

        //fix position
        
        let view0 :UIView = self.view.viewWithTag(10)!
        view0.frame.size.width = self.view.frame.size.width - 60
        
        let viewWidth = self.view.frame.size.width - 60
        
        let divW:CGFloat = 0.22
        
        let top:CGFloat =  80
        let btnWidth  = view0.frame.size.width * divW
        print(btnWidth)
        let btnHeight = btnWidth * 1.1
        
        let disX:CGFloat = ((1 - divW * 3) / 2 + divW) * view0.frame.width
        let disY:CGFloat = view0.frame.height * 0.25
        
        let diffi:CGFloat = CGFloat(btns.count % 3)
        
        var diffX:CGFloat = diffi == 0 ? 0 : (view0.frame.width - diffi * btnWidth ) / 2
        diffX = diffi == 2 ? diffX - (1 - divW * 3) / 4  * view0.frame.width : diffX
        
        
        var btnX:CGFloat = 0
        var btnY:CGFloat = btns.count <= 3 ? top + 90 : top
        btnX = btns.count <= 3 ? diffX + btnX : btnX
        for idx in 0..<btns.count {
            
           // println(self.dev_types[idx])
            
            var btnImg = "curtain_icon.png"         //  2015-05-18
            if (self.dev_types[idx] == 15){     //  2015-05-18
                btnImg = "screen_icon.png"      //  2015-05-18
            }                                   //  2015-05-18
            
            
            let btn = UIButton(frame: CGRect(x: CGFloat(btnX), y: CGFloat(btnY), width: CGFloat(btnWidth), height: CGFloat(btnHeight)))
            btn.setBackgroundImage(UIImage(named: btnImg), forState: UIControlState.Normal)
            
            let btnLable = UILabel(frame: CGRect(x: CGFloat(btnX - 20), y: CGFloat(btnY + btnHeight + 10), width: CGFloat(btnWidth + 40), height: 14))
            
            //gesture
            
            let longPressRec = UILongPressGestureRecognizer()
            longPressRec.addTarget(self, action: "longPress:")
            btn.addGestureRecognizer(longPressRec)
            //btn.userInteractionEnabled = true
            
            btnLable.text = btns[idx]
            btnLable.textColor = UIColor.whiteColor()
            btnLable.textAlignment = NSTextAlignment.Center
            btnLable.adjustsFontSizeToFitWidth = true
            
            btnX = idx == 2 ? diffX : btnX + disX
            btnY = idx == 2 ? btnY + disY : btnY
            
            btn.addTarget(self, action: "tap:", forControlEvents: UIControlEvents.TouchUpInside)
            btn.addTarget(self, action: "tapDown:", forControlEvents: UIControlEvents.TouchDown)
            
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.title = "modes"
        FAME.tempTableView = nil
    }
    
    func tap(sender : AnyObject!){
        print("btn tapped \(sender.tag)")
        FAME.saActid2 = sender.tag-1
        FAME.tempApplsId = act_ids[sender.tag-1]
        var viewId = sender.tag
        
        let next :UIViewController! = GBoard.instantiateViewControllerWithIdentifier("viewSA21") as UIViewController!
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
}


class ViewControllerMainSA3: UIViewController,UIAlertViewDelegate  {
    var btns:[String]=[]
    var act_ids:[Int]=[]
    var ieees:[String]=[]
    var tmp_tag = 0
    var is_alert = false
    func longPress(sender : UIButton!) {
        
        print("longpress")
        print(sender)
        //self.tmp_tag = sender.tag
        if (!self.is_alert){
            self.is_alert = true
            let alert :UIAlertView = UIAlertView()
            alert.delegate = self
            alert.title = Defined_ALERT_del
            alert.message = Defined_ALERT_del2
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.addButtonWithTitle(Defined_ALERT_CANCEL)
            alert.show()
            
        }
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        print("click at \(buttonIndex)")
        self.is_alert = false
        if buttonIndex == 0 {
            print("del")
            
            let ieee : String! = self.ieees[self.tmp_tag - 1]
            print("del ieee:\(ieee)")
            let dic:NSMutableDictionary = ["hvaddr":"\(ieee)"]
            FAME.delDeviceArray.removeAllObjects()
            FAME.delDeviceArray.addObject(dic)
            FAME.doDeleteDev()
            print(FAME.device_table)
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            
        }
    }
    
    func tapDown(sender : AnyObject!){
        print("btn down \(sender.tag)")
        self.tmp_tag = sender.tag
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        btns=[]
        act_ids=[]
        for value in FAME.airs {
            let airObj = value as NSDictionary
            let airName:String! = airObj["name"] as! String
            let airActid:String! = airObj["act_id"] as! String
            let airIeee:String! = airObj["ieee"] as! String
            btns.append(airName)
            act_ids.append(Int(airActid)!)
            self.ieees.append(airIeee)
        }
        
        //btns = Defined_SA_btns
        
        let btnImgs = ["sa1.png","sa2.png","sa3.png","sa4.png","sa5.png","sa6.png"]
        
        print("......")
        
        //fix position
        
        let view0 :UIView = self.view.viewWithTag(10)!
        view0.frame.size.width = self.view.frame.size.width - 60
        
        //let viewWidth = self.view.frame.size.width - 60
        
        let divW:CGFloat = 0.27
        
        let top:CGFloat =  80
        let btnWidth  = view0.frame.size.width * divW
        print(btnWidth)
        let btnHeight = btnWidth * 1.1
        
        let disX:CGFloat = ((1 - divW * 3) / 2 + divW) * view0.frame.width
        let disY:CGFloat = view0.frame.height * 0.25
        
        let diffi:CGFloat = CGFloat(btns.count % 3)
        
        var diffX:CGFloat = diffi == 0 ? 0 : (view0.frame.width - diffi * btnWidth ) / 2
        diffX = diffi == 2 ? diffX - (1 - divW * 3) / 4  * view0.frame.width : diffX
        
        
        var btnX:CGFloat = 0
        var btnY:CGFloat = btns.count <= 3 ? top + 90 : top
        btnX = btns.count <= 3 ? diffX + btnX : btnX
        for idx in 0..<btns.count {
            
            let btn = UIButton(frame: CGRect(x: CGFloat(btnX), y: CGFloat(btnY), width: CGFloat(btnWidth), height: CGFloat(btnHeight)))
            btn.setBackgroundImage(UIImage(named: btnImgs[2]), forState: UIControlState.Normal)
            
            let btnLable = UILabel(frame: CGRect(x: CGFloat(btnX - 20), y: CGFloat(btnY + btnHeight + 10), width: CGFloat(btnWidth + 40), height: 20))
            
            
            //gesture
            
            let longPressRec = UILongPressGestureRecognizer()
            longPressRec.addTarget(self, action: "longPress:")
            btn.addGestureRecognizer(longPressRec)
            //btn.userInteractionEnabled = true
            
            btnLable.text = btns[idx]
            btnLable.textColor = UIColor.whiteColor()
            btnLable.textAlignment = NSTextAlignment.Center
            
            btnX = idx == 2 ? diffX : btnX + disX
            btnY = idx == 2 ? btnY + disY : btnY
            
            btn.addTarget(self, action: "tap:", forControlEvents: UIControlEvents.TouchUpInside)
            
            btn.addTarget(self, action: "tapDown:", forControlEvents: UIControlEvents.TouchDown)
            
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
        
        
        if (btns.count < 1) {
            print("no aircs")
            
            let textLabel = UILabel (frame:CGRectMake(self.view.frame.size.width/8,view.frame.size.height/10,self.view.frame.size.width*3/4,view.frame.size.height*4/5))
            textLabel.text = Defined_Tips_none
            
            //textLabel.backgroundColor = UIColor.blackColor()
            textLabel.textColor = UIColor.whiteColor()
            textLabel.textAlignment = NSTextAlignment.Center
            textLabel.numberOfLines = 0;
            textLabel.font = UIFont.systemFontOfSize(25)
            self.view.addSubview(textLabel)
            
            
           }
        // animationSA = false
        
        
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
        self.navigationController?.title = "modes"
        FAME.tempTableView = nil
    }
    
    func tap(sender : AnyObject!){
        print("btn tapped \(sender.tag)")
        FAME.saActid3 = sender.tag-1
        FAME.tempApplsId = act_ids[sender.tag-1]
        
        var viewId = sender.tag
        
        let next :UIViewController! = GBoard.instantiateViewControllerWithIdentifier("viewSA31") as UIViewController!
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
}



class ViewControllerMainSA4: UIViewController,UIAlertViewDelegate {
    var btns:[String]=[]
    var act_ids:[Int]=[]
    var ieees:[String]=[]
    
    var tmp_tag = 0
    var is_alert = false
    func longPress(sender : UIButton!) {
        
        print("longpress")
        print(sender)
        //self.tmp_tag = sender.tag
        if (!self.is_alert){
            self.is_alert = true
            let alert :UIAlertView = UIAlertView()
            alert.delegate = self
            alert.title = Defined_ALERT_del
            alert.message = Defined_ALERT_del2
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.addButtonWithTitle(Defined_ALERT_CANCEL)
            alert.show()
            
        }
        

        
    }
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        print("click at \(buttonIndex)")
        self.is_alert = false
        if buttonIndex == 0 {
            print("del")
            
            let ieee : String! = self.ieees[self.tmp_tag - 1]
            print("del ieee:\(ieee)")
            let dic:NSMutableDictionary = ["hvaddr":"\(ieee)"]
            FAME.delDeviceArray.removeAllObjects()
            FAME.delDeviceArray.addObject(dic)
            FAME.doDeleteDev()
            print(FAME.device_table)
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.btns=[]
        self.act_ids=[]
        self.ieees = []
        
        for value in FAME.appls {
            let applObj = value as NSDictionary
            let appName:String! = applObj["name"] as! String
            let appActid:String! = applObj["act_id"] as! String
            let appIeee:String! = applObj["ieee"] as! String
            
            self.btns.append(appName)
            self.act_ids.append(Int(appActid)!)
            self.ieees.append(appIeee)
        }
        
        //btns = Defined_SA_btns
        
        let btnImgs = ["sa1.png","sa2.png","sa3.png","sa4.png","sa5.png","sa6.png"]
        
        print("......")
        
        //fix position
        
        let view0 :UIView = self.view.viewWithTag(10)!
        view0.frame.size.width = self.view.frame.size.width - 60
        
        let viewWidth = self.view.frame.size.width - 60
        
        let divW:CGFloat = 0.27
        
        let top:CGFloat =  80
        let btnWidth  = view0.frame.size.width * divW
        print(btnWidth)
        let btnHeight = btnWidth * 1.1
        
        let disX:CGFloat = ((1 - divW * 3) / 2 + divW) * view0.frame.width
        let disY:CGFloat = view0.frame.height * 0.25
        
        let diffi:CGFloat = CGFloat(btns.count % 3)
        
        var diffX:CGFloat = diffi == 0 ? 0 : (view0.frame.width - diffi * btnWidth ) / 2
        diffX = diffi == 2 ? diffX - (1 - divW * 3) / 4  * view0.frame.width : diffX
        
        
        var btnX:CGFloat = 0
        var btnY:CGFloat = btns.count <= 3 ? top + 90 : top
        btnX = btns.count <= 3 ? diffX + btnX : btnX
        for idx in 0..<btns.count {
            
            let btn = UIButton(frame: CGRect(x: CGFloat(btnX), y: CGFloat(btnY), width: CGFloat(btnWidth), height: CGFloat(btnHeight)))
            btn.setBackgroundImage(UIImage(named: btnImgs[3]), forState: UIControlState.Normal)
            
            let btnLable = UILabel(frame: CGRect(x: CGFloat(btnX - 20), y: CGFloat(btnY + btnHeight + 10), width: CGFloat(btnWidth + 40), height: 20))
            
            
            //gesture
            
            let longPressRec = UILongPressGestureRecognizer()
            longPressRec.addTarget(self, action: "longPress:")
            btn.addGestureRecognizer(longPressRec)
            //btn.userInteractionEnabled = true
            
            
            btnLable.text = btns[idx]
            btnLable.textColor = UIColor.whiteColor()
            btnLable.textAlignment = NSTextAlignment.Center
            
            btnX = idx == 2 ? diffX : btnX + disX
            btnY = idx == 2 ? btnY + disY : btnY
            
            btn.addTarget(self, action: "tap:", forControlEvents: UIControlEvents.TouchUpInside)
            
            btn.addTarget(self, action: "tapDown:", forControlEvents: UIControlEvents.TouchDown)
            
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
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.title = "modes"
        FAME.tempTableView = nil
    }
    
    func tap(sender : AnyObject!){
        print("btn tapped \(sender.tag)")
        FAME.saActid4 = sender.tag-1
        FAME.tempApplsId = act_ids[sender.tag-1]
        var viewId = sender.tag
        
        let next :UIViewController! = GBoard.instantiateViewControllerWithIdentifier("viewSA41") as UIViewController!
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    func tapDown(sender : AnyObject!){
        print("btn down \(sender.tag)")
        self.tmp_tag = sender.tag
        
    }
    
}