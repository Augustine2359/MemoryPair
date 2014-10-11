//
//  MPCollectionViewCell.h
//  MemoryPair
//
//  Created by Augustine on 17/9/14.
//  Copyright (c) 2014 Augustine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
  CellStateClosed = 0,
  CellStateOpen,
  CellStateCleared
} CellState;

@interface MPCollectionViewCell : UICollectionViewCell

- (void)updateWithString:(NSString *)string;
- (void)showCell:(BOOL)shouldShow;

@end
