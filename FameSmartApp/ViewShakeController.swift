//
//  ViewShakeController.swift
//  FameSmartApp
//
//  Created by famesmart on 16/8/8.
//  Copyright © 2016年 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

import UIKit
import AVFoundation

protocol ViewShakeControllerDelegate{
    func shakeAction()
}
class ViewShakeController: UIViewController , AVAudioPlayerDelegate {
    
    
    
    var rockup = UIView()
    var rockdown = UIView()
    
    var player: AVAudioPlayer?
    
    var delegate :ViewShakeControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        rockup = self.view.viewWithTag(11)! as UIView
        rockdown = self.view.viewWithTag(12)! as UIView
        
        /**
        开启摇动感应
        */
        UIApplication.sharedApplication().applicationSupportsShakeToEdit = true
        becomeFirstResponder()
        
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    /**
     开始摇动
     */
    override func motionBegan(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        print("开始摇动")
        
        //开始动画
        UIView.animateKeyframesWithDuration(0.5, delay: 0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            self.rockup.frame.origin.y -= 80
            self.rockdown.frame.origin.y += 80
            
            }, completion: nil)
        /// 设置音效
        let path1 = NSBundle.mainBundle().pathForResource("rock", ofType:"mp3")
        let data1 = NSData(contentsOfFile: path1!)
        self.player = try? AVAudioPlayer(data: data1!)
        self.player?.delegate = self
        self.player?.updateMeters()//更新数据
        self.player?.prepareToPlay()//准备数据
        self.player?.play()
        
        //结束动画
        UIView.animateKeyframesWithDuration(0.5, delay: 1.0, options: UIViewKeyframeAnimationOptions.BeginFromCurrentState, animations: { () -> Void in
            
            self.rockup.frame.origin.y += 80
            self.rockdown.frame.origin.y -= 80
            
            }, completion: nil)
        
    }
    
    /**
     取消摇动
     */
    override func motionCancelled(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        print("取消摇动")
        
        let alert = UIAlertView()
        alert.title = "通知"
        alert.message = "摇的不够大力"
        alert.addButtonWithTitle(Defined_ALERT_OK)
        alert.show()
        
        
    }
    
    
    /**
     摇动结束
     
     */
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        
        print("摇动结束")
        ///此处设置摇一摇需要实现的功能
        
        
        /// 设置音效
        let path = NSBundle.mainBundle().pathForResource("rock_end", ofType:"mp3")
        let data = NSData(contentsOfFile: path!)
        self.player = try? AVAudioPlayer(data: data!)
        self.player?.delegate = self
        self.player?.updateMeters()//更新数据
        self.player?.prepareToPlay()//准备数据
        self.player?.play()
        
        self.delegate?.shakeAction()
        
        self.navigationController?.popViewControllerAnimated(true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
