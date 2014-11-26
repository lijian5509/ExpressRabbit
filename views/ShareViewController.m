//
//  ShareViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-11.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "ShareViewController.h"
#import "TabBarViewController.h"
#import "ActiveExpress.h"


@interface ShareViewController ()
{
    NSMutableArray *_dataArray;
    UITextView *_textView;//文本框
    UIView *_headView;//文本框底层视图
    ActiveExpress *_activeExpress;//活动说明
}

@end

@implementation ShareViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _dataArray =[[NSMutableArray alloc]init];
    }
    return self;
}
//单元格数目
static NSInteger cellNumber=1;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showUI];
    //给桌面增加一个手势
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [self.tableView addGestureRecognizer:tap];
    
}
#pragma mark -实现单元格输入协议
-(void)addTextField:(DuanXinViewCell *)message{
    if ([Helper validateMobile:message.phoneText]) {
        for (int i=0; i<_dataArray.count; i++) {
            NSString *str=_dataArray[i];
            if (message.deleteBtn.tag==i){
                [_dataArray replaceObjectAtIndex:i withObject:message.phoneText];
                [self.tableView reloadData];
                return;
            }else  if ([str isEqualToString:message.phoneText]) {
                [self showAlertViewWithMaessage:@"该号码已存在,请核对后再输" title:@"警告" otherBtn:nil];
                message.textField.text=@"";
                return;
            }
        }
        [_dataArray addObject:message.phoneText];
        cellNumber++;
        [self.tableView reloadData];
    }else{
        [self showAlertViewWithMaessage:@"输入的号码不正确!请认真核对" title:@"警告" otherBtn:nil];
    }
}
-(void)removeTextViewWith:(DuanXinViewCell *)message{
    if (message.isValid) {
        [_dataArray removeObjectAtIndex:message.deleteBtn.tag];
        cellNumber--;
        [self.tableView reloadData];
    }else{
        cellNumber--;
        [self.tableView reloadData];
    }
}

#pragma mark - 摆UI界面
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"推荐给好友";
    //设置返回键
    BACKKEYITEM;
    //设置头视图
    _headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    _headView.userInteractionEnabled=YES;
    UIView *grayView=[[UIView alloc]initWithFrame:CGRectMake(0, 95, 320, 5)];
    [_headView addSubview: grayView];
    grayView.backgroundColor=GRAYCOLOR;
    
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, 300, 80)];
    _textView.delegate=self;
    
    GET_PLISTdICT
    _textView.text=[NSString stringWithFormat:@"您的朋友%@邀请你和他一起使用快递神器，并给你发了5元红包，下载安装注册就可轻松获得.",dictPlist[@"username"]];
    _textView.font=[UIFont systemFontOfSize:15];
    _textView.layer.borderWidth=1;
    _textView.layer.borderColor=[UIColor darkGrayColor].CGColor;
    [_headView addSubview:_textView];
    self.tableView.tableHeaderView=_headView;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor=[UIColor whiteColor];
    //设置脚视图
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 360)];
    view.userInteractionEnabled=YES;
    UIButton *peopleBtn=[MyControl creatButtonWithFrame:CGRectMake(220, 5, 90, 40) target:self sel:@selector(btnClicked:) tag:101 image:nil title:@"➕添加联系人"];
    UIButton *callBtn=[MyControl creatButtonWithFrame:CGRectMake(10, 5, 90, 40) target:self sel:@selector(btnClicked:) tag:102 image:nil title:@"☎通讯录添加"];
    [peopleBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [callBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [view addSubview:peopleBtn];
    [view addSubview:callBtn];
    UIButton *btn1=[UIButton buttonWithType:UIButtonTypeSystem];
    btn1.tag=103;
    btn1.frame=CGRectMake(10, 50, 300, 40);
    [btn1 setTitle:@"确定" forState:UIControlStateNormal];
    btn1.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"注册_10"] forState:UIControlStateNormal];
    [view addSubview:btn1];
    _activeExpress =[[[NSBundle mainBundle]loadNibNamed:@"ActiveExpress" owner:self options:nil]lastObject];
    _activeExpress.frame=CGRectMake(10, 100, 300, 250);
    [view addSubview:_activeExpress];
    self.tableView.tableFooterView=view;
    
}
-(void)getBack{
    [self setHidesBottomBarWhenPushed:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - btn被点击
-(void)btnClicked:(UIButton *)btn{
    if (btn.tag==101) {//添加联系人，如果上面的号码正确就允许添加
        if (_dataArray.count==cellNumber) {
            cellNumber++;
            [self.tableView reloadData];
        }else{
            [self showAlertViewWithMaessage:@"请先输入正确的号码" title:@"提示" otherBtn:@"ok"];
        }

    }
    if (btn.tag==102) {//调用手机通讯录，获取选中人物信息
       
        //调用系统控件，选中后获得指定人信息
        ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
        peoplePicker.peoplePickerDelegate = self;
        
        [self presentViewController:peoplePicker animated:YES completion:nil];
    }
    if (btn.tag==103) {//确定，把联系电话发给服务器
        NSString *urlPath=[NSString stringWithFormat:CESHIZONG,FENXIANGSMS];
    }
}

#pragma mark -收键盘
-(void)tap{
    [_textView resignFirstResponder];
}

SHOUJIANPAN;

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length >=11) {
        cellNumber++;
        [_dataArray addObject:textField.text];
        [self.tableView reloadData];
        return NO;
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.placeholder=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return cellNumber;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"dunaxin";
    DuanXinViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"DuanXinViewCell" owner:self options:nil]lastObject];
    }
    if (indexPath.row==0) {
        cell.deleteBtn.hidden=YES;
    }
    if (indexPath.row <_dataArray.count) {
            cell.textField.text=_dataArray[indexPath.row];
    }
    cell.textDelegate=self;
    cell.deleteBtn.tag=indexPath.row;
    
    return cell;
}

