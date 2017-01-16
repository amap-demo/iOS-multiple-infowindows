本工程为基于高德地图iOS SDK进行封装，多弹出框的效果。
## 前述 ##
- [高德官网申请Key](http://lbs.amap.com/dev/#/).
- 阅读[开发指南](http://lbs.amap.com/api/ios-sdk/summary/).
- 工程基于iOS 3D地图SDK实现

## 功能描述 ##
基于3D地图SDK，自定义annotationView实现多弹出框效果。

## 核心类/接口 ##
| 类    | 接口  | 说明   | 版本  |
| -----|:-----:|:-----:|:-----:|
| AMapSearchAPI	| - (void)AMapPOIKeywordsSearch:(AMapPOIKeywordsSearchRequest *)request;; | POI 关键字查询接口 | v4.0.0 |
| MAInfowindowView	| --- | 继承自MAAnnotationView，实现了弹出框样式的自定义annotationView。 | --- |

## 核心难点 ##

'Objective-C'

```

/* 自定义绘制弹出框效果annotaitonView. */
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
```

'Swift'

/* 自定义绘制弹出框效果annotaitonView. */
override func draw(_ rect: CGRect) {
    self.draw(context: UIGraphicsGetCurrentContext()!)
    self.layer.shadowColor = UIColor.gray.cgColor
    self.layer.shadowOpacity = 1.0
    self.layer.shadowOffset = CGSize(width: CGFloat(0.0), height: CGFloat(0.0))
}

func draw(context: CGContext) {
    context.setLineWidth(CGFloat(1.0))
    context.setFillColor(kBackgroundColor.cgColor)
    self.getDrawPath(context:context)
    context.fillPath()
}

func getDrawPath(context: CGContext) {
    let rrect: CGRect = self.bounds
    let radius: CGFloat = 6.0
    let minx: CGFloat = rrect.minX
    let midx: CGFloat = rrect.midX
    let maxx: CGFloat = rrect.maxX
    let miny: CGFloat = rrect.minY
    let maxy: CGFloat = rrect.maxY - kArrorHeight
    context.move(to: CGPoint(x: CGFloat(midx + kArrorHeight), y: maxy))
    context.addLine(to: CGPoint(x: midx, y: CGFloat(maxy + kArrorHeight)))
    context.addLine(to: CGPoint(x: CGFloat(midx - kArrorHeight), y: maxy))
    context.addArc(tangent1End: CGPoint(x: minx, y: maxy), tangent2End: CGPoint(x: minx, y: miny), radius: radius)
    context.addArc(tangent1End: CGPoint(x: minx, y: minx), tangent2End: CGPoint(x: maxx, y: miny), radius: radius)
    context.addArc(tangent1End: CGPoint(x: maxx, y: miny), tangent2End: CGPoint(x: maxx, y: maxx), radius: radius)
    context.addArc(tangent1End: CGPoint(x: maxx, y: maxy), tangent2End: CGPoint(x: midx, y: maxy), radius: radius)
    context.closePath()
}

