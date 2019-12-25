//
//  NSObject+OverJumping.h
//
//  Created by Jesus on 26.12.2019.
//  Copyright © 2019 Дмитрий Гончар. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -
#pragma mark Category InitSelectorOverJumping for NSObject 
#pragma mark -

/*
 Example:

class C : B : A; // B is subclass A, C is subclass B

@implementation A
-(instancetype)init                                  <-----
{                                                          |
    // ... initialization ...                              |
    return self;                                           |
}                                                          |
@end                                                       |
                                                           |
@implementation B                                          |
-(instancetype)init                                  <---  |
{                                                        | | JUMP OVER CHAIN
    return nil;                   // nil !               | |
}                                                        | |
@end                                                     | |
                                                         | |
@implementation C                                        | |
-(instancetype)init                                      | |
{                                                        | |
    self = [super init];          // super init == nil --  |
    self = [super initFromSuper]; // super super init  ----
    return self;
}
@end
 */

@interface NSObject (InitSelectorOverJumping)

- (instancetype)initFromSuper;

@end
