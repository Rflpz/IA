//
//  RLMoviesController.m
//  IA
//
//  Created by Rafael Lopez on 8/27/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLMoviesController.h"
#import "RLMovieCell.h"
#import "RLMovieDetailController.h"
@interface RLMoviesController ()
@property (strong, nonatomic) RLCustomizer *customizer;
@property (strong, nonatomic) RLRequest *reqObj;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RLMoviesController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customizer = [[RLCustomizer alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [_customizer colorFromHexString:@"#295999"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[_customizer imageWithImage:[UIImage imageNamed:@"back.png"] scaledToSize:CGSizeMake(20,20)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.title = @"PELICULAS";
    [self animateTable];

}
- (void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifierCustom = @"RLMovieCell";
    
    RLMovieCell *cell = (RLMovieCell *)[tableView dequeueReusableCellWithIdentifier:identifierCustom];
    if (cell == nil){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:identifierCustom owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.movieName.textColor = [_customizer colorFromHexString:@"#ffcb06"];
    }
    NSDictionary *movie = _moviesArray[indexPath.row];
    cell.movieName.text = [[movie valueForKey:@"Titulo"] uppercaseString];
    cell.movieGenere.text = [[movie valueForKey:@"Genero"] uppercaseString];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio{
    return _moviesArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RLMovieDetailController *movieDetailController = [[RLMovieDetailController alloc] initWithNibName:@"RLMovieDetailController" bundle:nil];
    movieDetailController.movie = _moviesArray[indexPath.row];
    movieDetailController.fileDB = _fileDB;
    [self.navigationController pushViewController:movieDetailController animated:YES];
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
