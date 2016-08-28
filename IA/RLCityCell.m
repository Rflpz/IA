//
//  RLCityCell.m
//  IA
//
//  Created by Rafael Lopez on 8/28/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLCityCell.h"

@implementation RLCityCell
@synthesize cityName = _cityName;
@synthesize cityState = _cityState;
@synthesize cityCountry = _cityCountry;
@synthesize cityNextButton = _cityNextButton;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
