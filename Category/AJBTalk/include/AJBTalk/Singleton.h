//
//  Created by male on 15/9/17.
//  Copyright (c) 2015年 itheima. All rights reserved.
//

//.h文件里面替换
#define singleton_h(name)   + (instancetype)shared##name;

//.m文件的替换
#if __has_feature(objc_arc) //ARC

#define singleton_m(name) \
static id instance; \
\
+ (instancetype)shared##name{ \
\
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance=[[self alloc] init]; \
}); \
\
return instance; \
}  \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{  \
instance = [super allocWithZone:zone]; \
}); \
\
return instance; \
} \
\
- (id)copyWithZone:(struct _NSZone *)zone{ \
\
return instance; \
}


#else //非ARC

#define singleton_m(name) \
static id instance; \
\
+ (instancetype)shared##name{ \
\
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
instance=[[self alloc] init]; \
}); \
\
return instance; \
}  \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{  \
instance = [super allocWithZone:zone]; \
}); \
\
return instance; \
} \
\
- (id)copyWithZone:(struct _NSZone *)zone{ \
\
return instance; \
} \
\
- (oneway void)release{ \
\
} \
\
- (instancetype)retain{ \
return instance; \
} \
\
- (instancetype)autorelease{ \
return instance; \
} \
\
- (NSUInteger)retainCount{ \
return 1; \
}

#endif


