//
//  RLGalleryController.m
//  IA
//
//  Created by Rafael Lopez on 8/29/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLGalleryController.h"
#import "RLCustomizer.h"
#import "RLImageChildController.h"
@interface RLGalleryController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (strong,nonatomic) RLCustomizer *customizer;
@property (strong, nonatomic) UIPageViewController *pageController;

@end

@implementation RLGalleryController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"GALERIA";
    _customizer = [[RLCustomizer alloc] init];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[_customizer imageWithImage:[UIImage imageNamed:@"back.png"] scaledToSize:CGSizeMake(20,20)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftButton;
    [self createPageController];
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createPageController{
    //Page Controller
    NSLog(@"Crea");
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    RLImageChildController *initialViewController = [self viewControllerAtIndex:0];
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}
- (RLImageChildController *)viewControllerAtIndex:(NSUInteger)index {
    
    RLImageChildController *childViewController = [[RLImageChildController alloc] initWithNibName:@"RLImageChildController" bundle:nil];
    childViewController.index = index;
    NSDictionary *image = _galleryArray[index];
    NSLog(@"%@",image);
    NSLog(@"%d",index);
    
    childViewController.URL = [NSString stringWithFormat:@"http://www.cinepolis.com/_MOVIL/iPhone/galeria/thumb/%@",[image valueForKey:@"Archivo"]];
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(RLImageChildController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    index--;
    
    // Decrease the index by 1 to return
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(RLImageChildController *)viewController index];
    
    index++;
    
    if (index == _galleryArray.count) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return _galleryArray.count;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}
@end
