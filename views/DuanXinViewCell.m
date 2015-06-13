//
//  DuanXinViewCell.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-11.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "DuanXinViewCell.h"

@implementation DuanXinViewCell

- (void)awakeFromNib{
    self.textField.delegate=self;
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius = 4;
    self.textField.inputAccessoryView = [self getInputAccessView];
    self.backgroundColor = MyColor(233, 233, 233);
    UIView *whiteBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 39)];
    whiteBackView.layer.masksToBounds = YES;
    whiteBackView.layer.cornerRadius = 4;
    whiteBackView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:whiteBackView];
    [whiteBackView addSubview:self.deleteBtn];
    [whiteBackView addSubview:self.deleteBtn1];
    [whiteBackView addSubview:self.textField];
}

-(UIView *)getInputAccessView{
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

-(void)done{
    [self.textField resignFirstResponder];
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
    
