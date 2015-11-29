//
//  Utility.h
//  MITBBS_TEST
//
//  Created by Juniorchen on 5/9/14.
//  Copyright (c) 2014 Juniorchen. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface Utility : NSObject

//获取文本宽高
+(CGSize)currentSizeWithContent:(NSString *)content font:(UIFont *)font cgSize:(CGSize)cgsize;
+(CGSize)currentSizeWithContent:(NSString *)content font:(UIFont *)font cgSize:(CGSize)cgsize lineSpace:(CGFloat)lineSpace;
+(CGFloat)getSizeByContent:(NSString *)content withWidth:(CGFloat)contentWidth withFontSize:(CGFloat)fontSize;//获取文本高度
+(CGFloat)getWidthByContent:(NSString *)content withHeight:(CGFloat)contentheight withFontSize:(CGFloat)fontSize;//获取文本宽度

+(BOOL)RegxCheckStr:(NSString *)st;//字符串格式校验
+(NSString *)numberSwitch:(NSString *)number;//极端处理
+ (void)showHUD:(NSString *)msg;//提示信息
+ (void)showIMPHUD:(NSString *)msg;
+ (void)showHUD:(NSString *)msg afterDelay:(NSTimeInterval)delay;
+ (void)showIMPHUD:(NSString *)msg  afterDelay:(NSTimeInterval)delay;
+(BOOL)isValidateEmail:(NSString *)email;//检验邮箱
+(BOOL)isMultiLine:(NSString*)text withWidth:(CGFloat)width withFontSize:(int)fontsize;
+ (CGFloat)measureHeightOfUITextView:(UITextView *)atextView andLineSpace:(int)lineSpace;//UITextView文本高度
+ (CATransition*)createAnimationWithType:(NSString *)type withsubtype:(NSString *)subtype withDuration:(double)duration;
+(UIImage*)imageCrop:(UIImage*)original;//剪切方形图片
+(UIImage*)imageCropTo:(UIImage*)original;
+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;//毛玻璃效果
+(void)cirecleImg:(UIImageView *)imgv withImg:(UIImage *)img;//绘制圆形图片
+(NSUInteger) unicodeLengthOfString: (NSString *) text;//字节数
+(NSData*)compressImage:(UIImage*)img;//压缩图片

+(UIImage*)imageByImg:(UIImage *)sourceImage ScalingForSize:(CGSize)targetSize;//等比缩放图片size
+ (UIColor *)getColor:(NSString *)hexColor;//颜色转换
+ (UIImage *)getImgByColor:(UIColor *)color bySize:(CGRect)rect;//根据color画个img 做button图

//绘制一个三角形
+ (UIImage *)getTriangleWithColor:(UIColor *)color;
//时间转换
+ (NSString *)getTheRightTimeStrWith:(id)timeObj;

//聊天消息时间转换
+ (NSString *)getMessageRightTimeWith:(NSTimeInterval)timeNum;

//聊天界面时间
+ (NSString *)getChatRightTimeWiht:(NSTimeInterval )timeNum;
//新规则的聊天时间
+ (NSString *)getNewChatRightTimeWiht:(NSTimeInterval )timeNum;
@end
