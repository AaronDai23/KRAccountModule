//
//  CountryCodeTableViewCell.m
//  kreditbro
//
//  Created by 戴培琼 on 2019/3/26.
//  Copyright © 2019 lai. All rights reserved.
//

#import "CountryCodeTableViewCell.h"
#import "CountryCodeModel.h"

@implementation CountryCodeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(CountryCodeModel *)model {
    _model = model;
    self.titleLaeb.text = [NSString stringWithFormat:@"%@ +%@", model.country, model.code];
//    self.titleLaeb.textColor = [UIColor blueColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
