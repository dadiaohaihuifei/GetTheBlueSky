//
//  UIImage+WDCategory.h
//  Image_extension
//
//  Created by MrWu on 16/8/7.
//  Copyright © 2016年 TTYL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WDCategory)

/** 对指定UI控件进行截图 */
+(UIImage *)captureView:(UIView *)targetView;

/** 调用私有API不通过 */
//+(UIImage *)captureScreen;

/** 抓取指定位置 */
- (UIImage *)imageAtRect:(CGRect)rect;

/** 适应最短边,可能另一条边更长 */
- (UIImage *)imageByScalingAspectTominSize:(CGSize)targetSize;

/** 适应最长边,可能另一条边更短 */
- (UIImage *)imageByScalingAspectToMaxSize:(CGSize)targetSize;

/** 不保持图片纵横比缩放 */
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

/** 对图片按弧度进行旋转 */
- (UIImage *)imageRotateByRadians:(CGFloat)radians;

/** 对图片按角度进行旋转 */
- (UIImage *)imageRotateByDegrees:(CGFloat)degrees;

/** 保存图片 */
- (void)saveToDocument:(NSString *)fileName;
@end
