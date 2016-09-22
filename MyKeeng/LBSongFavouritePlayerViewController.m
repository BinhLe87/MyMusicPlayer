//
//  LBSongFavouritePlayerViewController.m
//  MyKeeng
//
//  Created by Le Van Binh on 9/18/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBSongFavouritePlayerViewController.h"
#import "UIImage+ImageEffects.h"
#import <GPUImage/GPUImage.h>
#import "LBHomeNewSongCell.h"
#import "UIImageView+WebCache.h"
#import "LBConnManager.h"



@interface LBSongFavouritePlayerViewController() {
    
    //headerView properties
    UIView *headerView;
    CGRect headerViewRect;
    
    //footerView properties
    UIView *footerView;
    CGRect footerViewRect;
    
    //table view's datasource
    int curPageIdx;
    LBConnManager *connManager;
    CGRect originTableFrame;
    
    //scrollview
    UIScrollView *myScrollView;
    UIPageControl *pageControl;
    CGFloat lastScrollPageOffsetX;
    BOOL isDidEndScroll;
}

@end

static const int NUM_ROW_PER_PAGE = 10;
static const int NUM_PAGE_IN_SCROLLVIEW = 3;

@implementation LBSongFavouritePlayerViewController


#pragma mark - Initializer methods
-(void)setCurrentPageIndex:(int)currentPageIndex {
    
    _currentPageIndex = currentPageIndex;
    if (pageControl) {
        
        pageControl.currentPage = currentPageIndex;
    }
}

-(instancetype)initWithSong:(LBSong *)song {
    
    if(!(self = [super init])) return nil;
    
    _song = song;
    
    return self;
}



-(void)viewWillAppear:(BOOL)animated {
    
    [self initValues];
    
    //load data of first page
    curPageIdx = 1;
    [self loadDataAtPage:curPageIdx size:NUM_ROW_PER_PAGE completion:^(BOOL succeed, NSError *error) {
    }];
    
    //register observing keyboard notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    
    UIView* v = footerView;
    while ( v.superview != nil )
    {
        NSLog( @"%@ - %@", NSStringFromClass([v class]), CGRectContainsRect( v.superview.bounds, v.frame ) ? @"GOOD!" : @"BAD!" );
        v = v.superview;
    }
    
    self.view.frame = CGRectMake(0, 0, 320, 568);
}


-(void)viewWillDisappear:(BOOL)animated {
    
    //unregister observing keyboard notification
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    
    [super viewWillDisappear:animated];
}

