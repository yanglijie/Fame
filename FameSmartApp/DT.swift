//
//  DT.swift
//  FameSmartApp
//
//  Created by book on 15-1-14.
//  Copyright (c) 2015年 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//
//*********************
//
//      DEVICE_TABLE
//
//*********************
import Foundation


// create the device_tabel from the detail.txt 

class dt:NSObject {
    
    func initFromFile(){
        //create it from the detail.txt
        let jsonPath = NSBundle.mainBundle().bundlePath
        let jsonData = NSData(contentsOfFile: "\(jsonPath)/detail.txt")
        var json :Array<Dictionary<String,AnyObject>>!
        
        
        
        var idsDic:Dictionary<Int,Int> = [:]
        
        do{
            json = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.MutableContainers) as! Array<Dictionary<String,AnyObject>>
            
            print(json)
            FAME.detail = json
            for obj in json {
                let dev_id:Int! = obj["dev_id"] as! Int!
                var index:Int! = obj["index"] as! Int!
                let slot:Int! = obj["slot"] as! Int!
//                var cmd:Int! = 0
//                let operatin :String! = obj["operation"] as! String!
                
                if slot != nil {
                    index = slot
                }
                
                if (dev_id != nil)&&(index != nil) {
                    idsDic[dev_id * 100 + index] = obj["action_id"] as! Int!
                }
            }
            
            
        }catch{
            print("failed to create the device_tabel from file")
        }
        print(idsDic)
    }
    
}