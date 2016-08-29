//
//  RLCitiesController.m
//  IA
//
//  Created by Rafael Lopez on 8/28/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLCitiesController.h"
#import <KVNProgress.h>
#import "RLPlacesController.h"
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


- (void)customizeView{
    self.navigationController.navigationBar.barTintColor = [_customizer colorFromHexString:@"#295999"];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[_customizer colorFromHexString:@"#ffcb06"], NSForegroundColorAttributeName, [UIFont fontWithName:@"Avenir-Medium" size:18], NSFontAttributeName, nil];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *city = _citiesArray[indexPath.row];
    [KVNProgress showWithStatus:@"Cargando..."];
    RLPlacesController *placesController = [[RLPlacesController alloc]initWithNibName:@"RLPlacesController" bundle:nil];
    placesController.fileDB = [NSString stringWithFormat:@"db-%@.sqlite",[city valueForKey:@"Id"]];;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if (![user valueForKey:[[city valueForKey:@"Id"] stringValue]]) {
            [_reqObj getMoviesByCityWithID:[city valueForKey:@"Id"] onComplete:^(NSString *response){
                NSLog(@"File saved at %@",response);
                [user setObject:@"1" forKey:[[city valueForKey:@"Id"] stringValue]];
                [user synchronize];
                [KVNProgress showSuccessWithStatus:@"Listo" completion:^(void){
                    [KVNProgress dismiss];
                    [self.navigationController pushViewController:placesController animated:YES];
                }];
            } onError:^(NSString *error){
                [KVNProgress showErrorWithStatus:@"Vuelve a intentarlo" completion:^(void){
                    [KVNProgress dismiss];
                }];
            }];
            
        }else{
            
            [KVNProgress showSuccessWithStatus:@"Listo" completion:^(void){
                [KVNProgress dismiss];
                [self.navigationController pushViewController:placesController animated:YES];
            }];
        }
    });
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
