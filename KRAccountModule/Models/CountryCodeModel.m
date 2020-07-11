//
//  CountryCodeModel.m
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/24.
//  Copyright © 2019 lai. All rights reserved.
//

#import "CountryCodeModel.h"

@implementation CountryCodeModel
+ (instancetype)codeModelWithCode:(NSString *)code icon:(NSString *)icon country:(NSString *)country{
    CountryCodeModel *model = [[CountryCodeModel alloc] init];
    model.code = code;
    model.icon = icon;
    model.country = country;
    return model;
}

@end
