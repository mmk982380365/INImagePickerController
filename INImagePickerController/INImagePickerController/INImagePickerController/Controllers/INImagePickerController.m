//
//  INImagePickerController.m
//  INImagePickerControllerDemo
//
//  Created by Yuuki on 16/9/2.
//  Copyright © 2016年 Yuuki. All rights reserved.
//

#import "INImagePickerController.h"
#import "INImageListViewController.h"
#import "INLoadingView.h"

NSString * const INImagePickerControllerOriginalImage = @"INImagePickerControllerOriginalImage";
NSString * const INImagePickerControllerLocation = @"INImagePickerControllerLocation";
NSString * const INImagePickerControllerEditedImage = @"INImagePickerControllerEditedImage";
@interface INImagePickerController ()

@property (nonatomic, strong) INImageListViewController *imageListViewController;

@property (nonatomic, strong, readwrite) INImageManager *manager;

@property (nonatomic, strong) INLoadingView *loadingView;

@end

@implementation INImagePickerController


- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%@ class dealloc",NSStringFromClass(self.class));
#endif
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.manager = [[INImageManager alloc] init];
        
        self.imageListViewController = [[INImageListViewController alloc] init];
        self.viewControllers = @[self.imageListViewController];
        
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //导航栏样式
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    //显示toolBar
    self.toolbarHidden = NO;
    self.toolbar.barStyle = UIBarStyleBlackOpaque;
    
    [self showLoading];
    
    __weak typeof(self) ws = self;
    //获取手机相册 完成后刷新列表
    [self.manager fetchAlbums:^{
        [ws.imageListViewController reloadData];
        [self hideLoading];
    }];
    
}

- (void)showLoading {
    self.loadingView = [[INLoadingView alloc] init];
    self.loadingView.alpha = 0;
    [self.view addSubview:self.loadingView];
    [UIView animateWithDuration:0.25 animations:^{
        self.loadingView.alpha = 1;
    }];
}

- (void)hideLoading {
    [UIView animateWithDuration:0.25 animations:^{
        self.loadingView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.loadingView removeFromSuperview];
    }];
}

#pragma mark - setter
//设置最大选择的数量
-(void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    self.manager.maxSelectedCount = maxCount;
}
//设置是否只显示含定位信息的图片
-(void)setOnlyLocations:(BOOL)onlyLocations{
    _onlyLocations = onlyLocations;
    self.manager.onlyLocations = onlyLocations;
}

-(void)setEdit:(BOOL)edit{
    _edit = edit;
    if (edit) {
        self.maxCount = 1;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
