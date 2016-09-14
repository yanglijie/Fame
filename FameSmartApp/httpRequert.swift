//
//  httpRequert.swift
//  FameSmartApp
//
//  Created by Eric on 14-12-1.
//  Copyright 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//


//*********************
//
//      funcs of sendRequest 
//
//*********************


import UIKit
import AVFoundation



class httpRequert : NSObject{
    
    func downloadStringFromGetUrlSync(url:String) -> String! {
        let url = NSURL(string: url)
        let request = NSMutableURLRequest(URL: url!)
        request.timeoutInterval = 5
        request.HTTPMethod = "GET"
        let received:NSData! = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        if(received != nil) {
            let reStr:NSString! = NSString(data: received, encoding: NSUTF8StringEncoding)
            if reStr != nil {
                return reStr  as String
            }
        }
        return nil
    }
    
    
    func downloadFromPostUrlSync(url:String,cmd:String, cmplx:Bool=false ,timeout :NSTimeInterval = 8 ) -> NSDictionary!{
        //var nilDic:Dictionary = ["result":9]
        print("CMD TO POST\n \(cmd)")
        let nsUrl=NSURL(string: url)
        let request = NSMutableURLRequest(URL: nsUrl!)
        //request.encodeWithCoder(<#T##aCoder: NSCoder##NSCoder#>)
        request.timeoutInterval = timeout
        request.HTTPMethod = "POST"
        
        let bodyString = cmd as NSString
        request.HTTPBody=bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
 
            do{
                let received = try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)

                let str = NSString(data: received, encoding: NSUTF8StringEncoding)
                print("DATA RECEIVED\n \(str)")
                
                let resObj:NSDictionary! = try NSJSONSerialization.JSONObjectWithData(received, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                
                if !(resObj != nil){
                    return nil
                }
                
                if !(resObj["result"] != nil) {
                    return nil
                }
                
                if cmplx {
                    return resObj
                }
                else{
                    if resObj["result"] as! NSObject == 0 {
                        return resObj
                    }else{
                        return nil
                    }
                }

            }catch(let e){
                print(e)
                return nil
            }
    }
    
    
    func downloadFromPostUrlSync(url:String,dic:NSDictionary, cmplx:Bool=false ) -> NSDictionary!{
        //var nilDic:Dictionary = ["result":9]
        
        let nsUrl=NSURL(string: url)
        let request = NSMutableURLRequest(URL: nsUrl!)
        request.timeoutInterval = 8
        request.HTTPMethod = "POST"
        let param=NSMutableArray()
        for key:AnyObject in dic.allKeys{
            let s=NSString(format:"\(key as! NSString)=\(dic[key as! NSString])")
            param.addObject(s)
        }
        let bodyString=param.componentsJoinedByString("&") as NSString
        request.HTTPBody=bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let received:NSData! = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        
        if (received != nil) {
            let str = NSString(data: received, encoding: NSUTF8StringEncoding)
            print("DATA RECEIVED\n \(str)")
            do{
            let resObj:NSDictionary! = try NSJSONSerialization.JSONObjectWithData(received, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                if !(resObj != nil){
                    return nil
                }
                
                if !(resObj["result"] != nil) {
                    return nil
                }
                
                if cmplx {
                    return resObj
                }else{
                    if resObj["result"] as! NSObject == 0 {
                        return resObj
                    }else{
                        return nil
                    }
                }
            }catch{
                return nil
            }
            
        }else{
            return nil
        }
    }
    
    func ChatFromPostUrlSync(url:String,dic:NSDictionary) -> String!{
        let nsUrl=NSURL(string: url)
        let request = NSMutableURLRequest(URL: nsUrl!)
        request.timeoutInterval = 8
        request.HTTPMethod = "POST"
        let param=NSMutableArray()
        for key:AnyObject in dic.allKeys{
            let s=NSString(format:"\(key as! NSString)=\(dic[key as! NSString])")
            param.addObject(s)
        }
        let bodyString=param.componentsJoinedByString("&") as NSString
        request.HTTPBody=bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let received:NSData! = try? NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
        
        if (received != nil) {
            let str = NSString(data: received, encoding: NSUTF8StringEncoding)
            print("DATA RECEIVED\n \(str)")
            return str as! String
        }else{
            return nil
        }
    }
    func sendRequestSub(){
        let cmd = FAME.tempCmd
        print("send request:\(cmd)")
        let cmdStr = "{\"cmd\": 18, \"user_name\": \"\(FAME.user_name)\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did), \"param\": \(cmd)}"
        if (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr) != nil){
            print("SEND REQUEST SUCCESSED")
        }else{
            print("SEND REQUEST FAILED!")
            
        }
        
        
    }
    
