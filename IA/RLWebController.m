//
//  RLWebController.m
//  IA
//
//  Created by Rafael Lopez on 8/29/16.
//  Copyright © 2016 Rflpz. All rights reserved.
//

#import "RLWebController.h"
#import "KVNProgress.h"

@interface RLWebController ()
@property (strong, nonatomic) RLCustomizer *customizer;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation RLWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    _customizer = [[RLCustomizer alloc] init];

    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[[_customizer imageWithImage:[UIImage imageNamed:@"lg-cinepolis.png"] scaledToSize:CGSizeMake(103.5,26.5)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [KVNProgress showWithStatus:@"Cargando contenido"];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: [NSURL URLWithString: _urlToSend ] cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [self.webView loadRequest: request];
    
    self.webView.scalesPageToFit = YES;
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[_customizer imageWithImage:[UIImage imageNamed:@"back.png"] scaledToSize:CGSizeMake(20,20)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = leftButton;
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)goBack{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    if (webView.isLoading)
        return;
    else{
        [KVNProgress showSuccessWithStatus:@"Listo"
                                    onView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [KVNProgress dismiss];
        });
    }
}

@end
