//
//  LBPageMenuViewController.m
//  MyKeeng
//
//  Created by Le Van Binh on 9/5/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBPageMenuViewController.h"


#pragma mark - LBMenuItemInPageMenu


@interface LBMenuItemInPageMenu()

@property (nonatomic) CGFloat menuItemHeight;
@property (nonatomic) CGFloat menuItemImageWidth;
@property (nonatomic) CGFloat spaceBetweenItemsInMenuItem;
@property (nonatomic) UIFont *titleFont;

@end

@implementation LBMenuItemInPageMenu

-(instancetype)initWithMenuItemHeight:(CGFloat)menuItemHeight {
    
    if (!(self = [super init])) return nil;
    [self initValues];
    
    _menuItemHeight = menuItemHeight;
    
    return self;
}

-(instancetype)init {
    
    if (!(self = [super init])) return nil;
    [self initValues];
    
    return self;
}

-(void)initValues {
    
    _menuItemImageWidth = 20;
    _spaceBetweenItemsInMenuItem = 3;
    _titleFont = [UIFont fontWithName:@"HelveticaNeue" size:13.0];
    _menuItemHeight = 40;
}


-(void)setUpMenuItem:(NSString *)menuTitle menuImage:(UIImage *)menuImage{
    
    
    _imageView = [[UIImageView alloc] initWithImage:menuImage];
    
    [_imageView setFrame:CGRectMake(_spaceBetweenItemsInMenuItem, 0, _menuItemImageWidth, _menuItemHeight)];
    _imageView.contentMode = UIViewContentModeScaleToFill;
    
    [self addSubview:_imageView];
    
    
    _titleLbl = [[UILabel alloc] init];
    _titleLbl.text = menuTitle;
    _titleLbl.font = _titleFont;
    _titleLbl.textColor = [UIColor whiteColor];
    _titleLbl.textAlignment = NSTextAlignmentCenter;
    _titleLbl.userInteractionEnabled = NO;
    
    CGRect itemWidthRect = [menuTitle boundingRectWithSize:CGSizeMake(1000, 1000) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:_titleFont} context: nil];
    
    CGFloat estimateTitleWidth = itemWidthRect.size.width;
    
    [_titleLbl setFrame:CGRectMake(_spaceBetweenItemsInMenuItem + _menuItemImageWidth + _spaceBetweenItemsInMenuItem, 0, estimateTitleWidth, _menuItemHeight)];
    [_titleLbl layoutIfNeeded];
    [self addSubview:_titleLbl];
}

-(void)setUpMenuItemAndImageWidth:(NSString *)menuTitle menuImage:(UIImage *)menuImage menuImageWidth:(CGFloat)menuImageWidth {
    
    _menuItemImageWidth = menuImageWidth;
    [self setUpMenuItem:menuTitle menuImage:menuImage];
}

-(CGFloat)getMenuItemWidth {
    
    CGFloat menuItemWidth = 0.0;
    
    menuItemWidth = _spaceBetweenItemsInMenuItem + _imageView.frame.size.width + _spaceBetweenItemsInMenuItem + _titleLbl.frame.size.width + _spaceBetweenItemsInMenuItem;
    
    return menuItemWidth;
}



@end

#pragma mark - LBPageViewInPageMenu
@interface LBPageViewInPageMenu()

@property (nonatomic) UIViewController *viewController;
@property (nonatomic) NSString *menuItemTitle;
@property (nonatomic) UIImage *menuItemImage;


@end

@implementation LBPageViewInPageMenu

-(instancetype)initWithViewController:(UIViewController *)viewController menuTitle:(NSString *)menuTitle menuImage:(UIImage *)menuImage {
    
    if (!(self = [super init])) return nil;
    
    _viewController = viewController;
    _menuItemTitle = menuTitle;
    _menuItemImage = menuImage;
    
    return self;
}

@end


#pragma mark - LBPageMenuViewController class
@interface LBPageMenuViewController () {
    NSInteger currentPageIndex;
    NSMutableSet *pageAddedSet;
    CGFloat lastControllerScrollViewContentOffset;
    NSMutableArray *menuItemWidthArray;
    NSMutableArray *menuItemCGRectArray;
    BOOL isScrollAlready;
    NSInteger numPageCreated;
}


@end

@implementation LBPageMenuViewController

NSString * const LBPageMenuOptionScrollMenuBackgroundColor = @"scrollMenuBackgroundColor";
NSString * const LBPageMenuOptionSelectionIndicatorColor = @"selectionIndicatorColor";
NSString * const LBPageMenuOptionMenuHeight = @"menuHeight";
NSString * const LBPageMenuOptionMenuItemImageWidth = @"menuItemImageWidth";
NSString * const LBPageMenuOptionCenterMenuItems = @"centerMenuItems";
NSString * const LBPageMenuOptionMenuItemFont = @"menuItemFont";

