//
//  UpdataAppResult.h
//  kreditbro
//
//  Created by 戴培琼 on 2019/9/1.
//  Copyright © 2019 lai. All rights reserved.
//

#import <KRBaseComponents/KRBaseModel.h>

NS_ASSUME_NONNULL_BEGIN

@interface UpdataAppResult : KRBaseModel
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *path;
@end

NS_ASSUME_NONNULL_END
