//
//  LBHomeGeneralViewController.m
//  MyKeeng
//
//  Created by Le Van Binh on 9/5/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBHomeGeneralViewController.h"
#import "LBHomeNewVC.h"
#import "CAPSPageMenu.h"



@interface LBHomeGeneralViewController ()
@property (nonatomic) CAPSPageMenu *pageMenu;

@end

@implementation LBHomeGeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LBHomeNewVC *pageView_home = [[LBHomeNewVC alloc] init];
    pageView_home.title = @"HOME MAIN";
    
    
    LBHomeNewVC *pageView_sub1 = [[LBHomeNewVC alloc] init];
    pageView_sub1.title = @"HOME_SUB HOME_SUB";
    
    LBHomeNewVC *pageView_sub2 = [[LBHomeNewVC alloc] init];
    pageView_sub2.title = @"HOME_LOWEST_SUB HOME_LOWEST_SUB";
    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor orangeColor],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:13.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(90.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES),
                                 CAPSPageMenuOptionMenuItemSeparatorWidth: @(2.0),
                                 CAPSPageMenuOptionMenuItemSeparatorColor: [UIColor yellowColor],
                                 CAPSPageMenuOptionMenuItemSeparatorRoundEdges: @(YES)
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:@[pageView_home, pageView_sub1, pageView_sub2] frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    
    [self.view addSubview:_pageMenu.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