-(void)initValues {
    
    
    _currentPageIndex = 0;
    //TODO:Set up PAGE ONE
    //create UIImageView with blurred image
    UIImageView *blurImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    UIImage *songImage = [self downloadImage];
    UIImage *blurredImage = [self generateBlurredImage:songImage];
    blurImageView.image = blurredImage;
    [self.view addSubview:blurImageView];
    
    
    //layout headerView
    headerView = [[UIView alloc] init];
    headerViewRect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50);
    headerView.frame = headerViewRect;
    headerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:headerView];
    
    UIImageView *backView = [[UIImageView alloc] init];
    backView.image = [UIImage imageNamed:@"back.png"];
    backView.frame = CGRectMake(10, 10, 20, 20);
    [headerView addSubview:backView];
    UITapGestureRecognizer *tapGestureOnBackView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moveToParentViewController)];
    tapGestureOnBackView.numberOfTapsRequired = 1;
    tapGestureOnBackView.numberOfTouchesRequired = 1;
    tapGestureOnBackView.delegate = self;
    [backView setUserInteractionEnabled:YES];
    [backView addGestureRecognizer:tapGestureOnBackView];
    
    
    UILabel *headerViewTitle = [[UILabel alloc] init];
    headerViewTitle.text = [NSString stringWithFormat:@"%@-%@", _song.name, _song.singer];
    headerViewTitle.textColor = [UIColor yellowColor];
    headerViewTitle.frame = CGRectMake(CGRectGetMaxX(backView.frame) + 10, 10, 200, 20);[headerView addSubview:headerViewTitle];
    
    pageControl = [[UIPageControl alloc] init];
    CGFloat pageControlWidth = 30;
    pageControl.frame = CGRectMake(CGRectGetWidth(headerView.bounds)/2.0 - pageControlWidth/2.0, CGRectGetHeight(headerView.bounds) - 20, pageControlWidth, 20);
    pageControl.numberOfPages = NUM_PAGE_IN_SCROLLVIEW;
    pageControl.hidesForSinglePage = YES;
    pageControl.currentPage = self.currentPageIndex;
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.291 green:0.607 blue:1.000 alpha:1.000];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    [headerView addSubview:pageControl];
    
    //layout footerView
    footerView = [[UIView alloc] init];
    footerViewRect = CGRectMake(0, CGRectGetHeight(self.view.frame) - 40, CGRectGetWidth(self.view.frame), 40);
    footerView.frame = footerViewRect;
    footerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:footerView];
    
    UITextField *commentTextField = [[UITextField alloc] init];
    commentTextField.frame = CGRectInset(footerView.bounds, 2, 2);
    commentTextField.textColor = [UIColor blackColor];
    commentTextField.font = [UIFont systemFontOfSize:13.0f];
    commentTextField.borderStyle = UITextBorderStyleRoundedRect;
    commentTextField.placeholder = @"Chia sẻ cảm xúc và làm quen";
    [footerView addSubview:commentTextField];
    
    
    //layout centerView
    myScrollView = [[UIScrollView alloc] init];
    CGFloat scrollViewHeight = CGRectGetHeight(self.view.frame) - headerViewRect.size.height - footerViewRect.size.height;
    myScrollView.frame = CGRectMake(0, CGRectGetMaxY(headerViewRect), CGRectGetWidth(self.view.bounds), scrollViewHeight);
    myScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds) * NUM_PAGE_IN_SCROLLVIEW, scrollViewHeight);
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.delegate = self;
    myScrollView.bounces = NO;
    [self.view addSubview:myScrollView];
    lastScrollPageOffsetX = 0;
    isDidEndScroll = NO;
    
    
    _tableview = [[UITableView alloc] init];
    _tableview.frame = CGRectMake(2, 3, CGRectGetWidth(self.view.bounds)-6, scrollViewHeight);
    [myScrollView addSubview:_tableview];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    [_tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _tableview.backgroundColor = [UIColor colorWithWhite:0.05 alpha:0.1];
    originTableFrame = _tableview.frame;
    _tableview.layer.cornerRadius = 15;
    _tableview.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    
    UINib *songCellNib = [UINib nibWithNibName:@"LBHomeNewSongCell" bundle:nil];
    [self.tableview registerNib:songCellNib forCellReuseIdentifier:[LBHomeNewSongCell reusableCellWithIdentifier]];
    
    _medias = [NSMutableArray array];
    
    connManager = [[LBConnManager alloc] init];
    
    //TODO:Set up PAGE TWO
    UIView *pageTwoView = [[UIView alloc] init];
    pageTwoView.frame = CGRectMake(CGRectGetWidth(self.view.bounds), 0, CGRectGetWidth((self.view.bounds)), scrollViewHeight);
    [myScrollView addSubview:pageTwoView];
    
    UILabel *songTitle = [[UILabel alloc] init];
    songTitle.text =_song.name;
    songTitle.textColor = [UIColor orangeColor];
    songTitle.font = [UIFont systemFontOfSize:20];
    songTitle.frame = CGRectMake(10, 10, CGRectGetWidth(pageTwoView.bounds) - 20, 20);
    [pageTwoView addSubview:songTitle];
    
    //TODO:Set up PAGE THREE
    UIView *pageThreeView = [[UIView alloc] init];
    pageThreeView.frame = CGRectMake(CGRectGetWidth(self.view.bounds)*2, 0, CGRectGetWidth((self.view.bounds)), scrollViewHeight);
    [myScrollView addSubview:pageThreeView];
    
    UILabel *singerName = [[UILabel alloc] init];
    singerName.text =_song.singer;
    singerName.textColor = [UIColor cyanColor];
    singerName.font = [UIFont systemFontOfSize:15];
    singerName.frame = CGRectMake(10, 10, CGRectGetWidth(pageTwoView.bounds) - 20, 20);
    [pageThreeView addSubview:singerName];
}

