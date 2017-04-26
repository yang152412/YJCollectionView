//
//  UICollectionView+YJReload.m
//  neighborhood
//
//  Created by Yang on 2017/4/24.
//  Copyright © 2017年 Yang. All rights reserved.
//

#import "UICollectionView+YJReload.h"

@implementation UICollectionView (YJReload)


- (void)yj_reloadData
{
    NSUInteger sections = [self numberOfSections];
    NSUInteger newSections = sections;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        newSections = [self.dataSource numberOfSectionsInCollectionView:self];
    }
    NSInteger sectionsOffset = newSections - sections;
    
    // new indexPaths after reload data
    NSMutableArray *newIndexPaths = [[NSMutableArray alloc] init];
    
    // need to add
    NSMutableArray *addIndexPaths = [[NSMutableArray alloc] init];
    // need to delete
    NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
    NSRange addSectionsRange = NSMakeRange(0, 0),deleteSectionsRange = NSMakeRange(0, 0);
    // 1. find section count changes
    if (sectionsOffset > 0) { // add
        addSectionsRange = NSMakeRange(sections, labs(sectionsOffset));
        for (NSInteger i = sections; i < newSections; i++) {
            // new section
            NSUInteger newCount = [self.dataSource collectionView:self numberOfItemsInSection:i];
            NSArray *paths = [self createIndexPathInSection:i range:NSMakeRange(0, newCount)];
            [addIndexPaths addObjectsFromArray:paths];
        }
    } else if (sectionsOffset < 0){ // delete
        deleteSectionsRange = NSMakeRange(newSections, labs(sectionsOffset));
        for (NSInteger i = newSections; i < sections; i++) {
            NSUInteger newCount = [self.dataSource collectionView:self numberOfItemsInSection:i];
            NSArray *paths = [self createIndexPathInSection:i range:NSMakeRange(0, newCount)];
            [deleteIndexPaths addObjectsFromArray:paths];
        }
    }
    
    // add changed items in every section not changed
    NSUInteger sameSection = sectionsOffset > 0 ? sections : newSections;
    for (NSInteger i = 0; i < sameSection; i++) {
        [self changedItemInSection:i newIndexPaths:newIndexPaths addIndexPaths:addIndexPaths deletePaths:deleteIndexPaths];
    }
    
    @try {
        [self performBatchUpdates:^{
            if (addSectionsRange.length > 0) {
                [self insertSections:[NSIndexSet indexSetWithIndexesInRange:addSectionsRange]];
            }
            if (addIndexPaths.count > 0) {
                [self insertItemsAtIndexPaths:addIndexPaths];
            }
            if (deleteSectionsRange.length > 0) {
                [self deleteSections:[NSIndexSet indexSetWithIndexesInRange:deleteSectionsRange]];
            }
            if (deleteIndexPaths.count > 0){
                [self deleteItemsAtIndexPaths:deleteIndexPaths];
            }
        } completion:^(BOOL finished) {
        }];
    } @catch (NSException *exception) {
        NSLog(@"Error updating collection view: %@", exception);
    }

    // reload sections the image will also be flashed
    // 1.method
//    [UIView animateWithDuration:0.25 animations:^{
//        if (newIndexPaths.count>0) {
//            [self reloadItemsAtIndexPaths:newIndexPaths];
////            [self reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newSections)]];
//        }
//    }];
    // 2.method
    @try {
        [self performBatchUpdates:^{
            if (newIndexPaths.count>0) {
                  [self reloadItemsAtIndexPaths:newIndexPaths];
//                [self reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newSections)]];
            }
        } completion:^(BOOL finished) {
        }];
    } @catch (NSException *exception) {
        NSLog(@"Error updating collection view: %@", exception);
    }
}

- (NSMutableArray <NSIndexPath *>*)createIndexPathInSection:(NSUInteger)section range:(NSRange)range
{
    NSMutableArray *newIndexPaths = [[NSMutableArray alloc] init];
    for (NSInteger i = range.location; i < range.length; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
        [newIndexPaths addObject:indexPath];
    }
    return newIndexPaths;
}


- (void)changedItemInSection:(NSUInteger)section
               newIndexPaths:(NSMutableArray *)newIndexPaths
               addIndexPaths:(NSMutableArray *)addIndexPaths
                 deletePaths:(NSMutableArray *)deleteIndexPaths
{
    NSUInteger count = [self numberOfItemsInSection:section];
    NSUInteger newCount = [self.dataSource collectionView:self numberOfItemsInSection:section];
    
    //        NSMutableArray *addIndexPaths = [[NSMutableArray alloc] init];
    //        NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
    
    NSInteger offset = newCount - count;
    if (offset > 0) {
        for (NSInteger i = count; i < newCount; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            [addIndexPaths addObject:indexPath];
        }
    } else if (offset < 0){
        for (NSInteger i = newCount; i < count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
            [deleteIndexPaths addObject:indexPath];
        }
    }
    
    //        NSMutableArray *newIndexPaths = [[NSMutableArray alloc] init];
    for (int i = 0; i < newCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:section];
        [newIndexPaths addObject:indexPath];
    }
}

@end
