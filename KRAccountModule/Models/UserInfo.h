//
//  UserInfo.h
//  SP2P_6.1
//
//  Created by kiu on 14-9-24.
//  Copyright (c) 2014年 EIMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

// 用户ID
@property (nonatomic, copy) NSString *userId;
// 用户名
@property (nonatomic, copy) NSString *userName;

//手机号
@property (nonatomic, copy) NSString *cellPhone;


// 用户密码
@property (nonatomic, copy) NSString *userPwd;
// 用户头像
@property (nonatomic, copy) NSString *userImg;
// 用户等级
@property (nonatomic, copy) NSString *userCreditRating;
// 是否登录 (0.非登陆  1.登录)
@property (nonatomic, copy) NSString *isLogin;
// 信用额度
@property (nonatomic, copy) NSString *userLimit;
// 是否会员
@property (nonatomic, copy) NSString *isVipStatus;

// 是否设置安全手机
@property (nonatomic, assign) BOOL isTeleStatus;
// 是否设置交易密码
@property (nonatomic, assign) BOOL isPayPasswordStatus;
// 是否设置安全问题
@property (nonatomic, assign) BOOL isSecretStatus;
// 设备型号
@property (nonatomic, copy) NSString *deviceType;

// 账户总额
@property (nonatomic, copy) NSString *accountAmount;
// 可用余额
@property (nonatomic, copy) NSString *availableBalance;
// 昵称
@property (nonatomic, strong)  NSString *nickName;
@end
