//
//  UIImage+WDCategory.m
//  Image_extension
//
//  Created by MrWu on 16/8/7.
//  Copyright © 2016年 TTYL. All rights reserved.
//

#import "UIImage+WDCategory.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>

//extern CGImageRef UIGetScreenImage();
@implementation UIImage (WDCategory)

//+ (UIImage *)captureScreen {
//    extern CGImageRef UIGetScreenImage(); // 需要先声明该外部函数
//    CGImageRef screen = UIGetScreenImage();
//    // 获取截屏,获得新图片
//    UIImage *newImage = [UIImage imageWithCGImage:screen];
//    return newImage;
//}

+ (UIImage *)captureView:(UIView *)targetView {
    CGRect rect = targetView.frame;
    UIGraphicsBeginImageContext(rect.size);  //开始绘图
    CGContextRef context = UIGraphicsGetCurrentContext();
    [targetView.layer renderInContext:context];  //调用calayer的方法,图层绘制到context
    //获取context中的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageAtRect:(CGRect)rect {
    // 获取当前Image的CGImage对象
    CGImageRef imageSrc = [self CGImage];
    //获取指定位置图像
    CGImageRef imageRef = CGImageCreateWithImageInRect(imageSrc, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    return image;
}

- (UIImage *)imageByScalingAspectTominSize:(CGSize)targetSize {
    CGSize imageSize = self.size;
    CGFloat imageH = imageSize.height;
    CGFloat imageW = imageSize.width;
    
    CGFloat targetH = targetSize.height;
    CGFloat targetW = targetSize.width;
    
    //定义图片缩放后的宽度和高度
    CGFloat scaleW = targetW;
    CGFloat scaleH = targetH;
    
    CGPoint anchorPoint = CGPointZero;
    
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        CGFloat xFactor = scaleW / imageW;
        CGFloat yFactor = scaleH / imageH;
        //取得x,y缩放因子中较大的一个
        CGFloat scaleFactor = xFactor > yFactor ? xFactor : yFactor;
        scaleW = imageW * scaleFactor;
        scaleH = imageH * scaleFactor;
        
        if (xFactor > yFactor) {
            anchorPoint.y = (targetH - scaleH) * 0.5;
        }else if(xFactor < yFactor) {
            anchorPoint.x = (targetW - scaleW) * 0.5;
        }
    }
    //开始绘图
    UIGraphicsBeginImageContext(targetSize);
    CGRect anchorRect = CGRectZero;
    anchorRect.origin = anchorPoint;
    anchorRect.size.width = scaleW;
    anchorRect.size.height = scaleH;
    //将图片绘制到本区域
    [self drawInRect:anchorRect];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageByScalingAspectToMaxSize:(CGSize)targetSize {
    CGSize imageSize = self.size;
    CGFloat imageH = imageSize.height;
    CGFloat imageW = imageSize.width;
    
    CGFloat targetH = targetSize.height;
    CGFloat targetW = targetSize.width;
    
    //定义图片缩放后的宽度和高度
    CGFloat scaleW = targetW;
    CGFloat scaleH = targetH;
    
    CGPoint anchorPoint = CGPointZero;
    
    if (!CGSizeEqualToSize(imageSize, targetSize)) {
        CGFloat xFactor = scaleW / imageW;
        CGFloat yFactor = scaleH / imageH;
        //取得x,y缩放因子中较大的一个
        CGFloat scaleFactor = xFactor > yFactor ? xFactor : yFactor;
        scaleW = imageW * scaleFactor;
        scaleH = imageH * scaleFactor;
        
        //图片上下填充,充满空白
        if (xFactor < yFactor) {
            anchorPoint.y = (targetH - scaleH) * 0.5;
            //左右填充
        }else if(xFactor > yFactor) {
            anchorPoint.x = (targetW - scaleW) * 0.5;
        }
    }
    //开始绘图
    UIGraphicsBeginImageContext(targetSize);
    CGRect anchorRect = CGRectZero;
    anchorRect.origin = anchorPoint;
    anchorRect.size.width = scaleW;
    anchorRect.size.height = scaleH;
    //将图片绘制到本区域
    [self drawInRect:anchorRect];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
    UIGraphicsBeginImageContext(targetSize);
    CGRect anchorRect = CGRectZero;
    anchorRect.origin = CGPointZero;
    anchorRect.size = targetSize;
    [self drawInRect:anchorRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageRotateByRadians:(CGFloat)radians {
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    CGRect rotateRect = CGRectApplyAffineTransform(CGRectMake(0, 0, self.size.width, self.size.height), t);
    CGSize rotateSize = rotateRect.size;
    //创建绘制位图上下文
    UIGraphicsBeginImageContext(rotateSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, rotateSize.width*0.5, rotateSize.height*0.5);
    CGContextRotateCTM(context, radians);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(-self.size.width*0.5, -self.size.height*0.5, self.size.width, self.size.height), self.CGImage);
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)imageRotateByDegrees:(CGFloat)degrees {
    return [self imageRotateByRadians:degrees * M_PI /180];
}

- (void)saveToDocument:(NSString *)fileName {
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileName];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [UIImagePNGRepresentation(self) writeToFile:path atomically:YES];
        [UIImageJPEGRepresentation(self, 1.0) writeToFile:path atomically:YES];
        
        NSLog(@"---图片保存完成---");
    });
    
}
@end