    func sendRequest(cmd:NSNumber){
        FAME.tempCmd = cmd
        let myThread = NSThread(target: self, selector: "sendRequestSub", object: nil)
        myThread.start()
    }
    
    func sendTokenSub(){
        let cmd = FAME.devicetoken
        let userName = FAME.getProfile(0)
        let userPass = FAME.getProfile(1)
        FAME.user_name = userName
        FAME.user_pwd = userPass
        
        //    \(FAME.user_did)
        print("send request:\(cmd)")
        let cmdStr = "{\"cmd\": 40, \"user_name\": \"\(FAME.user_name)\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"push_enable\": 1, \"devicetoken\": \"\(cmd)\"}"
        if (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr) != nil){
            print("SEND devicetoken SUCCESSED")
            
        }else{
            print("SEND devicetoken FAILED!")
            
        }
        
        
    }
    
    func sendToken(cmd:String){
        FAME.devicetoken = cmd
        let myThread = NSThread(target: self, selector: "sendTokenSub", object: nil)
        myThread.start()
    }
    
    
    func getTheIdByTypeName(type:String) -> NSNumber!{
        var isOk = true
        var minId = 1
        var maxId = 25
        var id = 0
        switch type{
        case "lights" :
            minId = 1
            maxId = 22
        case "6lights" :
            minId = 23
            maxId = 25
            
        case "appls" :
            minId = 35
            maxId = 44
        case "sensors" :
            minId = 85
            maxId = 100
        case "curtains" :
            minId = 65
            maxId = 74
        default:
            break
            
        }
        
        var sType = type
        if sType == "6lights" {
            sType = "lights"
        }
        
        for i in minId...maxId {
            isOk = true
            //devaice_table
            
            for value : AnyObject in FAME.device_table.valueForKey(sType) as! NSArray {
                let DTValue = value as! NSDictionary
                let dev_id : NSNumber  =  DTValue.valueForKey("dev_id") as! NSNumber
                if dev_id == i {
                    isOk = false
                }
            }
            
            //addDeviceArray
            for value : AnyObject in FAME.addDeviceArray {
                let dev_id:NSNumber! = value.valueForKey("dev_id") as! NSNumber!
                if (dev_id != nil){
                    if dev_id == i{
                        isOk = false
                    }
                }
            }
            
            if isOk {
                id = i
                break
                
            }
            
        }
        
        if isOk {
            return id
        }else{
            return nil
        }
        
    }
    
    //getTheValiableDevID
    func getTheIdByType(ieee_addr: String, type:NSNumber) -> NSNumber!{
        
        switch type{
            //lights
        case 7,8,9,12,13:
            return self.getTheIdByTypeName("lights")
        case 11:
            return self.getTheIdByTypeName("6lights")
        case 15,10:
            return self.getTheIdByTypeName("curtains")
        case 18:
            return 35
        case 23,24,25,26,27,28:
            return self.getTheIdByTypeName("sensors")
        default:
            return nil
        }
    }
    
    //addDevice
    func addDevie() -> Bool{
        //get the ids
        
        
        let paramArray1 = NSMutableArray()
        for value : AnyObject in FAME.addDeviceArray {
            //let AmodelId:NSNumber! = value.valueForKey("modelId") as! NSNumber
            let Aname:String! = value.valueForKey("name") as! String
            let AroomId:NSNumber! = value.valueForKey("roomId") as! NSNumber
            let hvaddr:String = value.valueForKey("hvaddr") as! String
            
            let str = "{\"ieee_addr\":\"\(hvaddr)\",\"name\":\"\(Aname)\",\"room\":\(AroomId)}"
            paramArray1.addObject(str)
        }
        
        let devices = paramArray1.componentsJoinedByString(",")
        
        let cmdStr = "{\"cmd\": 45, \"user_name\": \"\(FAME.user_name)\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"devices\":[\(devices)]}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr){
            //get the ids SUCCESSED
            print("get the ids SUCCESSED")
            //for values:AnyObject in recevied.valueForKey("dev_detail") as NSArray {
            let paramArray2 = NSMutableArray()
            
           for value:AnyObject in recevied.valueForKey("dev_detail") as! NSArray {
                let ieee_addr:String! = value.valueForKey("ieee_addr") as! String
                let dev_id:NSNumber! = value.valueForKey("dev_id") as! NSNumber
                if dev_id == -1{
                    let alert = UIAlertView()
                    alert.title = Defined_Add_Title1
                    alert.message =  Defined_Add_Title_failed5
                    alert.addButtonWithTitle(Defined_ALERT_OK)
                    alert.show()
                    return false
                }
                let str = "{\"ieee_addr\":\"\(ieee_addr)\",\"dev_id\":\(dev_id)}"
                paramArray2.addObject(str)
            }
            
            
            let param = paramArray2.componentsJoinedByString(",")
            let cmdStr2 = "{\"cmd\": 28, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"param\":[\(param)]}"
            
            if (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr2) != nil){
                print("add device successed")
                return true
            }else{
                print("add device failed")
                let alert = UIAlertView()
                alert.title = Defined_Add_Title1
                alert.message =  Defined_Add_Title_failed3
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
                
                return false
            }
        }else{
            print("get the ids FAILED")
            let alert = UIAlertView()
            alert.title = Defined_Add_Title1
            alert.message =  "get the ids FAILED"
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
            
            return false
        }
        //post to server
        
    }
    
    
    //delDevice
    func delDevie() -> Bool{
        
        //create the post string
        
        
        let paramArray=NSMutableArray()
        for value : AnyObject in FAME.delDeviceArray {
            let hvaddr:String = value.valueForKey("hvaddr") as! String
            let str = "{\"ieee_addr\":\"\(hvaddr)\"}"
            paramArray.addObject(str)
        }
        
        let param = paramArray.componentsJoinedByString(",")
        
        let cmdStr = "{\"cmd\": 30, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \"\(FAME.user_did)\",\"param\":[\(param)]}"
        
        
        if (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr) != nil){
            
            print("del device successed")
            return true
        }else{
            FAME.showMessage("中控忙，设备删除失败")
            print("del device failed")
            return false
        }
        
        //post to server
        
    }
    
    
    
    
    func deleteDev( IEEE:String ) {
        if FAME.isAddingDevice {
            let alert = UIAlertView()
            alert.title = Defined_device_title
            alert.message =  Defined_device_failed
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
        }else{
            
            let alert = UIAlertView()
            alert.title = Defined_unAdd_Title1
            alert.message =  Defined_device_begin
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
            
            FAME.isAddingDevice = true
            FAME.tempIEEE = IEEE
            let myThread = NSThread(target: self, selector: "PrivateDeleteDev", object: nil)
            myThread.start()
        }
        
    }
    func PrivateDeleteDev() {
        FAME.isAddingDevice = true
        let cmdStr = "{\"cmd\": 30, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd )\", \"did\": \(FAME.user_did),\"param\":[{\"ieee_addr\":\"\(FAME.tempIEEE)\"}]}"
        if (httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr) != nil){
            print("delete device successed!!!!!!")
            FAME.isAddingDevice = false
            
            let alert = UIAlertView()
            alert.title = Defined_unAdd_Title1
            alert.message =  Defined_unAdd_Title_success
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
            
            
        }else{
            print("delete device failed!!!!!!!!")
            FAME.isAddingDevice = false
            let alert = UIAlertView()
            alert.title = Defined_unAdd_Title1
            alert.message =  Defined_unAdd_Title_failed
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
        }
        
    }
    
    func checkDelDevice() -> NSDictionary!{
        let cmdStr = "{\"cmd\": 35, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd )\", \"did\": \(FAME.user_did)}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr){
            
            print("ckeck added device successed")
            return recevied
        }else{
            print("ckeck added device failed")
            return nil
        }
    }
    
    func checkAddedDevice() -> NSDictionary!{
        
        
        let cmdStr = "{\"cmd\": 29, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd )\", \"did\": \(FAME.user_did)}"
        if let recevied = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr){
            if recevied["error_code"] as! NSObject == 0
            {
                print("ckeck added device successed")
                return recevied
            }
            else{
                let alert :UIAlertView = UIAlertView()
                
                alert.title = "入网失败"
                alert.message = "中控正在忙，请稍后再试"
                alert.addButtonWithTitle(Defined_ALERT_OK)
                alert.show()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                return nil
            }
            
        }else{
            //println("ckeck added device failed")
            let alert :UIAlertView = UIAlertView()
            
            alert.title = "入网失败"
            alert.message = "中控正在忙，请稍后再试"
            alert.addButtonWithTitle(Defined_ALERT_OK)
            alert.show()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            return nil
        }
    }
}

