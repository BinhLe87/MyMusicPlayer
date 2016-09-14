//
//  LBMenuView.m
//  MyKeeng
//
//  Created by Le Van Binh on 9/13/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBMenuView.h"


@implementation UIFont(UIFont_Constants)

+(UIFont*)menuPopupItemFont {
    
    return [UIFont systemFontOfSize:13];
}

@end


@implementation LBMenuItem

-(instancetype)initMenuItem:(NSString *)title target:(id)target action:(SEL)action {
    
    if (!(self = [super init])) return nil;
    
    _title = title;
    _target = target;
    _action = action;
    
    _enabled = YES;
    
    return self;
}


-(void)performAction {
    
    if (_target && [_target respondsToSelector:_action]) {
        
        [_target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
    }
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}




@end


const CGFloat kArrowSize = 12.f;
@interface LBMenuView() {
    
    UIView *menuOverlayView;
    UIView *rootView;
    UIView *_contentView;
    CGRect menuOwnerRect;
    
    
    //position and size of menu popup
    CGFloat maxMenuWidth;
    CGFloat marginX;
    CGFloat marginY;
    
    KxMenuViewArrowDirection _arrowDirection;
    CGFloat _arrowPosition;
}

@end

@implementation LBMenuView

-(instancetype)initWithMenuItems:(NSMutableArray<LBMenuItem *> *)menuItems {
    
    if (!(self = [super initWithFrame:CGRectZero])) return nil;
    
    _menuItems = [NSMutableArray array];
    _menuItems = menuItems;
    
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    
    
    maxMenuWidth = 70.0;
    marginX = 2.0;
    marginY = 2.0;
    
    return self;
}

-(void)showMenuInView:(UIView *)view fromOwnerRect:(CGRect)fromOwnerRect {
    
    rootView = view;
    
    menuOverlayView = [[UIView alloc] initWithFrame:view.bounds];
    menuOverlayView.backgroundColor = [UIColor clearColor];
    [menuOverlayView addSubview:self];
    [rootView addSubview:menuOverlayView];
    UITapGestureRecognizer *tapGestureOnOverlayView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenuView)];
    tapGestureOnOverlayView.numberOfTapsRequired = 1;
    [menuOverlayView addGestureRecognizer:tapGestureOnOverlayView];
    UIPanGestureRecognizer *panGestureOnOverlayView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenuView)];
    
    [menuOverlayView addGestureRecognizer:panGestureOnOverlayView];
    [view bringSubviewToFront:menuOverlayView];
    
    
    _contentView = [self generateContentView];
    _contentView.backgroundColor = [UIColor grayColor];
    [self addSubview:_contentView];
    
    [self setupFrameInView:rootView fromRect:fromOwnerRect];
    
    menuOwnerRect = fromOwnerRect;
    CGPoint pointWillAppear = fromOwnerRect.origin;
    CGRect rectWillAppear = self.frame;
    
    self.frame = (CGRect){pointWillAppear, 1, 1};
    _contentView.hidden = YES;
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.alpha = 1;
        self.frame = rectWillAppear;
    } completion:^(BOOL finished) {
        
        _contentView.hidden = NO;
    }];
}

-(void)dismissMenuView {
    
    if (self.superview) {
        
        _contentView.hidden = YES;
        CGPoint pointBeginDissappear = menuOwnerRect.origin;
        CGRect toFrame = (CGRect){pointBeginDissappear, 1, 1};
        
        [UIView animateWithDuration:0.2 animations:^{
            
            self.alpha = 0;
            self.frame = toFrame;
        } completion:^(BOOL finished) {
            
            [self.superview removeFromSuperview]; // dismiss MenuOverlayView
            [self removeFromSuperview]; //dismiss menuview from menuOverlayView
        }];
    }
}

