//
//  SYBBView.h
//  SYBubbleView
//
//  Created by Benjamin Gordon on 1/8/13.
//  Modified by ReeSun<https://github.com/reesun1130> on 2015.7.14
//  Copyright (c) 2015 ReeSun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLinePixel (1.0 / [UIScreen mainScreen].scale)

#define kColorBlue [UIColor colorWithRed:0/255.0 green:110/255.0 blue:191/255.0 alpha:1]
#define kColorWhite [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
#define kColorClear [UIColor clearColor]

#define kAnimationInterval 0.034

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define SY_TEXTSIZE(text, font) [text length] > 0 ? [text \
sizeWithAttributes:@{NSFontAttributeName:font}] : CGSizeZero;
#else
#define SY_TEXTSIZE(text, font) [text length] > 0 ? [text sizeWithFont:font] : CGSizeZero;
#endif

@class SYBBView;

@protocol SYBBDelegate <NSObject>

- (void)bbView:(SYBBView *)bbview didClickBubbleButton:(UIButton *)bubble;

@end

typedef NS_ENUM(NSUInteger, SYBBStyle) {
    SYBBStyleNormal = 0,
    SYBBStyleWish
};

@interface SYBBView : UIView

@property (nonatomic, weak) id <SYBBDelegate> delegate;
@property (nonatomic, assign) SYBBStyle style;
@property (nonatomic, assign) CGFloat maxHeight;//限制最大高度，超过这个最大值的按钮将不会添加

- (id)initWithFrame:(CGRect)frame style:(SYBBStyle)style;

/**
 *  填充buttons(使用动画的时候需要注意等移除完毕才能去做添加动作)
 *
 *  @param strings   btn集合
 *  @param bgColor   按钮背景色
 *  @param textColor 按钮文字颜色
 *  @param fsize     按钮文字大小，系统字体
 */
- (void)fillBubbleViewWithButtons:(NSArray *)strings bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor fontSize:(float)fsize;

/**
 *  删除按钮(使用动画的时候需要注意等移除完毕才能去做添加动作)
 *
 *  @param ftime 动画时间，如果大于0就使用动画，否则不使用
 */
- (void)removeBubbleButtonsWithInterval:(float)ftime;

/**
 *  获取view的高度
 *
 *  @return 高度
 */
- (CGFloat)getBubbleViewMaxY;

/**
 *  取消选中所有的按钮
 */
- (void)unSelectButtonsAll;

/**
 *  选中某一个按钮
 *
 *  @param index 下标
 */
- (void)setButtonSelectAtIndex:(NSUInteger)index;

/**
 *  选中的那个按钮下标
 *
 *  @return 按钮下标，如果小于0说明没有选中的按钮
 */
- (NSInteger)selectedButtonIndex;

@end
