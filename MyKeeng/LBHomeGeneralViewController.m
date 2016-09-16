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
#import "LBHomeNewWithFavouriteVC.h"



@interface LBHomeGeneralViewController ()
@property (nonatomic) CAPSPageMenu *pageMenu;

@end

@implementation LBHomeGeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LBHomeNewVC *pageView_home = [[LBHomeNewVC alloc] init];
    pageView_home.title = @"HOME MAIN";
    
    
    LBHomeNewWithFavouriteVC *pageView_homewithfavourite = [[LBHomeNewWithFavouriteVC alloc] init];
    pageView_homewithfavourite.title = @"FAVOURITE";
    

    
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
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:@[pageView_homewithfavourite, pageView_home] frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    
    [self.view addSubview:_pageMenu.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
