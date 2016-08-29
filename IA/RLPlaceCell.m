//
//  RLPlaceCell.m
//  IA
//
//  Created by Rafael Lopez on 8/28/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLPlaceCell.h"

@implementation RLPlaceCell
@synthesize placeName = _placeName;
@synthesize placeLocationButton = _placeLocationButton;
@synthesize placeAddress = _placeAddress;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
