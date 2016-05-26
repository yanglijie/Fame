//
// 
//  FameSmartApp
//
//  Created by book on 14-9-11.
//  Copyright (c) 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

import UIKit

class viewPickerController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    @IBOutlet weak var Date: UIDatePicker!
    var selectRoom:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        
        //roomSheet.title = " "
        //roomSheet.delegate = self
        let btn = UIButton(frame: CGRect(x: self.view.frame.width - 60, y: 20, width: 40, height: 20))
        btn.setTitle(Defined_ALERT_OK, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.tag = 1
        //btn.addTarget(self, action: Selector("selectedRoomBtn:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        let picker = UIPickerView(frame: CGRect(x: 20, y: -10, width: self.view.frame.width - 40 , height: 160))
        
        picker.dataSource = self
        picker.delegate = self
        
        self.view.addSubview(picker)
        self.view.addSubview(btn)
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        print("pickerView selected:\(row)")

    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        //var objRooms :NSArray = FAME.device_table.valueForKey("rooms") as NSArray
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return "123"
        
    }
    
    
}