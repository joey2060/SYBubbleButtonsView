//
//  ViewController.m
//  SYBubbleButtonsView
//
//  Created by sun on 15/7/14.
//  Copyright (c) 2015年 ReeSun. All rights reserved.
//

#import "ViewController.h"
#import "SYBBView.h"

@interface ViewController () <SYBBDelegate>

@property (nonatomic, weak) IBOutlet UISegmentedControl *vStepper;
@property (nonatomic, strong) SYBBView *vBB;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _vBB = [[SYBBView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 100) style:SYBBStyleWish];
    _vBB.delegate = self;
    _vBB.maxHeight = self.view.frame.size.height - 120;
    _vBB.backgroundColor = kColorClear;
    [self.view addSubview:_vBB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onClickStepper:(id)sender {
    NSLog(@"_vStepper.selectedSegmentIndex==%ld", (long)_vStepper.selectedSegmentIndex);
    
    if (_vStepper.selectedSegmentIndex == 0) {
        [_vBB removeBubbleButtonsWithInterval:0];
    }
    else {
        [_vBB fillBubbleViewWithButtons:[self bubbleArray:@[@"sun",@"yang",@"wang",@"suna",@"yanga",@"wanga",@"sunc",@"yangc",@"ok",@"sunv",@"yangv",@"y",@"sunwwww",@"yangqww",@"swww",@"sunkkddsfssdsdsds",@"yangooopkkklkldjjdkl",@"sunyangerrr",@"sundf",@"yangkj",@"reesunlk",@"yangij",@"wangpopp",@"sunqqwwq",@"yangefesd",@"wangrscsds",@"sunoipdls",@"yangere",@"oksss",@"suniuydshhdsh",@"yangerewsaw",@"ysdsddqd",@"sunqedfrgthyh"]] bgColor:kColorClear textColor:kColorBlue fontSize:14];
    }
}

// 获取一个随机数组，为了显示用
- (NSArray *)bubbleArray:(NSArray *)arr {
    NSMutableArray *arrTemp = [[NSMutableArray alloc] initWithArray:arr];
    NSMutableArray *arrRes = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < arrTemp.count; i++) {
        NSUInteger index = arc4random() % arrTemp.count;
        [arrRes addObject:arrTemp[index]];
        [arrTemp removeObjectAtIndex:index];
    }
    
    return arrRes;
}

// SYBBView delegate
- (void)bbView:(SYBBView *)bbview didClickBubbleButton:(UIButton *)bubble {
    NSLog(@"didClickBubbleButton==%@",bubble.titleLabel.text);
    [bbview setButtonSelectAtIndex:bubble.tag];
}

@end
