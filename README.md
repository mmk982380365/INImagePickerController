# INImagePickerController

简单的图片选择器

* maxCount **可选择图片的最大数量**

* onlyLocations **只显示定位图片**

* edit **截取图片 正方形区域**


@protocol INImagePickerControllerDelegate <NSObject>
/**
 *  选中图片后的回调 
 *  数组结构:
 *  @[@{INImagePickerControllerOriginalImage:image,INImagePickerControllerLocation:location}]
 *
 *  @param picker     选择器
 *  @param imageArray 结果数组
 */
- (void)INImagePickerController:(INImagePickerController *)picker didFinishPickingMediaWithArray:(NSArray *)imageArray;
/**
 *  取消的代理
 *
 *  @param picker 选择器
 */
- (void)INImagePickerControllerDidCancel:(INImagePickerController *)picker;

@end