//显示警告框
- (void) showAlertViewWithMaessage:(NSString *)message title:(NSString *)title otherBtn:(NSString *)btnT {
     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:btnT, nil];
    [alert show];
}
#pragma mark ----电话本

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person;
{
    ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
    //获得选中Vcard相应信息
    
    NSString* firstName=(NSString*)CFBridgingRelease( ABRecordCopyValue(person, kABPersonFirstNameProperty));
    if (firstName==nil) {
        firstName = @" ";
    }
    NSString* lastName=(NSString*)CFBridgingRelease(ABRecordCopyValue(person, kABPersonLastNameProperty));
    if (lastName==nil) {
        lastName = @" ";
    }
    NSMutableArray *phones = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
        
        NSString *aPhone = (NSString*) CFBridgingRelease(ABMultiValueCopyValueAtIndex(phoneMulti, i));
        
        [phones addObject:aPhone];
        [self addPhoneNumberFromAddressBook:aPhone];
        
    }

    [self dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

#pragma mark -从通讯录添加
-(void)addPhoneNumberFromAddressBook:(NSString *)phoneBook{
    //1.看联系人得电话是否有效
    if ([Helper validateMobile:phoneBook]) {
        //2.查看该联系人是否添加过
        if (_dataArray.count==0) {//第一次没有联系人和最后一个单元格的联系方式不完善
            [_dataArray addObject:phoneBook];
            cellNumber++;
            [self.tableView reloadData];
            return;
        }//
        for (int i=0; i<_dataArray.count; i++) {
            NSString *str=_dataArray[i];
            if ([str isEqualToString:phoneBook]) {
                [self showAlertViewWithMaessage:@"该联系人已添加" title:@"提示" otherBtn:nil];
                return;
            }
        }
        if (_dataArray.count==cellNumber||_dataArray.count<cellNumber) {
            [_dataArray addObject:phoneBook];
            cellNumber++;
        }
    }else{
        [self showAlertViewWithMaessage:@"号码有误，请核实后添加" title:@"警告" otherBtn:nil];
    }
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
    
}
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
