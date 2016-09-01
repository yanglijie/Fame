//
//  DefinitionString.swift
//  FameSmartApp
//
//  Created by book on 14-8-21.
//  Copyright (c) 2014 Shanghai Fame Smart Technology Co., Ltd. All rights reserved.
//

//*********************
//
//     definition for chinese
//
//*********************



import Foundation

let WIDTH = UIScreen.mainScreen().bounds.size.width
let HEIGHT = UIScreen.mainScreen().bounds.size.height

let Defined_navigation_back_title = "返回"

let Defined_Unkown_Device = "未知设备"

let Defined_ALERT_loginOut = "注销"
let Defined_ALERT_loginOut2 = "确定要退出？"
let Defined_ALERT_OK = "确定"
let Defined_ALERT_CANCEL = "取消"

let Defined_ALERT_del = "删除设备"
let Defined_ALERT_del2 = "确定要删除此设备？"


let Defined_SA_btns1 = ["灯 光","窗 帘","空 调","影 音","移 动 智 能","智 能 浴 霸","智 能 门 锁","风 机 控 制","中 央 空 调"]
let Defined_SA_btns = ["灯光","智能电机","空调","影音","移动智能","智能浴霸","智能门锁","风机控制","中央空调"]
let Defined_SS_btns = ["温湿监测","门窗磁","运动感应","烟雾报警","燃气报警","漏水检测","情景模式面板","空气质量"]
let Defined_SS_btns1 = ["温 湿 监 测","门 窗 磁","运 动 感 应","烟 雾 报 警","燃 气 报 警","漏 水 检 测","情 景 模 式 面 板","空 气 质 量"]

let Defined_SS_icons =
    ["0","ss2_2.png","move_03.png","smork_03.png","gas_03.png","ss6_6","0","ss8_8.png"]
let Defined_SS_icons1 = ["0","ss2_21.png","move_031.png","gas_031.png","smork_031.png","ss6_61","0","ss8_81.png"]

let Defined_SA_icons = ["0","light_icon.png","curtain_03.png","appl_19_icon.png","sound_icon.png","socket_03.png","light_icon3.png","lock_icon.png","0","cta_stop.png"]
let Defined_SA_icons1 = ["0","light_icon2.png","0","0","0","socket61.png","SA61.png","lock_icon2.png","0","cta_open.png"]


let Defined_VC6_AlertTitle="提示"
let Defined_VC6_AlertMessage1="你要抹掉之前所学习的按键，开启学习模式吗？"
let Defined_VC6_AlertMessage="设备自动添加过程将会持续40秒左右"
let Defined_VC6_AlertMessage2="不能添加空设备"

let Defined_Add_Title1 = "添加设置"
let Defined_Add_Title_failed = "添加失败"
let Defined_Add_Title_failed2 = "部分设备未能获取到设备类型，请检查网络状态后重新添加"
let Defined_Add_Title_failed3 = "添加设备指令未能成功发送，请检查网络状态后重新添加"
let Defined_Add_Title_failed4 = "设备表已被其他终端更新，请重新添加设备"
let Defined_Add_Title_success = "添加成功"

let Defined_Add_failed = "个设备添加失败"

let Defined_Delete = "删除"

let Defined_register_User_existed = "用户名已经存在"
let Defined_register_SQL_failed = "网络错误"
let Defined_register_userName_less = "用户名少于3个字符"
let Defined_register_userPwd_less = "密码少于6个字符"
let Defined_register_userPwd_diff = "两次密码不同"
let Defined_register_not_router = "不是凡米智能中控"
let Defined_register_failed = "注册失败"

let Defined_login_dt_failed = "网络错误"

let Defined_login_failed = "登录失败"
let Defined_network_failed = "网络错误"

let Defined_add_successed = "设备添加成功"
let Defined_add_existed = "该设备已存在"
let Defined_add_md5_failed = "校验码有误"

let Defined_mode_link = "点击添加事件"

let Defined_mode_on = "开"
let Defined_mode_off = "关"

let Defined_mode_failed = "情景模式配置失败"
let Defined_mode_update = "情景模式配置成功"
let Defined_mode_title = "情景模式配置"

let Defined_mode1_failed = "情景模式面板配置失败"
let Defined_mode1_update = "情景模式面板配置成功"
let Defined_mode1_title = "情景模式面板配置"


let Defined_link_update = "联动配置成功"
let Defined_link_failed = "联动配置失败"
let Defined_link_title = "联动配置"
let Defined_link_title1 = "恢复联动配置"

