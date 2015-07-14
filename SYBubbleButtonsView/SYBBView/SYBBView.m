//
//  SYBBView.m
//  SYBubbleView
//
//  Created by Benjamin Gordon on 1/8/13.
//  Modified by ReeSun<https://github.com/reesun1130> on 2015.7.14
//  Copyright (c) 2015 ReeSun. All rights reserved.
//

#import "SYBBView.h"

@interface SYBBView ()

@property (nonatomic, strong) NSMutableArray *arrBubbleButtons;
@property (nonatomic, strong) NSMutableArray *arrButtons;

@end

@implementation SYBBView

- (id)initWithFrame:(CGRect)frame style:(SYBBStyle)style {
    if (self = [super initWithFrame:frame]) {
        _style = style;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _style = SYBBStyleNormal;
    }
    return self;
}

#pragma mark - Bubble Button Methods

- (void)fillBubbleViewWithButtons:(NSArray *)strings bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor fontSize:(float)fsize {
    if (!self.arrBubbleButtons) {
        self.arrBubbleButtons = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [self.arrBubbleButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.arrBubbleButtons removeAllObjects];

    if (!self.arrButtons) {
        self.arrButtons = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [self.arrButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.arrButtons removeAllObjects];

    CGFloat padX = 15;
    CGFloat padY = 15;
    CGFloat startX = 15;
    
    if ([UIScreen mainScreen].bounds.size.height <= 480) {
        if (_style != SYBBStyleWish) {
            padX = 10;
            padY = 10;
        }
    }
    
    // Iterate over every string in the array to create the Bubble Button
    for (int xx = 0; xx < strings.count; xx++) {
        // Find the size of the button, turn it into a rect
        NSString *bub = [strings objectAtIndex:xx];
        CGSize bSize = SY_TEXTSIZE(bub, [UIFont systemFontOfSize:fsize]);
        CGRect buttonRect = CGRectMake(startX, 0, bSize.width + padX * 2, bSize.height + fsize);
        
        // if new button will fit on screen, in row:
        //   - place it
        // else:
        //   - put on next row at beginning
        if (xx > 0) {
            UIButton *oldButton = [[self subviews] objectAtIndex:self.subviews.count - 1];
            if ((oldButton.frame.origin.x + (2*startX) + oldButton.frame.size.width + bSize.width + padX * 2) > self.frame.size.width) {
                buttonRect = CGRectMake(startX, oldButton.frame.origin.y + oldButton.frame.size.height + padY, bSize.width + padX * 2, bSize.height + fsize);
            }
            else {
                buttonRect = CGRectMake(oldButton.frame.origin.x + padX + oldButton.frame.size.width, oldButton.frame.origin.y, bSize.width + padX * 2, bSize.height + fsize);
            }
        }
        
        // Create button and make magic with the UI
        // -- Set the alpha to 0, cause we're gonna' animate them at the end
        UIButton *bButton = [[UIButton alloc] initWithFrame:buttonRect];
        [bButton setShowsTouchWhenHighlighted:NO];
        [bButton setTitle:bub forState:UIControlStateNormal];
        bButton.backgroundColor = bgColor;
        
        if (_style == SYBBStyleWish) {
            CGRect aFrame = bButton.frame;
            aFrame.size.height = 32;
            bButton.frame = aFrame;
            [bButton setTitleColor:kColorBlue forState:UIControlStateNormal];
            [bButton setTitleColor:kColorWhite forState:UIControlStateSelected];
            bButton.layer.borderColor = kColorBlue.CGColor;
            bButton.layer.borderWidth = kLinePixel;
        }
        else {
            CGRect aFrame = bButton.frame;
            aFrame.size.height = 27;
            bButton.frame = aFrame;
            [bButton setTitleColor:textColor forState:UIControlStateNormal];
            bButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
            bButton.layer.borderWidth = kLinePixel;
        }
        [bButton.titleLabel setFont:[UIFont systemFontOfSize:fsize]];
        bButton.layer.cornerRadius = bButton.frame.size.height / 2.0;
        bButton.alpha = 0;
        bButton.tag = xx;
        [bButton addTarget:self action:@selector(clickedBubbleButton:) forControlEvents:UIControlEventTouchUpInside];
        
        // Add to the view, and to the array
        // 限制bubbleview的最大高度,超过这个高度的button将不会被显示
        if (self.maxHeight) {
            if (CGRectGetMaxY(bButton.frame) <= self.maxHeight) {
                [self addSubview:bButton];
                [self.arrBubbleButtons addObject:bButton];
                [self.arrButtons addObject:bButton];
            }
        }
        else {
            [self addSubview:bButton];
            [self.arrBubbleButtons addObject:bButton];
            [self.arrButtons addObject:bButton];
        }
    }
    CGRect aFrame = self.frame;
    aFrame.size.height = [self getBubbleViewMaxY];
    self.frame = aFrame;
    
    // Sequentially animate the buttons appearing in view
    // -- This is the interval between each button animating, not overall span
    // -- I recommend 0.034 for an nice, smooth transition
    [self showBubbleButtonsWithInterval:kAnimationInterval];
}

- (void)showBubbleButtonsWithInterval:(float)ftime {
    // Make sure there are buttons to animate
    // Take the first button in the array, animate alpha to 1
    // Recur. Lather, rinse, repeat until all are buttons are on screen
    if (self.arrButtons.count > 0) {
        UIButton *button = [self.arrButtons objectAtIndex:0];
        
        if (ftime) {
            [UIView animateWithDuration:ftime animations:^{
                button.alpha = 1;
            } completion:^(BOOL fin){
                [self.arrButtons removeObject:button];
                [self showBubbleButtonsWithInterval:ftime];
            }];
        }
        else {
            button.alpha = 1;
            [self.arrButtons removeObject:button];
            [self showBubbleButtonsWithInterval:ftime];
        }
    }
}

- (void)removeBubbleButtonsWithInterval:(float)ftime {
    // Make sure there are buttons on screen to animate
    // Take the last button on screen, animate alpha to 0
    // Remove button from superview
    // Recur. Lather, rinse, repeat until all buttons are off screen
    if (self.arrBubbleButtons.count > 0) {
        UIButton *button = [self.arrBubbleButtons objectAtIndex:self.arrBubbleButtons.count - 1];
        
        if (ftime > 0) {
            [UIView animateWithDuration:ftime animations:^{
                button.alpha = 0;
            } completion:^(BOOL fin){
                [button removeFromSuperview];
                [self.arrBubbleButtons removeObject:button];
                [self removeBubbleButtonsWithInterval:ftime];
            }];
        }
        else {
            button.alpha = 0;
            [button removeFromSuperview];
            [self.arrBubbleButtons removeObject:button];
            [self removeBubbleButtonsWithInterval:ftime];
        }
    }
}

- (void)clickedBubbleButton:(UIButton *)bubble {
    if (_delegate && [_delegate respondsToSelector:@selector(bbView:didClickBubbleButton:)]) {
        [_delegate bbView:self didClickBubbleButton:bubble];
    }
}

#pragma mark - Other Methods

- (CGFloat)getBubbleViewMaxY {
    UIButton *btn = (UIButton *)[self.arrBubbleButtons lastObject];
    
    return btn ? CGRectGetMaxY(btn.frame) : 0;
}

- (void)setButtonSelectAtIndex:(NSUInteger)index {
    [self.arrBubbleButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop){
        if (idx == index) {
            obj.selected = YES;
            obj.backgroundColor = kColorBlue;
        }
        else {
            obj.selected = NO;
            obj.backgroundColor = [UIColor clearColor];
        }
    }];
}

- (void)unSelectButtonsAll {
    [self.arrBubbleButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop){
        obj.selected = NO;
        obj.backgroundColor = [UIColor clearColor];
    }];
}

- (NSInteger)selectedButtonIndex {
    __block NSInteger index = -1;
    
    [self.arrBubbleButtons enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop){
        if (obj.selected) {
            index = idx;
            *stop = YES;
        }
    }];
    
    return index;
}

@end
