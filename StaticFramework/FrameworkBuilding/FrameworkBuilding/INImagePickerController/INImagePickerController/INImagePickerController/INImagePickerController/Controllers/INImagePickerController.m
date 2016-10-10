//
//  INImagePickerController.m
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/2.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "INImagePickerController.h"
#import "INImageListViewController.h"
//#import "UIView+Position.h"

NSString * const INImagePickerControllerOriginalImage = @"INImagePickerControllerOriginalImage";
NSString * const INImagePickerControllerLocation = @"INImagePickerControllerLocation";

@interface INImagePickerController ()

@property (nonatomic, strong) INImageListViewController *imageListViewController;

@property (nonatomic, strong, readwrite) INImageManager *manager;

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
    
    
    __weak typeof(self) ws = self;
    //获取手机相册 完成后刷新列表
    [self.manager fetchAlbums:^{
        [ws.imageListViewController reloadData];
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
