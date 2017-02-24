//
//  charsViewController.swift
//  FameSmartApp
//
//  Created by famesmart on 17/2/20.
//  Copyright © 2017年 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

import UIKit
import Charts

class charsViewController: UIViewController {
    
    private var scrollView : UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "历史记录"

        createScrollView()
        initDateSource()
        print(FAME.dev_ieee)
        
        // Do any additional setup after loading the view.
    }
    func initDateSource(){
        
        let data = FAME.getMonthDate(0)
        let arr = data.componentsSeparatedByString(" ")
        let sdate = arr[0] + " " + "00:00:00"
        let edate = FAME.getNowDate(2)
        var one = NSMutableArray()
        
        let result = FAME.getAirRecord(sdate, edate: edate, ieee: FAME.dev_ieee)
        if (result != nil){
            one = FAME.getAirRecord(sdate, edate: edate, ieee: FAME.dev_ieee)! as! NSMutableArray
            
        }
        else{
            let dic :Dictionary = ["id":"0","info":"无报警记录"]
            one.addObject(dic)
        }
        
    }
    func createScrollView(){
        let frame = self.view.bounds
        scrollView = UIScrollView(frame: frame)
        self.view.addSubview(scrollView)
        
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentOffset = CGPointZero
        //将scrollView 的contentSize 设置为屏幕宽的3倍
        scrollView.contentSize = CGSize(width: frame.size.width, height: frame.size.height * 2 - 64)
        createLineView(CGRect(x: 0, y: 64, width: WIDTH, height: (HEIGHT - 64) * 0.7), title: "PM2.5",color: UIColor.redColor())

//        createLineView(CGRect(x: 0, y: 64 + (HEIGHT - 64) * 0.5 , width: WIDTH, height: (HEIGHT - 64) * 0.5), title: "温度",color: UIColor.orangeColor())
//        
//        createLineView(CGRect(x: 0, y: 64 + (HEIGHT - 64) , width: WIDTH, height: (HEIGHT - 64) * 0.5), title: "湿度",color: UIColor.orangeColor())
//        
//        createLineView(CGRect(x: 0, y: 64 + (HEIGHT - 64) * 1.5 , width: WIDTH, height: (HEIGHT - 64) * 0.5), title: "甲醛",color: UIColor.orangeColor())
        
        
    }
    
    func createLineView(frame:CGRect,title:String,color:UIColor){
        let lineView = LineChartView(frame: frame)
        lineView.descriptionText = ""
        lineView.noDataText = "没有可展示的数据"
        scrollView.addSubview(lineView)
        lineView.extraBottomOffset = 5.0
        lineView.extraRightOffset = 15.0
        //不绘制右边栏Y轴的信息
        lineView.rightAxis.enabled = false
        //lineView.xAxis.enabled = false
        //不绘制网格线
        lineView.xAxis.drawGridLinesEnabled = false
        lineView.leftAxis.drawGridLinesEnabled = false
        lineView.xAxis.axisLineColor = UIColor.blackColor()
        lineView.leftAxis.axisLineColor = UIColor.blackColor()
        
        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        setChart(months, values: unitsSold, superView: lineView,title: title,color:color)
    }
    
    func setChart(dataPoints: [String],values: [Double], superView:LineChartView,title:String,color:UIColor) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: title)
        lineChartDataSet.setCircleColor(color)
        lineChartDataSet.colors = [color]
        lineChartDataSet.valueColors = [UIColor.blueColor()]
        lineChartDataSet.circleRadius = 5.0
        lineChartDataSet.drawCircleHoleEnabled = false
        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        superView.data = lineChartData
        superView.xAxis.labelPosition = .Bottom
        superView.animate(yAxisDuration: 1.4, easingOption: .EaseInOutQuart)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
