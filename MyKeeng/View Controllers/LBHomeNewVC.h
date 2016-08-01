//
//  LBHomeNewVC.h
//  MyKeeng
//
//  Created by Le Van Binh on 7/12/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LBMedia.h"
#import "LBSong.h"
#import "LBVideo.h"
#import "LBConnManager.h"

@interface LBHomeNewVC : UIViewController {
    
    NSManagedObjectContext *_managedObjectContext;
    LBConnManager *connManager;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic) NSMutableArray <LBMedia *> *medias;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;




@end
