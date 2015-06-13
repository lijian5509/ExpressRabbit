//
//  Header.h
//  快递兔测试版
//
//  Created by kuaiditu on 14-11-10.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#ifndef _______Header_h
#define _______Header_h

#import "TabBarViewController.h"
#import "LogInViewController.h"
#import "GetBackPasswordViewController.h"
#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "TGetPasswordViewController.h"
#import "FillMessageViewController.h"
#import "OrderDetailViewController.h"
#import "DidDealViewCell.h"
#import "HistoryViewController.h"
#import "FillMessageViewController.h"
#import "KuaiDiViewCell.h"
#import "HeadView.h"
#import "SheZhiViewController.h"
#import "ChatViewController.h"
#import "GeRenTableViewCell.h"
#import "AboutUsViewController.h"
#import "LJFScollerViewController.h"
#import "DidDealTableViewController.h"
#import "KuaiDiViewController.h"

//获取屏幕宽度
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
//获取屏幕高度
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
//获取当前系统版本
#define SYSTEMVERSION [[UIDevice currentDevice]systemVersion]
//设置定制的颜色
#define MyColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

//设置二级键盘
#define INPUTACCESSVIEW -(void)getBackKeybord{\
UIView *blackLineFromTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 1)];\
blackLineFromTop.backgroundColor = MyColor(200, 200, 200);\
UIButton *view=[MyControl creatButtonWithFrame:CGRectMake(0, 0, 320, 40) target:self sel:@selector(done) tag:100002 image:nil title:nil];\
view.backgroundColor=[UIColor whiteColor];\
UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(280, 12.5, 30, 15) target:self sel:@selector(done) tag:10001 image:nil title:@"完成"];\
UIView *blackLineFromBottom = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-1, SCREENWIDTH, 1)];\
blackLineFromBottom.backgroundColor = MyColor(200, 200, 200);\
[view addSubview:blackLineFromTop];\
[view addSubview:blackLineFromBottom];\
[view addSubview:btn];\
\
\
for (UIView *text in self.view.subviews) {\
if ([text isKindOfClass:[UITextField class]]) {\
((UITextField *)text).delegate=self;\
\
((UITextField *)text).inputAccessoryView=view;\
\
((UITextField *)text).clearButtonMode=UITextFieldViewModeWhileEditing;\
}\
}\
}\
-(void)done{\
    for (UIView *text in self.view.subviews) {\
        if ([text isKindOfClass:[UITextField class]]) {\
            ((UITextField *)text).delegate=self;\
\
self.view.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) ;\
            [(UITextField *)text resignFirstResponder];\
        }\
    }\
 \
}\

//收键盘
#define SHOUJIANPAN -(BOOL)textFieldShouldReturn:(UITextField *)textField{\
\
self.view.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height) ;\
[textField resignFirstResponder];\
\
return YES;\
\
}\

//设置背景图片
#define TABLEVIEWBACKVIEW self.tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景 "]]
#define BACKVIEW self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景 "]]
//设定常用颜色
#define GRAYCOLOR [UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景 "]]

//常用控件
#import "MyControl.h"
//获取自动高和时间转化的帮助类
#import "Helper.h"
//第三方下载类
#import "AFNetworking.h"
//统计
#import "MobClick.h"
//格式化字符串
#import "NSString+Color.h"
// 活动指示器头文件
#import "AMTumblrHud.h"

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define SHOWACTIVITY [tumblrHUD removeFromSuperview];\
tumblrHUD = [[AMTumblrHud alloc] initWithFrame:CGRectMake((CGFloat) ((self.view.frame.size.width - 55) * 0.5),\
(CGFloat) ((self.view.frame.size.height - 20) * 0.5), 55, 20)];\
tumblrHUD.hudColor = UIColorFromRGB(0x000212);\
[self.view addSubview:tumblrHUD];\
[tumblrHUD showAnimated:YES];\


#define HUODONGZHISHIQI   AMTumblrHud *tumblrHUD = [[AMTumblrHud alloc] initWithFrame:CGRectMake((CGFloat) ((self.view.frame.size.width - 55) * 0.5),(CGFloat) ((self.view.frame.size.height - 20) * 0.5), 55, 20)];\
tumblrHUD.hudColor =[UIColor clearColor];\
[self.view addSubview:tumblrHUD];\
[tumblrHUD showAnimated:YES];

