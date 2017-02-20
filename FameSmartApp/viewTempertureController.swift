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
import CoreLocation
class ViewTempController: UIViewController,CLLocationManagerDelegate {
    
    
    @IBOutlet var outterTemper : UILabel!
    @IBOutlet var innerTemper : UILabel!
    
    
    
    var currLocation : CLLocation! //这个是保存定位信息的  别乱想哈
    
    let locationManager : CLLocationManager = CLLocationManager()//这个也算是猪脚
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.outterTemper.text = FAME.outterTemp
        

//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest //定位精确度（最高）一般有电源接入，比较耗电
//        //kCLLocationAccuracyNearestTenMeters;//精确到10米
//        locationManager.distanceFilter = 50 //设备移动后获得定位的最小距离（适合用来采集运动的定位）
//        locationManager.requestWhenInUseAuthorization()//弹出用户授权对话框，使用程序期间授权（ios8后)
//        //requestAlwaysAuthorization;//始终授权
//        locationManager.startUpdatingLocation()
//        print("开始定位》》》")
        
        locationManager.requestAlwaysAuthorization()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.distanceFilter = kCLLocationAccuracyKilometer
        
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()//开始定位  在定位完成后 会调用协议方法  这个就不用多说了
        
        
        
//        let myThread2 = NSThread(target: self, selector: "timerFunction", object: nil)
//        myThread2.start()
        
        
        
    }
    
    func LonLatToCity() {
        
        let geocoder: CLGeocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(currLocation) { (placemark, error) -> Void in
            
            
            
            if(error == nil)//成功
                
            {
                
                let array = placemark! as NSArray
                
                let mark = array.firstObject as! CLPlacemark
                
                //这个是城市
                
                let city: String = (mark.addressDictionary! as NSDictionary).valueForKey("City") as! String
                
                //这个是国家
                
                let country: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("Country") as! NSString
                
                //这个是国家的编码
                
                let CountryCode: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("CountryCode") as! NSString
                
                //这是街道位置
                
                let FormattedAddressLines: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("FormattedAddressLines")?.firstObject as! NSString
                
                //这是具体位置
                
                let Name: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("Name") as! NSString
                
                //这是省
                
                var State: String = (mark.addressDictionary! as NSDictionary).valueForKey("State") as! String
                
                //这是区
                
                let SubLocality: NSString = (mark.addressDictionary! as NSDictionary).valueForKey("SubLocality") as! NSString
                
                //我在这里去掉了“省”和“市” 项目需求 可以忽略
                
                State = State.stringByReplacingOccurrencesOfString("省", withString: "")
                
                let citynameStr = city.stringByReplacingOccurrencesOfString("市", withString: "")
                
//                self.provinces  = State
//                
//                self.city = citynameStr
                
                print( State)
                
                print( citynameStr)
                print(SubLocality)
                print(Name)
                print(CountryCode)
                print(city)
                
            }
                
            else
                
            {
                
                print(error)
                
            }
            
        }
        
    }
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {//定位成功
        
        
        
        currLocation = locations.last //取出经纬度
        
        print(currLocation.coordinate.longitude)
        
        print(currLocation.coordinate.latitude)
        
        LonLatToCity()//去调用转换
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {//定位失败
        
        print(error)
        
        print("哇靠！！定位怎么失败了呢")
        
        
        
    }
    
    

    func Timerset(){
        let str = httpRequert().downloadStringFromGetUrlSync("http://www.famesmart.com/ios/weather.php")
        
        if ( str != nil){
            print("weather: \(str)")
            dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                FAME.outterTemp = str
                self.outterTemper.text = FAME.outterTemp
            })
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
                    
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        FAME.innerTemp = "\(temp_value)"
                        self.innerTemper.text = FAME.innerTemp
                    })
                }
            }
            }
            
        }else{
            print("SEND REQUEST FAILED!")
            
        }
        
        
    }
    override func viewWillDisappear(animated: Bool){
        super.viewWillDisappear(animated)
        

    }
}