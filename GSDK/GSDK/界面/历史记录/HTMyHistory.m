//
//  HTMyHistory.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/17.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//
#import "HTModelCenter.h"
#import "HTMyHistory.h"
#import "HTHistoryDetailController.h"

@interface HTMyHistory ()

@property (nonatomic,strong)NSMutableArray*modelArray;

@end

@implementation HTMyHistory
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        self.modelArray=[NSMutableArray array];
        self.tableview=[[UITableView alloc]initWithFrame:self.bounds];
        [self addSubview:self.tableview];
        self.tableview.delegate=self;
        self.tableview.dataSource=self;
        [self.tableview registerClass:[HTHistoryCell class] forCellReuseIdentifier:@"historyCell"];
        [self configNetUI];
   

    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadView) name:@"SHUAXIN" object:nil];
    return self;
}
-(void)configNetUI
{
 
    
    NSString*paraStr=[NSString stringWithFormat:@"token=%@&zone=%@",USERTOKEN,[USER_DEFAULT objectForKey:@"coo_server"]];
    
    NSString*url=[NSString stringWithFormat:@"http://aq.gamehetu.com/%@/topic/list",[USER_DEFAULT objectForKey:@"appID"]];
    
    [HTNetWorking POST:url paramString:paraStr ifSuccess:^(id response) {
        
        NSLog(@"%@",response);
        if ([response[@"code"] isEqualToNumber:@0]) {
            NSArray*array=response[@"data"];
            [self.modelArray removeAllObjects];
            for (NSDictionary*dic in array) {
                HTModelCenter*model=[[HTModelCenter alloc]init];
                model.title=dic[@"title"];
                model.type=[dic[@"isAnswer"] isEqualToString:@"false"]?@"未回复":@"已回复";
                model.uid=dic[@"id"];
                [self.modelArray addObject:model];
            }
            if (self.modelArray.count==0) {
                UILabel*jilu=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.tableview.width , self.tableview.height)];
                jilu.text=bendihua(@"当前没有联系记录");
                jilu.textAlignment=NSTextAlignmentCenter;
                jilu.center=self.tableview.center;
                jilu.tag=1000;
                jilu.backgroundColor=[UIColor whiteColor];
                [self addSubview:jilu];
            }else
            {
                [[self viewWithTag:1000]removeFromSuperview];
                [self.tableview reloadData];
            }
        }else
        {
            
        }
        
        
        
    } failure:^(NSError *error) {
        [HTAlertView showAlertViewWithText:bendihua(@"网络连接失败") com:nil];
    }];
}

-(void)reloadView
{
    [self configNetUI];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTHistoryCell*cell=[tableView dequeueReusableCellWithIdentifier:@"historyCell" forIndexPath:indexPath];
   
    if (!cell) {
        cell=[[HTHistoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"historyCell"];
          }
    HTModelCenter*model=self.modelArray[indexPath.row];
    [cell configUIwithModel:model];

    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [cell.rightButton addTarget:self action:@selector(rightButtonAction:event:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75/550.0*MAINVIEW_WIDTH;
}
-(void)rightButtonAction:(UIButton*)sender event:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableview];
    //获取选中cell的indexPath
    NSIndexPath *indexPath= [self.tableview indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        HTModelCenter*model=self.modelArray[indexPath.row];
        [HTPassValueSingle sharePassValue].idStr=model.uid;
        HTHistoryDetailController*con=[[HTHistoryDetailController alloc]init];
        [[self viewController].navigationController pushViewController:con animated:YES];
    }
}

@end
