//
//  ViewController.m
//  INImagePickerControllerDemo
//
//  Created by MaMingkun on 16/9/6.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "ViewController.h"
#import <INImagePickerController/INImagePickerController.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<UINavigationControllerDelegate,INImagePickerControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
}

- (IBAction)showPickerView:(UIBarButtonItem *)sender {
    INImagePickerController *picker = [[INImagePickerController alloc] init];
//    picker.onlyLocations = YES;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.imageView.image = self.dataArray[indexPath.row][INImagePickerControllerOriginalImage];
    
    if (self.dataArray[indexPath.row][INImagePickerControllerLocation]) {
        CLLocation *location = self.dataArray[indexPath.row][INImagePickerControllerLocation];
        CGPoint point = CGPointMake(location.coordinate.latitude, location.coordinate.longitude);
        cell.textLabel.text = NSStringFromCGPoint(point);
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - picker delegate

-(void)INImagePickerControllerDidCancel:(INImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)INImagePickerController:(INImagePickerController *)picker didFinishPickingMediaWithArray:(NSArray *)imageArray{
    [picker dismissViewControllerAnimated:YES completion:^{
        

        
    }];
    [self.dataArray addObjectsFromArray:imageArray];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
