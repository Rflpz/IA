//
//  RLMovieDetailController.m
//  IA
//
//  Created by Rafael Lopez on 8/29/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLMovieDetailController.h"
#import "RLCustomizer.h"
#import "RLRequest.h"
#import "RLGalleryController.h"
@interface RLMovieDetailController ()
@property (strong,nonatomic) RLCustomizer *customizer;
@property (strong, nonatomic) RLRequest *reqObj;
@property (weak, nonatomic) IBOutlet UILabel *lblActors;
@property (weak, nonatomic) IBOutlet UILabel *lblSinopsis;

@end

@implementation RLMovieDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customizer = [[RLCustomizer alloc] init];
    _reqObj = [[RLRequest alloc] init];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[_customizer imageWithImage:[UIImage imageNamed:@"back.png"] scaledToSize:CGSizeMake(20,20)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftButton;
    self.title = [[_movie valueForKey:@"Titulo"] uppercaseString];
    _lblActors.text = [_movie valueForKey:@"Actores"];
    _lblSinopsis.text = [_movie valueForKey:@"Sinopsis"];

}
- (IBAction)showGallery:(id)sender {
    [_reqObj getImagesOfMovieFromDBWithPath:_fileDB withIdImage:[_movie valueForKey:@"Id"] onComplete:^(NSMutableArray *response){
        NSLog(@"%@",response);
        RLGalleryController *galleryController = [[RLGalleryController alloc]initWithNibName:@"RLGalleryController" bundle:nil];
        galleryController.galleryArray = response;
        [self.navigationController pushViewController:galleryController animated:YES];
    } onError:nil];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
