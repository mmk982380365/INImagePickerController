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
    self.navigationBar.barStyle = UIBarStyleBlackOpaque;
    
    self.toolbarHidden = NO;
    self.toolbar.barStyle = UIBarStyleBlackOpaque;
    
    
    __weak typeof(self) ws = self;
    
    [self.manager fetchAlbums:^{
        [ws.imageListViewController reloadData];
    }];
    
}

-(void)setMaxCount:(NSInteger)maxCount{
    _maxCount = maxCount;
    self.manager.maxSelectedCount = maxCount;
}

-(void)setOnlyLocations:(BOOL)onlyLocations{
    _onlyLocations = onlyLocations;
    self.manager.onlyLocations = onlyLocations;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