let Defined_delay_update = "延时配置成功"
let Defined_delay_failed = "延时配置失败"
let Defined_delay_title = "延时配置"


let Defined_cmds = ["开灯。":21,"关灯。":20]
let Defined_cmds_str = "命令已执行"

let Defined_link_remove = "清空"

let Defined_setting_title = "设置"
let Defined_setting_error1 = "原密码不正确"
let Defined_setting_error2 = "修改失败"
let Defined_setting_error3 = "新密码不能为空"
let Defined_setting_error4 = "新密码格式错误"
let Defined_setting_error5 = "新密码不一致"
let Defined_setting_error6 = "会话已超时"
let Defined_setting_success = "修改成功"

let Defined_telphone_success1 = "该用户还没有绑定手机号，请先绑定手机号"
let Defined_telphone_success = "手机号绑定成功"
let Defined_telphone_error = "验证码不正确，请重新获取"

let Defined_device_title = "设备忙"
let Defined_device_failed = "当前正在进行设备的添加或删除，请稍后再试"
let Defined_device_begin = "设备自动删除中，请稍后"

let Defined_unAdd_Title1 = "退网设置"
let Defined_unAdd_Title2 = "退网设置"
let Defined_unAdd_Title_failed = "设备退网失败"
let Defined_unAdd_Title_failed2 = "中控忙,请稍后重试"

let Defined_unAdd_Title_success = "设备退网成功，请刷新界面"

let Defined_uptate_title = "更新失败"
let Defined_uptate_error1 = "设备表更新失败，请检查网络状态"

let Defined_6light_name=["照明","换气","灯暖","吹风","风暖I","风暖II"]

let Defined_timer_week_name = ["日","一","二","三","四","五","六"]

let Defined_clickToAdd_title = "点击添加"

let Defined_Timer_Date = "修改日期"
let Defined_Timer_Time = "修改时间"

let Defined_SS_Title1 = "设 置 联 动"
let Defined_SS_Title2 = "设置延时联动"
let Defined_SS_Title3 = "设置延时时间"
let Defined_SS_Title4 = "取       消"


let Defined_SS_air_Title1 = "修 改 名 字"
let Defined_SS_air_Title2 = "删 除 设 备"
let Defined_SS_air_Title3 = "配置联动设备"
let Defined_SS_air_Title4 = "恢复后的联动"
let Defined_SS_air_Title5 = "修 改 门 限"


let Defined_LS_Title3 = "联 动 配 置"

let Defined_PUSH_Title = "设置"
let Defined_PUSH_Title2 = "报警消息"
let Defined_PUSH_failed = "请打开推送设置"
//let Defined_PUSH_failed1 = "请打开信息记录的"

let Defined_Event_Title = "点击添加"
let Defined_MODE_NAME1 = "设备全开"


let Defined_LINKS_NAMES = ["情景模式","灯光","传感"]
let Defined_NULL = "清空"

let Defined_MODE_NAME = ["灯 全 关","全 布 防","全 撤 防"]

let Defined_Tips_none = "亲，您还未购买此设备哦！"

let Defined_btn_return = "返回"

let Defined_cur_title = "时间设置"
let Defined_cur_update = "时间设置成功"
let Defined_cur_failed = "时间设置失败"

let Defined_appl_10 = ["开","关","停止"]
let Defined_appl_16 = ["节目减","音量加","OK","节目加","音量减","HOME","静音","开/关","返回","自定义1","自定义2","自定义3","自定义4"]
let Defined_appl_17 = ["节目减","音量加","OK","节目加","音量减","HOME","静音","开/关","返回","自定义1","自定义2","自定义3","自定义4"]
let Defined_appl_18 = ["上一曲","音量加","播放/暂停","下一曲","音量减","随机播放","静音","开/关","循环播放","自定义1","自定义2","自定义3","自定义4"]
let Defined_appl_19 = ["开","关","除湿","送风","制冷","制热","btn7","btn8","btn9","自定义1","自定义2","自定义3","自定义4"]
let Defined_appl_20 = ["btn120","btn2","btn3","btn4","btn5","btn6","btn7","btn8","btn9","自定义1","自定义2","自定义3","自定义4"]
let Defined_appl_21 = ["btn121","btn2","btn3","btn4","btn5","btn6","btn7","btn8","btn9","自定义1","自定义2","自定义3","自定义4"]
