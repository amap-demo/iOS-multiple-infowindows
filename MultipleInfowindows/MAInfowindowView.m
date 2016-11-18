//
//  MAInfowindowView.m
//  MultipleInfowindows
//
//  Created by xiaoming han on 16/11/18.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import "MAInfowindowView.h"

#define kMinWidth  20
#define kMaxWidth  200
#define kHeight    44

#define kHoriMargin 3
#define kVertMargin 3

#define kFontSize   14

#define kArrorHeight        8
#define kBackgroundColor    [UIColor whiteColor]

@interface MAInfowindowView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MAInfowindowView

- (NSString *)title
{
    return self.titleLabel.text;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
    [self.titleLabel sizeToFit];
    
    if (self.titleLabel.frame.size.width > kMaxWidth)
    {
        self.titleLabel.frame = CGRectMake(0, 0, kMaxWidth, kHeight - kVertMargin * 2 - kArrorHeight);
    }
    
    self.bounds = CGRectMake(0.f, 0.f, self.titleLabel.frame.size.width + kHoriMargin * 2, kHeight);
    
    self.titleLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) - kVertMargin);
    
    
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.bounds = CGRectMake(0.f, 0.f, kMinWidth, kHeight);
        self.centerOffset = CGPointMake(0, -kHeight / 2.0);
        
        
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor  = [UIColor clearColor];
        self.titleLabel.textAlignment    = NSTextAlignmentCenter;
        self.titleLabel.textColor        = [UIColor blackColor];
        self.titleLabel.font             = [UIFont systemFontOfSize:kFontSize];
        [self addSubview:self.titleLabel];
    }
    
    return self;
}

#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, kBackgroundColor.CGColor);
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}


@end
