//
//  FAME.swift
//  FameSmartApp
//
//  Created by Eric on 14-12-1.
//  Copyright (c) 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

//*********************
//
//      Global vars and funcs
//
//*********************

import UIKit
import AVFoundation
import Starscream

let GBoard = UIStoryboard(name: "Main", bundle: nil)
//var Surl="http://www.famesmart.com/famecloud/user_intf.php"
var Surl="http://famesmart.com/test_famecloud/user_intf.php"

//let Curl="http://219.220.215.211/weixin/fame/wx_fame.php"

var socket = WebSocket(url: NSURL(string: "ws://famesmart.com:8080/")!)


enum LINKARRAYID:Int{
    case Mode = 0
    case Light = 1
    case Sensor = 2
    case Appls = 3
    case Curtain = 4
}
enum LINKSUBARRAYID:Int{
    case Name = 0
    case Room = 1
    case SubName = 2
    case SubId = 3
}


var FAME = fame()


class fame:NSObject{
    

    
    //标记是否是退出
    var outTag :Int! = 0
    //联动标记
    var link_id :Int! = 0
    
    var delete_id:Int! = 0
    
    //修改设备名称
    var dev_ss_name :String!
    var dev_ss_Rname :String!
    var variation_index :Int!
    var dev_ieee :String!
    
    var loading :UILabel!
    
    var fameIeee:String!
    var verify:String!
    
    //编辑的变量
    var modeArr : NSMutableArray = []
    var devicDis : NSMutableArray = []
    
    var editTag :Int! = 0
    
    var dev_id :Int! = 0
    var dev_type :Int! = 0

    
    var msgs :Array<String>= []
    var IS_IOS8:Bool = false
    var bPushEnable:Bool = false
    var bPushEnable1:Bool = true
    var deviceToken:String!
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var addDeviceArray:NSMutableArray = []
    var delDeviceArray:NSMutableArray = []
    
    var linkmDic:NSMutableArray = []
    var timermDic:NSMutableArray = []
    
    var DTversion :Int! = 0
    var lastDTversion:Int! = 0
    var user_name:String! = ""
    var user_uid:UInt!
    var user_pwd:String! = ""
    var user_did:UInt! = 0
    var user_ieee_addr:String!
    var user_ieee_ck:String!
    var device_table :NSMutableDictionary!
    
    var didArray:NSMutableArray = []
    
    var detail :Array<Dictionary<String,AnyObject>>!
    
    var user_dname:String!
    var checkAddDeviceTimes = 0
    var checkDelDeviceTimes = 0
    
    var isAddDeviceFromSetting:Bool = false
    var isAddingDevice:Bool = false
    var isLinkPhoneFromSetting:Bool = false
    
    var tempIEEE:String!
    var tempSensorId = 0
    var tempMode = 0
    var outterTemp = "0"
    var innerTemp = "0"
    var tempApplsId = 170
    var tempCmd:NSNumber = 0
    var tempTableView:UITableView!
    var tempTimerView:UITableView!
    
    var rooms:Array<String> = []
    
    
    var models:Array<Dictionary<String,String>> = []
    var lights:Array<Dictionary<String,String>> = []
    var lights7:Array<Dictionary<String,String>> = []
    var lights11:Array<Dictionary<String,String>> = []
    var sockets:Array<Dictionary<String,String>> = []
    var socket13:Array<Dictionary<String,String>> = []
    var socket31:Array<Dictionary<String,String>> = []
    var socket33:Array<Dictionary<String,String>> = []
    var socket34:Array<Dictionary<String,String>> = []
    var sensors:Array<Dictionary<String,String>> = []
    
    
    var lightsT = NSMutableArray()
    var socket13T = NSMutableArray()
    var lights11T = NSMutableArray()
    
    
    //timer
    var timers:Array<Dictionary<String,String>> = []
    
    var timerArray1:Array<Dictionary<String,String>> = []
    var timerArray2:Array<Dictionary<String,String>> = []
    var timerArray3:Array<Dictionary<String,String>> = []
    var timerArray4:Array<Dictionary<String,String>> = []
    
    var tempTimerArrayID:Int = -1
    var theTimeInterval:NSTimeInterval = 0
    
    var tempTimerArrayContent:Dictionary<String,String> = [:]
    
    var sensors23:Array<Dictionary<String,String>> = []
    var sensors24:Array<Dictionary<String,String>> = []
    var sensors25:Array<Dictionary<String,String>> = []
    var sensors26:Array<Dictionary<String,String>> = []
    var sensors28:Array<Dictionary<String,String>> = []
    var sensors30:Array<Dictionary<String,String>> = []
    var sensors32:Array<Dictionary<String,String>> = []
    var sensors47:Array<Dictionary<String,String>> = []
    var sensors48:Array<Dictionary<String,String>> = []
    var sensors49:Array<Dictionary<String,String>> = []
    
    var appls45:Array<Dictionary<String,String>> = []
    
    
    var curtains:Array<Dictionary<String,String>> = []
    
    var appls:Array<Dictionary<String,String>> = []
    var airs:Array<Dictionary<String,String>> = []
    
    //只存的有灯光和插座的联动id和名字
    var linkMoled:Array<Dictionary<String,String>> = []
    var linkYB:Array<Dictionary<String,String>> = []
    
    var timmer:NSTimer!
    //var lights:Array<Dictionary<String,String>> = []
    
    //state
    var socketsCellState:Dictionary<String,Int> = [:]
    var lightsCellState:Dictionary<String,Int> = [:]
    var sensorsCellState:Dictionary<String,Int> = [:]
    
    var deviceCount:Int = 0
    
    var linkArray:Array<Array<Array<Array<String>>>> = []
    //  Array["model","light","sensor","appls","curtain"]
    //  Array["model"][cell,cell]
    //  cell:dic = ["name":["name"],room:["room"],subName:[""],subId[""],level:["1","1"]]
    // level first for model  level 2nd for timer
    
    var idForNames:Dictionary<Int,Dictionary<String,String>> = [:]
    var editForDevice : Array<Dictionary<String,String>> = []
    
    var idForNamesMode:Dictionary<Int,String> = [:]
    
    var subNames : Dictionary<Int,Array<AnyObject>> = [:]
    var button_names : Dictionary<Int,Array<AnyObject>>? = [:]
    
    var Links:Array<Dictionary<String,AnyObject>> = []
    //  Array["light"][Array<Dic>]
    //  Array[ ["name":"ss","show":0,"room":0,"sub":[ ["name":"A","act_id":12,"type":0]  ]  [......]                  ]
    
    //情景模式面板
    var event_ids = [1,2,3,49,50,51]
    var action_ids : Dictionary<Int,Array<Int>> = [:]
    var boolCounts : Int!
    
    var saActid2 = 0;
    var saActid3 = 0;
    var saActid4 = 0;
    
    
    
    var showLights :Bool = true
    
    var showLight1Arr :Array<Int> = []
    var showLight2Arr :Array<Int> = []
    
    var devicetoken:String = ""
    
    func saveProfile(name:String!,pwd:String!){
        
        self.defaults.setObject(name, forKey: "user_name")
        
        self.defaults.setObject(pwd, forKey: "user_pwd")
        
        let sname = self.defaults.objectForKey("user_name") as! String!
        let spwd = self.defaults.objectForKey("user_pwd") as! String!
        
        print("save \(name) to Name as \(sname)")
        print("save \(pwd) to Pwd as \(spwd)")
        
        
    }
    
