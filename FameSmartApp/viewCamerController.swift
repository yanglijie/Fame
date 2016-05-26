
//
//  viewCamerController.swift
//  FameSmartApp
//
//  Created by book on 15-1-14.
//  Copyright (c) 2015 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

import UIKit


class ViewCamerController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func btnBuy(sender: AnyObject) {
        
        UIApplication.sharedApplication().openURL(NSURL(string: "http://famesmart.com/")!)
    }
}