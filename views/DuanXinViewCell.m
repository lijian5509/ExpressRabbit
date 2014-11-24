//
//  DuanXinViewCell.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-11.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "DuanXinViewCell.h"

@implementation DuanXinViewCell

- (void)awakeFromNib
{
    self.textField.delegate=self;
    self.textField.keyboardType=UIKeyboardTypeTwitter;
    //设置二级键盘
    _inputView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    _inputView.tag=1001;
    _inputView.backgroundColor=[UIColor whiteColor];
    UIButton *figureBtn=[MyControl creatButtonWithFrame:CGRectMake(20, 5, 60, 30) target:self sel:@selector(textBtnClicked:) tag:201 image:nil title:@"数字"];
    figureBtn.backgroundColor=[UIColor blueColor];
    figureBtn.titleLabel.textColor=[UIColor whiteColor];
    UIButton *letterBtn=[MyControl creatButtonWithFrame:CGRectMake(80, 5, 60, 30) target:self sel:@selector(textBtnClicked:) tag:202 image:nil title:@"字母"];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef borderColorRef = CGColorCreate(colorSpace,(CGFloat[]){ 0, 0, 1, 1 });
    letterBtn.layer.borderWidth=1;
    letterBtn.layer.borderColor=borderColorRef;
    figureBtn.layer.borderColor=borderColorRef;
    figureBtn.layer.borderWidth=1;
    letterBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    figureBtn.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    UIButton *doneBtn=[MyControl creatButtonWithFrame:CGRectMake(260, 5, 60, 30) target:self sel:@selector(done) tag:203 image:nil title:@"完成"];
    doneBtn.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    [_inputView addSubview:letterBtn];
    [_inputView addSubview:figureBtn];
    [_inputView addSubview:doneBtn];
    self.textField.keyboardType=UIKeyboardTypeNumberPad;
    self.textField.inputAccessoryView=_inputView;
}
-(void)done{
    [self.textField resignFirstResponder];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 限定输入内容
-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
   
    if (textField.text.length+string.length>11) {
        return NO;
    }
    if (textField.text.length ==10&& string.length==1) {
        self.phoneText=[NSString stringWithFormat:@"%@%@",textField.text,string];
        if ([self.textDelegate respondsToSelector:@selector(addTextField:)]) {
            [self.textDelegate performSelector:@selector(addTextField:) withObject:self];
            
        }
    }
        return YES;
}
-(void)textBtnClicked:(UIButton *)btn{
    
    switch (btn.tag) {
        case 201:
        {
            
            [btn setBackgroundColor:[UIColor blueColor]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIButton *button=(UIButton *)[_inputView viewWithTag:202];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            button.backgroundColor=[UIColor whiteColor];
            [self.textField resignFirstResponder];
            self.textField.keyboardType=UIKeyboardTypeNumberPad;
            [self.textField becomeFirstResponder];
        }
            break;
        case 202:
        {
            [btn setBackgroundColor:[UIColor blueColor]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            UIButton *button=(UIButton *)[_inputView viewWithTag:201];
            [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            button.backgroundColor=[UIColor whiteColor];
            [self.textField resignFirstResponder];
            self.textField.keyboardType=UIKeyboardTypeDefault;
            [self.textField becomeFirstResponder];
        }
            break;
        default:
            break;
    }
}

- (IBAction)btnClicked:(UIButton *)sender {
    if ([Helper validateMobile:self.textField.text]) {
        self.isValid=YES;
           }else{
        self.isValid=NO;
    }
    if ([self.textDelegate respondsToSelector:@selector(removeTextViewWith:)]) {
        [self.textDelegate performSelector:@selector(removeTextViewWith:) withObject:self];
    }

   
}
@end
    
