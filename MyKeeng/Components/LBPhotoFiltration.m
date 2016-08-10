//
//  LBPhotoFiltration.m
//  MyKeeng
//
//  Created by Le Van Binh on 8/10/16.
//  Copyright © 2016 LB. All rights reserved.
//

#import "LBPhotoFiltration.h"
#import "LBPhoto.h"

@implementation LBPhotoFiltration 

-(instancetype)initWithPhoto:(LBPhoto *)iPhoto indexPath:(NSIndexPath *)iIndexPath delegate:(id<LBPhotoFiltrationDelegate>)iDelegate {
    
    if (self = [super init]) {
        
        _photo = iPhoto;
        _indexPathInTableView = iIndexPath;
        self.delegate = iDelegate;
    }
    
    return self;
}

-(void)main {
    
    if (self.isCancelled)
        return;
    
    if (!self.photo.hasImage)
        return;
    
    UIImage *rawImage = self.photo.image;
    UIImage *processedImage = [self applySepiaFilterToImage:rawImage];
    
    if (self.isCancelled)
        return;
    
    if (processedImage) {
        
        self.photo.image = processedImage;
        self.photo.filtered = YES;
        
        if ([self.delegate respondsToSelector:@selector(LBPhotoFiltrationDidFinish:)]) {
            
            [self.delegate LBPhotoFiltrationDidFinish:self];
        }
    }
}

#pragma mark -
#pragma mark - Filtering image


- (UIImage *)applySepiaFilterToImage:(UIImage *)image {
    
    // This is expensive + time consuming
    CIImage *inputImage = [CIImage imageWithData:UIImagePNGRepresentation(image)];
    
    if (self.isCancelled)
        return nil;
    
    UIImage *sepiaImage = nil;
    CIContext *context = [CIContext contextWithOptions:nil];
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues: kCIInputImageKey, inputImage, @"inputIntensity", [NSNumber numberWithFloat:0.8], nil];
    CIImage *outputImage = [filter outputImage];
    
    if (self.isCancelled)
        return nil;
    
    // Create a CGImageRef from the context
    // This is an expensive + time consuming
    CGImageRef outputImageRef = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    if (self.isCancelled) {
        CGImageRelease(outputImageRef);
        return nil;
    }
    
    sepiaImage = [UIImage imageWithCGImage:outputImageRef];
    CGImageRelease(outputImageRef);
    return sepiaImage;
}

@end
