//
//  EditViewController.swift
//  FameSmartApp
//
//  Created by famesmart on 17/1/5.
//  Copyright © 2017年 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

import UIKit

protocol EditViewController_nameDelegate{
    func reloadMode();
}

class EditViewController: UIViewController {

    var delegate :EditViewController_nameDelegate?
    
    let tableView = UITableView()
    
    var dataSource:Array<Dictionary<String,String>> = []
    override func viewDidLoad() {
        super.viewDidLoad()

        
        createNav()
        initDateSource()
        
        initTable()
        
        
    }
    func sureClick(sender:AnyObject!){
        //print(dataSource)
        
        if FAME.editTag == 1{
            let arr:NSMutableArray = []
            for j in 0..<dataSource.count{
                if dataSource[j]["isChoose"] == "1"{
                    arr.addObject("\(dataSource[j]["act_id"]!)")
                    //arr.addObject("\(dataSource[j]["act_id"]!)")
                    
                }
            }
            FAME.modeArr = arr
        }else{
            print(dataSource)
            let arr = NSMutableArray()
            for j in 0..<dataSource.count{
                if dataSource[j]["isChoose"] == "1"{
                    let name = dataSource[j]["name"]! as String
                    let act_id = dataSource[j]["act_id"]! as String
                    let type = dataSource[j]["type"]! as String
                    let ieee = dataSource[j]["ieee"]! as String
                    let index = dataSource[j]["index"]! as String
                    let dev_id = dataSource[j]["dev_id"]! as String
                    let typeI = Int(type)!
                    let act_idI = Int(act_id)!
                    arr.addObject(["name":name,"act_id":act_idI,"type":typeI,"state":"0","ieee":"\(ieee)","index":"\(index)","dev_id":"\(dev_id)"])
                    //arr.addObject("\(dataSource[j]["act_id"]!)")
                    
                }
            }
            FAME.devicDis = arr
        }
        
        
        let myThread = NSThread(target: self, selector: "Timerset", object: nil)
        myThread.start()
    }
    func Timerset(){
        
        let dic = ["name":FAME.devicDis,"mode":FAME.modeArr]
        let nsdata = try? NSJSONSerialization.dataWithJSONObject(dic, options: [] )
        let value = NSString(data: nsdata!, encoding: 4)!
        
        let cmdStr = "{\"cmd\": 58, \"user_name\": \"\(FAME.user_name )\",\"user_pwd\": \"\(FAME.user_pwd)\", \"did\": \(FAME.user_did),\"name\": \"p_mode\",\"value\":\(value)}"
        let result = httpRequert().downloadFromPostUrlSync(Surl,cmd: cmdStr,timeout:90)
        if result["result"] as! NSObject == 0{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.delegate?.reloadMode();
            self.navigationController?.popViewControllerAnimated(true);
            })
            
        }
        else{
            self.delegate?.reloadMode();
            self.navigationController?.popViewControllerAnimated(true);
        }
    }
    func createNav(){
        let button = UIButton(frame: CGRectMake(0,0,60,35))
        button.setTitle("确定", forState: UIControlState.Normal)
        button.addTarget(self, action: Selector("sureClick:"), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    func initDateSource(){
        if FAME.editTag == 1{
            var btns = Defined_MODE_NAMEB
            for i in 0..<btns.count{
                if i < 6{
                    dataSource.append(["name":"\(btns[i])","isChoose":"0","act_id":"\(i + 8)"])
                }
                else{
                    dataSource.append(["name":"\(btns[i])","isChoose":"0","act_id":"\(i - 5)"])
                }
            }
            
            for i in 0..<FAME.modeArr.count{
                for j in 0..<dataSource.count{
                    if FAME.modeArr[i] as? String == dataSource[j]["act_id"]{
                        dataSource[j]["isChoose"] = "1"
                        break
                    }
                }
            }
        }
        else{
            //print(FAME.idForNames)
            dataSource = FAME.editForDevice
            for i in 0..<FAME.devicDis.count{
                for j in 0..<dataSource.count{
                    let act = dataSource[j]["act_id"]! as String
                    let dAct = FAME.devicDis[i]["act_id"] as! Int
                    if dAct == Int(act)!{
                        dataSource[j]["isChoose"] = "1"
                        break
                    }
                }
            }
            
        }
        
    }
    func initTable(){
        
        tableView.frame = CGRect(x: 0, y: 64, width: WIDTH, height: HEIGHT - 64)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = UIView()
        
        tableView.registerNib(UINib(nibName: "editModeCell", bundle: nil), forCellReuseIdentifier: "editModeCell")
        tableView.separatorStyle = .None
        self.view.addSubview(tableView)
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}


extension EditViewController:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return dataSource.count
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: editModeCell = tableView.dequeueReusableCellWithIdentifier("editModeCell") as! editModeCell
        cell.editLable.text = dataSource[indexPath.row]["name"]
        let ischoose = dataSource[indexPath.row]["isChoose"]
        if ischoose == "1"{
            cell.editButton.setBackgroundImage(UIImage(named: "checkbox_selected.png"), forState: .Normal)
        }
        cell.editButton.id = indexPath.row
        cell.editButton.addTarget(self, action: Selector("chooseClick:"), forControlEvents: .TouchUpInside)
        return cell
    }
    func chooseClick(sender:UIButton2){
        let ischoose = dataSource[sender.id]["isChoose"]
        if ischoose == "1"{
            sender.setBackgroundImage(UIImage(named: "checkbox_unselect.png"), forState: .Normal)
            dataSource[sender.id]["isChoose"] = "0"
        }
        else{
            sender.setBackgroundImage(UIImage(named: "checkbox_selected.png"), forState: .Normal)
            dataSource[sender.id]["isChoose"] = "1"
        }
    }
    
}