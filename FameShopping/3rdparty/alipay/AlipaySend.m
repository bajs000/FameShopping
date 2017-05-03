//
//  AlipaySend.m
//  JMS
//  支付宝支付
//  Created by crly on 15/8/21.
//  Copyright (c) 2015年 sevnce. All rights reserved.
//

#import "AlipaySend.h"
#import "DataSigner.h"
#import "Order.h"
#import <AlipaySDK/AlipaySDK.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "FameShopping-Swift.h"
//#import "NTAPPConstants.h"

@implementation AlipaySend

+(void)toAlipay:(NSString *)outTradeNO withSubject:(NSString *)subject withBody:(NSString *)body withTotalFee:(float)totalFee callback:(void (^)(NSDictionary *))callback{
    
    //partner和seller获取失败,提示
    NSString *partner = @"2088911730183731";
    NSString *seller= @"369140141@qq.com"; //商户号
    NSString *privateKey= @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAM8bwmVhV4bjsYuf3cn5kVeaIvavXEoTUjZVCDklsLRolHT6DcrKvwhxTLlD9lDIO2PSHMBjyxGBCEni6+XjjO4PLtGROXD/atyNPZFJwzU7qD+Ov1rZltl5hfqJXMYIZg8JjEd3FYgFWY6QZpTM07srEtzT86S64HFSzpn79k0RAgMBAAECgYBEDewX4h+fvGwX5EU93BsNPSHmC4N499ZY8iIMnTzuWzsFITGtBGg3fvtmGVXz/4e8akt2UJRmwQ6XMNCxLs+cxtMizgxWm3bqPnoiv4UmVhgWjv0hpW0dtTO1gORIqwH/tBFRvdQxw3UNiOF6YmwUZw/mMgtdd2xp6OvV+iAonQJBAOwEJDDzF5ZLpvaAvf+peh2zTDM+KHznuxJs6lkvwBNNkO50/tE2tw1WKFkASx1QB4Rv6WJNCWIWMwsMvLTzYjcCQQDgpQRnNyk1apqnGjMw5mPVzkjH73Vy/PIIydXxjeyuTARaG2MkyI48XoqzR8Tm6ssXdVjSgSechvGHoexsNMb3AkAA47cbNB9XoqtbbHrK1uGt8PoNi2NtrRXoaN6tPV/U8srkCy7WrQUdmMCILVcbIi0VE7LmevHZG8pPdVnUuMIbAkBi1feD+e71g3ubfZl8MEFIdkPrQ12nQ8axOywX5Nt3LBbWFiqeqmZ6BRZ9HlxxRGgqYAS+SPjGk1B83i8IxIetAkEAoSFJwGsImRYx/xBIBklEt3A/7NX0J7dDAvrqcFErLU/ZVhl3gUFiSZxqPeTaIqVdgnjsGDNF9NZONh2pAWRrlQ=="; //私钥
    [SVProgressHUD show];
    [NetworkModel request:@{@"payment":@"alipay",@"deal_no":outTradeNO} url:@"/Pay/online_pay" complete:^(id _Nonnull dic) {
        if ([dic[@"code"] intValue] == 200) {
            if ([partner length] == 0 ||
                [seller length] == 0 ||
                [privateKey length] == 0)
            {
                NSString *error=@"缺少partner或者seller或者私钥";
                NSLog(@"支付宝错误：%@",error);
            }
            
            
            
            /*
             *生成订单信息及签名
             */
            //将商品信息赋予AlixPayOrder的成员变量
            Order *order = [[Order alloc] init];
            order.partner = partner;
            order.sellerID = seller;
            order.outTradeNO = outTradeNO; //订单ID（由商家自行制定）
            order.subject = subject; //商品标题
            order.body = body; //商品描述
            order.totalFee = [NSString stringWithFormat:@"%.2f",totalFee]; //商品价格
            order.notifyURL =  dic[@"notifyurl"]; //回调URL
            
            order.service = @"mobile.securitypay.pay";
            order.paymentType = @"1";
            order.inputCharset = @"utf-8";
            order.itBPay = @"30m";
            //            order.showURL = @"m.alipay.com";
            
            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
            NSString *appScheme = @"fameshopping";
            
            //将商品信息拼接成字符串
            NSString *orderSpec = [order description];
            NSLog(@"orderSpec = %@",orderSpec);
            
            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
            id<DataSigner> signer = CreateRSADataSigner(privateKey);
            NSString *signedString = [signer signString:orderSpec];
            
            //将签名成功字符串格式化为订单字符串,请严格按照该格式
            NSString *orderString = nil;
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    NSLog(@"reslut = %@",resultDic);
                }];
            }
            if (signedString != nil) {
                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                               orderSpec, signedString, @"RSA"];
                
                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                    //            NSLog(@"reslut = %@",resultDic);
                    callback(resultDic);
                }];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
        }

    }];
//    [[[NetworkModel alloc] initWithRequestWithParam:@{@"deal_no":outTradeNO,@"payment":@"alipay"} url:@"/api.php/Pay/online_pay" requestMethod:YTKRequestMethodPost requestType:YTKRequestSerializerTypeHTTP] startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments error:nil];
//        if ([dic[@"code"] intValue] == 200) {
//            if ([partner length] == 0 ||
//                [seller length] == 0 ||
//                [privateKey length] == 0)
//            {
//                NSString *error=@"缺少partner或者seller或者私钥";
//                NSLog(@"支付宝错误：%@",error);
//            }
//            
//            
//            
//            /*
//             *生成订单信息及签名
//             */
//            //将商品信息赋予AlixPayOrder的成员变量
//            Order *order = [[Order alloc] init];
//            order.partner = partner;
//            order.sellerID = seller;
//            order.outTradeNO = outTradeNO; //订单ID（由商家自行制定）
//            order.subject = subject; //商品标题
//            order.body = body; //商品描述
//            order.totalFee = [NSString stringWithFormat:@"%.2f",totalFee]; //商品价格
//            order.notifyURL =  dic[@"notifyurl"]; //回调URL
//            
//            order.service = @"mobile.securitypay.pay";
//            order.paymentType = @"1";
//            order.inputCharset = @"utf-8";
//            order.itBPay = @"30m";
////            order.showURL = @"m.alipay.com";
//            
//            //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
//            NSString *appScheme = kWXAPP_ID;
//            
//            //将商品信息拼接成字符串
//            NSString *orderSpec = [order description];
//            NSLog(@"orderSpec = %@",orderSpec);
//            
//            //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
//            id<DataSigner> signer = CreateRSADataSigner(privateKey);
//            NSString *signedString = [signer signString:orderSpec];
//            
//            //将签名成功字符串格式化为订单字符串,请严格按照该格式
//            NSString *orderString = nil;
//            if (signedString != nil) {
//                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                               orderSpec, signedString, @"RSA"];
//                
//                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                    NSLog(@"reslut = %@",resultDic);
//                }];
//            }
//            if (signedString != nil) {
//                orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
//                               orderSpec, signedString, @"RSA"];
//                
//                [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                    //            NSLog(@"reslut = %@",resultDic);
//                    callback(resultDic);
//                }];
//            }
//        }else{
//            [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
//        }
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        
//    }];
    
    
    
    
    
    
}

@end
