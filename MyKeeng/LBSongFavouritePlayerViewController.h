//
//  LBSongFavouritePlayerViewController.h
//  MyKeeng
//
//  Created by Le Van Binh on 9/18/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBSong.h"

@interface LBSongFavouritePlayerViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate> {
    
  //  NSMutableArray<LBMedia *> *medias;
}

@property(nonatomic) LBSong *song;
@property(nonatomic) UITableView *tableview;
@property(nonatomic) NSMutableArray<LBMedia*> *medias;

@property(nonatomic) int currentPageIndex;

-(instancetype)initWithSong:(LBSong*)song;

@end