#define BACKKEYITEM UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_back"] style:UIBarButtonItemStylePlain target:self action:@selector(getBack)];\
self.navigationItem.leftBarButtonItem = left;\
left.tintColor = [UIColor whiteColor];\

#define RIGHTKEYITEM UIButton *rightBtn = [MyControl creatButtonWithFrame:CGRectMake(0, 0, 25, 25) target:self sel:@selector(inviteCustomer) tag:10002 image:@"01_03" title:nil];\
[rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];\
rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];\
rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;\
rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);\
UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];\
\
right.tintColor = [UIColor whiteColor];\
self.navigationItem.rightBarButtonItem = right;\

//定义一个获取plist文件的宏
#define GET_PLISTdICT NSString *filePatn=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/userInfo.plist"];\
NSMutableDictionary *dictPlist=[NSMutableDictionary dictionaryWithContentsOfFile:filePatn];\

//公钥和私钥
#define PUBLICKEY @"IkZd9z7Jp97j0d2wv644zQKBgQC7OeLYI5FloTHjaxeX3p/A2zzFfXSeP0JHtl7a"
#define PRIVATEKEY @"jLIlazLombFl9URVrsjI30m6ZaZCI13I7HZ6tuxmub7yL+3PDq9JyPJid+TXaUIQ"


//接口文档
//测试 115.29.240.85      正式 115.29.206.228  本地 192.168.1.109:8080     115.29.240.85/kuaidituInphone/indexV8.jsp
#define CESHIZONG @"http://115.29.206.228/kuaidituInphone/v8/%@"
#define ZHENGSHIZONG @"http://115.29.206.228/kuaidituInphone/v8/%@"