-(instancetype)initWithViewControllers:(NSArray *)viewControllers frame:(CGRect)frame options:(NSDictionary *)options {
    
    if (!(self = [super init])) return nil;
    
    _controllerArray = viewControllers;
    self.view.frame = frame;
    
    [self initValues];
    
    if (options) {
        
        for (NSString *key in options) {
            
            if([key isEqualToString:LBPageMenuOptionMenuHeight]) {
                _menuHeight = [options[key] floatValue];
            } else if ([key isEqualToString:LBPageMenuOptionMenuItemImageWidth]) {
                _menuItemImageWidth = [options[key] floatValue];
            } else if ([key isEqualToString:LBPageMenuOptionScrollMenuBackgroundColor]) {
                _scrollMenuBackgroundColor = options[key];
            } else if ([key isEqualToString:LBPageMenuOptionSelectionIndicatorColor]) {
                _selectionIndicatorColor = options[key];
            } else if ([key isEqualToString:LBPageMenuOptionCenterMenuItems]) {
                _centerMenuItems = [options[key] boolValue];
            } else if ([key isEqualToString:LBPageMenuOptionMenuItemFont]) {
                _menuItemFont = options[key];
            }
        }
    }
    
    [self setUpUserInterface];
    [self configUserInterface];
    
    return self;
}

-(void)initValues {
    
    //set default values
    _menuHeight = 20;
    _menuMargin = 10;
    _spaceBetweenMenuItems = 5;
    _menuItemImageWidth = 20;
    _menuItemFont = [UIFont fontWithName:@"HelveticaNeue" size:9.0];
    _selectionIndicatorViewHeight = 4;
    
    currentPageIndex = 0;
    lastControllerScrollViewContentOffset = 0.0;
    menuItemWidthArray = [[NSMutableArray alloc] init];
    menuItemCGRectArray = [[NSMutableArray alloc] init];
    pageAddedSet = [[NSMutableSet alloc] init];
    isScrollAlready = NO;
    
    numPageCreated = 0;
}

-(void)setUpUserInterface {
    
    
    _menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _menuHeight)];
    _menuScrollView.delegate = self;
    [self.view addSubview:_menuScrollView];
    
    //TODO: setup UITapGestureRecognizer for _menuScrollView
    UITapGestureRecognizer *menuItemTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleMenuItemTap:)];
    menuItemTapGestureRecognizer.numberOfTapsRequired = 1;
    menuItemTapGestureRecognizer.numberOfTouchesRequired = 1;
    menuItemTapGestureRecognizer.delegate = self;
    [_menuScrollView addGestureRecognizer:menuItemTapGestureRecognizer];
    
    
    _controllerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _menuHeight, self.view.frame.size.width, self.view.frame.size.height)];
    _controllerScrollView.pagingEnabled = YES;
    // Set delegate for controller scroll view
    _controllerScrollView.delegate = self;
    [self.view addSubview:_controllerScrollView];
    
    //selectionIndicatorView
    _selectionIndicatorView = [[UIView alloc] init];
    _selectionIndicatorView.backgroundColor = [UIColor orangeColor];
    [_menuScrollView addSubview:_selectionIndicatorView];
    
    
    // Disable scroll bars
    _menuScrollView.showsHorizontalScrollIndicator       = NO;
    _menuScrollView.showsVerticalScrollIndicator         = NO;
    _controllerScrollView.showsHorizontalScrollIndicator = NO;
    _controllerScrollView.showsVerticalScrollIndicator   = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configUserInterface {
    
    //calculate the width of menu scrool view
    __block CGFloat curMenuItemOffsetX = _menuMargin;
    
    [_controllerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LBPageViewInPageMenu *vc = obj;
        
        LBMenuItemInPageMenu *menuItemView = [[LBMenuItemInPageMenu alloc] initWithMenuItemHeight:_menuHeight - _selectionIndicatorViewHeight];
        menuItemView.titleFont = _menuItemFont;
        [menuItemView setUpMenuItemAndImageWidth:vc.menuItemTitle menuImage:vc.menuItemImage menuImageWidth:_menuItemImageWidth];
        
        CGRect menuItemCGRect = CGRectMake(curMenuItemOffsetX, 0, [menuItemView getMenuItemWidth], _menuHeight - _selectionIndicatorViewHeight);
        [menuItemView setFrame:menuItemCGRect];
        
        curMenuItemOffsetX += [menuItemView getMenuItemWidth] + _spaceBetweenMenuItems;
        [menuItemWidthArray addObject:@([menuItemView getMenuItemWidth])];
        [menuItemCGRectArray addObject:[NSValue valueWithCGRect:menuItemCGRect]];
        
        
        //add menu item into menu scroll view
        [self.menuScrollView addSubview:menuItemView];
    }];
    
    self.menuScrollView.contentSize = CGSizeMake(curMenuItemOffsetX, _menuHeight);
    self.controllerScrollView.contentSize = CGSizeMake((CGFloat)_controllerArray.count * self.view.frame.size.width, self.view.frame.size.height);
    
    //display the first page as default view
    LBPageViewInPageMenu *vc = _controllerArray[0];
    [vc.viewController viewWillAppear:YES];
    [self addPageAtIndex:0];
    [vc.viewController viewDidAppear:YES];
    
}

