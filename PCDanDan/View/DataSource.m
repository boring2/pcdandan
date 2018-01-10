//
//  DataSource.m
//  PCDanDan
//
//  Created by Boring on 2018/1/9.
//  Copyright © 2018年 vma-lin. All rights reserved.
//

#import "DataSource.h"

static NSMutableArray<NSMutableDictionary<NSString *, NSString *> *> *dxdDataSource ;
static NSMutableArray<NSMutableDictionary<NSString *, NSString *> *> *cszDataSource;
static NSMutableArray<NSMutableDictionary<NSString *, NSString *> *> *tswfDataSource;

@implementation DataSource


+ (void) initialize {
  if (dxdDataSource == nil) {
    dxdDataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
      NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
      [dic setValue:@"false" forKey:@"selected"];
      [dic setValue:@"0" forKey:@"total"];
      [dxdDataSource addObject:dic];
    }
  }
  if (cszDataSource == nil) {
    cszDataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < 28; i++) {
      NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
      [dic setValue:@"false" forKey:@"selected"];
      [dic setValue:@"0" forKey:@"total"];
      [cszDataSource addObject:dic];
    }
  }
  if (tswfDataSource == nil) {
    tswfDataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i < 4; i++) {
      NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
      [dic setValue:@"false" forKey:@"selected"];
      [dic setValue:@"0" forKey:@"total"];
      [tswfDataSource addObject:dic];
    }
  }
}

+ (NSMutableArray *) getDxdDataSource {
  return dxdDataSource;
}
+ (NSMutableArray *) getCszDataSource {
  return cszDataSource;
}
+ (NSMutableArray *) getTswfDataSource {
  return tswfDataSource;
}

+ (void) resetAll {
  dxdDataSource = [[NSMutableArray alloc] init];
  for (int i = 0; i < 10; i++) {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"false" forKey:@"selected"];
    [dic setValue:@"0" forKey:@"total"];
    [dxdDataSource addObject:dic];
  }
  cszDataSource = [[NSMutableArray alloc] init];
  for (int i = 0; i < 28; i++) {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"false" forKey:@"selected"];
    [dic setValue:@"0" forKey:@"total"];
    [cszDataSource addObject:dic];
  }
  tswfDataSource = [[NSMutableArray alloc] init];
  for (int i = 0; i < 4; i++) {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"false" forKey:@"selected"];
    [dic setValue:@"0" forKey:@"total"];
    [tswfDataSource addObject:dic];
  }
}

@end
