//
//  MPCollectionViewCell.m
//  MemoryPair
//
//  Created by Augustine on 17/9/14.
//  Copyright (c) 2014 Augustine. All rights reserved.
//

#import "MPCollectionViewCell.h"

@interface MPCollectionViewCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation MPCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {      
      self.label = [[UILabel alloc] init];
      self.label.backgroundColor = [UIColor whiteColor];
      self.label.frame = self.contentView.frame;
      self.label.textAlignment = NSTextAlignmentCenter;
      self.label.font = [UIFont boldSystemFontOfSize:20];
      [self.contentView addSubview:self.label];
        // Initialization code
    }
    return self;
}

- (void)updateWithString:(NSString *)string {
  self.label.text = string;
}

- (void)showCell:(BOOL)shouldShow {
  if (shouldShow) {
    self.label.hidden = NO;
    self.backgroundColor = [UIColor whiteColor];
  }
  else {
    self.label.hidden = YES;
    self.backgroundColor = [UIColor blackColor];
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