    func getProfile(type:Int = 0 ) -> String! {
        switch type{
        case 0:
            return self.defaults.objectForKey("user_name") as! String!
        case 1:
            return self.defaults.objectForKey("user_pwd") as! String!
        default:
            return nil
        }
    }
    
    func subString(str:String,A:Int,B:Int) -> String! {
        print((str as NSString).length)
        if (str as NSString).length <= 32 {
            return nil
        }else{
            let str1 = (str as NSString).substringFromIndex(A)
            let str2 = (str1 as NSString).substringToIndex(B)
            return str2 as String
        }
    }
    
    func getNameById(idStr:String!) -> Array<Int>! {
        let id = Int(idStr)
        if id == nil {
            return nil
        }
        
        
        /*
        //mode
        for i in 0...(FAME.linkArray[0].count - 1 ) {
            
            let value = FAME.linkArray[0][i]
         //   let idString = value["subId"]?[0]
          //  let id1 = idString?.toInt()
            if (id1 == id){
                //off
                return [0,i,0]
            }
        }
        //light 
        for i in 0...(FAME.linkArray[0].count - 1 ){
            let value = FAME.linkArray[0][i]
         //   let valueSubId = value["subId"] as Array<String>!
            for j in 0...( valueSubId.count - 1 ) {
                let idString = value["subId"]?[0]
                let id1 = idString?.toInt()!
                
                if (id1! == id!){
                    //off
                    return [0,i,j]
                }
                
                if ((id1! + 1) == id!){
                    //off
                    return [0,i,j]
                }
                
                
                
                
            }
        }
        */
        return nil
    }
    
    func updateDateToServer(date:NSDate) -> Bool {
        
        
        
        
        let timeString = FAME.stringFromDate(date, type: 3)
        
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 38, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": {\"cmd\": 2, \"param\": {\"time\": \"\(timeString)\"}}}",timeout : 5)
        
