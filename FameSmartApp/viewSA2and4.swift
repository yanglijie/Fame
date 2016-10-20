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
    
    var BGView:UIView!
    var pickView:UIView!
    var ieee:String! = ""
    
    @IBOutlet weak var tableView: UITableView!
    var curtains:Array<Dictionary<String,String>> = []
    
    var lights:Array<Dictionary<String,String>> = []
        func refreshData(){
        switch FAME.tempSensorId {
        case 2:
            self.lights = FAME.curtains
        case 3:
            self.lights = FAME.airs
        case 4:
            self.lights = FAME.appls
        default:
            break
        }
    }
    func paixu(){

        refreshData()
        
        btns=[]
        act_ids=[]
        dev_types = []  //  2015-05-18
        ieees = []
        
        if curtains.count != 0{
            curtains.removeAll()
        }
        print(lights)
        for i in 0..<FAME.rooms.count{
            for j in 0..<lights.count{
                if i == Int(lights[j]["room"]!){
                    curtains.append(lights[j])
                }
            }
        }
        
        for value in curtains {
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
        
    }
    func handleLongpressGesture(sender: UILongPressGestureRecognizer) {
        
        
        if sender.state == UIGestureRecognizerState.Began {
            let point:CGPoint = sender.locationInView(self.tableView)
            let indexPath:NSIndexPath! = self.tableView.indexPathForRowAtPoint(point)
            if(indexPath != nil){
                let cell:UITableViewCell2! = self.tableView.cellForRowAtIndexPath(indexPath) as! UITableViewCell2
                
                //index = cell.index
                FAME.dev_id = cell.dev_id
                
                FAME.dev_ss_Rname = curtains[indexPath.row]["roomName"] as String!
                FAME.dev_ss_name = curtains[indexPath.row]["name1"] as String!
                self.ieee = curtains[indexPath.row]["ieee"] as String!
                
                self.BGView.hidden = false
                
            }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        paixu()
        
        if curtains.count == 0 {
            
            let textLabel = UILabel (frame:CGRectMake(self.view.frame.size.width/8,view.frame.size.height/10,self.view.frame.size.width*3/4,view.frame.size.height*4/5))
            textLabel.text = Defined_Tips_none
            
            //textLabel.backgroundColor = UIColor.blackColor()
            textLabel.textColor = UIColor.whiteColor()
            textLabel.textAlignment = NSTextAlignment.Center
            textLabel.numberOfLines = 0;
            textLabel.font = UIFont.systemFontOfSize(25)
            self.view.addSubview(textLabel)
            
            //break
            
        }
        
        else{
            
            
            createPop()
            
            
        }
      
        
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
        
        
        FAME.tempTableView = nil
       
    }
    
    func tapPress( sender : AnyObject){
        
        self.BGView.hidden = true
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
        
        
        
        
        self.pickView = UIView(frame: CGRect(x: 0, y: self.view.frame.height - 200 , width: self.view.frame.width, height: 200))
        self.pickView.backgroundColor = UIColor.whiteColor()
        
        
        
        
        //btns
        let btnX:CGFloat = 30
        let btnWidth:CGFloat = self.view.frame.width - btnX * 2
        let btnHeight:CGFloat = 30
        let btnY:CGFloat = 25
        
        let btnS1 = UIButton(frame: CGRect(x: btnX, y: btnY, width: btnWidth, height: btnHeight))
        btnS1.setTitle(Defined_SS_air_Title1, forState: UIControlState.Normal)
        btnS1.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        //btnS1.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS1.tag = 1
        btnS1.addTarget(self, action: Selector("btns1Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnS2 = UIButton(frame: CGRect(x: btnX, y: btnY + 50, width: btnWidth, height: btnHeight))
        btnS2.setTitle(Defined_SS_air_Title2, forState: UIControlState.Normal)
        btnS2.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btnS2.tag = 2
        //btnS2.setBackgroundImage(UIImage(named: "airBtn.png"), forState: UIControlState.Normal)
        btnS2.addTarget(self, action: Selector("btns2Fun:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let btnS3 = UIButton(frame: CGRect(x: btnX, y: btnY + 100, width: btnWidth, height: btnHeight))
        
        btnS3.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)

        btnS3.tag = 3

        btnS3.setTitle("更改设备名", forState: UIControlState.Normal)
        btnS3.addTarget(self, action: Selector("btns3Fun:"), forControlEvents: UIControlEvents.TouchUpInside)

        
        
        self.pickView.addSubview(btnS1)
        self.pickView.addSubview(btnS2)
        self.pickView.addSubview(btnS3)
        //self.pickView.addSubview(btnS4)
        
        self.BGView.addSubview(self.pickView)
        self.view.addSubview(self.BGView)
        self.BGView.hidden = true
        
    }
    //更改设备名
    func btns3Fun(sender:UIButton){
        self.BGView.hidden = true
        print("更改设备名")
        let next = GBoard.instantiateViewControllerWithIdentifier("music")
        
        self.navigationController?.pushViewController(next, animated: true)
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        
        
        
    }

    //修改名字
    func btns1Fun(sender:UIButton){
        self.BGView.hidden = true
        let next = GBoard.instantiateViewControllerWithIdentifier("viewSS_name") as! ViewControllerSS_name
        next.delegate = self ;
        
        self.navigationController?.pushViewController(next, animated: true)
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
    }
    //删除设备
    func btns2Fun(sender:UIButton){
        self.BGView.hidden = true
        let alertController = UIAlertController(title: "友情提示", message: "请输入密码删除该设备", preferredStyle: UIAlertControllerStyle.Alert);
        alertController.addTextFieldWithConfigurationHandler {
            (textField: UITextField!) -> Void in
            
        }
        let cancelAction = UIAlertAction(title: "取消", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "好的", style: .Default,
            handler: {
                action in
                //也可以用下标的形式获取textField let login = alertController.textFields![0]
                let login = alertController.textFields!.first! as UITextField
                print("用户名：\(login.text)=======\(FAME.user_name)34637169")
                
                self.presentedViewController?.dismissViewControllerAnimated(false, completion: nil)
                
                if login.text! == "\(FAME.user_name)34637169"
                {
                    FAME.delDeviceByIeee(self.ieee)
                    self.navigationController?.popToRootViewControllerAnimated(true)
  
                    
                }
                else{
                    FAME.showMessage("输入的密码不正确")
                }
                
                
        })
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
}
extension ViewControllerMainSA2:ViewControllerSS_nameDelegate{
    func reloadName() {
        FAME.showMessage("名字修改成功");

        paixu()
        tableView.reloadData()
    
        
    }
}
extension ViewControllerMainSA2:UITableViewDataSource,UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return curtains.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 100
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell2
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target:self
            , action: "handleLongpressGesture:")
        longpressGesutre.minimumPressDuration = 1.0;
        
        cell .addGestureRecognizer(longpressGesutre)
        
        cell.selectionStyle = .Gray
        let dev_Str:String! = curtains[indexPath.row]["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)
        cell.dev_id = dev_id
        
        
        //name
        let name = cell.viewWithTag(1) as! UILabel
        name.text = curtains[indexPath.row]["name"]

        //image      2015-05-21
        let imgObj = cell.viewWithTag(99) as! UIImageView
        
        if (self.dev_types[indexPath.row] == 15){     //  2015-05-18
            imgObj.image = UIImage(named: "screen_icon.png")      //  2015-05-18
        }
        else if (self.dev_types[indexPath.row] == 16 || self.dev_types[indexPath.row] == 17){
            imgObj
            imgObj.image = UIImage(named: "appl_17_icon.png")
        }
        else{
            imgObj.image = UIImage(named: Defined_SA_icons[FAME.tempSensorId])
        }
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let dev_Str:String! = curtains[indexPath.row]["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)
        
        let dev_Type:String! = curtains[indexPath.row]["dev_type"] as String!
        let dev_type:Int! = Int(dev_Type)
        
        FAME.dev_id = dev_id
        
        FAME.tempApplsId = act_ids[indexPath.row]

        var viewId:Int = 0
        if FAME.tempSensorId == 2{
            viewId = 2 * 10 + 1
            FAME.saActid2 = dev_id
        }
        else if FAME.tempSensorId == 3{
            viewId = 3 * 10 + 1
        }
        else{
            viewId = 4 * 10 + 1
            FAME.saActid4 = dev_type
        }
        
        self .performSelector("deselect", withObject: nil, afterDelay: 0.3)
        
        let next :UIViewController! = GBoard.instantiateViewControllerWithIdentifier("viewSA\(viewId)") as UIViewController!
        next.title = curtains[indexPath.row]["name"]
        self.navigationController?.pushViewController(next, animated: true)
        //
        
        
    }
    func deselect(){
        
        if (tableView.indexPathForSelectedRow != nil){
            tableView.deselectRowAtIndexPath(tableView.indexPathForSelectedRow!, animated: true)
        }
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
        
        //var viewId = sender.tag
        
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
            
            
            FAME.delDeviceByIeee(ieee)
            self.navigationController?.popToRootViewControllerAnimated(true)
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.btns=[]
        self.act_ids=[]
        self.ieees = []
        if FAME.appls.count == 0 {
            
            let textLabel = UILabel (frame:CGRectMake(self.view.frame.size.width/8,view.frame.size.height/10,self.view.frame.size.width*3/4,view.frame.size.height*4/5))
            textLabel.text = Defined_Tips_none
            
            //textLabel.backgroundColor = UIColor.blackColor()
            textLabel.textColor = UIColor.whiteColor()
            textLabel.textAlignment = NSTextAlignment.Center
            textLabel.numberOfLines = 0;
            textLabel.font = UIFont.systemFontOfSize(25)
            self.view.addSubview(textLabel)
            
            //break
            
        }
        else{
            for value in FAME.appls {
                let applObj = value as NSDictionary
                let appName:String! = applObj["name"] as! String
                let appActid:String! = applObj["act_id"] as! String
                let appIeee:String! = applObj["ieee"] as! String
                
                self.btns.append(appName)
                self.act_ids.append(Int(appActid)!)
                self.ieees.append(appIeee)
            }
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
        //var viewId = sender.tag
        
        let appActid:String! = FAME.appls[FAME.saActid4]["name"]! as String
        
        let next :UIViewController! = GBoard.instantiateViewControllerWithIdentifier("viewSA41") as UIViewController!
        next.title = appActid
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    
    func tapDown(sender : AnyObject!){
        print("btn down \(sender.tag)")
        self.tmp_tag = sender.tag
        
    }
    
}


class ViewControllerWind: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var onButton : UIButton2?
    var offButton : UIButton2?
    var isOn : Bool = true
    var dev_id : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print(FAME.socket34)
        
//        onButton = self.view.viewWithTag(68) as! UIButton2!
//        offButton = self.view.viewWithTag(69) as! UIButton2!
        
        if FAME.socket34.count == 0 {
            
            let textLabel = UILabel (frame:CGRectMake(self.view.frame.size.width/8,view.frame.size.height/10,self.view.frame.size.width*3/4,view.frame.size.height*4/5))
            textLabel.text = Defined_Tips_none
            
            //textLabel.backgroundColor = UIColor.blackColor()
            textLabel.textColor = UIColor.whiteColor()
            textLabel.textAlignment = NSTextAlignment.Center
            textLabel.numberOfLines = 0;
            textLabel.font = UIFont.systemFontOfSize(25)
            self.view.addSubview(textLabel)
            
            
        }
        else {
            tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: "refreshLights")
            tableView.mj_header.beginRefreshing()
        }
        
        
    }
    func refreshLights(){
        print("refreshLights")
        //self.TableView!.reloadData()
        

        let thread = NSThread(target: self, selector: "Timerset", object: nil)
        thread.start()
  
        
    }
    func Timerset(){
        let paramArray = NSMutableArray()
        var lastId = "0"
        
        for value in FAME.socket34 {
            let AddedObj = value as NSDictionary
            let dev_id:NSString! = AddedObj["dev_id"] as! NSString
            if lastId != dev_id {
                paramArray.addObject(dev_id)
                lastId = dev_id as String
            }
        }
        
        
        let param = paramArray.componentsJoinedByString(",")
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 19, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": [\(param)]}",timeout : 60)
        
        
        if (received != nil){
            print("333333")
            self.tableView.mj_header.endRefreshing()
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                //FAME.showMessage("刷新成功")
            })
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            let view = self.view.viewWithTag(60)! as UIView
            
            //got the state
            for values:AnyObject in received.valueForKey("states") as! NSArray {
                print(values)
                let AddedObj = values as! NSDictionary
                let ADDieee_addr :Int!  = AddedObj.valueForKey("id") as! Int
                var ADDflag :Int!  = AddedObj.valueForKey("state") as! Int
                var id = ADDieee_addr * 10
                if ADDflag >= 1 {
                    id = ADDieee_addr * 10 + 1
                    FAME.lightsCellState["\(id)"] = 1
                    ADDflag = ADDflag - 2
                    isOn = true
                    view.hidden = false
                }
                else{
                    id = ADDieee_addr * 10 + 1
                    FAME.lightsCellState["\(id)"] = 0
                    ADDflag = ADDflag - 3
                    isOn = false
                    view.hidden = true
                }
                if ADDflag >= 0 {
                    id = ADDieee_addr * 10
                    FAME.lightsCellState["\(id)"] = 1
                }
                else{
                    id = ADDieee_addr * 10
                    FAME.lightsCellState["\(id)"] = 0
                }
                
            }
            
            for subCell:AnyObject in self.tableView!.visibleCells {
                //print(subCell)
                let cell = subCell as! UITableViewCell2
                let view = cell.viewWithTag(2) as! UIImageView
                let view1 = cell.viewWithTag(21) as! UIImageView
                
                //print(FAME.lightsCellState)
                let state :Int! = FAME.lightsCellState["\(cell.id)"]
                let state1 :Int! = FAME.lightsCellState["\(cell.id + 1)"]
                
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    if (state != nil) {
                        if state == 1 {
                            view1.image = UIImage(named: "socket_10.png")
                            
                        }else {
                            view1.image = UIImage(named: "socket_06.png")
                            
                        }
                    }
                    if (state1 != nil) {

                        if state1 == 1 {
                            view.image = UIImage(named: "socket_10.png")
                            
                        }else {
                            view.image = UIImage(named: "socket_06.png")
                            
                        }
                    }

                })
                
                
            }
            
        }

    }

    func Timerset1(){
        let paramArray = NSMutableArray()
        
        paramArray.addObject(dev_id!)

        let param = paramArray.componentsJoinedByString(",")
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 19, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": [\(param)]}",timeout : 60)
        
        
        if (received != nil){
            
            
            print("333333")
            
            
            let view1 = self.view.viewWithTag(60)! as UIView
            view1.hidden = false
            
            
            //got the state
            for values:AnyObject in received.valueForKey("states") as! NSArray {
                print(values)
                let AddedObj = values as! NSDictionary
                let ADDieee_addr :Int!  = AddedObj.valueForKey("id") as! Int
                var ADDflag :Int!  = AddedObj.valueForKey("state") as! Int
                var id = ADDieee_addr * 10
                if ADDflag >= 1 {
                    id = ADDieee_addr * 10 + 1
                    FAME.lightsCellState["\(id)"] = 1
                    ADDflag = ADDflag - 2
                }
                else{
                    id = ADDieee_addr * 10 + 1
                    FAME.lightsCellState["\(id)"] = 0
                    ADDflag = ADDflag - 3
                    
                }
                if ADDflag >= 0 {
                    id = ADDieee_addr * 10
                    FAME.lightsCellState["\(id)"] = 1
                }
                else{
                    id = ADDieee_addr * 10
                    FAME.lightsCellState["\(id)"] = 0
                }
                
            }
            
            for subCell:AnyObject in self.tableView!.visibleCells {
                //print(subCell)
                let cell = subCell as! UITableViewCell2
                let view1 = cell.viewWithTag(21) as! UIImageView
                
                //print(FAME.lightsCellState)
                let state :Int! = FAME.lightsCellState["\(cell.id)"]
                
                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                    if (state != nil) {
                        if state == 1 {
                            view1.image = UIImage(named: "socket_10.png")
                            
                        }else {
                            view1.image = UIImage(named: "socket_06.png")
                            
                        }
                    }
                    
                })
                
                
            }
            
        }
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAllClick(sender: UIButton2) {
        let view = sender.superview!.viewWithTag(2) as! UIImageView
        view.image = UIImage(named: "socket_10.png")
        
        FAME.lightsCellState["\(sender.id + 1)"] = 1
        
        httpRequert().sendRequest(sender.act_id)
        dev_id = sender.dev_id
        print("devid=====\(dev_id)")
        
        isOn = true
        
        let thread = NSThread(target: self, selector: "Timerset1", object: nil)
        thread.start()
        print("sender.act_id开2\(sender.act_id)")
    }
    @IBAction func onClick(sender: UIButton2) {
        if isOn{
            let view = sender.superview!.viewWithTag(21) as! UIImageView
            view.image = UIImage(named: "socket_10.png")
            
            FAME.lightsCellState["\(sender.id)"] = 1
            
            httpRequert().sendRequest(sender.act_id)
            print("sender.act_id开1\(sender.act_id)")
        }
    }
    
    @IBAction func offClick(sender: UIButton2) {
        
        if isOn{
            let view = sender.superview?.viewWithTag(21) as! UIImageView
            view.image = UIImage(named: "socket_06.png")
            
            FAME.lightsCellState["\(sender.id)"] = 0
            
            httpRequert().sendRequest(sender.act_id)
            print("sender.act_id关\(sender.act_id)")
        }
    }
    
    @IBAction func offAllClick(sender: UIButton2) {
        let view = sender.superview?.viewWithTag(2) as! UIImageView
        view.image = UIImage(named: "socket_06.png")
        
        FAME.lightsCellState["\(sender.id + 1)"] = 0
        
        isOn = false
        let view1 = self.view.viewWithTag(60)! as UIView
        view1.hidden = true
        
        httpRequert().sendRequest(sender.act_id)
        
        print("sender.act_id开zong\(sender.act_id)")
    }
    
    func handleLongpressGesture(sender: UILongPressGestureRecognizer) {
        
        
        if sender.state == UIGestureRecognizerState.Began {
            let point:CGPoint = sender.locationInView(self.tableView)
            let indexPath:NSIndexPath! = self.tableView.indexPathForRowAtPoint(point)
            if(indexPath != nil){
                let cell:UITableViewCell2! = self.tableView.cellForRowAtIndexPath(indexPath) as! UITableViewCell2
                
                FAME.dev_id = cell.dev_id
                
                print(FAME.dev_id)
            }
        }
    }
    
}