-(UIView*)generateContentView {
    
    __block CGFloat maxMenuItemWidth = 0.0;
    __block CGFloat maxMenuItemHeight = 0.0;
    
    if (_menuItems.count == 0)
        return nil;
    
    
    [_menuItems enumerateObjectsUsingBlock:^(LBMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect estimateItemRect;
        
        estimateItemRect = [obj.title boundingRectWithSize:CGSizeMake(1000, 1000) options: NSStringDrawingUsesLineFragmentOrigin attributes: @{NSFontAttributeName:[UIFont menuPopupItemFont]} context: nil];
        
        if (estimateItemRect.size.width > maxMenuItemWidth) {
            
            maxMenuItemWidth = estimateItemRect.size.width;
        }
        
        if (estimateItemRect.size.height > maxMenuItemHeight) {
            
            maxMenuItemHeight = estimateItemRect.size.height;
        }
    }];
    
    //plus margin X into maxMenuItemWidth
    maxMenuItemWidth = maxMenuItemWidth + (2 * marginX);
    
    UIView *contentView;
    contentView = [[UIView alloc] initWithFrame:CGRectZero];
    contentView.opaque = NO;
    contentView.backgroundColor = [UIColor clearColor];
    
    __block CGFloat currentItemOffsetY = 0;
    
    [_menuItems enumerateObjectsUsingBlock:^(LBMenuItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect itemFrame = CGRectMake(0, currentItemOffsetY, maxMenuItemWidth, maxMenuItemHeight);
        
        UIView *itemView = [[UIView alloc] initWithFrame:itemFrame];
        itemView.backgroundColor = [UIColor clearColor];
        itemView.opaque = NO;
        
        [contentView addSubview:itemView];
        
        
        if (obj.enabled) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = idx;
            button.frame = itemView.bounds;
            button.enabled = obj.enabled;
            
            [button addTarget:self action:@selector(performAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [itemView addSubview:button];
        }
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectInset(itemView.bounds, marginX, marginY)];
        titleLbl.text = obj.title;
        titleLbl.font = [UIFont menuPopupItemFont];
        titleLbl.textColor = [UIColor yellowColor];
        titleLbl.backgroundColor = [UIColor clearColor];
        
        [itemView addSubview:titleLbl];
        
        
        currentItemOffsetY += maxMenuItemHeight;
    }];
    
    contentView.frame = CGRectMake(0, 0, maxMenuItemWidth, currentItemOffsetY);
    
    return contentView;
    
}

- (void) setupFrameInView:(UIView *)view
                 fromRect:(CGRect)fromRect
{
    const CGSize contentSize = _contentView.frame.size;
    
    const CGFloat outerWidth = view.bounds.size.width;
    const CGFloat outerHeight = view.bounds.size.height;
    
    const CGFloat rectX0 = fromRect.origin.x;
    const CGFloat rectX1 = fromRect.origin.x + fromRect.size.width;
    const CGFloat rectXM = fromRect.origin.x + fromRect.size.width * 0.5f;
    const CGFloat rectY0 = fromRect.origin.y;
    const CGFloat rectY1 = fromRect.origin.y + fromRect.size.height;
    const CGFloat rectYM = fromRect.origin.y + fromRect.size.height * 0.5f;;
    
    const CGFloat widthPlusArrow = contentSize.width + kArrowSize;
    const CGFloat heightPlusArrow = contentSize.height + kArrowSize;
    const CGFloat widthHalf = contentSize.width * 0.5f;
    const CGFloat heightHalf = contentSize.height * 0.5f;
    
    const CGFloat kMargin = 5.f;
    
    if (heightPlusArrow < (outerHeight - rectY1)) {
        
        _arrowDirection = KxMenuViewArrowDirectionUp;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY1
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        //_arrowPosition = MAX(16, MIN(_arrowPosition, contentSize.width - 16));
        _contentView.frame = (CGRect){0, kArrowSize, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + kArrowSize
        };
        
    } else if (heightPlusArrow < rectY0) {
        
        _arrowDirection = KxMenuViewArrowDirectionDown;
        CGPoint point = (CGPoint){
            rectXM - widthHalf,
            rectY0 - heightPlusArrow
        };
        
        if (point.x < kMargin)
            point.x = kMargin;
        
        if ((point.x + contentSize.width + kMargin) > outerWidth)
            point.x = outerWidth - contentSize.width - kMargin;
        
        _arrowPosition = rectXM - point.x;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width,
            contentSize.height + kArrowSize
        };
        
    } else if (widthPlusArrow < (outerWidth - rectX1)) {
        
        _arrowDirection = KxMenuViewArrowDirectionLeft;
        CGPoint point = (CGPoint){
            rectX1,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + kMargin) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){kArrowSize, 0, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width + kArrowSize,
            contentSize.height
        };
        
    } else if (widthPlusArrow < rectX0) {
        
        _arrowDirection = KxMenuViewArrowDirectionRight;
        CGPoint point = (CGPoint){
            rectX0 - widthPlusArrow,
            rectYM - heightHalf
        };
        
        if (point.y < kMargin)
            point.y = kMargin;
        
        if ((point.y + contentSize.height + 5) > outerHeight)
            point.y = outerHeight - contentSize.height - kMargin;
        
        _arrowPosition = rectYM - point.y;
        _contentView.frame = (CGRect){CGPointZero, contentSize};
        
        self.frame = (CGRect) {
            
            point,
            contentSize.width  + kArrowSize,
            contentSize.height
        };
        
    } else {
        
        _arrowDirection = KxMenuViewArrowDirectionNone;
        
        self.frame = (CGRect) {
            
            (outerWidth - contentSize.width)   * 0.5f,
            (outerHeight - contentSize.height) * 0.5f,
            contentSize,
        };
    }
}


-(void)performAction:(id) sender {
    
    [self dismissMenuView];
    
    UIButton *button = (UIButton*) sender;
    LBMenuItem *menuItem = [_menuItems objectAtIndex:button.tag];
    [menuItem performAction];
}

@end
