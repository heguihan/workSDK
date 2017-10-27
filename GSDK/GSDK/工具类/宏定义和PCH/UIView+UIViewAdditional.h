//
//  UIView+UIViewAdditional.h
//  NSDK
//
//  Created by 王璟鑫 on 16/7/27.
//  Copyright © 2016年 王璟鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
CGPoint CGRectGetCenter(CGRect rect);
CGRect  CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (UIViewAdditional)

@property CGSize size;


//中心点X
@property CGFloat centerX;
@property CGFloat centerY;

//起点
@property CGFloat originX;
@property CGFloat originY;


/**
 *  四个点
 */
@property CGPoint origin;
@property (readonly) CGPoint bottomLeft;
@property (readonly) CGPoint bottomRight;
@property (readonly) CGPoint topRight;

/**
 *  宽高
 */
@property CGFloat height;
@property CGFloat width;

/**
 *  上下左右
 */
@property CGFloat top;
@property CGFloat left;
@property CGFloat bottom;
@property CGFloat right;

/**
 *  根据View取到Controller
 *
 *  @return 返回的controller
 */
- (UIViewController *)viewController;


/**
 *  子View中是否包含有aView
 *
 *  @param view  需要检测的View
 *  @param aview 是否包含的那个View,类名
 *
 *  @return BOOL值
 */
- (BOOL)listSubviewsOfView:(UIView *)view containView:(NSString*)aview;

/**
 *  直接设置圆角
 *
 *  @param corner 值
 */
- (void)setCorner:(CGFloat)corner;

@end
