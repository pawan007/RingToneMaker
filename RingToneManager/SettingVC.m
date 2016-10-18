//
//  SettingVC.m
//  RingToneManager
//
//  Created by Narender Kumar on 6/11/16.
//  Copyright (c) 2016 Pawan Kumar. All rights reserved.
//

#import "SettingVC.h"

@interface SettingVC () {
    NSMutableArray *arrayImages;
}
@property (weak, nonatomic) IBOutlet UIView *tutView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;


@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    arrayImages=[[NSMutableArray alloc]initWithObjects:@"1", @"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];
   // [self showTutorila];
    [self.scrollView layoutIfNeeded];
    [self.scrollView layoutSubviews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void )viewDidLayoutSubviews
{
}
-(void)viewDidAppear:(BOOL)animated
{
    [self showTutorila];
}
- (void)showTutorila
{
    
    for(UIImageView *img in self.scrollView.subviews)
    {
        [img removeFromSuperview];
    }
    for(int i=0;i<arrayImages.count;i++)
    {

        UIImageView *imgview=[[UIImageView alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width*i, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        imgview.image=[UIImage imageNamed:arrayImages[i]];
        imgview.contentMode = UIViewContentModeScaleAspectFit;
        [self.scrollView addSubview:imgview];
        
        self.pageControl.numberOfPages=arrayImages.count;
         //scrollView.contentSize = CGSize(width: scrollView.frame.size.width * CGFloat(productImageArray.count), height: scrollView.frame.size.height)
    }
    
    self.scrollView.contentSize=CGSizeMake(self.scrollView.frame.size.width * arrayImages.count,self.scrollView.frame.size.height);
    ;


}

-(void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    int pageNo=(self.scrollView.contentOffset.x/self.scrollView.frame.size.width);
    self.pageControl.currentPage=pageNo;
}



@end
