//
//  RLCitiesController.m
//  IA
//
//  Created by Rafael Lopez on 8/28/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLCitiesController.h"

@interface RLCitiesController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) RLCustomizer *customizer;
@property (strong, nonatomic) RLRequest *reqObj;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *citiesArray;
@property (weak, nonatomic)  UIRefreshControl *refreshControl;

@end

@implementation RLCitiesController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customizer = [[RLCustomizer alloc] init];
    _reqObj = [[RLRequest alloc] init];
    [self customizeView];
    [self refreshInfo:_refreshControl];

   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)customizeView{
    self.navigationController.navigationBar.barTintColor = [_customizer colorFromHexString:@"#295999"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[_customizer colorFromHexString:@"#FFFFFF"], NSForegroundColorAttributeName, [UIFont fontWithName:@"Avenir-Medium" size:18], NSFontAttributeName, nil];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[[_customizer imageWithImage:[UIImage imageNamed:@"lg-cinepolis.png"] scaledToSize:CGSizeMake(103.5,26.5)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    self.view.backgroundColor = [_customizer colorFromHexString:@"#295999"];
    
    UIRefreshControl *refreshControl= [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self
                       action:@selector(refreshInfo:)
             forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [_customizer colorFromHexString:@"#ffcb06"];
    [_tableView addSubview:refreshControl];
    _refreshControl = refreshControl;
}
- (void)refreshInfo:(UIRefreshControl *) sender {
    [self.refreshControl beginRefreshing];
    [_reqObj getAllCitiesOnComplete:^(NSDictionary *response){
        NSLog(@"%@",response);
        _citiesArray = [[NSMutableArray alloc] init];
        for(NSDictionary *city in response){
            [_citiesArray addObject:city];
            [self animateTable];
        }
        [sender endRefreshing];

    } onError:^(NSError *error){
        [sender endRefreshing];
    }];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCustom = @"RLCityCell";
    
    RLCityCell *cell = (RLCityCell *)[tableView dequeueReusableCellWithIdentifier:identifierCustom];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifierCustom owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.cityName.textColor = [_customizer colorFromHexString:@"#ffcb06"];
        cell.cityState.textColor = [_customizer colorFromHexString:@"#ffcb06"];
    }
    NSDictionary *city = _citiesArray[indexPath.row];
    cell.cityState.text = [[city valueForKey:@"Estado"] uppercaseString];
    cell.cityName.text = [[city valueForKey:@"Nombre"] uppercaseString];
    cell.cityCountry.text = [[city valueForKey:@"Pais"] uppercaseString];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return _citiesArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)animateTable{
    [_tableView reloadData];
    NSArray *cells = _tableView.visibleCells;
    ;
    for (UITableViewCell  *cell in cells) {
        cell.transform = CGAffineTransformMakeTranslation(0, _tableView.bounds.size.height);
    }
    int index = 0;
    for (UITableViewCell  *cell in cells) {
        [UIView animateWithDuration:1.5f delay:0.05f * index
             usingSpringWithDamping:0.8f initialSpringVelocity:0.0f
                            options:0 animations:^{
                                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                            } completion:nil];
        index++;
    }
}
@end