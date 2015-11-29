//
//  Utility.m
//  MITBBS_TEST
//
//  Created by Juniorchen on 5/9/14.
//  Copyright (c) 2014 Juniorchen. All rights reserved.
//

#import "Utility.h"
#import <Social/Social.h>
#import <Accelerate/Accelerate.h>
#import "MBProgressHUD.h"
#import "NSDate+Exts.h"


@implementation Utility

//根据文本的内容，计算字符串的大小
//根据换行方式和字体的大小，已经计算的范围来确定字符串的size
+(CGSize)currentSizeWithContent:(NSString *)content font:(UIFont *)font cgSize:(CGSize)cgsize{
    CGFloat version=[[UIDevice currentDevice].systemVersion floatValue];
    CGSize size;
    //计算size， 7之后有新的方法
    if (version>=7.0) {
        //得到一个设置字体属性的字典
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        //optinos 前两个参数是匹配换行方式去计算，最后一个参数是匹配字体去计算
        //attributes 传入的字体
        //boundingRectWithSize 计算的范围
        size=[content boundingRectWithSize:cgsize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    }else{
        //ios7以前
        //根据字号和限定范围还有换行方式计算字符串的size，label中的font 和linbreak要与此一致
        //CGSizeMake(215, 999) 横向最大计算到215，纵向Max999
        size=[content sizeWithFont:font constrainedToSize:cgsize lineBreakMode:NSLineBreakByCharWrapping];
    }
    return size;
}
+(CGSize)currentSizeWithContent:(NSString *)content font:(UIFont *)font cgSize:(CGSize)cgsize lineSpace:(CGFloat)lineSpace{
    CGFloat version=[[UIDevice currentDevice].systemVersion floatValue];
    CGSize size;
    //计算size， 7之后有新的方法
    if (version>=7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = lineSpace;
        //        NSDictionary *attributes = @{NSParagraphStyleAttributeName:paragraphStyle};
        //       [[NSAttributedString alloc]initWithString:content attributes:attributes];
        //得到一个设置字体属性的字典
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil];
        //optinos 前两个参数是匹配换行方式去计算，最后一个参数是匹配字体去计算
        //attributes 传入的字体
        //boundingRectWithSize 计算的范围
        size=[content boundingRectWithSize:cgsize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    }else{
        //ios7以前
        //根据字号和限定范围还有换行方式计算字符串的size，label中的font 和linbreak要与此一致
        //CGSizeMake(215, 999) 横向最大计算到215，纵向Max999
        size=[content sizeWithFont:font constrainedToSize:cgsize lineBreakMode:NSLineBreakByCharWrapping];
    }
    return size;
}

#pragma mark - 获取文本高度

+(CGFloat)getSizeByContent:(NSString *)content withWidth:(CGFloat)contentWidth withFontSize:(CGFloat)fontSize{
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    if (![content isKindOfClass:[NSString class]]) {
        return 0;
    }
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 900) lineBreakMode:UILineBreakModeTailTruncation];
    return size.height;
}

#pragma mark -  获取文本宽度

+(CGFloat)getWidthByContent:(NSString *)content withHeight:(CGFloat)contentheight withFontSize:(CGFloat)fontSize{
    if (![content isKindOfClass:[NSString class]]) {
        return 0;
    }
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(900, contentheight) lineBreakMode:UILineBreakModeTailTruncation];
    return size.width;
}

#pragma mark - 多行文本判断

+(BOOL)isMultiLine:(NSString*)text withWidth:(CGFloat)width withFontSize:(int)fontsize{
    CGFloat singleLine = [Utility getSizeByContent:@"mit" withWidth:width withFontSize:fontsize];
    CGFloat height = [Utility getSizeByContent:text withWidth:width withFontSize:fontsize];
    //LogBlue(@"高度%f",height);
    return (height>singleLine?YES:NO);
}

#pragma mark - 提示信息
+ (void)showHUD:(NSString *)msg{
    return [Utility showHUD:msg afterDelay:1.5];
}
+ (void)showHUD:(NSString *)msg afterDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows objectAtIndex:0] animated:YES];
    // Configure for text only and offset down
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = msg;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}
+ (void)showIMPHUD:(NSString *)msg{
    return [Utility showIMPHUD:msg afterDelay:1.5];
}
+ (void)showIMPHUD:(NSString *)msg  afterDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows objectAtIndex:0] animated:YES];
    // Configure for text only and offset down
    hud.userInteractionEnabled = NO;
    hud.tag = 1;
    //hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = msg;
    [hud setLabelFont:[UIFont systemFontOfSize:17]];
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:delay];
}

