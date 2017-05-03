//
//  startWeiChatPAy.m
//  NTFM_IOS
//
//  Created by zhiminruan on 16/8/2.
//  Copyright © 2016年 cmytc. All rights reserved.
//

#import "startWeiChatPAy.h"
//#import "NTAppConstants.h"
//#import "JSONKit.h"
//#import "HUDHelper.h"
//#import "MBProgressHUD.h"
#import <AFNetworking/AFNetworking.h>
//#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import <CommonCrypto/CommonDigest.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "FameShopping-Swift.h"

@implementation startWeiChatPAy


+ (void)jumpToBizPay:(NSDictionary *)dataDic {
    
    //============================================================
    // V3&V4支付流程实现
    // 注意:参数配置请查看服务器端Demo
    // 更新时间：2015年11月20日
    //============================================================
//    NSString *urlString   = @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php?plat=ios";
//    NSString *urlString = [NSString stringWithFormat:@"%@/card/v1/weixin/pay/ask/appPay",NT_BaseUrl];//@"http://yt.dev.cmytc.com/card/v1/weixin/pay/ask/appPay";
    
//    __weak MBProgressHUD *hud = [[HUDHelper sharedInstance] loading];
    
    
    [SVProgressHUD show];
    [NetworkModel request:@{@"payment":@"weixin",@"deal_no":dataDic[@"deal_no"]} url:@"/Pay/online_pay" complete:^(id _Nonnull dic) {
        if ([dic[@"code"] intValue] == 200) {
            NSDictionary *dict = dic[@"wechat_pay"];
            if(dict != nil){
                NSDictionary *dic = dict;
                NSMutableString *retcode = [dic objectForKey:@"result_code"];
                if (retcode.intValue == 0){
                    NSMutableString *stamp  = (NSMutableString *)[[dic objectForKey:@"timestamp"] stringValue];
                    PayReq* req             = [[PayReq alloc] init];
                    req.openID              = [dic objectForKey:@"appid"];
                    req.partnerId           = [dic objectForKey:@"mch_id"];
                    req.prepayId            = [dic objectForKey:@"prepay_id"];
                    req.nonceStr            = [dic objectForKey:@"nonce_str"];
                    req.timeStamp           = stamp.intValue;
                    req.package             = @"Sign=WXPay";
                    req.sign                = [dic objectForKey:@"sign"];
                    
                    NSMutableDictionary *params = [NSMutableDictionary dictionary];
                    [params setObject:req.openID forKey:@"appid"];
                    [params setObject:req.nonceStr forKey:@"noncestr"];
                    [params setObject:req.package forKey:@"package"];
                    [params setObject:req.partnerId forKey:@"partnerid"];
                    [params setObject:req.prepayId forKey:@"prepayid"];
                    [params setObject:[NSString stringWithFormat:@"%d", stamp.intValue] forKey:@"timestamp"];
                    
                    
                    
                    NSLog(@"%@",req.sign);
                    //                [WXApi sendReq:req];
                    req.sign = [self createMd5Sign:params];
                    NSLog(@"%@",req.sign);
                    
                    [WXApi sendReq:req];
                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%d\npackage=%@\nsign=%@",[dic objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(int)req.timeStamp,req.package,req.sign );
                }
            }

        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }
    }];
//    [[[NetWorkModel alloc] initWithRequestWithParam:@{@"deal_no":dataDic[@"deal_no"],@"payment":@"weixin"} url:@"/api.php/Pay/online_pay" requestMethod:YTKRequestMethodPost requestType:YTKRequestSerializerTypeHTTP] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:nil];
//        [SVProgressHUD dismiss];
//        if(dict != nil){
//            NSDictionary *dic = dict[@"wechat_pay"];
//            NSMutableString *retcode = [dic objectForKey:@"result_code"];
//            if (retcode.intValue == 0){
//                NSMutableString *stamp  = (NSMutableString *)[[dic objectForKey:@"timestamp"] stringValue];
//                PayReq* req             = [[PayReq alloc] init];
//                req.openID              = [dic objectForKey:@"appid"];
//                req.partnerId           = [dic objectForKey:@"mch_id"];
//                req.prepayId            = [dic objectForKey:@"prepay_id"];
//                req.nonceStr            = [dic objectForKey:@"nonce_str"];
//                req.timeStamp           = stamp.intValue;
//                req.package             = @"Sign=WXPay";
//                req.sign                = [dic objectForKey:@"sign"];
//                
//                NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                [params setObject:req.openID forKey:@"appid"];
//                [params setObject:req.nonceStr forKey:@"noncestr"];
//                [params setObject:req.package forKey:@"package"];
//                [params setObject:req.partnerId forKey:@"partnerid"];
//                [params setObject:req.prepayId forKey:@"prepayid"];
//                [params setObject:[NSString stringWithFormat:@"%d", stamp.intValue] forKey:@"timestamp"];
//                
//                
//                
//                NSLog(@"%@",req.sign);
////                [WXApi sendReq:req];
//                req.sign = [self createMd5Sign:params];
//                NSLog(@"%@",req.sign);
//                
//                [WXApi sendReq:req];
//            NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%d\npackage=%@\nsign=%@",[dic objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(int)req.timeStamp,req.package,req.sign );
//            }
//        }
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        
//    }];
    
    
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json"forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
//    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//    
//    [manager POST:urlString parameters:dataDic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
////        [[HUDHelper sharedInstance] stopLoading:hud];
//        NSMutableDictionary *dict = NULL;
//        dict = responseObject;
//        if(dict != nil){
//            NSDictionary *dic = dict;
//            NSMutableString *retcode = [dic objectForKey:@"result_code"];
//            if (retcode.intValue == 0){
////                NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
//                NSMutableString *stamp  = (NSMutableString *)[[[dic objectForKey:@"timestamp"] stringValue] substringToIndex:10];
//                //调起微信支付
//                PayReq* req             = [[PayReq alloc] init];
//                req.openID              = [dic objectForKey:@"appid"];
//                req.partnerId           = [dic objectForKey:@"partnerid"];
//                req.prepayId            = [dic objectForKey:@"prepayid"];
//                req.nonceStr            = [dic objectForKey:@"noncestr"];
//                req.timeStamp           = stamp.intValue;
//                req.package             = [dic objectForKey:@"package"];
//                req.sign                = [dic objectForKey:@"sign"];
//                [WXApi sendReq:req];
//                //日志输出
//                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%d\npackage=%@\nsign=%@",[dic objectForKey:@"appId"],req.partnerId,req.prepayId,req.nonceStr,(int)req.timeStamp,req.package,req.sign );
//                
////                NSDate *date            = [NSDate date];
////                req.openID              = [dic objectForKey:@"appId"];
////                req.partnerId           = [dic objectForKey:@"partnerId"];
////                req.prepayId            = [dic objectForKey:@"prepayId"];
////                req.nonceStr            = [dic objectForKey:@"nonceStr"];
////                req.timeStamp           = [dic[@"timeStamp"] intValue];
////                req.package             = dic[@"package"];
////                req.sign                = [dic objectForKey:@"sign"];
////                
//                NSMutableDictionary *params = [NSMutableDictionary dictionary];
//                [params setObject:req.openID forKey:@"appid"];
//                [params setObject:req.nonceStr forKey:@"noncestr"];
//                [params setObject:req.package forKey:@"package"];
//                [params setObject:req.partnerId forKey:@"partnerid"];
//                [params setObject:req.prepayId forKey:@"prepayid"];
//                [params setObject:[NSString stringWithFormat:@"%.0f", interval] forKey:@"timestamp"];
//                NSLog(@"%@",req.sign);
//                req.sign = [[self class] createMd5Sign:params];
//                NSLog(@"%@",req.sign);
////                [WXApi sendReq:req];
//            }else{
////                [[HUDHelper sharedInstance] tipMessage:dict[@"retmsg"]];
//                //                return [dict objectForKey:@"retmsg"];
//            }
//        }else{
//            
//            //            return @"服务器返回错误，未获取到json对象";
//        }
//    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
////        [[HUDHelper sharedInstance] stopLoading:hud];
//        NSLog(@"Error: %@", error);
//    }];
    
//    [NSURLConnection]
//    if ( response != nil) {
//        NSMutableDictionary *dict = NULL;
//        //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//        dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//        
//        NSLog(@"url:%@",urlString);
//        if(dict != nil){
//            NSMutableString *retcode = [dict objectForKey:@"retcode"];
//            if (retcode.intValue == 0){
//                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//                
//                //调起微信支付
//                PayReq* req             = [[PayReq alloc] init];
//                req.partnerId           = [dict objectForKey:@"partnerid"];
//                req.prepayId            = [dict objectForKey:@"prepayid"];
//                req.nonceStr            = [dict objectForKey:@"noncestr"];
//                req.timeStamp           = stamp.intValue;
//                req.package             = [dict objectForKey:@"package"];
//                req.sign                = [dict objectForKey:@"sign"];
//                [WXApi sendReq:req];
//                //日志输出
//                NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
////                return @"";
//            }else{
////                return [dict objectForKey:@"retmsg"];
//            }
//        }else{
////            return @"服务器返回错误，未获取到json对象";
//        }
//    }else{
////        return @"服务器返回错误";
//    }
}

+ (NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", @"chongqingyibiyiwangluo369140141y"];
    //得到MD5 sign签名
    NSString *md5Sign =[self md5:contentString];
    
    //输出Debug Info
//    [self.debugInfo appendFormat:@"MD5签名字符串：\n%@\n\n",contentString];
    
    return md5Sign;
}

+ (NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
