//
//  ViewController.m
//  FrameworkBuilding
//
//  Created by MaMingkun on 16/9/6.
//  Copyright © 2016年 MaMingkun. All rights reserved.
//

#import "ViewController.h"
#import "INImagePickerController.h"

@interface ViewController () <INImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *originalImage;
@property (weak, nonatomic) IBOutlet UIImageView *clipImage;
@property (weak, nonatomic) IBOutlet UISwitch *editBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)switchAct:(UISwitch *)sender {
    if (sender.isOn) {
        self.collectionView.hidden = YES;
    }else{
        self.collectionView.hidden = NO;
    }
}

- (IBAction)btnAct:(id)sender {
    INImagePickerController *picker = [[INImagePickerController alloc] init];
//    picker.onlyLocations = YES;
    picker.delegate = self;
    picker.edit = self.editBtn.on;
    [self presentViewController:picker animated:YES completion:nil];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    
    UIImageView *imageView = [cell.contentView viewWithTag:23333];
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = 23333;
        [cell.contentView addSubview:imageView];
    }
    
    UILabel *locationLbl = [cell.contentView viewWithTag:111];
    if (locationLbl == nil) {
        locationLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 40)];
        locationLbl.tag = 111;
        locationLbl.text = @"有定位!";
        locationLbl.textColor = [UIColor redColor];
        locationLbl.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:locationLbl];
    }
    
    NSDictionary *dict = self.dataArray[indexPath.item];
    
    UIImage *image = dict[INImagePickerControllerOriginalImage];
    imageView.image = image;
    
    if (dict[INImagePickerControllerLocation]) {
        locationLbl.hidden = NO;
    }else{
        locationLbl.hidden = YES;
    }
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(void)INImagePickerController:(INImagePickerController *)picker didFinishPickingMediaWithArray:(NSArray *)imageArray{
    
    NSLog(@"%@",imageArray);
    if (self.editBtn.isOn) {
        NSDictionary *dict = imageArray.firstObject;
        
        UIImage *originalImage = dict[INImagePickerControllerOriginalImage];
        UIImage *editedImage = dict[INImagePickerControllerEditedImage];
        self.originalImage.image = originalImage;
        self.clipImage.image = editedImage;
        
    }else{
        self.dataArray = imageArray;
        [self.collectionView reloadData];
    }
    
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