#pragma mark - 数字转换
+(NSString *)numberSwitch:(NSString *)number{
    int num = [number intValue];
    if (num < 10000) {
        return number;
    }else{
        float count = (float)(num)/10000;
        if ((int)(10*(count-(int)count)) == 0) {
            return [NSString stringWithFormat:@"%d万+",(int)count];
        }
        return [NSString stringWithFormat:@"%0.1f万+",count];
    }
}

#pragma mark - 邮箱校验
+(BOOL)isValidateEmail:(NSString *)email {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

#pragma mark - UITextView文本高度
+ (CGFloat)measureHeightOfUITextView:(UITextView *)atextView andLineSpace:(int)lineSpace
{
    if (!atextView.text.length) {
        return 0;
    }
    __weak UITextView *textView = atextView;
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingTextView, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = textView.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = textView.textContainerInset;
        UIEdgeInsets contentInsets = textView.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + textView.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = textView.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", textView.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        if (lineSpace) {
            paragraphStyle.maximumLineHeight = textView.font.pointSize+lineSpace;
            paragraphStyle.minimumLineHeight = textView.font.pointSize+lineSpace;
        }
        
        NSDictionary *attributes = @{ NSFontAttributeName: textView.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        
        return measuredHeight;
    }
    else
    {
        return textView.contentSize.height;
    }
}
#pragma mark - 动画
+ (CATransition*)createAnimationWithType:(NSString *)type withsubtype:(NSString *)subtype withDuration:(double)duration{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f;
    
    if (duration) {
        animation.duration = duration;
    }
    
    //	animation.fillMode = kCAFillModeForwards;
    //    animation.type = kCATransitionMoveIn;
    animation.type = type;
    //    animation.subtype = kCATransitionFromTop;
    animation.subtype = subtype;
    return animation;
}


#pragma mark - 数据校验:注册修改信息
+(BOOL)RegxCheckStr:(NSString *)st {
    NSString * regex = @"^[0-9]{6}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:st];
    return isMatch;
}

#pragma mark - 图片剪裁

+(UIImage*)imageCrop:(UIImage*)original
{
    UIImage *ret = nil;
    
    // This calculates the crop area.
    
    float originalWidth  = original.size.width;
    float originalHeight = original.size.height;
    
    float edge = fminf(originalWidth, originalHeight);
    
    float posX = (originalWidth   - edge) / 2.0f;
    float posY = (originalHeight  - edge) / 2.0f;
    
    
    CGRect cropSquare = CGRectMake(posX, posY,
                                   edge, edge);
    if(original.imageOrientation == UIImageOrientationLeft ||
       original.imageOrientation == UIImageOrientationRight)
    {
        cropSquare = CGRectMake(posY, posX,
                                edge, edge);
        
    }
    else
    {
        cropSquare = CGRectMake(posX, posY,
                                edge, edge);
    }
    
    // This performs the image cropping.
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], cropSquare);
    
    ret = [UIImage imageWithCGImage:imageRef
                              scale:original.scale
                        orientation:original.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return ret;
}

#pragma mark - 字符个数
+(NSUInteger) unicodeLengthOfString: (NSString *) text {
    NSUInteger asciiLength = 0;
    for (NSUInteger i = 0; i < text.length; i++) {
        unichar uc = [text characterAtIndex: i];
        asciiLength += isascii(uc) ? 1 : 2;
    }
    NSUInteger unicodeLength = asciiLength / 2;
    
    if(asciiLength % 2) {
        unicodeLength++;
    }
    
    return unicodeLength;
}

#pragma mark - 圆形图片
+(void)cirecleImg:(UIImageView *)imgv withImg:(UIImage *)img{
    UIGraphicsBeginImageContextWithOptions(imgv.bounds.size, NO, [UIScreen mainScreen].scale);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    UIBezierPath* ovalPath = [UIBezierPath bezierPathWithRoundedRect:imgv.bounds
                                                        cornerRadius:imgv.bounds.size.width/2];
    [[UIColor redColor]set];
    [ovalPath addClip];
    
    // Draw your image
    
    [[Utility imageCrop:img] drawInRect:imgv.bounds];
    [[UIImage imageNamed:@"border"] drawInRect:CGRectMake(imgv.bounds.origin.x-0.5, imgv.bounds.origin.y-0.5, imgv.bounds.size.width+1, imgv.bounds.size.height+1)];
    
    // Get the image, here setting the UIImageView image
    imgv.image = UIGraphicsGetImageFromCurrentImageContext();
    imgv.backgroundColor = [UIColor clearColor];
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
}

