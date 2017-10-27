//
//  HTIAPManager.m
//  正式内购开整
//
//  Created by 王璟鑫 on 16/5/20.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import "HTIAPManager.h"
#import <StoreKit/StoreKit.h>
@interface HTIAPManager() <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic,strong) NSTimer*timer;
@property (nonatomic,strong) SKPayment * payment;
@property (nonatomic,strong) NSMutableArray*receiptArray;
@property (nonatomic,strong) NSString*filePath;
@end
@implementation HTIAPManager
@synthesize productRequest = _productRequest;
+(instancetype)defaultManager
{
   static  HTIAPManager*manager=nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager=[[HTIAPManager alloc]init];
    });
    
    return manager;
}
-(NSMutableArray *)receiptArray
{
    if (_receiptArray==nil) {
        _receiptArray=[NSMutableArray array];
    }
    return _receiptArray;
}
-(instancetype)init
{
    if (self==[super init]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        NSString*document=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
        self.filePath=[document stringByAppendingPathComponent:@"receiptArray.plist"];
        self.receiptArray=[NSMutableArray arrayWithContentsOfFile:self.filePath];
    }
    return self;
}
-(void)setExtra:(NSString *)extra
{
    [USER_DEFAULT setObject:extra forKey:@"extra"];
    [USER_DEFAULT synchronize];
    NSLog(@"_+_+_+_+_+_+_+_+_+_+_%@",[USER_DEFAULT objectForKey:@"extra"]);
}
-(void)createTimer
{
        self.timer=[NSTimer scheduledTimerWithTimeInterval:9 target:self selector:@selector(chongfajizhi) userInfo:nil repeats:YES];
    
    
}
-(void)chongfajizhi
{
    
    if (self.receiptArray.count!=0) {
        
        [self timeRsendReceipt:self.receiptArray[0]];
    }else
    {
        [self.timer invalidate];
        self.timer=nil;
    }
    
    
}
/**
 *  步骤1根据id请求商品
 *
 *  @param productId 商品的id
 *
 */
- (void)requestProductWithId:(NSString *)productId
{
    
    if (productId.length > 0) {
        NSLog(@"请求商品: %@", productId);
        self.productRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithObject:productId]];
        self.productRequest.delegate = self;
        [self.productRequest start];
        
        //发起请求
    } else {
        NSLog(@"商品ID为空");
        [self alertViewWithString:@"商品ID为空"];
    }
}


- (void)requestProductWithId:(NSString *)productId withblock:(void(^)(NSString *str))block
{
    if (productId.length > 0) {
        NSLog(@"请求商品: %@", productId);
        self.productRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithObject:productId]];
        self.productRequest.delegate = self;
        [self.productRequest start];
        
        [HTIAPManager defaultManager].IAPBlock = ^(NSString *str)
        {
            block(str);
        };
        
        
        //发起请求
    } else {
        NSLog(@"商品ID为空");
    }
    
    
    
    
    
}


- (void)alertViewWithString:(NSString *)str
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:str
                                                     delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}



/**
 *  步骤二 发起请求后的代理方法
 *
 *  @param response 请求的响应结果
 */
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSLog(@"rsponse.pooduct=%@",response);
    NSArray *myProductArray = response.products;
    if([myProductArray count] == 0){
        [self alertViewWithString:@"查询不到此商品"];

        NSLog(@"查询不到此商品");
        
        return;
    }
        //如果用户允许购买
    if ([SKPaymentQueue canMakePayments]) {
        /**
         *  创建并发送购买请求
         */
        NSArray *myProduct = response.products;
        NSLog(@"Product ID:%@\n",response.invalidProductIdentifiers);
        // populate UI
        for(SKProduct *product in myProduct){
            NSLog(@"Detail product info\n");
            NSLog(@"SKProduct description: %@\n", [product description]);
            NSLog(@"Product localized title: %@\n" , product.localizedTitle);
            NSLog(@"Product localized descitption: %@\n" , product.localizedDescription);
            NSLog(@"Product price: %@\n" , product.price);
            NSLog(@"Product identifier: %@\n" , product.productIdentifier);
        }
        self.payment = [SKPayment paymentWithProduct:myProductArray[0]];
        //购买监听
        [[SKPaymentQueue defaultQueue] addPayment:self.payment];

    }else
    {
        NSLog(@"不允许程序内付费");
        [self alertViewWithString:@"不允许程序内付费"];
    }
}


/**
 *  步骤三
 *  监听购买结果
 *
 *  @param queue        代理方法
 *  @param transactions 结果数组
 */
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    for(SKPaymentTransaction *tran in transactions){
        switch (tran.transactionState) {
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                NSLog(@"商品被添加进购买列表");
                break;
            case SKPaymentTransactionStatePurchased://交易成功
                [HTIAPManager defaultManager].IAPBlock(@"success");
                NSLog(@"购买成功");
                [self completeTransaction:tran];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                NSLog(@"交易失败");
                

                [HTIAPManager defaultManager].IAPBlock(@"failure");
                [self failedTransaction:tran];
                break;
            case SKPaymentTransactionStateRestored://已购买过该商品
                [self restorePurchase];
                NSLog(@"恢复购买");
                break;
            case SKPaymentTransactionStateDeferred://交易延迟
                break;
            default:
                break;
        }    }
}

