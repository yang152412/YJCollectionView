//
//  UICollectionView+YJReload.h
//  neighborhood
//
//  Created by Yang on 2017/4/24.
//  Copyright © 2017年 Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (YJReload)


/**
 Find the items count in every section  of UICollectionView has been changed, 
 then invoke insertItemsAtIndexPaths or deleteItemsAtIndexPaths . 
 At last ,invoke reloadItemsAtIndexPaths for the items that not changed.
 */
- (void)yj_reloadData;

@end
