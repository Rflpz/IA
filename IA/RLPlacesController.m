//
//  RLPlacesController.m
//  IA
//
//  Created by Rafael Lopez on 8/28/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLPlacesController.h"
#import "RLPlaceCell.h"
#import "RLMapPlaceController.h"
#import "RLWebController.h"
#import "RLMoviesController.h"
@interface RLPlacesController ()<UITableViewDelegate, UITableViewDataSource, RLMapPlaceDelegate>
@property (strong, nonatomic) RLCustomizer *customizer;
@property (strong, nonatomic) RLRequest *reqObj;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *placesArray;
@end

@implementation RLPlacesController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customizer = [[RLCustomizer alloc] init];
    _reqObj = [[RLRequest alloc] init];
    self.title = @"COMPLEJOS";

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[_customizer imageWithImage:[UIImage imageNamed:@"back.png"] scaledToSize:CGSizeMake(20,20)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(goBack)];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[_customizer imageWithImage:[UIImage imageNamed:@"earth.png"] scaledToSize:CGSizeMake(25,25)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(showMapLocations)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.view.backgroundColor = [_customizer colorFromHexString:@"#295999"];
    _tableView.backgroundColor = [UIColor clearColor];
    
    [_reqObj getPlacesFromDBWithPath:_fileDB onComplete:^(NSMutableArray *response){
        _placesArray = response;
        [self animateTable];
    } onError:^(NSString *error){
        NSLog(@"%@",error);
    }];
}

- (void)showMapLocations{
    RLMapPlaceController *mapPlacesController = [[RLMapPlaceController alloc]initWithNibName:@"RLMapPlaceController" bundle:nil];
    mapPlacesController.showAll = YES;
    mapPlacesController.placesArray = _placesArray;
    [self presentViewController:mapPlacesController animated:YES completion:nil];
}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCustom = @"RLPlaceCell";
    
    RLPlaceCell *cell = (RLPlaceCell *)[tableView dequeueReusableCellWithIdentifier:identifierCustom];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifierCustom owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.placeName.textColor = [_customizer colorFromHexString:@"#ffcb06"];
    }
    NSDictionary *place = _placesArray[indexPath.row];
    cell.placeName.text = [place valueForKey:@"Nombre"];
    cell.placeAddress.text = [place valueForKey:@"Direccion"];
    [cell.placeLocationButton setTag:indexPath.row];
    
    [cell.placeLocationButton addTarget:self action:@selector(showLocation:) forControlEvents:UIControlEventTouchUpInside];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}
- (void)showLocation:(id)sender{
    NSMutableArray *placesToShow = [[NSMutableArray alloc] initWithObjects:_placesArray[[sender tag]], nil];
    RLMapPlaceController *mapPlacesController = [[RLMapPlaceController alloc]initWithNibName:@"RLMapPlaceController" bundle:nil];
    mapPlacesController.showAll = NO;
    mapPlacesController.delegate = self;
    mapPlacesController.placesArray = placesToShow;
    [self presentViewController:mapPlacesController animated:YES completion:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return _placesArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_reqObj getMoviesFromDBWithPath:_fileDB andIdPlace:[_placesArray[indexPath.row] valueForKey:@"Id"] onComplete:^(NSMutableArray *response){
        RLMoviesController *moviesController = [[RLMoviesController alloc]initWithNibName:@"RLMoviesController" bundle:nil];
        moviesController.moviesArray = response;
        moviesController.fileDB = _fileDB;
        [self.navigationController pushViewController:moviesController animated:YES];
    } onError:nil];
}
- (void)didSelectShowRoute:(RLMapPlaceController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
    RLWebController *webController = [[RLWebController alloc] initWithNibName:@"RLWebController" bundle:nil];
    webController.urlToSend = [NSString stringWithFormat:@"https://www.google.com.mx/maps/dir/%@,%@/%@,%@",controller.myLat,controller.myLon,[controller.placesArray[controller.placesArray.count - 1] valueForKey:@"Latitud"],[controller.placesArray[controller.placesArray.count - 1] valueForKey:@"Longitud"]];
    [self.navigationController pushViewController:webController animated:YES];

}
@end
