//
//  ViewController.m
//  FrameworkBuilding
//
//  Created by MaMingkun on 16/9/6.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "ViewController.h"
#import "INImagePickerController.h"

@interface ViewController () <INImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)btnAct:(id)sender {
    INImagePickerController *picker = [[INImagePickerController alloc] init];
//    picker.onlyLocations = YES;
    picker.delegate = self;
    picker.edit = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)INImagePickerController:(INImagePickerController *)picker didFinishPickingMediaWithArray:(NSArray *)imageArray{
    
    NSLog(@"%@",imageArray);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)INImagePickerControllerDidCancel:(INImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