extension ViewControllerWind:UITableViewDataSource,UITableViewDelegate{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return FAME.socket34.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        return 200
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell2
        
        let dev_Str:String! = FAME.socket34[indexPath.row]["dev_id"] as String!
        let dev_id:Int! = Int(dev_Str)

        let SwithView = cell.viewWithTag(5) as UIView!
        //SwithView.backgroundColor = UIColor.grayColor()
        
        //长按手势
        let longpressGesutre = UILongPressGestureRecognizer(target:self
            , action: "handleLongpressGesture:")
        longpressGesutre.minimumPressDuration = 1.0
        
        SwithView .addGestureRecognizer(longpressGesutre)
        
        
        
        cell.dev_id = dev_id
        
        cell.id = dev_id * 10
        
        
        let tagOn = cell.viewWithTag(3) as! UIButton2!
        let tagOff = cell.viewWithTag(4) as! UIButton2!
        let tagOn1 = cell.viewWithTag(68) as! UIButton2!
        let tagOff1 = cell.viewWithTag(69) as! UIButton2!
        let act_Str:String! = FAME.socket34[indexPath.row]["act_id"] as String!
        
        let act_id:Int = Int(act_Str)!
        tagOff.dev_id = dev_id
        
        //print("2222222\(act_id)")
        tagOn.act_id = act_id
        tagOff.act_id = act_id + 1
        tagOn1.act_id = act_id + 2
        tagOff1.act_id = act_id + 3
        
        return cell
    }
    
    
    
    
}




