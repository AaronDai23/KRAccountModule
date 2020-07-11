//
//  RegNextTableViewCell.h
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/24.
//  Copyright © 2019 lai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegNextTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString *phone;//手机号
@property (nonatomic, copy) NSString *name;//用户名
// 验证码
@property (nonatomic, copy) NSString *verifyCode;
@property(nonatomic ,weak) UIViewController *deleagate;
@property (nonatomic, assign)  NSInteger inviteCodeStatus;
@end

NS_ASSUME_NONNULL_END