//设置邀请码
#define INVITECODE @"inviteRecord/setCourierCode"              //courierId
//邀请客户
#define INVITETIJIAO @"inviteRecord/sendInviteRequest"         //sign   	publicKey    courierId   invitedMobile
#define INVITEHISTORY @"inviteRecord/listInviteRecord"         //pageNum    recordId   courierId
//忘记密码验证验证码是否正确
#define WANGYANZHENG @"updatePassword/checkRandom"             //mobile   电话号码   random 验证码
//忘记密码获取验证码
#define WANGHUOQU @"updatePassword/sendsms"                    //mobile   电话号码
//忘记密码之更换新密码
#define WANGGENGHUAN @"updatePassword/updatePasswordByMobile"    //mobile   电话号码   password  密码
//登陆
#define DENGLU @"applog/loginCheck"                           //mobile   电话号码   password  密码
//点击获取验证码的时候发送
#define SHIFOUZHUCE @"applog/isregister"                       //mobile   电话号码
//发送验证码
#define FASONGYANZHENG @"applog/sendsms"                       //mobile   电话号码
//注册
#define ZHUCE @"applog/regCourier"                             //mobile   电话号码 random 验证码   password  密码
//判断验证码是否正确
#define YANZHENGMAISRIGHT @"applog/israndomnum"
//获取订单
#define HUOQUDINGDAN @"order/listOrders"                        //courierId 快递员Id  page  当前页  pageNum 一页多少条 orderStatus
//获取订单总数
#define HUOQUDINGDANZONGSHU @"order/getOrdersCount"             //courierId 快递员ID  orderStatus  1：等待取货的订单,2：取货成功的订单,3：等待取货和取货成功
//订单详情
#define DINGDANXIANGQING @"order/getOrder"                      //ordered
//手动录入，或者扫描二维码
#define WANSHANGDINGDAN @"order/updateOrder"                    ////orderId  订单Id   expressOrderNo   快递单号
//未录入单号
#define WEILURUDANHAO @"order/pickedOrder"                      //orderId  订单Id   expressOrderNo   快递单号
//得到系统时间
#define GETSYSTIME @"order/pickedOrder"
//获取所有物流公司
#define ALLWULIU @"express/listExpressCompany"
//我的信息
#define WODEXINXI @"courier/getCourier"                          //courierId,快递员ID
//短信内容
#define DUANXINNEIRONG @"problemExpress/getSMS"                  //courierId,快递员ID
//发送短信
#define FASONGDUANXIN @"problemExpress/sendProblemSMS"           //courierId,mobile,sms   快递员Id,手机号码,短信内容
//查询快递员当天发短信总数
#define CHAXUNDANGTIANDUANXINLIANG @"problemExpress/getCourierMesNum"  //courierId  快递员Id
//发送短信记录查询
#define DUANXINJILU @"problemExpress/listProblems"               //courierId 快递员Id   page  当前页  pageNum  一页多少条
//短信详情
#define DUANXINDETAIL @"problemExpress/listProblems"             //只需要问题件id         problemExpressId
//发送短信总数
#define DUANXINZONGSHU @"problemExpress/getSmsCountEveryDay"     //courierId  快递员Id
//意见反馈添加（发送）
#define YIJIANFASONG @"FeedBack/addFeedBack"                     //Id:唯一标示,Courier：快a递员,Opinion：意见
//意见反馈记录
#define YIJIANJILU @"FeedBack/listFeedBacks"                     //courierId ,快递员Id
//分享发送短信（发送）
#define FENXIANGSMS @"shareRecord/shareRecordSMS"                //   //sendTel:   receiverTel：	   smsCommnet：发送者电话,接受者电话,短信内容
//添加完善信息
#define WANSHANXINXI @"regInfo/addregInfo"                       //regMobile:expressCompanyName,netSiteName,netSiteAddress,netSiteMobile：注册者账号,快递公司名称,网点名称,网点地址,网点电话
//得到完善信息详情
#define GETWANSHANGXINXI @"regInfo/getRegInfo"                   //regMobile
//得到默认网点的Id
#define GETMORENWANGDIAN @"regInfo/getDefaultNetSiteId"
// 添加银行卡
#define TIANJIAYINHANGKA @"bankCard/addBankCard"                 //@param courierId 快递员Id,@param cardName持有者姓名,@param bankCard  卡号,@param bankName  银行名称,@param checkMobile  验证电话,@param random 验证码
//修改银行卡
#define XIUGAIYINHANGKA @"bankCard/updateBankCard"               //@param courierId 快递员Id,@param cardName持有者姓名,@param bankCard  卡号,@param bankName  银行名称,@param checkMobile  验证电话,@param random 验证码
//得到银行卡信息
#define GETYINHANGKAXINXI @"bankCard/getBankCardInfo"            //courierId
//发送验证码 (银行）
#define YINGHANGSMS @"bankCard/sendsms"                          //mobile
//验证码是否正确 (银行）
#define YINHANGYANZHENGYZM @"bankCard/israndomnum"               //mobile
//取得快递员金额
#define HUOQUYUE @"balanceDeal/getCourierCmoney"                 //courierId
//快递员提现
#define QUXIAN @"balanceDeal/turnOutCourierCmoney"               //courierId,turnOutMoney,random
//发送验证码 (取现）
#define QUXIANYANZHENG @"balanceDeal/sendsms"                    //mobile
//获取流水表数据
#define ZHANGDANCHAXUN @"balanceDeal/listProcessInfos"           //courierId,page,pageNum
//流水表总数
#define ZHANGDANZONGSHU @"balanceDeal/getProcessCount"           //courierId
//流水表新数据总数
#define XINZHANGDANZONGSHU @"balanceDeal/getProcessCount"        //courierId     motifyTime
// 流水表数据详情
#define ZHANGDANSHUJUDETAIL @"balanceDeal/getProcessInfoDetail"  //processInfoId
//得到银行卡信息
#define GETBANKCARKMESSASGE @"bankCard/getBankCardInfo"         //courierId  快递员id
//订单已读
#define DINGDANYIDU @"order/courierReadOrder"                    //orderId  
//订单未读
#define DINGDANWEIDU @"order/getNewOrdersCount"                  //courierId
//新流水数目
#define XINLIUSHUISHUMU @"balanceDeal/getNewProcessCount"        //courierId    motifyTime
//支付回调
#define DUANXINZHIFU @"courier/payMesAmount"
//完善订单号
#define WANSHANDINGDANHAO @"regInfo/updateRegInfo"

//图片接口
//测试  115.29.240.85 正式 115.29.206.228
#define CESHITUPIAN @"http://115.29.206.228/Skuaiditu-managerCms/"
//正式
#define ZHENGSHITUPIAN @"http://115.29.206.228/Skuaiditu-managerCms/"
#endif
