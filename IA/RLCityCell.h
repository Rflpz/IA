//
//  RLCityCell.h
//  IA
//
//  Created by Rafael Lopez on 8/28/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RLCityCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *cityState;
@property (weak, nonatomic) IBOutlet UILabel *cityCountry;
@property (weak, nonatomic) IBOutlet UIButton *cityNextButton;

@end
