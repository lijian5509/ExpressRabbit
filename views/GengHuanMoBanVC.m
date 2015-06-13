//
//  GengHuanMoBanVC.m
//  ExpressRabbit
//
//  Created by 快递兔 on 15/4/14.
//  Copyright (c) 2015年 kuaiditu. All rights reserved.
//

#import "GengHuanMoBanVC.h"

@implementation GengHuanMoBanVC
{
    //修改的列表
    UITableView *_tabFormWork;
    //模板数组
    NSMutableArray *_dataArr;
    //被选择的下标
    NSInteger _selectIndex;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addTitile:@"编辑模板"];
    [self addBarButtonItemWithNormalimageName:@"ic_back" target:self action:@selector(goBack) isLeft:YES andTitle:nil andTitleWidth:0];
    [self dataConfig];
    [self showUI];
}

-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dataConfig{
    NSMutableDictionary *messageDict = [Helper getMessageListAndSelectIndex];
    if (messageDict==nil) {
        _dataArr = [[NSMutableArray alloc] init];
        _selectIndex = 10;
        NSArray *arr = @[@"你的快递正在派送中，请准备好收件",@"你的快递放在门卫室了，请抽空去取件",@"你的电话无人接听，明天再送",@"我是快递员，麻烦现在到楼下取件，我大约会等15分钟",@"你的快递放在物业那里了，麻烦有空的时候去取"];
        for (NSString *s in arr) {
            [_dataArr addObject:s];
        }
    }else{//读数组和上一次单元格被选择的下标
        _dataArr = [messageDict objectForKey:@"messageArr"];
        _selectIndex = [[messageDict objectForKey:@"selectIndex"] integerValue];
    }
}

-(void)showUI{
    _tabFormWork = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-64)];
    _tabFormWork.delegate = self;
    _tabFormWork.dataSource = self;
    _tabFormWork.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tabFormWork];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"cell";
    GengHuanCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell==nil) {
        cell = [[GengHuanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.btnUpdate.tag = indexPath.row;
    cell.delegate = self;
    if (indexPath.row==_selectIndex) {
        cell.imgSelect.image = [UIImage imageNamed:@"选择模板"];
    }
    NSString *strDetail = _dataArr[indexPath.row];
    [cell showData:strDetail];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strDetail = _dataArr[indexPath.row];
    CGFloat allHeight = 10 + [Helper textHeightFromString:strDetail width:SCREENWIDTH-(26+10+10+9*2+20) fontsize:12] + 10;
    return allHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *messgae = _dataArr[indexPath.row];
    //保存到本地的index
    NSString *filePath = [Helper getMessagePath];
    NSMutableDictionary *messageDict = [Helper getMessageListAndSelectIndex];
    if (messageDict==nil) {
        messageDict = [[NSMutableDictionary alloc] init];
        NSMutableArray *messageArray = [[NSMutableArray alloc] init];
        for (NSString *s in _dataArr) {
            [messageArray addObject:s];
        }
        [messageDict setValue:messageArray forKey:@"messageArr"];
        [messageDict setValue:[NSString stringWithFormat:@"%ld",indexPath.row] forKey:@"selectIndex"];
    }else{
        [messageDict setValue:[NSString stringWithFormat:@"%ld",indexPath.row] forKey:@"selectIndex"];
    }
    [messageDict writeToFile:filePath atomically:YES];
    [self.delegate updateMessage:messgae];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 执行修改代理方法
-(void)transIndex:(NSInteger)index{
    NSString *strUpdateText = _dataArr[index];
    GengHuanMoBanBianJiVC *gvc = [[GengHuanMoBanBianJiVC alloc] init];
    gvc.strUpdateText = strUpdateText;
    gvc.dataArr = _dataArr;
    gvc.index = index;
    gvc.delegate = self;
    gvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:gvc animated:YES];
}

#pragma mark - 执行刷新的代理方法
-(void)updateText{
    //刷新列表
    [_tabFormWork reloadData];
    NSString *filePath = [Helper getMessagePath];
    NSMutableDictionary *messageDict = [Helper getMessageListAndSelectIndex];
    if (messageDict==nil) {
        messageDict = [[NSMutableDictionary alloc] init];
        NSMutableArray *messageArray = [[NSMutableArray alloc] init];
        for (NSString *s in _dataArr) {
            [messageArray addObject:s];
        }
        [messageDict setValue:messageArray forKey:@"messageArr"];
    }else{
        NSMutableArray *messageArray = [messageDict objectForKey:@"messageArr"];
        [messageArray removeAllObjects];
        for (NSString *s in _dataArr) {
            [messageArray addObject:s];
        }
        [messageDict setValue:messageArray forKey:@"messageArr"];
    }
    [messageDict writeToFile:filePath atomically:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
