//
//  DataSource.h
//  PCDanDan
//
//  Created by Boring on 2018/1/9.
//  Copyright © 2018年 vma-lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject
+ (NSMutableArray *) getDxdDataSource;
+ (NSMutableArray *) getCszDataSource;
+ (NSMutableArray *) getTswfDataSource;
+ (void) resetAll;
@end
