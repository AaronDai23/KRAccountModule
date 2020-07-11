//
//  LoginViewController.h
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/22.
//  Copyright © 2019 lai. All rights reserved.
//

#import <KRBaseComponents/BasicViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoginViewController : BasicViewController
@property (nonatomic, copy) void(^loginSuccess)(void);
@property (nonatomic, copy) void(^backBlock)(void);
@property (nonatomic, copy) void(^registerSuccess)(void);
@end

NS_ASSUME_NONNULL_END