        if (received != nil){
            print("Update time OK")
            return true
        }else{
            return false
        }
    }
    
    
    func getDateFormServer(){
        let myThread = NSThread(target: self, selector: "threatGetDateFormServer", object: nil)
        myThread.start()
    }
    
    func threatGetDateFormServer() {
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 38, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": {\"cmd\": 1}}",timeout : 90)
        let now = NSDate()
        if (received != nil){
            let detail:NSDictionary? = received.valueForKey("detail") as! NSDictionary?
            let timeStringObj: AnyObject? = detail?.valueForKey("time")
            var timeString:String! = nil
            
            if timeStringObj != nil {
                timeString = detail?.valueForKey("time") as! String
            }
            
            if timeString != nil {
                
                let date:NSDate = FAME.dateFromString(timeString, type: 0)
                FAME.theTimeInterval = date.timeIntervalSinceDate(now)
                print("getTimeFromSever: \(timeString)")
                print("local time: \(FAME.stringFromDate(date,type:0))")
                print("the interval:\(FAME.theTimeInterval)")
                
                
            }
        }
    }
    
    func getDateFormLocal() -> NSDate{
        
        let date = NSDate(timeInterval: FAME.theTimeInterval, sinceDate: NSDate())
        print("local time: \(FAME.stringFromDate(NSDate(),type:0))")
        print("the interval:\(FAME.theTimeInterval)")
        print("getTimeFromlocal: \(FAME.stringFromDate(date,type:0))")
        return date
        
    }
    
    func stringFromDate(date:NSDate , type:Int = 0) -> String {
        let nsdatef:NSDateFormatter = NSDateFormatter()
        if type == 1 {
            nsdatef.dateFormat = "yyyy-MM-dd"
        }else if type == 2 {
            nsdatef.dateFormat = "HH:mm"
        }else if type == 3{
            nsdatef.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }else {
            nsdatef.dateFormat = "yyyy-MM-dd HH:mm"
        }
        
        return nsdatef.stringFromDate(date)
        
    }
    
    func dateFromString(str:String, type:Int = 0) -> NSDate {
        
        let nsdatef:NSDateFormatter = NSDateFormatter()
        if type == 1 {
            nsdatef.dateFormat = "yyyy-MM-dd"
        }else if type == 2 {
            nsdatef.dateFormat = "HH:mm"
        }else{
            nsdatef.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        
        let date:NSDate! = nsdatef.dateFromString(str)
        if date != nil {
            return date
        }else{
            return NSDate()
        }
        
    }
    
    
    
    
    
    func addToDt(name:String,dev_id:NSNumber,room:NSNumber,dev_type:NSNumber,ieee:String){
        switch dev_type {
        case 11 :
            
            let dic:NSDictionary = ["name":name,"variation":[""],"room":room,"dev_id":dev_id,"dev_type":dev_type,"ieee":ieee,"set":[1],"remote":[1]]
            let DTlights : AnyObject! = self.device_table.valueForKey("lights")
            DTlights.addObject(dic)
           // println(FAME.device_table)
        case 7 :
            
            let dic:NSDictionary = ["name":name,"variation":["A"],"room":room,"dev_id":dev_id,"dev_type":dev_type,"ieee":ieee,"set":[1],"remote":[1]]
            let DTlights : AnyObject! = self.device_table.valueForKey("lights")
            DTlights.addObject(dic)
            //println(FAME.device_table)
            
        case 8 :
            
            let dic:NSDictionary = ["name":name,"variation":["A","B"],"room":room,"dev_id":dev_id,"dev_type":dev_type,"ieee":ieee,"set":[1,1],"remote":[1,1]]
            let DTlights : AnyObject! = self.device_table.valueForKey("lights")
            DTlights.addObject(dic)
            //println(FAME.device_table)
            
        case 9 :
            
            let dic:NSDictionary = ["name":name,"variation":["A","B","C"],"room":room,"dev_id":dev_id,"dev_type":dev_type,"ieee":ieee,"set":[1,1,1],"remote":[1,1,1]]
            let DTlights : AnyObject! = self.device_table.valueForKey("lights")
            DTlights.addObject(dic)
            
            
        case 12 :
            
            let dic:NSDictionary = ["name":name,"variation":Defined_6light_name,"room":room,"dev_id":dev_id,"dev_type":dev_type,"ieee":ieee,"set":[1,1,1,1,1,1],"remote":[1,1,1,1,1,1]]
            let DTlights : AnyObject! = self.device_table.valueForKey("lights")
            DTlights.addObject(dic)
            //println(FAME.device_table)
            
        case 13 :
            
            let dic:NSDictionary = ["name":name,"variation":[name],"room":room,"dev_id":dev_id,"dev_type":dev_type,"ieee":ieee,"set":[1],"remote":[1]]
            let DTlights : AnyObject! = self.device_table.valueForKey("lights")
            DTlights.addObject(dic)
        
            
        case 18 :
            let dic:NSDictionary = ["name":name,"room":room,"dev_id":dev_id,"dev_type":dev_type,"ieee":ieee,"set":1,"remote":1,"button_name":["btn1","btn2","btn3","btn4","btn5", "btn6","btn7","btn8","btn9","cus","cus","cus","cus"]]
            let DTappls : AnyObject! = self.device_table.valueForKey("appls")
            DTappls.addObject(dic)
          
            
        case 23,24,25,26,27 :
            let dic:NSDictionary = ["name":name,"room":room,"dev_id":dev_id,"dev_type":dev_type,"ieee":ieee,"set":1,"remote":1]
            let DTsensors : AnyObject! = self.device_table.valueForKey("sensors")
            DTsensors.addObject(dic)
            
        case 10,15:
            let dic:NSDictionary = ["name":name,"room":room,"dev_id":dev_id,"dev_type":dev_type,"ieee":ieee,"set":1,"remote":1]
            let DTsensors : AnyObject! = self.device_table.valueForKey("curtains")
            DTsensors.addObject(dic)
            
            print(FAME.device_table)
        default:
            break
            
            
            
        }
    }
    func getDeviceTable() ->NSNumber! {
        
        if let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 16, \"user_name\": \"\(self.user_name )\",\"user_pwd\": \"\(self.user_pwd)\", \"did\": \"\(self.user_did)\"}"){
            let DT :AnyObject! = received.valueForKey("device_table")
            if (DT != nil){
                print("DT is OK")
                self.device_table = DT as! NSMutableDictionary!
                //println(self.device_table)
                self.deCodeDeviceTable()
                return 0
            }
            else{
                print("DT is null")
                return 1
            }
        }else{
            return nil
        }
    }
    func updateDeviceTable(){
        
        print("updateDeviceTable !!!!!!!!")
        
        var tsNum :Int = 0 as Int
        
        let TS:AnyObject! = FAME.device_table.valueForKey("table_version")
        if (TS != nil) {
            tsNum  = TS as! Int
            tsNum = tsNum + 1
            if tsNum > 1000 {
                tsNum = 1
            }
            print("set the table_version as:\(tsNum)")
            FAME.device_table.setValue(tsNum, forKey: "table_version")
        }
        
        let dic = FAME.device_table
        let nsdata = try? NSJSONSerialization.dataWithJSONObject(dic, options: [] )
        let str = NSString(data: nsdata!, encoding: 4)!
        print("DeviceTable Str: \(str)")
        
        if (httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 17, \"user_name\": \"\(self.user_name )\",\"user_pwd\": \"\(self.user_pwd)\", \"did\": \"\(self.user_did)\", \"device_table\": \(str)}") != nil){
            
            print("updateDeviceTable successed")
            
            FAME.lastDTversion = tsNum
            
        }else{
            let alert = UIAlertView()
            alert.title = Defined_uptate_title
            alert.message =  Defined_uptate_error1
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
            FAME.getDeviceTable()
            
        }

    }
    
    func doDeleteDev() -> Bool{
        
        if FAME.isNotAdding(){
            FAME.isAddingDevice = true
            self.defaults.setObject(self.delDeviceArray, forKey: "delDeviceArray")
            
            if httpRequert().delDevie() {
                
                let alert = UIAlertView()
                alert.title = Defined_unAdd_Title1
                //alert.delegate = self
                alert.message =  Defined_device_begin
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
                self.timmer = NSTimer.scheduledTimerWithTimeInterval(5.0, target:self, selector:"checkDelFunction", userInfo:nil, repeats:false)
                FAME.isAddingDevice = true

                return true
            }else{
                return false
            }
        }
        return false
    }
    
    func checkDelFunction () {
        print("check del")
        self.checkDelDevice()
        
    }
    
  // MARK: device表
    func deCodeDeviceTable(){
        
        
        FAME.linkArray = [[],[],[],[],[]]
        FAME.Links = []
        
        idForNamesMode = [:]
        idForNames = [:]
        editForDevice = []
        FAME.deviceCount = 0
        
        var Links3:Array<Dictionary<String,AnyObject>> = []
        var acrArr = []
        //version
        let TS:AnyObject! = FAME.device_table.valueForKey("table_version")
        if (TS != nil) {
            let tsNum :Int = TS as! Int
            print("the table_version is:\(tsNum)")
            FAME.DTversion = tsNum
        }else{
            FAME.DTversion = 0
        }
        
        self.linkMoled.removeAll(keepCapacity: false)
        self.linkMoled.append(["name":Defined_link_remove,"id":"0"])
        
        self.rooms = []
        
        if (self.device_table.valueForKey("rooms") != nil) {
            for value:String in self.device_table.valueForKey("rooms") as! Array<String> {
                self.rooms.append(value)
            }
        }else{
            self.device_table.setValue([], forKey: "rooms")
        }
        
        
        //e
        
        //1
        self.Links.append(["name":Defined_NULL,"show":3,"room":0,"sub":[["name":"","act_id":-2,"type":1]]])
        
        //modes
        
        Links3 = []
        
        var act_id = 8
        self.models = []
        
        if (self.device_table.valueForKey("modes") != nil) {
            for value:String in self.device_table.valueForKey("modes") as! Array<String> {
                self.models.append(["name":value,"act_id":"\(act_id)"])
                
                //add to idForName
                //FAME.idForNames[act_id]=["name":value,"room":"","string":value,"act_id":"\(act_id)"]
                
                self.idForNamesMode[act_id] = "\(value)"
                
                
                //add to linkArray
                
                FAME.linkArray[0].append([[value],[" "],[" "],["\(act_id)"]])
                
                //add to Links
                Links3.append(["name":value,"act_id":act_id,"type":1])
                act_id++
            }
            
            for i in 0..<Defined_MODE_NAME.count{
                FAME.models.append(["name":Defined_MODE_NAME[i],"act_id":"\(1 + i)"])
                
                
            }
            FAME.models.insert(["name":Defined_Event_Title,"act_id":"-1"], atIndex: 0)
            FAME.models.insert(["name":Defined_MODE_NAME1,"act_id":"0"], atIndex: 1)
            
            
        }else{
            self.device_table.setValue([], forKey: "modes")
        }
        
        self.Links.append(["name":Defined_LINKS_NAMES[0],"show":0,"room":0,"sub":Links3])
        
        
        
        //lights
        act_id = 20
        self.linkYB = []
        self.lights = []
        self.lights7 = []
        self.lights11 = []
        self.sockets = []
        self.socket13 = []
        self.socket31 = []
        self.socket33 = []
        self.socket34 = []
        self.showLight1Arr = []
        self.showLight2Arr = []
        self.subNames = [:]
        
        self.lightsT = []
        self.socket13T = []
        self.lights11T = []
        
        Links3 = []
        var  lightId:Int = 0
        var isShow:Bool = true
        var flag:NSNumber!
        if (self.device_table.valueForKey("lights") != nil) {
            
            for value : AnyObject in self.device_table.valueForKey("lights") as! NSArray {
                let DTlight = value as! NSDictionary
                let ieee :String  = DTlight.valueForKey("ieee") as! String
                let name :String  = DTlight.valueForKey("name") as! String
                
                let dev_id : Int  =  DTlight.valueForKey("dev_id") as! Int
                let room:Int = DTlight.valueForKey("room") as! Int
                let dev_type:NSNumber = DTlight.valueForKey("dev_type") as! NSNumber
                
                
                
                let roomName = self.rooms[room]
                
                if ((DTlight.valueForKey("flag") as! NSNumber!) != nil){
                    flag = DTlight.valueForKey("flag") as! NSNumber!
                    isShow = true
                    if(flag == 1){
                        isShow = false
                    }else{
                        isShow = true
                    }

                }
                else{
                    isShow = true
                }
                
                if (isShow){
                
                //ids
//                    if dev_id <= 22 {
//                        act_id = (dev_id -  1) * 6 + 20
//                    }else{
//                        act_id = (dev_id -  23) * 12 + 152
//                    }
                
                    if(value.valueForKey("action_ids") != nil ) {
                        acrArr = value.valueForKey("action_ids") as! NSArray
                        if(acrArr.count > 0){
                            act_id = acrArr[0] as! Int
                            //print("action_ids \(act_id)")
                        }
                    }
                //如果是新风的，直接跳过去了，没有subValue
                    if (dev_type == 7)||(dev_type == 8)||(dev_type == 9)||(dev_type == 11)||(dev_type == 12){
                        //light
                        var index = 0
                        let subName:Array<String> = []
                        var subId:Array<String> = []
                    
                    
                        Links3 = []
                        //var sub :Array<String> = []
                        
                        var sub:Array<AnyObject> = []

                        let set:Array = value.valueForKey("set") as! Array<Int>
                        //for subValue in value.valueForKey("variation") as! Array<AnyObject> {
                        
                        let variation = value.valueForKey("variation") as! NSArray
                        for i in 0..<set.count{
                            
                            var subValue:AnyObject
                            
                            if variation.count == 0{
                                subValue = ""
                            }
                            else{
                                subValue = variation[i]
                            }
                            sub.append("\(subValue)")

                            self.linkMoled.append(["name":"\(roomName) \(name) \(subValue)","id":"\(act_id + index * 2)"])
                        
                            
                            FAME.idForNames[act_id + index * 2 + 1 ]=["name":"\(name)\(subValue)开","room":"\(roomName)","string":"\(roomName) \(name) \(subValue) 开","act_id":"\(act_id + index * 2 + 1)"]
                            FAME.idForNames[act_id + index * 2]=["name":"\(name)\(subValue)关","room":"\(roomName)","string":"\(roomName) \(name) \(subValue) 关","act_id":"\(act_id + index * 2)"]
                            self.editForDevice.append(["name":"\(roomName)\(name)\(subValue)","act_id":"\(act_id + index * 2 + 1)","type":"\(dev_type)","state":"0","ieee":"\(ieee)","index":"\(index)","dev_id":"\(dev_id)"])
                        
                        
                            //add to Links
                        
                            Links3.append(["name":"\(subValue)","act_id":act_id + index * 2,"type":1])
                        
                            FAME.deviceCount++
                        
                            
                            subId.append("\(act_id + index * 2)")
                        
                        
                            self.idForNamesMode[act_id+index*2 + 1] = "\(roomName) \(name) \(subValue) 开"
                            self.idForNamesMode[act_id+index*2] = "\(roomName) \(name) \(subValue) 关"
                        
                            //Lights?
                            if (dev_type == 11)||(dev_type == 12) {
                                //FAME.showLight2Arr.append(lightId)
                                self.lights11.append(["name":"\(roomName)\(name)\(subValue)","roomName":"\(roomName)","name1":"\(name)","subValue":"\(subValue)","act_id":"\(act_id + index * 2)","dev_id":"\(dev_id)","room":"\(room)","index":"\(index)","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
                                lights11T.addObject(["name":"\(roomName)\(name)\(subValue)","roomName":"\(roomName)","name1":"\(name)","subValue":"\(subValue)","act_id":"\(act_id + index * 2)","dev_id":"\(dev_id)","room":"\(room)","index":"\(index)","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
                            
                            }else{
                                //FAME.showLight1Arr.append(lightId)
                                self.lights7.append(["name":"\(roomName)\(name)\(subValue)","roomName":"\(roomName)","name1":"\(name)","subValue":"\(subValue)","act_id":"\(act_id + index * 2)","dev_id":"\(dev_id)","room":"\(room)","index":"\(index)","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
                                lightsT.addObject(["name":"\(roomName)\(name)\(subValue)","roomName":"\(roomName)","name1":"\(name)","subValue":"\(subValue)","act_id":"\(act_id + index * 2)","dev_id":"\(dev_id)","room":"\(room)","index":"\(index)","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)","child":"0"])
                            }
                        
                            index++
                            
                            lightId++
                        
                        }
                    
                        self.subNames[dev_id] = sub
                    
                        if (dev_type != 11){
                        //add to Links
                            self.Links.append(["name":"\(roomName) \(name)","show":1,"room":room,"sub":Links3])
                        
                        }
                    
                    
                    
                    
                    //add to linkArray
                        FAME.linkArray[1].append([[name],[roomName],subName,subId])
                    
                    
                    //YB
                        if dev_type == 12 {
                            FAME.linkYB.append(["name":"\(roomName)\(name)","dev_id":"\(dev_id)"])
                        }
                    
                    
                    }
                    else{
                    //sockets
                        switch dev_type {
                        case 13 :
                            self.socket13.append(["name":"\(roomName)\(name)","roomName":"\(roomName)","name1":"\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
                            socket13T.addObject(["name":"\(roomName)\(name)","roomName":"\(roomName)","name1":"\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)","child":"0"])
                        case 31 :
                            self.socket31.append(["name":"\(roomName)\(name)","roomName":"\(roomName)","name1":"\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
                        case 33 :
                            self.socket33.append(["name":"\(roomName)\(name)","roomName":"\(roomName)","name1":"\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
                        case 34 :
                            self.socket34.append(["name":"\(roomName)\(name)","roomName":"\(roomName)","name1":"\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
                        default:
                            
                            break
                            
                        }

                        
                        self.sockets.append(["name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)"])
                        self.linkMoled.append(["name":"\(roomName)\(name)","id":"\(act_id)"])
                    
                        FAME.idForNames[act_id + 1 ]=["name":"\(name)开","room":"\(roomName)","string":"\(roomName) \(name) 开","act_id":"\(act_id + 1 )"]
                        FAME.idForNames[act_id ]=["name":"\(name)关","room":"\(roomName)","string":"\(roomName) \(name) 关","act_id":"\(act_id )"]
                        
                        self.editForDevice.append(["name":"\(roomName)\(name)","act_id":"\(act_id + 1)","type":"\(dev_type)","state":"0","ieee":"\(ieee)","index":"0","dev_id":"\(dev_id)"])
                        
                        self.idForNamesMode[act_id + 1] = "\(roomName)\(name) 开"
                        self.idForNamesMode[act_id] = "\(roomName)\(name) 关"
                    
                        FAME.deviceCount++
                    
                        //add to linkArray
                        FAME.linkArray[1].append([[name],[roomName],[" "],["\(act_id )"]])
                    
                    
                        //add to Links

                        Links3 = [["name":"","act_id":act_id,"type":1]]
                        self.Links.append(["name":"\(roomName)\(name)","show":1,"room":room,"sub":Links3])

                    }
                }
            }

        }
        else{
            self.device_table.setValue([], forKey: "lights")
        }
        
        
        
        //sensors
        self.sensors = []
        self.sensors23 = []
        self.sensors24 = []
        self.sensors25 = []
        self.sensors26 = []
        self.sensors28 = []
        self.sensors30 = []
        self.sensors32 = []
        self.sensors47 = []
        self.sensors48 = []
        self.sensors49 = []
        act_id = 460
        
        Links3 = []
        
        //FF-47-00-09-F6-06-92-D5
        if (self.device_table.valueForKey("sensors") != nil) {
            for value : AnyObject in self.device_table.valueForKey("sensors") as! NSArray {
                let DTsensor = value as! NSDictionary
                
                
                if ((DTsensor.valueForKey("flag") as! NSNumber!) != nil){
                    flag = DTsensor.valueForKey("flag") as! NSNumber!
                    isShow = true
                    if(flag == 1){
                        isShow = false
                    }else{
                        isShow = true
                    }
                    
                }
                else{
                    isShow = true
                }

                if(isShow){
                
                
                let name :String  = DTsensor.valueForKey("name") as! String
                let ieee :String  = DTsensor.valueForKey("ieee") as! String
                
                let dev_id : Int  =  DTsensor.valueForKey("dev_id") as! Int
                    
                let room:Int = DTsensor.valueForKey("room") as! Int
                let dev_type:NSNumber = DTsensor.valueForKey("dev_type") as! NSNumber
                
                let roomName = self.rooms[room]
                
                
                act_id = (dev_id -  85) * 3 + 452
                if(value.valueForKey("action_ids") != nil ) {
                    acrArr = value.valueForKey("action_ids") as! NSArray
                    if(acrArr.count > 0){
                        act_id = acrArr[0] as! Int
                    }
                }
                
                switch dev_type {
                case 23 :
                    self.sensors23.append(["name1":"\(name)","roomName":"\(roomName)","name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)"])
                case 24 :
                    self.sensors24.append(["name1":"\(name)","roomName":"\(roomName)","name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)"])
                case 25 :
                    self.sensors25.append(["name1":"\(name)","roomName":"\(roomName)","name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)"])
                case 26 :
                    self.sensors26.append(["name1":"\(name)","roomName":"\(roomName)","name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)"])
                case 28 :
                    self.sensors28.append(["name1":"\(name)","roomName":"\(roomName)","name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)"])
                case 30 :
                    self.sensors30.append(["name1":"\(name)","roomName":"\(roomName)","name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)"])
                case 32 :
                    self.sensors32.append(["name1":"\(name)","roomName":"\(roomName)","name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
                case 47 :
                    self.sensors47.append(["name1":"\(name)","roomName":"\(roomName)","name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
                case 48 :
                    self.sensors47.append(["name1":"\(name)","roomName":"\(roomName)","name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
                case 49 :
                    self.sensors49.append(["name1":"\(name)","roomName":"\(roomName)","name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
//                    self.sensors32.append(["name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)"])
                default:
                    
                    break
                    
                }
                
                //print("2222222\(self.sensors25)")
                FAME.deviceCount++
                    
                //if dev_type == 24{
                    FAME.idForNames[act_id ]=["name":"\(name)布防","room":"\(roomName)","string":"\(roomName) \(name) 布防","act_id":"\(act_id  )"]
                    FAME.idForNames[act_id + 1]=["name":"\(name)撒防","room":"\(roomName)","string":"\(roomName) \(name) 撒防","act_id":"\(act_id + 1 )"]
                    
                    self.editForDevice.append(["name":"\(roomName)\(name)","act_id":"\(act_id)","type":"\(dev_type)","state":"0","ieee":"\(ieee)","index":"0","dev_id":"\(dev_id)"])
                    
                    
                    self.idForNamesMode[act_id + 1] = "\(roomName) \(name) 撒防"
                    self.idForNamesMode[act_id] = "\(roomName) \(name) 布防"
//                }
//                
//                else{
//                    FAME.idForNames[act_id + 1]=["name":"\(name)开","room":"\(roomName)","string":"\(roomName) \(name) 开","act_id":"\(act_id  + 1 )"]
//                    FAME.idForNames[act_id ]=["name":"\(name)关","room":"\(roomName)","string":"\(roomName) \(name) 关","act_id":"\(act_id)"]
//                    
//                    self.idForNamesMode[act_id + 1] = "\(roomName) \(name) 开"
//                    self.idForNamesMode[act_id] = "\(roomName) \(name) 关"
//                    }
                
                //add to linkArray
              //  FAME.linkArray[2].append(["name":[name],"room":[roomName],"subName":[" "],"subId":["\(act_id )"]])
                
                //add to Links
                

                Links3 = [["name":"","act_id":act_id,"type":1]]
                self.Links.append(["name":"\(roomName) \(name)","show":2,"room":room,"sub":Links3])
                    
                    
                }
            }
        }else{
            self.device_table.setValue([], forKey: "sensors")
        }
        
        
        
        
        //curtains
        self.curtains = []
        act_id = 0
        Links3 = []
        
        if (self.device_table.valueForKey("curtains") != nil) {
            for value : AnyObject in self.device_table.valueForKey("curtains") as! NSArray {
                let DTcurtain = value as! NSDictionary
                
                if ((DTcurtain.valueForKey("flag") as! NSNumber!) != nil){
                    flag = DTcurtain.valueForKey("flag") as! NSNumber!
                    isShow = true
                    if(flag == 1){
                        isShow = false
                    }else{
                        isShow = true
                    }
                    
                }
                else{
                    isShow = true
                }
                if(isShow){
                
                let name :String  = DTcurtain.valueForKey("name") as! String
                let ieee :String  = DTcurtain.valueForKey("ieee") as! String
                
                let dev_id : Int  =  DTcurtain.valueForKey("dev_id") as! Int
                let room:Int = DTcurtain.valueForKey("room") as! Int
                let dev_type:NSNumber = DTcurtain.valueForKey("dev_type") as! NSNumber
                
                let roomName = self.rooms[room]
                
                act_id = (dev_id -  65) * 3 + 422
                if(value.valueForKey("action_ids") != nil ) {
                    acrArr = value.valueForKey("action_ids") as! NSArray
                    if(acrArr.count > 0){
                        act_id = acrArr[0] as! Int
                    }
                }
                
                /*
                switch dev_type {
                case 23 :
                    self.sensors23.append(["name":"\(roomName) \(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)"])
                default:
                    break
                }
                */
                
                
                self.curtains.append(["name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","roomName":"\(roomName)","name1":"\(name)","index":"0","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])      //  2015-05-18
                
                FAME.deviceCount++
                
                FAME.idForNames[act_id + 1]=["name":"\(name)打开","room":"\(roomName)","string":"\(roomName) \(name) 打开","act_id":"\(act_id  + 1 )"]
                FAME.idForNames[act_id + 2]=["name":"\(name)暂停","room":"\(roomName)","string":"\(roomName) \(name) 暂停","act_id":"\(act_id  + 2 )"]
                FAME.idForNames[act_id ]=["name":"\(name)停止","room":"\(roomName)","string":"\(roomName) \(name) 停止","act_id":"\(act_id)"]
                    
                self.editForDevice.append(["name":"\(roomName)\(name)","act_id":"\(act_id + 1)","type":"\(dev_type)","state":"0","ieee":"\(ieee)","index":"0","dev_id":"\(dev_id)"])
                
                //add to linkArray
                //  FAME.linkArray[2].append(["name":[name],"room":[roomName],"subName":[" "],"subId":["\(act_id )"]])
                
                //add to Links
                    self.idForNamesMode[act_id + 2] = "\(roomName)\(name) 暂停"
                self.idForNamesMode[act_id + 1] = "\(roomName)\(name) 停止"
                self.idForNamesMode[act_id] = "\(roomName)\(name) 打开"
                
                    //2
                Links3 = [["name":"","act_id":act_id,"type":1]]
                self.Links.append(["name":"\(roomName)\(name)","show":4,"curtains":1,"room":room,"sub":Links3])
                    
                    
                }
            }
        }else{
            self.device_table.setValue([], forKey: "curtains")
        }

        
        //appls
        self.appls = []
        self.airs = []
        //act_id = 0
        Links3 = []
        
        button_names = [:]
        
        
        
        
        
        if (self.device_table.valueForKey("appls") != nil) {
            for value : AnyObject in self.device_table.valueForKey("appls") as! NSArray {
                let DTappl = value as! NSDictionary
                
                if ((DTappl.valueForKey("flag") as! NSNumber!) != nil){
                    flag = DTappl.valueForKey("flag") as! NSNumber!
                    isShow = true
                    if(flag == 1){
                        isShow = false
                    }else{
                        isShow = true
                    }
                    
                }
                else{
                    isShow = true
                }
                if(isShow){
                
                let name :String  = DTappl.valueForKey("name") as! String
                let ieee :String  = DTappl.valueForKey("ieee") as! String
                let dev_id : Int  =  DTappl.valueForKey("dev_id") as! Int
                let dev_type : Int  =  DTappl.valueForKey("dev_type") as! Int
                let room:Int = DTappl.valueForKey("room") as! Int
                    
                var sub:Array<AnyObject>? = []
                sub = DTappl.valueForKey("button_name") as? Array
                
                let roomName = self.rooms[room]
                    
                var act_ids : Array<Int>= []
                
                //act_id = (dev_id -  35) * 26 + 189
                if(value.valueForKey("action_ids") != nil ) {
                    acrArr = value.valueForKey("action_ids") as! NSArray
                    if(acrArr.count > 0){
                        act_id = acrArr[0] as! Int
                    }
                    for i in 0..<acrArr.count{
                        let act_id1 = acrArr[i] as! Int
                        act_ids.append(act_id1)
                    }
                }
                /*
                switch dev_type {
                case 23 :
                self.sensors23.append(["name":"\(roomName) \(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","index":"0","state":"0","ieee":"\(ieee)"])
                default:
                break
                }
                */
                //19 空调  
                if (dev_type == 19 || dev_type == 45){
                    self.airs.append(["name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","roomName":"\(roomName)","name1":"\(name)","index":"0","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
                }else{
                    self.appls.append(["name":"\(roomName)\(name)","act_id":"\(act_id)","dev_id":"\(dev_id)","room":"\(room)","roomName":"\(roomName)","name1":"\(name)","index":"0","state":"0","ieee":"\(ieee)","dev_type":"\(dev_type)"])
                }
                
                
                
                // idfornames
                    
                //var btns_str = value.valueForKey("button_name") as! NSArray
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
                    self.idForNamesMode[act_id + inid * 2 + 1] = "\(roomName)\(name) \(btn_str)"
                    inid++
                    //
                }
                
                
                self.button_names![dev_id] = sub
                
                //self.button_names = nil
                
                FAME.deviceCount++
                
                //FAME.idForNames[act_id + 3]=["name":"\(name)关","room":"\(roomName)","string":"\(roomName)\(name) 关","act_id":"\(act_id + 3)"]
                
                //add to linkArray
                //  FAME.linkArray[2].append(["name":[name],"room":[roomName],"subName":[" "],"subId":["\(act_id )"]])
                
                //add to Links
                
                //self.idForNamesMode[act_id + 1] = "\(roomName) \(name) 开"
                //self.idForNamesMode[act_id] = "\(roomName) \(name) 关"
                
                Links3 = [["name":"","act_id":act_id,"type":1]]
                
                self.Links.append(["name":"\(roomName)\(name)","show":5,"dev_type":dev_type,"room":room,"sub":Links3])
                    
                //print(self.button_names.reta)
            }
                
            }
        }else{
            self.device_table.setValue([], forKey: "appls")
        }
        
        
        
        
        
        //println("self.idForNamesMode")
        //println(self.idForNamesMode)
        //println("...............\(FAME.deviceCount).......\(Int(FAME.deviceCount * 35 / 10) + 1)")
        //println(self.Links)
        
       // println("..........curtains....")
        //println(self.curtains)
        //println("..........applas......")
        //println(self.appls)

        
    }
    
    func isNotAdding() -> Bool{
        if FAME.isAddingDevice {
            let alert = UIAlertView()
            alert.title = Defined_device_title
            alert.message =  Defined_device_failed
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
            return false
        }else{
            return true
        }
    }
    func doAddSenDevice(arr:NSArray){
        if httpRequert().addDevieS(arr) {
            for i in 0..<arr.count{
                let name:String = arr[i]["name"] as! String
                let alert = UIAlertView()
                alert.title = Defined_Add_Title1
                alert.message =  "\(name) \(Defined_Add_Title_success)"
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            }
            
            FAME.getDeviceTable()
            FAME.addDeviceArray = []
            FAME.isAddingDevice = false
        }
        
        
        
        
        
    }
    func doAddDevice() -> Bool{
        
        if (FAME.isNotAdding()) {
            FAME.isAddingDevice = true
            //self.defaults.setObject(self.addDeviceArray, forKey: "addDeviceArray")

            
            
            if httpRequert().addDevie() {
                
                let time = FAME.addDeviceArray.count * 5
                
                
                self.timmer = NSTimer.scheduledTimerWithTimeInterval(40.0 + Double(time), target:self, selector:"timerFunction", userInfo:nil, repeats:false)

                FAME.isAddingDevice = true
                return true
            }
            else{
                FAME.isAddingDevice = false
                return false
            }
        }
        return false
    }
    func checkAddedDevice(){

        
        let received :NSDictionary? = httpRequert().checkAddedDevice()
        print(received)
        if  (received != nil){
            //check the list
            print("checkAddedDevice")
            print(received)
            var i = 0
            for values:AnyObject in received!.valueForKey("detail") as! NSArray {
                print(values)
                let AddedObj = values as! NSDictionary
                let ADDieee_addr :String!  = AddedObj.valueForKey("ieee_addr") as! String
                let ADDflag :NSNumber = AddedObj.valueForKey("flag") as! NSNumber
                //let Adddev_id:NSNumber = AddedObj.valueForKey("dev_id") as! NSNumber
                
                print("check:\(ADDieee_addr) addflag:\(ADDflag)")
                //var isA = false
                print("11111\(FAME.addDeviceArray[i])")
                //for value : AnyObject in FAME.addDeviceArray {
                    let value = FAME.addDeviceArray[i]
                    let Ahvaddr:String! = value.valueForKey("hvaddr") as! String
                    let Aname:String! = value.valueForKey("name") as! String
                    if (Ahvaddr != nil){
                        if Ahvaddr  == ADDieee_addr {
                            // right
                            if (ADDflag == 3) {
                                //successed
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    let alert = UIAlertView()
                                    alert.title = Defined_Add_Title1
                                    alert.message =  "\(Aname) \(Defined_Add_Title_success)"
                                    alert.addButtonWithTitle(Defined_ALERT_OK)
                                    alert.show()
                                    print("成功")
                                })
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                
                                
                            }else{
                                //failed
                                dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                    let alert = UIAlertView()
                                    alert.title = Defined_Add_Title1
                                    alert.message =  "\(Aname) \(Defined_Add_failed)"
                                    alert.addButtonWithTitle(Defined_ALERT_OK)
                                    alert.show()
                                    print("成功1")
                                })
                                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                                
                            }
                        }
                        else{
                            //failed
                            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                                FAME.showMessage("入网失败")
                                print("成功2")
                            })
                            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                            
                        }
                    }
                    else{
                        //failed
                        dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                            FAME.showMessage("入网失败")
                        })
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    }
                i++
                }
            //}
            
            //self.deCodeDeviceTable()
        }
        FAME.getDeviceTable()
        FAME.addDeviceArray = []
        FAME.isAddingDevice = false
        
    }
    func timerFunction(){
        print("CHECK!!!!!!!!!!!! \(FAME.checkAddDeviceTimes)")
        
        let thread = NSThread(target: self, selector: "checkAddedDevice", object: nil)
        thread.start()
        
    }
    
    func delDeviceByIeee(ieee_addr:String) -> Bool{
        print("deleteDev \(ieee_addr)")
        if (FAME.isNotAdding()){
            let dic:NSMutableDictionary = ["hvaddr":"\(ieee_addr)"]
            FAME.delDeviceArray.removeAllObjects()
            FAME.delDeviceArray.addObject(dic)
            FAME.doDeleteDev()
            return true
        }
        return false
    }
    
    func checkDelDevice(){
        //self.addDeviceArray = self.defaults.objectForKey("addDeviceArray") as NSMutableArray
        let received :NSDictionary! = httpRequert().checkDelDevice()
        //print(received)
        
        if  (received != nil){
            //check the list
            print("checkDelDevice")
            print(received)
            
            if received.valueForKey("error_code") as! NSObject! == 0 {
                    let alert = UIAlertView()
                    alert.title = Defined_unAdd_Title1
                    alert.message =  Defined_unAdd_Title_success
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()
                FAME.isAddingDevice = false
                FAME.getDeviceTable()
                
            }else{
                print("ROUTER BUSY")
                let alert = UIAlertView()
                alert.title = Defined_unAdd_Title1
                alert.message =  "\(Defined_unAdd_Title_failed2)"
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
            }
        }
        else{
            print("ROUTER BUSY")
            let alert = UIAlertView()
            alert.title = Defined_unAdd_Title1
            alert.message =  "\(Defined_unAdd_Title_failed2)"
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
        }
        
    }
    
    func refreshLightState() -> Bool{
        print("refresh llllllll")
        let paramArray = NSMutableArray()
        var lastId = "0"
//        switch FAME.tempSensorId {
//        case 1:
//            self.lights = lights7
//            
//        case 6:
//            self.lights = lights11
//  
//        default:
//            break
//        }
        
        print(lights)
        
        for value in lights {
            let AddedObj = value as NSDictionary
            let dev_id:NSString! = AddedObj["dev_id"] as! NSString
            if lastId != dev_id {
                paramArray.addObject(dev_id)
                lastId = dev_id as String
            }

        }
        
        let param = paramArray.componentsJoinedByString(",")
        
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: "{\"cmd\": 19, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\", \"param\": [\(param)]}",timeout : 90)
            if (received != nil){
            //got the state
            for values:AnyObject in received.valueForKey("states") as! NSArray {
                print(values)
                let AddedObj = values as! NSDictionary
                let ADDieee_addr :Int!  = AddedObj.valueForKey("id") as! Int
                var ADDflag :Int!  = AddedObj.valueForKey("state") as! Int
                var id = ADDieee_addr * 10
               
                if ADDflag >= 32 {
                    id = ADDieee_addr * 10 + 5
                    FAME.lightsCellState["\(id)"] = 1
                    ADDflag = ADDflag - 32
                }else{
                    id = ADDieee_addr * 10 + 5
                    FAME.lightsCellState["\(id)"] = 0
                }
                
                if ADDflag >= 16 {
                    id = ADDieee_addr * 10 + 4
                    FAME.lightsCellState["\(id)"] = 1
                    ADDflag = ADDflag - 16
                }else{
                    id = ADDieee_addr * 10 + 4
                    FAME.lightsCellState["\(id)"] = 0
                }
                
                
                if ADDflag >= 8 {
                    id = ADDieee_addr * 10 + 3
                    FAME.lightsCellState["\(id)"] = 1
                    ADDflag = ADDflag - 8
                }else{
                    id = ADDieee_addr * 10 + 3
                    FAME.lightsCellState["\(id)"] = 0
                }
                
                if ADDflag >= 4 {
                    id = ADDieee_addr * 10 + 2
                    FAME.lightsCellState["\(id)"] = 1
                    ADDflag = ADDflag - 4
                }else{
                    id = ADDieee_addr * 10 + 2
                    FAME.lightsCellState["\(id)"] = 0
                }
                
                if ADDflag >= 2 {
                    id = ADDieee_addr * 10 + 1
                    FAME.lightsCellState["\(id)"] = 1
                    ADDflag = ADDflag - 2
                }else{
                    id = ADDieee_addr * 10 + 1
                    FAME.lightsCellState["\(id)"] = 0
                }
                
                if ADDflag >= 1 {
                    id = ADDieee_addr * 10
                    FAME.lightsCellState["\(id)"] = 1
                }else{
                    id = ADDieee_addr * 10
                    FAME.lightsCellState["\(id)"] = 0
                }
                
                
            }
            return true
        }else{
            print("get the state failed")
            return false
        }
    }
    func loadingString(isLoad:Bool){
        
        let window :UIWindow! = UIApplication.sharedApplication().keyWindow;
        
        let showView :UIView! = UIView(frame: CGRect(x: window.frame.size.width*0.1, y: (window.frame.size.height-100) * 0.5 , width: window.frame.size.width*0.8, height: 100 ));
        showView.backgroundColor = UIColor.blackColor();
        
        showView.layer.cornerRadius = 5.0;
        showView.layer.masksToBounds = true ;
        window .addSubview(showView);
        
        let imgV = UIImageView(frame: CGRectMake((showView.frame.size.width - 50 )/2, 10, 50, 50))
        
        imgV.animationDuration = 2.0
        imgV.tag = 99
        showView .addSubview(imgV)
        
        var images = [UIImage]()
        
        for i in 0...11{
              let img = UIImage(named: "loading_login\(i + 1)")
              images.append(img!)
         }
         imgV.animationImages = images
         imgV.animationRepeatCount = 0
         imgV.startAnimating()
        
        
        let lable : UILabel! = UILabel(frame: CGRectMake((showView.frame.size.width - 100 )/2, 70, 100, 20))
        lable.text = "正在配置中，请稍后....";
        lable.font = UIFont.systemFontOfSize(15)
        lable.textColor = UIColor.whiteColor() ;
        lable.backgroundColor = UIColor.clearColor() ;
        lable.textAlignment = NSTextAlignment.Center ;
        showView .addSubview(lable) ;
        
        if isLoad{
            showView.alpha = 1.0;
        }
        else{
            showView.alpha = 0
            showView.removeFromSuperview()
        }
        
//        UIView.animateWithDuration(3, animations: { () -> Void in
//            showView.alpha = 0;
//            }) { (flase) -> Void in
//                showView.removeFromSuperview();
//        }
        
    }

    func showMessage(str:String){
        
        let window :UIWindow! = UIApplication.sharedApplication().keyWindow;
        
        let showView :UIView! = UIView(frame: CGRect(x: window.frame.size.width*0.1, y: (window.frame.size.height-30)-30 , width: window.frame.size.width*0.8, height: 30 ));
        showView.backgroundColor = UIColor.blackColor();
        showView.alpha = 1.0;
        showView.layer.cornerRadius = 5.0;
        showView.layer.masksToBounds = true ;
        window .addSubview(showView);
        
        let lable : UILabel! = UILabel(frame: CGRect(x: 0, y: 5 , width: showView.frame.size.width, height: 20 ));
        lable.text = str;
        lable.font = UIFont.systemFontOfSize(15)
        lable.textColor = UIColor.whiteColor() ;
        lable.backgroundColor = UIColor.clearColor() ;
        lable.textAlignment = NSTextAlignment.Center ;
        showView .addSubview(lable) ;
        


        UIView.animateWithDuration(3, animations: { () -> Void in
            showView.alpha = 0;
            }) { (flase) -> Void in
                showView.removeFromSuperview();
        }
        
    }
    
    
    func requestEventActionIds(dev_id : Int){
        var event_id : Int!
        var actids = [-1,-1,-1,-1,-1,-1]
        for i in 0..<6{
            
            if i < 3{
                event_id = (dev_id - 85) * 3 + 1 + i
            }
            else{
                event_id = (dev_id - 85) * 3 + 1 + i + 45
            }
            let cmdStr = "{\"cmd\": 34, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":{\"event_id\":\(event_id)}}"
                
            if let received = (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90)){
                    
                actids[i] = received.valueForKey("detail")?.valueForKey("action_id") as! Int
                self.boolCounts = self.boolCounts + 1
                    
            }
            event_id = 0

        }
        
        self.action_ids[dev_id] = actids
        
    }
    
    func changeToInt(num:String) -> Int {
        let str = num.uppercaseString
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    func WIFIsepStr(str:String) -> NSArray{
        let arr = NSMutableArray()
        
        let string1 = str.stringByReplacingOccurrencesOfString("ffffff", withString: "")
        print(string1)
        
        //温度
        let temperStr = (string1 as NSString).substringWithRange(NSMakeRange(8, 2))
        let temperInt = FAME.changeToInt(temperStr)
        let temperDou = Double(temperInt)/10
        print("temperInt====\(temperStr)")
        print("temperInt====\(temperDou)")
        
        arr.addObject(String(temperDou))
        
        //开关
        let switchStr : String = (string1 as NSString).substringWithRange(NSMakeRange(13, 1)) as String
        print("switchStr====\(switchStr)")
        arr.addObject(String(switchStr))
        
        //风速
        let windStr:String = (string1 as NSString).substringWithRange(NSMakeRange(17, 1)) as String
        print("windStr====\(windStr)")
        arr.addObject(String(windStr))
        
        //模式
        let coldStr:String = (string1 as NSString).substringWithRange(NSMakeRange(19, 1)) as String
        print("coldStr====\(coldStr)")
        
        arr.addObject(String(coldStr))
        
        return arr
    }
    func getAirRecord(sdate : String,edate : String,ieee:String) -> NSArray?{
        let arr = NSMutableArray()
        
        let cmdStr = "{\"cmd\":62, \"did\": \(FAME.user_did),\"user_name\": \"\(FAME.user_name)\",\"user_pwd\": \"\(FAME.user_pwd)\",\"sdate\":\"\(sdate)\",\"edate\":\"\(edate)\",\"ieee_addr\":\"\(ieee)\"}"
        
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr)
        if received != nil{
            
        }
        return arr
    }
    func getMonthRecord(sdate : String,edate : String) -> NSArray?{
        let arr = NSMutableArray()
        
        let cmdStr = "{\"cmd\":49, \"did\": \(FAME.user_did),\"user_name\": \"\(FAME.user_name)\",\"user_pwd\": \"\(FAME.user_pwd)\",\"sdate\":\"\(sdate)\",\"edate\":\"\(edate)\"}"
        
        let received = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr)
        if received != nil{
            print("SEND REQUEST SUCCESSED")
            
            if received.valueForKey("result") as! NSNumber == 0{
                
                let array : NSArray = received.valueForKey("alarm_detail") as! NSArray
                
                if array.count == 0{
                    return nil
                }
                else{
                    
                    for j in 0..<array.count{
                        
                        let alarm_info = array[j]["message"] as? String
                        if (alarm_info != nil){
                            let str : String = alarm_info!
                            
                            let id = array[j]["id"] as! Int
                            
                            let dic :Dictionary = ["id":String(id),"info":str]
                            
                            arr.addObject(dic)
                        }
                        
                    }
                    if arr.count > 0{
                        return arr
                    }
                    else{
                        return nil
                    }
                }
                
            }
        }else{
            print("SEND REQUEST FAILED!")
            
            
        }
        return nil
        
    }
    
    func getMonthDate(day : Int) -> String!{
        
        let nowDate = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.stringFromDate(nowDate)
        
        let dfmatter = NSDateFormatter()
        dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss"
        let date = dfmatter.dateFromString(dateString)
        let dateStamp:NSTimeInterval = date!.timeIntervalSince1970
        
        let dateSt:Int = Int(dateStamp)
        let dateSt1 = dateSt - 24 * 60 * 60 * day
        print("data =\(dateSt1)")
        
        let string = NSString(string: String(dateSt1))
        
        let timeSta:NSTimeInterval = string.doubleValue
        let dfmatter1 = NSDateFormatter()
        dfmatter1.dateFormat="yyyy-MM-dd"
        
        let date1 = NSDate(timeIntervalSince1970: timeSta)
        
        print(dfmatter.stringFromDate(date1))
        return dfmatter.stringFromDate(date1)
        
    }
    func getNowDate(type:Int) -> String!{
        
        let nowDate = NSDate()
        let formatter = NSDateFormatter()
        if type == 1{
            formatter.dateFormat = "yyyy/MM/dd"
        }
        else{
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        let dateString = formatter.stringFromDate(nowDate)
        
        return dateString
        
    }

    
    
    func deviceImage(type:Int,state:Int) -> String{
        var btnImage : String
        
        if state == 0{
            switch type{
            case 7,8,9:
                btnImage = "sa1.png"
                break
            case 10:
                btnImage = "sa2.png"
                break
            case 19:
                btnImage = "sa3.png"
                break
            case 16,17,18:
                btnImage = "sa4.png"
                break
            case 13:
                btnImage = "sa5.png"
                break
            case 11,12:
                btnImage = "sa6.png"
                break
            case 31:
                btnImage = "sa7.png"
                break
            case 33:
                btnImage = "sa9.png"
                break
            case 23:
                btnImage = "ss2.png"
                break
            case 24:
                btnImage = "ss3.png"
                break
            case 26:
                btnImage = "ss4.png"
                break
            case 25:
                btnImage = "ss5.png"
                break
            case 28:
                btnImage = "ss6.png"
                break
            case 30:
                btnImage = "ss7.png"
                break
            case 32:
                btnImage = "ss8.png"
                break
            case 48:
                btnImage = "ss9.png"
                break
            case 49:
                btnImage = "ss10.png"
                break
            default:
                btnImage = "sa1.png"
                
            }

        }
        else{
            switch type{
            case 7,8,9:
                btnImage = "sa1_1.png"
                break
            default:
                btnImage = "sa1_1.png"
                
            }
        }
        return btnImage
    }


}
import Foundation
import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        let isReachable = flags.contains(.Reachable)
        let needsConnection = flags.contains(.ConnectionRequired)
        
        return isReachable && !needsConnection
    }
    
}










