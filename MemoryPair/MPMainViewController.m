//
//  MPMainViewController.m
//  MemoryPair
//
//  Created by Augustine on 17/9/14.
//  Copyright (c) 2014 Augustine. All rights reserved.
//

#import "MPMainViewController.h"
#import "MPCollectionViewCell.h"

#define REUSE_IDENTIFIER_NORMAL @"NormalIdentifier"

@interface MPMainViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *pairs;
@property (nonatomic, strong) NSArray *locationOfPairs;
@property (nonatomic, strong) NSMutableArray *cellStates;
@property (nonatomic) NSInteger indexOfOpenCellA;
@property (nonatomic) NSInteger indexOfOpenCellB;

@end

@implementation MPMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  [self generatePairs];
  [self.collectionView registerClass:[MPCollectionViewCell class] forCellWithReuseIdentifier:REUSE_IDENTIFIER_NORMAL];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)generatePairs {
  NSMutableArray *array = [NSMutableArray array];
  for (NSInteger index = 0; index < 8; index++) {
    [array addObject:[NSString stringWithFormat:@"%ld", index]];
    [array addObject:[NSString stringWithFormat:@"%ld", index]];
  }
  self.pairs = [NSArray arrayWithArray:array];

  array = [NSMutableArray array];
  for (NSInteger index = 0; index < 16; index++) {
    [array addObject:[NSNumber numberWithInteger:index]];
  }
  
  NSMutableArray *locations = [NSMutableArray array];
  while ([array count] > 0) {
    NSInteger randomNumber = arc4random() % [array count];
    NSInteger index = [array[randomNumber] intValue];
    [locations addObject:self.pairs[index]];
    [array removeObjectAtIndex:randomNumber];
  }
  
  self.locationOfPairs = [NSArray arrayWithArray:locations];
  
  self.cellStates = [NSMutableArray array];
  for (NSInteger index = 0; index < 16; index++) {
    [self.cellStates addObject:[NSNumber numberWithInteger:CellStateClosed]];
  }
  
  self.indexOfOpenCellA = NSNotFound;
  self.indexOfOpenCellB = NSNotFound;
  
  [self.collectionView reloadData];
}

- (void)resolvePairs {
  if (self.indexOfOpenCellB == NSNotFound)
    return;

  self.collectionView.userInteractionEnabled = NO;
  
  NSString *string1 = self.locationOfPairs[self.indexOfOpenCellA];
  NSString *string2 = self.locationOfPairs[self.indexOfOpenCellB];
  if ([string1 isEqualToString:string2]) {
    [self.cellStates replaceObjectAtIndex:self.indexOfOpenCellA withObject:[NSNumber numberWithInteger:CellStateCleared]];
    [self.cellStates replaceObjectAtIndex:self.indexOfOpenCellB withObject:[NSNumber numberWithInteger:CellStateCleared]];
  }
  else {
    [self.cellStates replaceObjectAtIndex:self.indexOfOpenCellA withObject:[NSNumber numberWithInteger:CellStateClosed]];
    [self.cellStates replaceObjectAtIndex:self.indexOfOpenCellB withObject:[NSNumber numberWithInteger:CellStateClosed]];
  }

  self.indexOfOpenCellA = NSNotFound;
  self.indexOfOpenCellB = NSNotFound;

  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    self.collectionView.userInteractionEnabled = YES;
  });
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  MPCollectionViewCell *cell = (MPCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:REUSE_IDENTIFIER_NORMAL forIndexPath:indexPath];

  switch ([self.cellStates[indexPath.row] intValue]) {
    case CellStateClosed: {
      [cell showCell:YES];
      [cell updateWithString:@""];
      break;
    }
    case CellStateOpen: {
      [cell showCell:YES];
      NSString *string = self.locationOfPairs[indexPath.row];
      [cell updateWithString:string];
      break;
    }
    case CellStateCleared: {
      [cell showCell:NO];
      break;
    }
    default:
      break;
  }

  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  switch ([self.cellStates[indexPath.row] intValue]) {
    case CellStateClosed: {
      [self.cellStates replaceObjectAtIndex:[indexPath row] withObject:[NSNumber numberWithInteger:CellStateOpen]];
      if (self.indexOfOpenCellA == NSNotFound) {
        self.indexOfOpenCellA = [indexPath row];
      }
      else {
        if (self.indexOfOpenCellB == NSNotFound) {
          self.indexOfOpenCellB = [indexPath row];
        }
      }

      [collectionView reloadItemsAtIndexPaths:@[indexPath]];
      [self resolvePairs];
      return;
    }
    case CellStateOpen: {
      return;
      break;
    }
    case CellStateCleared: {
      return;
    }
    default:
      break;
  }
}

@end
