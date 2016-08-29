//
//  RLPlaceCell.h
//  IA
//
//  Created by Rafael Lopez on 8/28/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLPlaceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UIButton *placeLocationButton;
@property (weak, nonatomic) IBOutlet UILabel *placeAddress;

@end
