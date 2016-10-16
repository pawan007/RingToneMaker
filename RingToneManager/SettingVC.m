//
//  SettingVC.m
//  RingToneManager
//
//  Created by Narender Kumar on 6/11/16.
//  Copyright (c) 2016 Pawan Kumar. All rights reserved.
//

#import "SettingVC.h"
#import "MYIntroductionView.h"

@interface SettingVC ()<MYIntroductionDelegate> {
    MYIntroductionView *introductionView;
}
@property (weak, nonatomic) IBOutlet UIView *tutView;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showTutorila];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showTutorila {
    MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"1"] description:@"hgh"];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"2"]  description:@"kjk"];
    
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"3"] title:@"Your Ticket!3" description:@""];
    
    MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"4"] title:@"Your Ticket!4" description:@""];
    
    MYIntroductionPanel *panel5 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"5"] title:@"" description:@""];
    
    MYIntroductionPanel *panel6 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"6"] title:@"" description:@""];
    MYIntroductionPanel *panel7 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"7"] title:@"" description:@""];
    
    MYIntroductionPanel *panel8 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"8"] title:@"" description:@""];
    
    MYIntroductionPanel *panel9 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"9"] title:@"" description:@""];
    
    MYIntroductionPanel *panel10 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"10"] title:@"" description:@""];
    
    MYIntroductionPanel *panel11 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"11"] title:@"" description:@""];
    
    introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2, panel3, panel4, panel5,panel6,panel7,panel8,panel9,panel10,panel11]];
    
    [introductionView.BackgroundImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [introductionView.HeaderImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.HeaderLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.HeaderView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [introductionView.PageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    //[introductionView.SkipButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
     introductionView.delegate = self;
    introductionView.SkipButton.hidden=true;
    [introductionView showInView:_tutView animateDuration:0.2];
    
}

-(void)introductionDidFinishWithType:(MYFinishType)finishType {
    
}
-(void)introductionDidChangeToPanel:(MYIntroductionPanel *)panel withIndex:(NSInteger)panelIndex {
    
}


@end
