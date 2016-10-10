//
//  INImageEditViewController.m
//  INImagePickerController
//
//  Created by MaMingkun on 16/10/10.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "INImageEditViewController.h"

@interface INImageEditViewController ()

@property (nonatomic, strong) UIBarButtonItem *confirmButton;

@end

@implementation INImageEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.4392 green:0.8902 blue:0.9569 alpha:1.0];
    
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *fix = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    self.toolbarItems = @[flex,self.confirmButton,fix];
    
}

#pragma mark - userAction

-(void)confirmToSelect:(id)sender{
    
}

#pragma mark - getter

-(UIBarButtonItem *)confirmButton{
    if (_confirmButton == nil) {
        _confirmButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmToSelect:)];
        _confirmButton.tintColor = [UIColor whiteColor];
    }
    return _confirmButton;
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