/** TODO:非消耗品恢复*/
-(void)restorePurchase {
    
    // NO if this device is not able or allowed to make payments
    if ([SKPaymentQueue canMakePayments]) {
        
        // 解决方法很简单，增加一个Restore按钮，并调用[[SKPaymentQueue defaultQueue] restoreCompletedTransactions]，
        
        [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
    } else {
        NSLog(@"失败,用户禁止应用内付费购买.");
    }
}
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSString * productIdentifier = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSData * transactionReceiptdata = [productIdentifier dataUsingEncoding:NSUTF8StringEncoding] ;
    
    NSString*transactionReceiptString=[transactionReceiptdata base64EncodedStringWithOptions:0];
    if ([transactionReceiptString length] > 0) {
        
        NSLog(@"凭证打印%@",transactionReceiptString);
        
    
        [self sendReceipt:transactionReceiptString];
        
        
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}
-(BOOL) checkLastPurchase
{
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count > 0) {
        //检测是否有未完成的交易
        SKPaymentTransaction* transaction = [transactions lastObject];
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            [self completeTransaction:transaction];
            
            return true;
        }
    }
    return false;
}

////弹出错误信息
//- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
//    NSLog(@"-------弹出错误信息----------");
//    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
//                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
//    [alerView show];
//    
//}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled && transaction.error.code != SKErrorUnknown) {
        
        NSLog(@"购买失败，未知错误或用户取消交易");
        
    }
    
    NSLog(@"cuowu=%ld",transaction.error.code);
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


-(void)sendReceipt:(NSString*)receipt
{
    
    
///改改改aaa支付订单
    NSString*string=[NSString stringWithFormat:@"http://c.gamehetu.com/order/notice/apple?"];
    
//    NSURL*url=[NSURL URLWithString:string];
    NSString*parmaStr=[NSString stringWithFormat:@"app=%@&uid=%@&coo_server=%@&coo_uid=%@&extra=%@&receipt=%@",[USER_DEFAULT objectForKey:@"appID"],[USER_DEFAULT objectForKey:@"uid"],[USER_DEFAULT objectForKey:@"coo_server"],[USER_DEFAULT objectForKey:@"coo_uid"],[USER_DEFAULT objectForKey:@"extra"],receipt];
    
    
    //测试用的
//    NSString*parmaStr=[NSString stringWithFormat:@"app=%@&uid=%@&coo_server=%@&coo_uid=%@&extra=%@&receipt=%@",[USER_DEFAULT objectForKey:@"appID"],@"123456",[USER_DEFAULT objectForKey:@"coo_server"],[USER_DEFAULT objectForKey:@"coo_uid"],[USER_DEFAULT objectForKey:@"extra"],receipt];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",string,parmaStr];
    NSLog(@"url==%@",urlstr);
    NSURL *newUrl = [NSURL URLWithString:urlstr];
    
//    NSLog(@"urlstr=%@",parmaStr);
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:newUrl cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:10];
//    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
//    NSData*paraData=[parmaStr dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:paraData];
    
    
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dict[@"code"]isEqualToNumber:@0]) {
            
            NSLog(@"发送凭证成功");
            
        }else
        {
            [self.receiptArray addObject:receipt];
            [self.receiptArray writeToFile:self.filePath atomically:YES];
            
            if (self.timer==nil) {
                [self createTimer];
            }
            
            NSLog(@"失败%@",connectionError);
        }
        
        
        
    }];
    
    
}
-(void)timeRsendReceipt:(NSString*)receipt
{
    
//改改改aaa支付订单重发
    NSString*string=[NSString stringWithFormat:@"http://c.gamehetu.com/order/notice/apple?"];
//    NSURL*url=[NSURL URLWithString:string];
    NSString*parmaStr=[NSString stringWithFormat:@"app=%@&uid=%@&coo_server=%@&coo_uid=%@&extra=%@&receipt=%@",[USER_DEFAULT objectForKey:@"appID"],[USER_DEFAULT objectForKey:@"uid"],[USER_DEFAULT objectForKey:@"coo_server"],[USER_DEFAULT objectForKey:@"coo_uid"],[USER_DEFAULT objectForKey:@"extra"],receipt];
    
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@",string,parmaStr];
    NSLog(@"url==%@",urlstr);
    NSURL *newUrl = [NSURL URLWithString:urlstr];
    
    //    NSLog(@"urlstr=%@",parmaStr);
    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:newUrl cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:5];
    
//    NSMutableURLRequest*request=[NSMutableURLRequest requestWithURL:url cachePolicy:(NSURLRequestUseProtocolCachePolicy) timeoutInterval:5];
    [request setHTTPMethod:@"POST"];
//    NSData*paraData=[parmaStr dataUsingEncoding:NSUTF8StringEncoding];
//    [request setHTTPBody:paraData];
    
    
    
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSDictionary*dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dict[@"code"]isEqualToNumber:@0]) {
            
            [self.receiptArray removeObjectAtIndex:0];
            [self.receiptArray writeToFile:self.filePath atomically:YES];
            
            
            
        }else
        {
            NSLog(@"失败%@",connectionError);
        }
        
        
        
    }];
    
    
}
@end
