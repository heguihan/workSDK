//
//  HTFAQView.m
//  GSDK
//
//  Created by 王璟鑫 on 16/8/17.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTFAQView.h"
#import "HTFAQCell.h"

@interface HTFAQView ()

@property (nonatomic,strong) NSMutableArray *modelArray;

@property (nonatomic,strong) NSIndexPath*selectIndex;

@property (nonatomic,assign) BOOL isOpen;
@end
@implementation HTFAQView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.modelArray=[NSMutableArray array];
        [HTNetWorking POST:@"http://aq.gamehetu.com/faq/getlist" paramString:nil ifSuccess:^(id response) {
            if ([response[@"code"] isEqualToNumber:@0]) {
                NSArray*arr=response[@"data"];
                
                for (NSDictionary*dic in arr) {
                    HTModelCenter*model=[[HTModelCenter alloc]init];
                    model.title=dic[@"question"];
                    model.content=dic[@"answer"];
                    [self.modelArray addObject:model];
                }
                [self.tableview reloadData];
            }
        } failure:^(NSError *error) {
                }];
        

        self.isOpen=NO;
        self.tableview=[[UITableView alloc]initWithFrame:self.bounds];
        [self addSubview:self.tableview];
        self.tableview.delegate=self;
        self.tableview.dataSource=self;
        [self.tableview registerClass:[HTFAQCell class] forCellReuseIdentifier:@"HTFAQCell"];
        UIView *view =[ [UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        [self.tableview setTableFooterView:view];
   
        
    }
    return self;
}
//-(void)reload
//{
//    if (self.modelArray.count!=0) {
//        return;
//    }else
//    {
//        [HTNetWorking POST:@"http://aq.gamehetu.com/faq/getlist" paramString:nil ifSuccess:^(id response) {
//            if ([response[@"code"] isEqualToNumber:@0]) {
//                NSArray*arr=response[@"data"];
//                
//                for (NSDictionary*dic in arr) {
//                    HTModelCenter*model=[[HTModelCenter alloc]init];
//                    model.title=dic[@"question"];
//                    model.content=dic[@"answer"];
//                    [self.modelArray addObject:model];
//                }
//                [self.tableview reloadData];
//            }
//        } failure:^(NSError *error) {
//        }];
//
//    }
//    
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTFAQCell*cell=[[HTFAQCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HTFAQCell"];
    HTModelCenter*model=self.modelArray[indexPath.row];
    if ([self.selectIndex isEqual: indexPath]) {
        cell.isExpent=YES;
    }else
    {
        cell.isExpent=NO;
    }
    [cell configUIWithModel:model];
 
    cell.detailLabel.text=model.content;
    cell.detailLabel.height=[self p_heightWithString:cell.detailLabel.text];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if ([self.selectIndex isEqual:indexPath]) {
      
        self.selectIndex=nil;
        //刷新 单行cell
        //UITableViewRowAnimationFade 淡入淡出  ，right从左往右滑出 以此类推
          [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    }else
    {
        
        NSIndexPath*temp;
        if (self.selectIndex!=nil) {
            temp=self.selectIndex;
            self.selectIndex=indexPath;
            [self.tableview reloadRowsAtIndexPaths:@[temp] withRowAnimation:(UITableViewRowAnimationFade)];
            [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        }else
        {
            self.selectIndex=indexPath;
            [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
        }
        
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.selectIndex isEqual: indexPath]) {
        HTModelCenter*model=self.modelArray[indexPath.row];
        
       CGFloat a= [self p_heightWithString:model.content];

        
        return a+90/550.0*MAINVIEW_WIDTH ;
        
    }else
    {
        return 60/550.0*MAINVIEW_WIDTH;
   }

}
//输入一段文字返回文字高度
-(CGFloat)p_heightWithString:(NSString*)aString
{
    CGRect r= [aString boundingRectWithSize:CGSizeMake(470/550.0*MAINVIEW_WIDTH-50/550.0*MAINVIEW_WIDTH, 2000) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:MXSetSysFont(10)} context:nil];
    return r.size.height;
}
@end
