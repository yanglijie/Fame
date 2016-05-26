//
//  viewAnimate.swift
//  FameSmartApp
//
//  Created by Eric on 14-12-1.
//  Copyright (c) 2014年 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//


//*********************
//
//      class for animation
//
//*********************

import UIKit
import AVFoundation



class viewAnimate:NSObject{
    
    func showView(view:UIView){
        UIView.animateWithDuration(0.5, animations: {
            view.alpha = 1
        })
    }
    func hideView(view:UIView){
        view.alpha = 1
        UIView.animateWithDuration(0.5, animations: {
            view.alpha = 0
        })
    }
    
    func showTip(view: UILabel, content: String! ,color:UIColor! = nil){
        view.text = content
        view.alpha = 1
        let orgColer = view.textColor
        if (color != nil) {
            view.textColor = color
        }
        UIView.animateWithDuration(0.5, delay: 3, options: [], animations: {
            view.alpha = 0
            }, completion: {
                (finished:Bool) -> Void in
                view.textColor = orgColer
        })
        
    }
    
    func popOut(view:UIView, timeInterval: NSTimeInterval = 0.3 , delay : NSTimeInterval = 0){
        let orgFrame = view.frame
        let Frame2 = CGRect(x: orgFrame.origin.x - orgFrame.width * 0.05 , y: orgFrame.origin.y - orgFrame.height * 0.05, width: orgFrame.width * 1.1 , height: orgFrame.height * 1.1 )
        view.frame = CGRect(x: orgFrame.origin.x + orgFrame.width / 2 -  1 , y: orgFrame.origin.y + orgFrame.height / 2 - 1, width: 2, height: 2)
        view.alpha = 0
        UIView.animateWithDuration(timeInterval, delay: delay, options: [], animations: {
            view.frame = Frame2
            view.alpha = 1
            }, completion: {
                (finished:Bool) -> Void in
                UIView.animateWithDuration(timeInterval, delay: delay / 5, options: [], animations: {
                    view.frame = orgFrame
                    }, completion: {
                        (finished:Bool) -> Void in
                        
                })
        })
        
    }
    
    func shrkInput(view:UITextField , notChangeColoer: Bool = true){
        view.textColor = UIColor.redColor()
        self.shark(view, dis: 3, num: 10, complete: {
            if notChangeColoer {
                view.textColor = UIColor.whiteColor()
            }
        })
    }
    
    func shark(view:UIView , dis : Float = 3 ,num : UInt = 10 , complete :( () -> Void)! = nil){
        self.sharKc(view, orX: Float(view.frame.origin.x), dis: dis, num: num, complete: complete)
    }
    
    func sharKc(view: UIView , orX : Float, dis : Float , num : UInt , complete : () -> Void!){
        UIView.animateWithDuration(0.05, delay: 0, options: [], animations: {
            let FNum = Float(num)
            if num % 2 == 0 {
                view.frame.origin.x = CGFloat(orX + FNum / 4  * dis)
            }else{
                view.frame.origin.x = CGFloat(orX - FNum / 4  * dis)
            }
            }, completion:{
                (finished:Bool) -> Void in
                if num > 0 {
                    let numNext = num - 1
                    self.sharKc(view, orX: orX, dis: dis, num: numNext ,complete: complete)
                }else{
                    
                    complete()
                    
                }
            }
        )
    }
}

