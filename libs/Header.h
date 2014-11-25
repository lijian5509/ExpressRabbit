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
#import "AFHTTPClient.h"
#import "TabBarViewController.h"
#import "AppDelegate.h"
//#import "LogInViewController.h"
#import "TGetPasswordViewController.h"
#import "FillMessageViewController.h"
#import "WaitViewController.h"
#import "ShareViewController.h"
#import "OrderDetailViewController.h"
#import "DidDealViewCell.h"
#import "HistoryViewController.h"
#import "WaitViewController.h"
#import "FillMessageViewController.h"
#import "LogInViewController.h"
#import "KuaiDiViewCell.h"
#import "HeadView.h"
#import "GeRenTableViewCell.h"
#import "SheZhiViewController.h"
#import "NoMoneyViewController.h"
#import "ChatViewController.h"
#import "FialViewController.h"
#import "GeRenTableViewCell.h"
#import "AboutViewController.h"
#import "LJFScollerViewController.h"
#import "DidDealTableViewController.h"
#import "KuaiDiViewController.h"

//获取屏幕高度
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
//获取当前系统版本
#define SYSTEMVERSION [[UIDevice currentDevice]systemVersion]

//三极色
#define SANJISE [UIColor colorWithRed:(arc4random()%256/255.0) green:(arc4random()%256/255.0) blue:(arc4random()%256/255.0) alpha:1]

//设置二级键盘
#define INPUTACCESSVIEW -(void)getBackKeybord{\
UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];\
view.backgroundColor=[UIColor whiteColor];\
UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(260, 0, 60, 40) target:self sel:@selector(done) tag:10001 image:nil title:@"Done"];\
[view addSubview:btn];\
\
for (UIView *text in self.view.subviews) {\
    if ([text isKindOfClass:[UITextField class]]) {\
        ((UITextField *)text).delegate=self;\
    \
        ((UITextField *)text).inputAccessoryView=view;\
        ((UITextField *)text).clearButtonMode=UITextFieldViewModeWhileEditing;\
    }\
}\
}\
-(void)done{\
    for (UIView *text in self.view.subviews) {\
        if ([text isKindOfClass:[UITextField class]]) {\
            ((UITextField *)text).delegate=self;\
\
            [(UITextField *)text resignFirstResponder];\
        }\
    }\
 \
}\



//获取完善信息状态 记录是否完善信息，是否激活

#define CHECKSTATUS  \
NSString *isWanShan=dictPlist[@"isTureNetSite"];\
if ([isWanShan isEqualToString:@"0"]) {\
    FillMessageViewController *fill=[[FillMessageViewController alloc]init];\
    self.hidesBottomBarWhenPushed=YES;\
    [self.navigationController pushViewController:fill animated:YES];\
    return;\
}\
\
NSString *isJiHuo=dictPlist[@"checkStatus"];\
if ([isJiHuo isEqualToString:@"0"]) {\
    FialViewController *wait=[[FialViewController alloc]init];\
    self.hidesBottomBarWhenPushed=YES;\
    [self.navigationController pushViewController:wait animated:YES];\
    return;\
}else if ([isJiHuo isEqualToString:@"2"]){\
    WaitViewController *wait=[[WaitViewController alloc]init];\
    self.hidesBottomBarWhenPushed=YES;\
    [self.navigationController pushViewController:wait animated:YES];\
    return;\
}\



//收键盘
#define SHOUJIANPAN -(BOOL)textFieldShouldReturn:(UITextField *)textField{\
\
[textField resignFirstResponder];\
\
return YES;\
\
}\
//返回键

//设置背景图片
#define TABLEVIEWBACKVIEW self.tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景 "]]

#define BACKVIEW self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景"]]

//设定常用颜色
#define GRAYCOLOR [UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景"]]



//常用控件
#import "MyControl.h"
//获取自动高和时间转化的帮助类
#import "Helper.h"
//第三方下载类
#import "AFNetworking.h"


#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


//CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 1, 0, 0, 1 });
#define BACKKEYITEM UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(0, 0,60, 40) target:self sel:@selector(getBack) tag:101 image:nil title:@"< 返回"];\
\
btn.titleLabel.font=[UIFont boldSystemFontOfSize:17];\
\
[btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];\
\
UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:btn];\
\
self.navigationItem.leftBarButtonItem=item;\

#define TEST(str)  UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(0, 0,60, 40) target:self sel:@selector(getBack) tag:101 image:nil title:str];
//定义一个获取plist文件元素的宏
#define GET_PLISTMEMBER(name)  NSString *filePatn=[NSHomeDirectory() stringByAppendingPathComponent:@"userInfo.plist"];\
NSMutableDictionary *dictPlist=[NSMutableDictionary dictionaryWithContentsOfFile:filePatn];\
NSString *member=dictPlist[name];
//定义一个获取plist文件的宏
#define GET_PLISTdICT NSString *filePatn=[NSHomeDirectory() stringByAppendingPathComponent:@"userInfo.plist"];\
NSMutableDictionary *dictPlist=[NSMutableDictionary dictionaryWithContentsOfFile:filePatn];\




//接口文档
#define CESHIZONG @"http://115.29.240.85/kuaidituInphone/%@"
#define ZHENGSHIZONG @"http://115.29.206.228/kuaidituInphone%@"

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

//我的信息
#define WODEXINXI @"courier/getCourier"                          //courierId,快递员ID
//短信内容
#define DUANXINNEIRONG @"problemExpress/getSMS"                  //courierId,快递员ID
//发送短信
#define FASONGDUANXIN @"problemExpress/sendProblemSMS"           //courierId,mobile,sms   快递员Id,手机号码,短信内容
//查询快递员当天发短信总数
#define CHAXUNDANGTIANDUANXINLIANG @"problemExpress/getproblemExpressCount"  //courierId  快递员Id
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


#import "AFNetworking.h"


#define HUODONGZHISHIQI   AMTumblrHud *tumblrHUD = [[AMTumblrHud alloc] initWithFrame:CGRectMake((CGFloat) ((self.view.frame.size.width - 55) * 0.5),\
(CGFloat) ((self.view.frame.size.height - 20) * 0.5), 55, 20)];\
tumblrHUD.hudColor =[UIColor clearColor];\
\[self.view addSubview:tumblrHUD];\
[tumblrHUD showAnimated:YES];
#import "AMTumblrHud.h"// 活动指示器头文件


#endif
