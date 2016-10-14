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
    MYIntroductionPanel *panel = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"tutorial_background_00"] description:@"Welcome to MYIntroductionView, your 100 percent customizable interface for introductions and tutorials! Simply add a few classes to your project, and you are ready to go!"];
    
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"tutorial_background_01"] title:@"Your Ticket!" description:@"MYIntroductionView is your ticket to a great tutorial or introduction!"];
    
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"tutorial_background_02"] title:@"Your Ticket!3" description:@"MYIntroductionView is your ticket to a great tutorial or introduction!"];
    
    MYIntroductionPanel *panel4 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"tutorial_background_03"] title:@"Your Ticket!4" description:@"MYIntroductionView is your ticket to a great tutorial or introduction!"];
    
    MYIntroductionPanel *panel5 = [[MYIntroductionPanel alloc] initWithimage:[UIImage imageNamed:@"tutorial_background_04"] title:@"Your Ticket!5" description:@"MYIntroductionView is your ticket to a great tutorial or introduction!"];
    
    introductionView = [[MYIntroductionView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height) panels:@[panel, panel2, panel3, panel4, panel5]];
    
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
