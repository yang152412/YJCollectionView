# YJCollectionView
fix UICollectionView call relaodData flash


Find the items count in every section  of UICollectionView has been changed, 
 then invoke insertItemsAtIndexPaths or deleteItemsAtIndexPaths . 
 At last ,invoke reloadItemsAtIndexPaths for the items that not changed.
