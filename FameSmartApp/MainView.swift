//
//  MainView.swift
//  FameSmartApp
//
//  Created by famesmart on 17/1/5.
//  Copyright © 2017年 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

import UIKit

class MainView: UIView {

    @IBOutlet weak var M_data: UILabel!

    @IBOutlet weak var M_air: UILabel!
    
    @IBOutlet weak var M_outTemp: UILabel!
    
    @IBOutlet weak var M_inTemp: UILabel!
    
    @IBOutlet weak var M_userPower: UILabel!
    
    @IBOutlet weak var M_userName: UILabel!
    
    @IBOutlet weak var M_warnOne: UILabel!
    
    @IBOutlet weak var M_warnTwo: UILabel!
    
    
    
    static func newInstance() -> MainView?{
        let nibView = NSBundle.mainBundle().loadNibNamed("MainView", owner: nil, options: nil)
        if let view = nibView.first as? MainView{
            return view
        }
        return nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        load_init()
    }
    
    func load_init(){
        
        
    }
    
    
}
