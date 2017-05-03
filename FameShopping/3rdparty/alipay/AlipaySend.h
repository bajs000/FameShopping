//
//  AlipaySend.h
//  JMS
//  支付宝支付
//  Created by crly on 15/8/21.
//  Copyright (c) 2015年 sevnce. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order.h"

@interface AlipaySend : NSObject

/**
 *   发起订单支付
 *
 *  @param outTradeNO 订单号
 *  @param subject    商品标题
 *  @param body       商品描述
 *  @param totalFee   商品价格（0.01为1分）
 *  @param callback   支付结果
 */
+(void)toAlipay:(NSString *)outTradeNO withSubject:(NSString *)subject withBody:(NSString *)body withTotalFee:(float)totalFee callback:(void (^)(NSDictionary *))callback;

@end