#pragma mark - 压缩图片

+(NSData*)compressImage:(UIImage*)img{
    CGFloat compression = 1.0f;
    int maxFileSize = 1024*200;
    NSData *imageData = UIImageJPEGRepresentation(img, compression);
    // NSLog(@"first%d",imageData.length);
    if(imageData.length>1024*1024*5)
    {
        if(imageData.length>1024*1024*8)
        {
            imageData=UIImageJPEGRepresentation(img, 0.01);
        }
        else
        {
            imageData=UIImageJPEGRepresentation(img, 0.03);
        }
    }
    else if(imageData.length>1024*1024&&imageData.length<1024*1024*5)
    {
        imageData=UIImageJPEGRepresentation(img, 0.1);
    }
    else
    {
        while (([imageData length] >maxFileSize)&&(compression>0.1f) )
        {
            compression-=0.1f;
            imageData=UIImageJPEGRepresentation(img, compression);
            //  NSLog(@"lenth:%d",[imageData length]);
        }
        
    }
    //  NSLog(@"last %d",imageData.length);
    return imageData;
}

//剪切图片到正方形 运用CGImage
+(UIImage*)imageCropTo:(UIImage*)original
{
    UIImage *ret = nil;
    
    
    // This performs the image cropping.
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([original CGImage], CGRectMake(0, 0, 100,100*9/16));
    
    ret = [UIImage imageWithCGImage:imageRef
                              scale:original.scale
                        orientation:original.imageOrientation];
    
    CGImageRelease(imageRef);
    
    return ret;
}

+(void) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return;
}

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
    //CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}
//16进制颜色转换(#00ffBB)
+ (UIColor *)getColor:(NSString *)hexColor
{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green / 255.0f) blue:(float)(blue / 255.0f) alpha:1.0f];
}
/**
 
 @功能:等比例缩放图片到指定大小
 
 @参数1:CGSize   缩放后的大小
 
 @返回值:更改后的图片对象
 
 */

