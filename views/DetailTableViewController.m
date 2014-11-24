//
//  DetailTableViewController.m
//  快递兔-终
//
//  Created by kuaiditu on 14-11-12.
//  Copyright (c) 2014年 kuaiditu. All rights reserved.
//

#import "DetailTableViewController.h"
#import "DetailTableViewCell.h"

@interface DetailTableViewController ()
{
    NSMutableArray *_dataArray;
    NSMutableArray *_numberArray;
    NSArray *_nameArray;
    NSString *_path;
    
    
}
@end

@implementation DetailTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        //
        _dataArray=[[NSMutableArray alloc]init];
        _nameArray=@[@"流水号",@"状态",@"类型",@"金额",@"时间",@"余额",@"订单",@"详情"];
        _path =[[NSBundle mainBundle]pathForResource:@"validNum" ofType:@"plist"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled=NO;
    TABLEVIEWBACKVIEW;
    [self showUI];
    [self requestDatawith:nil];
}
- (void)showUI{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"订单详情_11"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlackOpaque;
    self.title=@"详情";
    //返回键、
    BACKKEYITEM;
    UIButton *bianJiBtn=[MyControl creatButtonWithFrame:CGRectMake(0, 0, 50, 40) target:self sel:@selector(editorBtn) tag:201 image:nil title:@"编辑"];
    bianJiBtn.titleLabel.font=[UIFont boldSystemFontOfSize:17];
    [bianJiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:bianJiBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)getBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)editorBtn{
    
}
//请求数据
-(void)requestDatawith:(NSString *)url{
    _numberArray=[[NSMutableArray alloc]initWithContentsOfFile:_path];
    for (int i=0; i<8; i++) {
        [_dataArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _numberArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId=@"detail";
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"DetailTableViewCell" owner:self options:nil]lastObject];
    }
    int a=[_numberArray[indexPath.row] intValue];
    cell.cellNameLabel.text=_nameArray[a];
    cell.cellMessageLabel.text=_dataArray[a];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
