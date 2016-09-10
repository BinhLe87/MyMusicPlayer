//
//  LBPageMenuViewController.h
//  MyKeeng
//
//  Created by Le Van Binh on 9/5/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Delegate functions
@protocol LBPageMenuDelegate <NSObject>

@optional
- (void)willMoveToPage:(UIViewController *)controller index:(NSInteger)index;
- (void)didMoveToPage:(UIViewController *)controller index:(NSInteger)index;
@end



@interface LBMenuItemInPageMenu : UIView

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *titleLbl;

-(instancetype)initWithMenuHeight:(CGFloat)menuHeight;
-(void)setUpMenuItem:(NSString*)menuTitle menuImage:(UIImage*)menuImage menuHeight:(CGFloat*)menuItemHeight;
-(void)setUpMenuItemAndImageWidth:(NSString*)menuTitle menuImage:(UIImage*)menuImage menuImageWidth:(CGFloat)menuImageWidth menuHeight:(CGFloat*)menuItemHeight;
-(CGFloat)calculateMenuItemWidth;
-(void)initValues;
@end

@interface LBPageViewInPageMenu : NSObject

-(instancetype)initWithViewController:(UIViewController*) viewController menuTitle:(NSString*)menuTitle menuImage:(UIImage*)menuImage;
@end


@interface LBPageMenuViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic) UIScrollView *menuScrollView;
@property (nonatomic) UIScrollView *controllerScrollView;

@property (nonatomic) NSArray<LBPageViewInPageMenu *> *controllerArray;

@property (nonatomic) UIColor *scrollMenuBackgroundColor;
@property (nonatomic) UIColor *selectionIndicatorColor;
@property (nonatomic) CGFloat menuHeight;
@property (nonatomic) CGFloat menuItemImageWidth;
@property (nonatomic) CGFloat spaceBetweenMenuItems;
@property (nonatomic) CGFloat menuMargin;
@property (nonatomic) BOOL centerMenuItems;
@property (nonatomic) UIFont *menuItemFont;

@property (nonatomic,weak) id<LBPageMenuDelegate> delegate;
@property (nonatomic) UIView *selectionIndicatorView;
@property (nonatomic) CGFloat selectionIndicatorViewHeight;


#pragma mark - constant Attributes' name
extern NSString * const LBPageMenuOptionScrollMenuBackgroundColor;
extern NSString * const LBPageMenuOptionSelectionIndicatorColor;
extern NSString * const LBPageMenuOptionMenuHeight;
extern NSString * const LBPageMenuOptionMenuItemImageWidth;
extern NSString * const LBPageMenuOptionCenterMenuItems;
extern NSString * const LBPageMenuOptionMenuItemFont;


#pragma mark - methods
-(instancetype)initWithViewControllers:(NSArray *)viewControllers frame:(CGRect)frame options:(NSDictionary*)options;

-(void)setUpUserInterface;
-(void)configUserInterface;

@end