+(UIImage*)imageByImg:(UIImage *)sourceImage ScalingForSize:(CGSize)targetSize
{
    //    UIImage *sourceImage = self;
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    
    CGFloat scaledWidth = targetWidth;
    
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
        
    {
        
        CGFloat widthFactor = targetWidth / width;
        
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            
        {
            
            scaleFactor = widthFactor; // scale to fit height
            
        }
        
        else
            
        {
            
            scaleFactor = heightFactor; // scale to fit width
            
        }
        
        scaledWidth= width * scaleFactor;
        
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
            
        {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }
        
        else if (widthFactor < heightFactor)
            
        {
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            
        }
        
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    
    thumbnailRect.origin = thumbnailPoint;
    
    thumbnailRect.size.width= scaledWidth;
    
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if ( scaledImage == nil )
    {
        
        NSLog(@"UIImageRetinal:could not scale image!!!");
        return nil;
        
    }
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
    
}

+ (UIImage *)getImgByColor:(UIColor *)color bySize:(CGRect)rect
{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//判断字符串是否是数字组成的
+ (BOOL)isPureInt:(NSString *)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return [scan scanInt:&val] && [scan isAtEnd];
    
}

#define MINUTES		60
#define HOURS		3600
#define DAYS		86400
#define MONTHS		(86400 * 30)
#define YEARS		(86400 * 30 * 12)

//论坛文章时间转换
/**
 *  规则
 *
 *  今天：08:52
 *  昨天：昨天
 *  更早：2015－04－29
 *
 */
+ (NSString *)getTheRightTimeStrWith:(id)timeObj
{
    
    NSString *returnStr;
    NSTimeInterval timeNum;
    
    if([timeObj isKindOfClass:[NSDate class]])
    {
        NSDate *timeDate = (NSDate *)timeObj;
        timeNum = [timeDate timeIntervalSince1970];
    }
    else if([timeObj isKindOfClass:[NSNumber class]])
    {
        timeNum = [timeObj doubleValue];
    }
    else if ([timeObj isKindOfClass:[NSString class]])
    {
        /**
         *  现在时间戳：      1427953149.691974
         *  时间戳           1427953149
         *  dataFormat:     yyyy-MM-dd hh:mm:ss
         *  时间：           2015年5月30号
         *  新闻事件：        2014/12/09
         *  直接汉字          昨天
         *  今天时刻          21:15
         */
        
        
        NSString *timeStr = (NSString *)timeObj;
        
        
        NSString *Regex = @"^[\u4e00-\u9fa5]{0,}$";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", Regex];
        
        if(timeStr.length == 17)
        {
            timeNum = [timeStr doubleValue];
        }
        else if(timeStr.length == 5)
        {
            returnStr = timeStr;
            return returnStr;
        }
        else if (timeStr.length == 9)
        {
            if([self isPureInt:timeStr])
            {
                timeNum = [timeStr doubleValue];
            }
            else
            {
                return timeStr;
            }
        }
        else if (timeStr.length == 10)
        {
            NSRange range = [timeStr rangeOfString:@"/"];
            NSRange range1 = [timeStr rangeOfString:@"-"];
            if(range.length)
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYY/MM/dd"];
                //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
                [formatter setTimeZone:[NSTimeZone localTimeZone]];
                NSDate *theDate =  [formatter dateFromString:timeStr];
                timeNum = [theDate timeIntervalSince1970];
            }
            else if (range1.length)
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"YYYY-MM-dd"];
                //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
                [formatter setTimeZone:[NSTimeZone localTimeZone]];
                NSDate *theDate =  [formatter dateFromString:timeStr];
                timeNum = [theDate timeIntervalSince1970];
            }
            else
            {
                if([self isPureInt:timeStr])
                {
                    timeNum = [timeStr doubleValue];
                }
                else
                {
                    return timeStr;
                }
                
            }
        }
        else if ([predicate evaluateWithObject:timeStr])
        {
            returnStr = timeStr;
            return returnStr;
        }
        else if (timeStr.length == 19)
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
            //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            NSDate *theDate =  [formatter dateFromString:timeStr];
            timeNum = [theDate timeIntervalSince1970];
        }
        else
        {
            return timeStr;
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //设置时区 NSDataFormatter默认输出格林威治时间，要输出本地时间要设置时区 ，跟北京时间差8小时
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSTimeInterval timeNowNum = [[NSDate date]timeIntervalSince1970];
    
    //要处理的date
    NSDate *lastDate = [NSDate dateWithTimeIntervalSince1970:timeNum];
    
    
    //是否同一天
    double timezoneFix = [NSTimeZone localTimeZone].secondsFromGMT;
    int betweenDay = ((int)(timeNowNum + timezoneFix)/(DAYS)) - (int)((timeNum + timezoneFix)/(DAYS));
    //    int betweenMonth = ((int)(timeNowNum + timezoneFix)/(MONTHS)) - (int)((timeNum + timezoneFix)/(MONTHS));
    //    int betweenYear = ((int)(timeNowNum + timezoneFix)/(YEARS)) - (int)((timeNum + timezoneFix)/(YEARS));
    
    //不是今年
    //    if(betweenYear && betweenYear<20)
    //    {
    //        [formatter setDateFormat:@"YYYY-MM-dd"];
    //        returnStr = [formatter stringFromDate:lastDate];
    //    }
    //    else
    if(betweenDay >= 0)
    {
        //今天
        if (betweenDay == 0)
        {
            [formatter setDateFormat:@"HH:mm"];
            returnStr = [formatter stringFromDate:lastDate];
        }
        //昨天
        else if (betweenDay == 1)
        {
            returnStr = @"昨天";
        }
        //前天
        //        else if (betweenDay == 2)
        //        {
        //            returnStr = @"前天";
        //        }
        else
        {
            [formatter setDateFormat:@"YYYY-MM-dd"];
            returnStr = [formatter stringFromDate:lastDate];
        }
    }
    else
    {
        returnStr = @"";
    }
    
    
    
    return returnStr;
}

//消息列表需要的时间
/**
 *  规则
 *
 *  今天：08:52
 *  本周：周二
 *  更早：15/4/29
 *
 */
+ (NSString *)getMessageRightTimeWith:(NSTimeInterval)timeNum;
{
    
    NSString *returnStr = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:timeNum];
    
    NSString *dateSMS = [formatter stringFromDate:theDate];
    
    NSDate *now = [NSDate date];
    NSString *dateNow = [formatter stringFromDate:now];
    
    //今天
    if ([dateSMS isEqualToString:dateNow])
    {
        
        [formatter setDateFormat:@"HH:mm"];
        NSString *strDate =[formatter stringFromDate:theDate];
        returnStr = [NSString stringWithFormat:@"%@",strDate];
        
    }
    else
    {
        //一周内
        int theDateWeek = [theDate week];
        int nowWeek = [[NSDate date] week];
        if(theDateWeek == nowWeek)
        {
            int WeekDay = [theDate weekday];
            NSString *weekStr = @"";
            if(WeekDay == 2)
                weekStr = @"周一";
            else if (WeekDay == 3)
                weekStr = @"周二";
            else if (WeekDay == 4)
                weekStr = @"周三";
            else if (WeekDay == 5)
                weekStr = @"周四";
            else if (WeekDay == 6)
                weekStr = @"周五";
            else if (WeekDay == 7)
                weekStr = @"周六";
            else if (WeekDay == 1)
                weekStr = @"周日";
            
            returnStr = weekStr;
            
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yy/M/d"];
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            NSString *strDate =[formatter stringFromDate:theDate];
            returnStr = strDate;
        }
    }
    
    
    return returnStr;
}