#pragma -mark: MenuScrollView
-(void)handleMenuItemTap:(UITapGestureRecognizer *)gestureRecognizer {
    
    CGPoint tappedPoint = [gestureRecognizer locationInView:_menuScrollView];
    
    [menuItemCGRectArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect menuItemCGRect = [obj CGRectValue];
        if (CGRectContainsPoint(menuItemCGRect, tappedPoint)) {
            
            NSLog(@"Tapped menu item %d", idx);
            
            [self moveSelectionIndicatorView:idx];
            
            // Move controller scroll view when tapping menu item
            double duration = 0.2;
            [UIView animateWithDuration:duration animations:^{
                
                [_controllerScrollView setContentOffset:CGPointMake(idx * self.view.frame.size.width, _menuHeight)];
            }];
            
            
        }
        
    }];
    
}

// MARK: - Remove/Add Page
- (void)addPageAtIndex:(NSInteger)index
{
    numPageCreated++;
    [pageAddedSet addObject:@(index)];
    // Call didMoveToPage delegate function
    LBPageViewInPageMenu *pageView = _controllerArray[index];
    UIViewController *newVC = pageView.viewController;
    if ([_delegate respondsToSelector:@selector(willMoveToPage:index:)]) {
        [_delegate willMoveToPage:newVC index:index];
    }
    
    [newVC willMoveToParentViewController:self];
    
    newVC.view.frame = CGRectMake(self.view.frame.size.width * (CGFloat)index, 0, self.view.frame.size.width, self.view.frame.size.height - _menuHeight);
    
    [self addChildViewController:newVC];
    [_controllerScrollView addSubview:newVC.view];
    [newVC didMoveToParentViewController:self];
    
    [self moveSelectionIndicatorView:index];
    
    
}


-(void)removePageAtIndex:(NSInteger)index {
    
    [pageAddedSet removeObject:@(index)];
    LBPageViewInPageMenu *pageView = _controllerArray[index];
    UIViewController *curVC = pageView.viewController;
    
    [curVC willMoveToParentViewController:nil];
    
    [curVC.view removeFromSuperview];
    [curVC removeFromParentViewController];
    
    [curVC didMoveToParentViewController:nil];
}

-(void)moveSelectionIndicatorView:(NSInteger)index {
    
    //insert selectionIndicatorView below the selected menu item
    [UIView animateWithDuration:0.15 animations:^{
        
        CGFloat currentMenuItemWidth = [menuItemWidthArray[index] floatValue];
        
        //determine current offset x of selectionIndicatorView
        CGFloat selectionIndicatorOffsetX = _menuMargin;
        for (int i=0; i < index; i++) {
            
            selectionIndicatorOffsetX += [menuItemWidthArray[i] floatValue] + _spaceBetweenMenuItems;
        }
        
        [_menuScrollView setContentOffset:CGPointMake(selectionIndicatorOffsetX, 0)];
        
        
        [_selectionIndicatorView setFrame:CGRectMake(selectionIndicatorOffsetX, _menuHeight - _selectionIndicatorViewHeight, currentMenuItemWidth, _selectionIndicatorViewHeight)];
        
    }];
}

#pragma mark - Scrollview Delegates
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([scrollView isEqual:_controllerScrollView]) {
        
        NSLog(@"currentPageIndex=%ld", (long)currentPageIndex);
        if (!isScrollAlready) {
            
            if (scrollView.contentOffset.x >= 0.0 && scrollView.contentOffset.x <= (CGFloat)(_controllerArray.count-1)*self.view.frame.size.width) {
                
                //determine whether swipe left or right
                if (scrollView.contentOffset.x > lastControllerScrollViewContentOffset) //swipe right
                {
                    if (currentPageIndex < _controllerArray.count - 1) { //not still reach last page
                        
                        currentPageIndex++;
                        [self addPageAtIndex:currentPageIndex];
                    }
                } else { //swipe left
                    
                    if (currentPageIndex > 0) {
                        
                        currentPageIndex--;
                        [self addPageAtIndex:currentPageIndex];
                    }
                }
            }
            
            isScrollAlready = YES;
        }
        
        lastControllerScrollViewContentOffset = scrollView.contentOffset.x;
    } else if ([scrollView isEqual:_menuScrollView]) {
        
        
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    [pageAddedSet enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if (currentPageIndex != [obj integerValue]) {
            
             // [self removePageAtIndex:[obj integerValue]];
        }
    }];
    
    isScrollAlready = false;
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
