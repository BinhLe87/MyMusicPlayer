//
//  LBHomeGeneralViewController.m
//  MyKeeng
//
//  Created by Le Van Binh on 9/5/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBHomeGeneralViewController.h"
#import "LBHomeNewVC.h"
#import "LBPageMenuViewController.h"

@interface LBHomeGeneralViewController ()
@property (nonatomic) LBPageMenuViewController *pageMenu;

@end

@implementation LBHomeGeneralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    LBPageViewInPageMenu *pageView_home = [[LBPageViewInPageMenu alloc] initWithViewController:[[LBHomeNewVC alloc] init] menuTitle:@"HOME_MAIN" menuImage:[UIImage imageNamed:@"icon_mocha_small.png"]];
    
    
    LBPageViewInPageMenu *pageView_sub1 = [[LBPageViewInPageMenu alloc] initWithViewController:[[LBHomeNewVC alloc] init] menuTitle:@"HOME_SUB HOME_SUB" menuImage:[UIImage imageNamed:@"icon.png"]];
    LBPageViewInPageMenu *pageView_sub2 = [[LBPageViewInPageMenu alloc] initWithViewController:[[LBHomeNewVC alloc] init] menuTitle:@"HOME_LOWEST_SUB HOME_LOWEST_SUB" menuImage:[UIImage imageNamed:@"icon.png"]];
    
    NSDictionary *parameters = @{
                                 LBPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:30.0/255.0 green:30.0/255.0 blue:30.0/255.0 alpha:1.0],
                                 LBPageMenuOptionSelectionIndicatorColor: [UIColor orangeColor],
                                 LBPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:13.0],
                                 LBPageMenuOptionMenuHeight: @(40.0),
                                 LBPageMenuOptionMenuItemImageWidth: @(30.0),
                                 LBPageMenuOptionCenterMenuItems: @(YES)
                                 };
    
    _pageMenu = [[LBPageMenuViewController alloc] initWithViewControllers:@[pageView_home, pageView_sub1, pageView_sub2] frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    
    [self.view addSubview:_pageMenu.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
