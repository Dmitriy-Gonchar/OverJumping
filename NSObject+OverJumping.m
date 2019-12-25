//
//  NSObject+OverJumping.m
//
//  Created by Jesus on 26.12.2019.
//    Copyright © 2019 Дмитрий Гончар. All rights reserved.
//

#import "NSObject+OverJumping.h"

#import <objc/runtime.h>

#pragma mark -
#pragma mark AnyNSObjectDescendant declaration:
#pragma mark -

@interface AnyNSObjectDescendant : NSObject
- (instancetype)initFromSuper;
@end

@implementation AnyNSObjectDescendant
-(instancetype)initFromSuper
{
// [super super init] implementation:
	IMP impInit = class_getMethodImplementation([self.superclass superclass],
												@selector(init));

// [super init] implementation:
	IMP prevImpInit = class_getMethodImplementation([self superclass],
													@selector(init));

// precautionary measures:
	@synchronized (self.superclass)
	{
// replace implementation:
		class_replaceMethod(self.superclass,
							@selector(init),
							impInit,
							NULL);

// call replaced implementation:
		self = [super init];

// call return back:
		class_replaceMethod(self.superclass,
							@selector(init),
							prevImpInit,
							NULL);
	}

	return self;
}
@end

#pragma mark -
#pragma mark Category InitSelectorOverJumping for NSObject:
#pragma mark -

@implementation NSObject (InitSelectorOverJumping)

- (instancetype)initFromSuper
{
	static dispatch_once_t onceToken;

// precautionary measures:
	dispatch_once(&onceToken, ^
	{
		IMP impInit = class_getMethodImplementation(AnyNSObjectDescendant.class,
													@selector(initFromSuper));
		class_replaceMethod(self.superclass,
							@selector(initFromSuper),
							impInit,
							0);
	});

	Class ponso = NSObject.class;
	Class mycls = self.class;

	if(!memcmp(&mycls, &ponso, sizeof(Class)))
	{
		return [self initFromSuper];
	}
	else
	{
		return [self init];
	}
}

@end
