//
//  CountryCodeModel.h
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/24.
//  Copyright © 2019 lai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CountryCodeModel : NSObject
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *icon;
+ (instancetype)codeModelWithCode:(NSString *)code icon:(NSString *)icon country:(NSString *)country;
@end

NS_ASSUME_NONNULL_END