#pragma mark - Table view controller
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _medias.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBMedia *media = [_medias objectAtIndex:indexPath.row];
    
    if ([media isKindOfClass:[LBSong class]]) {
        
        return [LBHomeNewSongCell heightForSongCell];
    }
    
    return 0;
}


-(BOOL)canBecomeFirstResponder {
    
    return YES;
}

-(BOOL)becomeFirstResponder {
    
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LBMedia *media = [_medias objectAtIndex:indexPath.row];
    
    if ([media isKindOfClass:[LBSong class]]) {
        
        LBHomeNewSongCell *songCell;
        
        songCell = (LBHomeNewSongCell *)[tableView dequeueReusableCellWithIdentifier:[LBHomeNewSongCell reusableCellWithIdentifier] forIndexPath:indexPath];
        songCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SDWebImageOptions songDownloadOptions = SDWebImageProgressiveDownload | SDWebImageContinueInBackground | SDWebImageTransformAnimatedImage;
        
        
        [songCell.SongImg sd_setImageWithURL:media.image.url placeholderImage:[UIImage imageNamed:@"image_placeholder.png"] options:songDownloadOptions];
        
        [songCell.SongImg setShowActivityIndicatorView:YES];
        
        
        songCell.SongNameLbl.text = media.name;
        songCell.SingerLbl.text = media.singer;
        songCell.NumListenLbl.text = [NSString stringWithFormat:@"%d", [media.listen_no intValue]];
        songCell.NumLikeLbl.text = @"New Song";
        songCell.NumCommentLbl.text = [NSString stringWithFormat:@"Giá %d", [media.price intValue]];
        songCell.song = (LBSong*)media;
        songCell.backgroundColor = [UIColor clearColor];
        songCell.SongNameLbl.textColor = [UIColor whiteColor];
        
        //display seperator image at the bottom of cell
        UIImageView *seperatorImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"separator_cell.png"]];
        seperatorImgView.frame = CGRectMake(0, [LBHomeNewSongCell heightForSongCell] - 1 , CGRectGetWidth(songCell.bounds), 1);
        
        [songCell.contentView addSubview:seperatorImgView];
        
        return songCell;
    }
    
    return 0;
}


-(void)loadDataAtPage:(int)iPage size:(int)iSize completion:(void (^)(BOOL, NSError *))iCompletion {
    
    __weak typeof(self) weakself = self;
    
    
    [connManager getHomeNewMedias:iPage size:iSize performWithCompletion:^(BOOL succeed, NSError *error, NSMutableArray<LBMedia *> *aMedias) {
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            if (succeed) {
                
                [weakself.tableview beginUpdates];
                int curRowCount = weakself.medias.count;
                
                for (LBMedia *media in aMedias) {
                    
                    if ([media isKindOfClass:[LBSong class]]) {
                        [weakself.medias addObject:media];
                    }
                }
                
                NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
                
                for (int i = curRowCount; i < weakself.medias.count; i++) {
                    
                    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [insertIndexPaths addObject:newIndexPath];
                }
                
                
                [weakself.tableview insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationFade];
                
                [weakself.tableview endUpdates];
                
                iCompletion(true, nil);
                
                [weakself.tableview reloadData];
            } else {
                
                iCompletion(false, error);
            }});
    }];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    isDidEndScroll = YES;
    
    CGFloat currentScrollPageContentOffsetX = scrollView.contentOffset.x;
    
    if (currentScrollPageContentOffsetX >= 0.0 && currentScrollPageContentOffsetX <= (CGFloat)self.view.bounds.size.width * (NUM_PAGE_IN_SCROLLVIEW -1)) {
        
        if (currentScrollPageContentOffsetX > lastScrollPageOffsetX) { //swipe right
            
            if (self.currentPageIndex < NUM_PAGE_IN_SCROLLVIEW - 1) {
                
                self.currentPageIndex++;
            }
        } else if (currentScrollPageContentOffsetX < lastScrollPageOffsetX){ //swipe left
            
            if (self.currentPageIndex > 0) {
                
                self.currentPageIndex--;
            }
        }
        
        lastScrollPageOffsetX = currentScrollPageContentOffsetX;
    }
    
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _tableview) {
        
        CGPoint contentOffset =[self.tableview contentOffset];
        NSIndexPath *scroolToIndexPath = [self.tableview indexPathForRowAtPoint:CGPointMake(contentOffset.x, self.tableview.bounds.size.height + contentOffset.y)];
        
        
        if ([scroolToIndexPath row] == [self.medias count] - 1) { //scroll reach last row
            
            // if (self.tableview.contentOffset.y > self.tableview.contentSize.height - self.tableview.bounds.size.height) {
            curPageIdx += 1;
            [self loadDataAtPage:curPageIdx size:NUM_ROW_PER_PAGE completion:^(BOOL succeed, NSError *error) {
                
            }];
        }
    }
}