//旧版聊天界面时间
/**
 *  规则
 *
 *  今天：08:52:17
 *  本周：周二 15:33
 *  更早：2015年4月29日 16:36
 *
 */
+ (NSString *)getChatRightTimeWiht:(NSTimeInterval )timeNum
{
    NSString *returnStr = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:timeNum];
    
    NSString *dateSMS = [formatter stringFromDate:theDate];
    
    NSDate *now = [NSDate date];
    NSString *dateNow = [formatter stringFromDate:now];
    
    //今天
    if ([dateSMS isEqualToString:dateNow])
    {
        
        [formatter setDateFormat:@"HH:mm:ss"];
        NSString *strDate =[formatter stringFromDate:theDate];
        returnStr = [NSString stringWithFormat:@"%@",strDate];
        
    }
    else
    {
        //一周内[theDate distanceInDaysToDate:[NSDate date]] < 7
        int theDateWeek = [theDate week];
        int nowWeek = [[NSDate date] week];
        if(theDateWeek == nowWeek)
        {
            int WeekDay = [theDate weekday];
            NSString *weekStr = @"";
            if(WeekDay == 2)
                weekStr = @"周一";
            else if (WeekDay == 3)
                weekStr = @"周二";
            else if (WeekDay == 4)
                weekStr = @"周三";
            else if (WeekDay == 5)
                weekStr = @"周四";
            else if (WeekDay == 6)
                weekStr = @"周五";
            else if (WeekDay == 7)
                weekStr = @"周六";
            else if (WeekDay == 1)
                weekStr = @"周日";
            
            [formatter setDateFormat:@"HH:mm"];
            NSString *strDate =[formatter stringFromDate:theDate];
            
            returnStr = [NSString stringWithFormat:@"%@ %@",weekStr,strDate];
            
        }
        else
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy年M月d日 HH:mm"];
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            NSString *strDate =[formatter stringFromDate:theDate];
            returnStr = strDate;
        }
    }
    
    
    return returnStr;
}
//聊天界面时间  后来改成这样的
/**
 *  规则
 *
 *  今天：08:52
 *  昨天：昨天 09:43
 *  更早：2015年4月29日 16:36
 *
 */
+ (NSString *)getNewChatRightTimeWiht:(NSTimeInterval )timeNum
{
    NSString *returnStr = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSDate *theDate = [NSDate dateWithTimeIntervalSince1970:timeNum];
    
    NSString *dateSMS = [formatter stringFromDate:theDate];
    
    NSDate *now = [NSDate date];
    NSString *dateNow = [formatter stringFromDate:now];
    
    int theDateDay = [theDate day];
    int nowDay = [[NSDate date] day];
    
    //今天
    if (theDateDay == nowDay)
    {
        
        [formatter setDateFormat:@"HH:mm"];
        NSString *strDate =[formatter stringFromDate:theDate];
        returnStr = [NSString stringWithFormat:@"%@",strDate];
        
    }
    else if((nowDay-theDateDay) == 1)
    {
        [formatter setDateFormat:@"HH:mm"];
        NSString *strDate =[formatter stringFromDate:theDate];
        returnStr = [NSString stringWithFormat:@"昨天 %@",strDate];
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy年M月d日 HH:mm"];
        [formatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *strDate =[formatter stringFromDate:theDate];
        returnStr = strDate;
    }
    
    
    
    return returnStr;
}


//绘制一个三角形
+ (UIImage *)getTriangleWithColor:(UIColor *)color
{
    //设置背景颜色
    UIGraphicsBeginImageContext(CGSizeMake(10, 8));
    
    [[UIColor clearColor] set];
    
    UIRectFill(CGRectMake(0, 0, 10, 7));
    
    //拿到当前视图准备好的画板
    
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    
    CGContextMoveToPoint(context,
                         5, 0);//设置起点
    
    CGContextAddLineToPoint(context,
                            0, 7);
    
    CGContextAddLineToPoint(context,
                            10, 7);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [color setFill]; //设置填充色
    
    [[UIColor
      clearColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
