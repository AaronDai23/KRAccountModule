//
//  Target_Login.m
//  KRAccountModule
//
//  Created by 戴培琼 on 2020/7/9.
//  Copyright © 2020 戴培琼. All rights reserved.
//

#import "Target_Login.h"
#import "LoginViewController.h"

typedef _Nullable id (^TargetHandler)( NSDictionary * _Nullable parameters);
typedef void (^TargetLoginSuccessBlock)(void);
typedef void (^TargetBackBlock)(void);
typedef void (^TargetRegisterSuccess)(void);
NSString *const kLoginSuccessKey = @"kLoginSuccessKey";
NSString *const kLoginBackKey = @"kLoginBackKey";
NSString *const kLoginRegisterKey = @"kLoginRegisterKey";

@implementation Target_Login
- (UIViewController *)Action_getLoginViewController:(NSDictionary *)params {
    LoginViewController *vc = [[LoginViewController alloc] init];
    vc.loginSuccess = params[kLoginSuccessKey];;
    vc.backBlock = params[kLoginBackKey];
    vc.registerSuccess =  params[kLoginRegisterKey];
    return vc;
}

@end
