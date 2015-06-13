//
//  GengHuanMoBanBianJiVC.m
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/14.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "GengHuanMoBanBianJiVC.h"

@implementation GengHuanMoBanBianJiVC
{
    UITextView *_textView;
    UILabel *_wordLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor(240, 240, 240);
    [self addTitile:@"编辑模板"];
    [self addBarButtonItemWithNormalimageName:@"ic_back" target:self action:@selector(goBack) isLeft:YES andTitle:nil andTitleWidth:0];
    [self showUI];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showUI{
    //输入短信内容
    _textView=[[UITextView alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 85)];
    _textView.delegate = self;
    _textView.text = self.strUpdateText;
    _textView.font = [UIFont systemFontOfSize:12];
    _textView.layer.cornerRadius = 4;
    _textView.layer.masksToBounds = YES;
    _textView.keyboardType = UIKeyboardTypeNamePhonePad;
    _textView.inputAccessoryView=[self getViewFromSecondLevel];
    //计算还能输入的字数
    NSString *strSurperPlus = @"还能输入45字";
    _wordLabel=[MyControl creatLabelWithFrame:CGRectMake(_textView.frame.size.width-100, _textView.frame.size.height-7-5, 100, 8) text:strSurperPlus];
    _wordLabel.attributedText = [strSurperPlus selfFont:8 selfColor:[UIColor lightGrayColor] LightText:@"45" LightFont:8 LightColor:MyColor(521, 78, 10)];
    _wordLabel.textAlignment = NSTextAlignmentRight;
    [_textView addSubview:_wordLabel];
    //保存的按钮
    UIButton *btnSave = [MyControl creatButtonWithFrame:CGRectMake(15, _textView.frame.origin.y+_textView.frame.size.height+25, SCREENWIDTH-30, 43) target:self sel:@selector(btnSave:) tag:101 image:@"橙色按钮" title:nil];
    UILabel *lblYaoQing = [MyControl creatLabelWithFrame:CGRectMake(btnSave.frame.size.width/2-50, 5, 100, 30) text:@"保 存"];
    lblYaoQing.textAlignment = NSTextAlignmentCenter;
    lblYaoQing.textColor = [UIColor whiteColor];
    lblYaoQing.font = [UIFont boldSystemFontOfSize:18];
    [btnSave addSubview:lblYaoQing];
    [self.view addSubview:btnSave];
    [self.view addSubview:_textView];
}

//保存信息
-(void)btnSave:(UIButton *)btn{
    NSString *updateText = _textView.text;
    [self.dataArr replaceObjectAtIndex:self.index withObject:updateText];
    [self.delegate updateText];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -textView代理事件
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请输入短信内容!"]) {
        textView.text = @"";
    }
    textView.textColor=[UIColor blackColor];
    NSString *strSuperPlus = [NSString stringWithFormat:@"还能输入%ld个字",45-textView.text.length];
    _wordLabel.attributedText = [strSuperPlus selfFont:8 selfColor:[UIColor lightGrayColor] LightText:[NSString stringWithFormat:@"%ld",45-textView.text.length] LightFont:8 LightColor:MyColor(521, 78, 10)];
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>45) {
        NSString *strSuperPlus = [NSString stringWithFormat:@"已超出%ld个字",textView.text.length-45];
        _wordLabel.attributedText = [strSuperPlus selfFont:8 selfColor:[UIColor lightGrayColor] LightText:[NSString stringWithFormat:@"%ld",textView.text.length-45] LightFont:8 LightColor:MyColor(521, 78, 10)];
    }else{
        NSString *strSuperPlus = [NSString stringWithFormat:@"还可输入%ld个字",45-textView.text.length];
        _wordLabel.attributedText = [strSuperPlus selfFont:8 selfColor:[UIColor lightGrayColor] LightText:[NSString stringWithFormat:@"%ld",45-textView.text.length] LightFont:8 LightColor:MyColor(521, 78, 10)];
    }
}

-(UIView *)getViewFromSecondLevel{
    UIView *blackLineFromTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENHEIGHT, 1)];
    blackLineFromTop.backgroundColor = MyColor(200, 200, 200);
    UIButton *view=[MyControl creatButtonWithFrame:CGRectMake(0, 0, 320, 40) target:self sel:@selector(done) tag:100002 image:nil title:nil];
    view.backgroundColor=[UIColor whiteColor];
    UIButton *btn=[MyControl creatButtonWithFrame:CGRectMake(280, 12.5, 30, 15) target:self sel:@selector(done) tag:10001 image:nil title:@"完成"];
    UIView *blackLineFromBottom = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.size.height-1, SCREENWIDTH, 1)];
    blackLineFromBottom.backgroundColor = MyColor(200, 200, 200);
    [view addSubview:blackLineFromTop];
    [view addSubview:blackLineFromBottom];
    [view addSubview:btn];
    return view;
}

#pragma mark - 编辑完成收键盘
-(void)done{
    [_textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
