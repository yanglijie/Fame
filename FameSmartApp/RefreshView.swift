//
//  RefreshView.swift
//  Refresh
//
//  Created by famesmart on 16/7/7.
//  Copyright © 2016年 famesmart. All rights reserved.
//

import UIKit

class RefreshView: UIViewController {
    
    var activityIndicator:UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 20 , width: 30, height: 30 ));
        //let window :UIWindow! = UIApplication.sharedApplication().keyWindow;
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle:
            UIActivityIndicatorViewStyle.White)
        
        activityIndicator.frame = CGRect(x: 0, y: 12 , width: 30, height: 30 )
        self.view.addSubview(activityIndicator);
        let lable : UILabel! = UILabel(frame: CGRect(x: 32, y: 6 , width: 80, height: 20 ));
        lable.text = "正在联网操作中..."
        lable.font = UIFont.systemFontOfSize(10)
        lable.textColor = UIColor.whiteColor()
        activityIndicator.addSubview(lable)
        //window.bringSubviewToFront(activityIndicator)
        
    }
    
    func play(){
        //进度条开始转动
        activityIndicator.startAnimating()
    }
    
    func stop(){
        //进度条停止转动
        activityIndicator.stopAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
