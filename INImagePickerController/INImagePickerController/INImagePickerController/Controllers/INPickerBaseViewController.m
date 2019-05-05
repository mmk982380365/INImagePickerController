//
//  INPickerBaseViewController.m
//  INImagePickerControllerDemo
//
//  Created by Yuuki on 16/9/5.
//  Copyright © 2016年 Yuuki. All rights reserved.
//

#import "INPickerBaseViewController.h"

@interface INPickerBaseViewController ()

@end

@implementation INPickerBaseViewController

- (void)dealloc
{
#ifdef DEBUG
    NSLog(@"%@ class dealloc",NSStringFromClass(self.class));
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
