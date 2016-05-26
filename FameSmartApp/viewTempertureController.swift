//
//  viewTempertureController.swift
//  FameSmartApp
//
//  Created by book on 14-9-11.
//  Copyright (c) 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//


//*********************
//
//     viewControllers of getting the temperture
//
//*********************



import UIKit
import AVFoundation

class ViewTempController: UIViewController {
    
    var timmer:NSTimer!
    
    @IBOutlet var outterTemper : UILabel!
    @IBOutlet var innerTemper : UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.outterTemper.text = FAME.outterTemp
        
        self.timmer = NSTimer.scheduledTimerWithTimeInterval(10.0, target:self, selector:"timerFunction", userInfo:nil, repeats:true)
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
        let myThread2 = NSThread(target: self, selector: "timerFunction", object: nil)
        myThread2.start()
    }

    func Timerset(){
        let str = httpRequert().downloadStringFromGetUrlSync("http://www.famesmart.com/ios/weather.php")
        
        if ( str != nil){
            print("weather: \(str)")
            FAME.outterTemp = str
            self.outterTemper.text = FAME.outterTemp
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func timerFunction(){
        print("get the temp")
        
        print(FAME.user_ieee_addr)
        //inner
        let cmdStr = "{\"cmd\": 27, \"ieee_addr\": \"\(FAME.user_ieee_addr)\"}"
        
        if let received:NSDictionary! = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:8 ){
            print("SEND REQUEST SUCCESSED")
            
            if (received?.valueForKey("temp_detail") != nil) {
            for values:AnyObject in received.valueForKey("temp_detail") as! NSArray{
                if let temp_value:AnyObject! = values.valueForKey("temp_value"){
                    FAME.innerTemp = "\(temp_value)"
                    self.innerTemper.text = FAME.innerTemp
                }
            }
            }
            
        }else{
            print("SEND REQUEST FAILED!")
            
        }
        
        
    }
    override func viewWillDisappear(animated: Bool){
        super.viewWillDisappear(animated)
        self.timmer.invalidate()
        self.timmer = nil

    }
}