#pragma mark - Generate Blurred image
-(UIImage*)generateBlurredImage:(UIImage*)originImage {
    
    return [originImage applyBlurWithRadius:50 tintColor:[UIColor colorWithWhite:0.7 alpha:0.2] saturationDeltaFactor:1.5 maskImage:nil];
    
    // UIImage *bgImage = [UIImage imageNamed:@"singerB.jpg"];
    
    
    /*GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc] init];
     blurFilter.blurRadiusInPixels = 20.0;
     
     return [blurFilter imageByFilteringImage: originImage];*/
    
}

-(UIImage*)downloadImage {
    
    NSData *songImageData = [[NSData alloc] initWithContentsOfURL:_song.image.url];
    UIImage *songImage = nil;
    
    if (songImageData) {
        
        songImage = [UIImage imageWithData:songImageData];
    }
    
    return songImage;
}

#pragma mark - Move to parent view controller
-(void)moveToParentViewController {
    
    [self willMoveToParentViewController:nil];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.view.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame), 0, 0);
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
}


#pragma mark - Response to Keyboard events
-(void)keyboardWillShow:(NSNotification *)notification {
    
    
    //dertermine the last visible cell for scrolling to it
    NSArray<UITableViewCell*> *visibleCells = [_tableview visibleCells];
    UITableViewCell *lastTableCell = [visibleCells lastObject];
    NSIndexPath *lastIndexPath = [_tableview indexPathForCell:lastTableCell];
    
    //get the end position of keyboard frame
    NSDictionary *keyInfo = [notification userInfo];
    CGRect keyboardFrame = [[keyInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    //Step 1: move foot view above keyboard
    CGRect keyboardFrameInRootView = [self.view convertRect:keyboardFrame fromView:nil];
    footerView.frame = CGRectMake(0, keyboardFrameInRootView.origin.y - CGRectGetHeight(footerView.bounds), CGRectGetWidth(footerView.frame), CGRectGetHeight(footerView.frame));

    
    //Step 2: move table view above all of footview
    //convert it to the same view coords as the tableView it might be occluding
    CGFloat oldTableViewHeight = CGRectGetHeight(_tableview.frame);
    CGRect tableViewFrameInView = _tableview.frame;
    tableViewFrameInView.size.height = footerView.frame.origin.y - CGRectGetMaxY(headerView.frame) - 3;
    _tableview.frame = tableViewFrameInView;
    
    CGFloat decreasedHeight = oldTableViewHeight - CGRectGetHeight(_tableview.frame);
    self.tableview.contentInset = UIEdgeInsetsMake(0, 0, decreasedHeight, 0);
    self.tableview.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, decreasedHeight, 0);
    
    [_tableview scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

    
    
    /*CGRect keyboardFrameInTableView = [self.tableview convertRect:keyboardFrame fromView:nil];
    //calculate if the rects intersect
    CGRect intersect = CGRectIntersection(keyboardFrameInTableView, self.tableview.bounds);
    
    if (!CGRectIsNull(intersect)) {
        
        //yes they do - adjust the insets on tableview to handle it
        //first get the duration of the keyboard appearance animation
        NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
        //change the table insets to match - animated to the same duration of the keyboard appearance
    }*/
}

- (void) keyboardWillHide:  (NSNotification *) notification{
    
    NSDictionary *keyInfo = [notification userInfo];
    NSTimeInterval duration = [[keyInfo objectForKey:@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    //clear the table insets - animated to the same duration of the keyboard disappearance
    [UIView animateWithDuration:duration animations:^{
        self.tableview.contentInset = UIEdgeInsetsZero;
        self.tableview.scrollIndicatorInsets = UIEdgeInsetsZero;
        
    }];
}



@end
