//
//  INImageEditViewController.m
//  INImagePickerController
//
//  Created by MaMingkun on 16/10/10.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "INImageEditViewController.h"
#import "INImageBorderView.h"
#import "INImagePickerController.h"

@interface INImageEditViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *confirmButton;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) INImageBorderView *borderView;

@property (nonatomic, strong) UIImage *originalImage;

@property (nonatomic, strong) UIImage *editedImage;

@end

@implementation INImageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.4392 green:0.8902 blue:0.9569 alpha:1.0];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.toolbarItems = @[flex,self.confirmButton,fix];
    
    [self.containerView addSubview:self.imageView];
    [self.scrollView addSubview:self.containerView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.borderView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self.view addGestureRecognizer:singleTap];
    [self.view addGestureRecognizer:doubleTap];
    
    
    self.containerView.backgroundColor = [UIColor redColor];
    
    INImagePickerController *picker = (INImagePickerController *)self.navigationController;
    INImageManager *manager = picker.manager;
    
    [manager requestImageForAsset:self.asset size:[INImageManager maxImageSize] resizeMode:INImagePickerResizeModeExact completion:^(UIImage *result,INImageAsset *oldAsset) {
        
//        self.originalImage = result;
        self.imageView.image = result;
        
        if (result.size.width > result.size.height) {
            self.imageView.frame = CGRectMake(0, 0, (Screen_Width) * (result.size.width / result.size.height), Screen_Width);
        }else{
            self.imageView.frame = CGRectMake(0, 0, Screen_Width, (Screen_Width)* (result.size.height / result.size.width));
        }
        
        CGRect rect = self.containerView.frame;
        rect.size = CGSizeMake(self.imageView.frame.size.width, self.imageView.frame.size.height);
        
        self.containerView.frame = rect;
        
        self.scrollView.contentSize = self.imageView.frame.size;
        
    }];
    
    
}

#pragma mark - userAction

-(void)confirmToSelect:(id)sender{
    
    self.confirmButton.enabled = NO;
    
    CGRect targetRect;
    targetRect.origin.x = 0;
    targetRect.origin.y = self.borderView.center.y - self.borderView.frame.size.width * 0.5;
    targetRect.size = CGSizeMake(self.borderView.frame.size.width, self.borderView.frame.size.width);
    
    CGRect theRect = [self.borderView convertRect:targetRect toView:self.imageView];
    
    
    
    float scale = self.imageView.image.size.width / self.imageView.frame.size.width;
    
    theRect.origin.x *= scale;
    theRect.origin.y *= scale;
    theRect.size.width *= scale;
    theRect.size.height *= scale;
    
    INImagePickerController *picker = (INImagePickerController *)self.navigationController;
    INImageManager *manager = picker.manager;
    
    [manager requestEditedImageWithAsset:self.asset clipRect:theRect result:^(NSArray *resultArray) {
        if ([(INImagePickerController *)self.navigationController delegate] && [[(INImagePickerController *)self.navigationController delegate] conformsToProtocol:@protocol(INImagePickerControllerDelegate)] && [[(INImagePickerController *)self.navigationController delegate] respondsToSelector:@selector(INImagePickerController:didFinishPickingMediaWithArray:)]) {
            [[(INImagePickerController *)self.navigationController delegate] INImagePickerController:(INImagePickerController *)self.navigationController didFinishPickingMediaWithArray:resultArray];
            
        }
    }];
    
    
    
    
    
    
}

-(void)singleTapAction:(UIGestureRecognizer *)recognizer{
//    if (self.navigationController.navigationBarHidden == NO) {
//        
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//        [self.navigationController setToolbarHidden:YES animated:YES];
//        self.scrollView.contentInset = UIEdgeInsetsMake(self.borderView.frame.origin.y, 0, self.borderView.frame.origin.y, 0);
//    }else{
//        self.scrollView.contentInset = UIEdgeInsetsMake(self.borderView.frame.origin.y - self.navigationController.navigationBar.frame.size.height, 0, self.borderView.frame.origin.y - self.navigationController.navigationBar.frame.size.height, 0);
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        [self.navigationController setToolbarHidden:NO animated:YES];
//        
//    }
}

-(void)doubleTapAction:(UIGestureRecognizer *)recognizer{
    if (self.scrollView.zoomScale > 1.0f) {
        [self.scrollView setZoomScale:1.0 animated:YES];
    }else {
        CGPoint touchPoint = [recognizer locationInView:self.imageView];
        CGFloat newZoomScale = self.scrollView.maximumZoomScale;
        CGFloat xsize = self.view.frame.size.width / newZoomScale;
        CGFloat ysize = self.view.frame.size.height / newZoomScale;
        [self.scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - scrollView delegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.containerView;
}

#pragma mark - getter

-(UIBarButtonItem *)confirmButton{
    if (_confirmButton == nil) {
        _confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmToSelect:)];
        _confirmButton.tintColor = [UIColor whiteColor];
    }
    return _confirmButton;
}

-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.maximumZoomScale = 4.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bouncesZoom = YES;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.delegate = self;
        
        CGRect targetRect;
        targetRect.origin.x = 0;
        targetRect.origin.y = self.borderView.center.y - self.borderView.frame.size.width * 0.5;
        targetRect.size = CGSizeMake(self.borderView.frame.size.width, self.borderView.frame.size.width);
        
        _scrollView.contentInset = UIEdgeInsetsMake(targetRect.origin.y - self.navigationController.navigationBar.frame.size.height, 0, targetRect.origin.y - self.navigationController.navigationBar.frame.size.height, 0);
    }
    return _scrollView;
}

-(UIView *)containerView{
    if (_containerView == nil) {
        _containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _containerView;
}

-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

-(INImageBorderView *)borderView{
    if (_borderView == nil) {
        _borderView = [[INImageBorderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _borderView.center = CGPointMake(_borderView.center.x, self.view.center.y);
        _borderView.userInteractionEnabled = NO;
    }
    return _borderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
