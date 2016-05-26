//
//  ViewRootController.swift
//  FameSmartApp
//
//  Created by Eric on 14-8-5.
//  Copyright (c) 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//




//*********************
//
//      ViewController of the main view 
//
//*********************

import UIKit

class ViewControllerMain: UIViewController ,UIAlertViewDelegate {
    
    var showAnimate :Bool = true

    var isFameWork = false
    @IBOutlet var btnP : UIButton!
    @IBOutlet var btnVM : UIButton!
    @IBOutlet var btnSA : UIButton!
    @IBOutlet var btnSU : UIButton!
    @IBOutlet var btnSS : UIButton!
    @IBOutlet var btnUM : UIButton!
    @IBOutlet var btnAU : UIButton!
    @IBOutlet var btnHU : UIButton!
    
    @IBOutlet var speechButton : UIButton!
    @IBOutlet var viewSpeech : UIView!
    @IBOutlet var userImg : UIImageView!
    
    @IBOutlet var homeImg : UIImageView!
    
    
    @IBOutlet var speechBGview : UIView!
    @IBOutlet var viewVolTip : UIView!
    @IBOutlet var userName : UIButton!
    @IBOutlet var speechText1 : UILabel!
    
    @IBOutlet var speechText2 : UILabel!
    @IBOutlet var homeName : UIButton!
    
    @IBAction func btnBack(sender : AnyObject) {
        
        let alert :UIAlertView = UIAlertView()
        alert.delegate = self
        alert.title = Defined_ALERT_loginOut
        alert.message = Defined_ALERT_loginOut2
        alert.addButtonWithTitle(Defined_ALERT_OK)
        alert.addButtonWithTitle(Defined_ALERT_CANCEL)
        alert.show()
        
        //self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func swiped(sender : AnyObject) {
        print("swiped down")
        //self.clolseSpeechV()
    }
    
    @IBAction func swipedUp(sender : AnyObject) {
        print("swiped Up")
       // self.showSpeechV()
    }

    @IBOutlet var ViewBtns : UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FAME.getDateFormServer()
        
        
        
        let returnButtonItem = UIBarButtonItem()
        returnButtonItem.title = Defined_navigation_back_title
        self.navigationItem.backBarButtonItem = returnButtonItem
        
        
        self.btnP.hidden = true
        self.btnVM.hidden = true
        self.btnSA.hidden = true
        self.btnSU.hidden = true
        self.btnSS.hidden = true
        self.btnUM.hidden = true
        self.btnAU.hidden = true
        self.btnHU.hidden = true
        self.userName.hidden = true
        self.homeName.hidden = true
        self.userImg.hidden = true
        self.homeImg.hidden = true
        
        /*
        var initString :NSString =  "appid=\(APPID_VALUE),timeout=\(TIMEOUT_VALUE)"
        IFlySpeechUtility.createUtility(initString)
        self.iFlySpeechRecognizer  = RecognizerFactory.CreateRecognizer(self, domain: "iat") as IFlySpeechRecognizer
        self.iFlySpeechRecognizer.setParameter("plain", forKey: IFlySpeechConstant.RESULT_TYPE())
        self.iFlySpeechRecognizer.setParameter("40", forKey: IFlySpeechConstant.VAD_EOS())
        self.iFlySpeechRecognizer.setParameter("0", forKey: IFlySpeechConstant.ASR_PTT())
        
        self.isCanceled = false
        self.viewVolTip.frame.size.width = 0
        
        
        
        //TTS
        self.iFlySpeechSynthesizerInstance = IFlySpeechSynthesizer.sharedInstance() as IFlySpeechSynthesizer
        self.iFlySpeechSynthesizerInstance.delegate = self
        self.iFlySpeechSynthesizerInstance.setParameter("70", forKey: IFlySpeechConstant.SPEED())
        self.iFlySpeechSynthesizerInstance.setParameter("50", forKey: IFlySpeechConstant.VOLUME())
        self.iFlySpeechSynthesizerInstance.setParameter("vinn", forKey: IFlySpeechConstant.VOICE_NAME())
        self.iFlySpeechSynthesizerInstance.setParameter("8000", forKey: IFlySpeechConstant.SAMPLE_RATE())
        
        self.iFlySpeechSynthesizerInstance.setParameter(nil, forKey: IFlySpeechConstant.TTS_AUDIO_PATH())

        self.ttsHasError = false
        NSThread.sleepForTimeInterval(0.05)
        println("buffering")
        //self.iFlySpeechSynthesizerInstance.startSpeaking(self.toBeSyn.text)
        */
        self.mainInit()
    }
    
    
    func mainInit(){
        print("MAIN_INIT")
        let myThreadInit = NSThread(target: self, selector: "Timerset", object: nil)
        myThreadInit.start()
    }
    
    func Timerset(){
        print("ok")
        //FAME.refreshLightState()
    }

    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "empty.png"), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName:UIFont.boldSystemFontOfSize(22)]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        
        self.viewSpeech.frame.origin.y =  self.view.frame.height - 20
        
    }
    override func viewWillDisappear(animated: Bool){
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
    }
    

    
    override func viewDidAppear(animated: Bool){
        super.viewDidAppear(animated)
        
        self.userName.setTitle(FAME.user_name, forState: UIControlState.Normal)
        
        
        
        
        if showAnimate {
            
            self.showAnimate = false
            let viewHeight = self.view.frame.height
            let viewWidth = self.view.frame.width
            
            
            self.btnP.frame.origin.y += viewHeight
            self.btnVM.frame.origin.y += viewHeight
            self.btnSA.frame.origin.y += viewHeight
            self.btnSU.frame.origin.y += viewHeight
            self.btnSS.frame.origin.y += viewHeight
            self.btnUM.frame.origin.y += viewHeight
            self.btnAU.frame.origin.y += viewHeight
            self.btnHU.frame.origin.y += viewHeight
            
            self.userImg.frame.origin.x += viewWidth
            self.homeImg.frame.origin.x += viewWidth
            
            
            self.btnP.hidden = false
            self.btnVM.hidden = false
            self.btnSA.hidden = false
            self.btnSU.hidden = false
            self.btnSS.hidden = false
            self.btnUM.hidden = false
            self.btnAU.hidden = false
            self.btnHU.hidden = false
            
            self.userImg.hidden = false
            self.homeImg.hidden = false
            
            self.userName.alpha = 0
            self.homeName.alpha = 0
            self.userName.hidden = false
            self.homeName.hidden = false
            
            UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnP.frame.origin.y -= viewHeight
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.05, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnSA.frame.origin.y -= viewHeight
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.1, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnVM.frame.origin.y -= viewHeight
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.15, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnSU.frame.origin.y -= viewHeight
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.2, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnSS.frame.origin.y -= viewHeight
                self.userImg.frame.origin.x -= viewWidth
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.25, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnUM.frame.origin.y -= viewHeight
                self.homeImg.frame.origin.x -= viewWidth
                
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.3, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnAU.frame.origin.y -= viewHeight
                self.userName.alpha = 1
                }, completion: nil)
            
            UIView.animateWithDuration(0.4, delay: 0.35, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.btnHU.frame.origin.y -= viewHeight
                self.homeName.alpha = 1
                }, completion: nil)
            
        }else{
            
        }
        
        
        
        
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        print("click at \(buttonIndex)")
        if buttonIndex == 0 {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func alertViewCancel(alertView: UIAlertView){
        
    }
    
}