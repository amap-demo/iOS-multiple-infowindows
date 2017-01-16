//
//  MAInfowindowView.swift
//  MultipleInfowindows
//
//  Created by eidan on 17/1/16.
//  Copyright © 2017年 AutoNavi. All rights reserved.
//

import UIKit

class MAInfowindowView: MAAnnotationView {
    
    var titleLabel : UILabel!
    
    let kMinWidth = CGFloat(20)
    let kMaxWidth = CGFloat(200)
    let kHeight = CGFloat(44)
    let KHoriMargin = CGFloat(3)
    let kVertMargin = CGFloat(3)
    let kFontSize = CGFloat(14)
    let kArrorHeight = CGFloat(8)
    let kBackgroundColor = UIColor.white
    
    override init!(annotation: MAAnnotation!, reuseIdentifier: String!) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        
        self.backgroundColor = UIColor.clear
        self.bounds = CGRect.init(x: 0, y: 0, width: kMinWidth, height: kHeight)
        self.centerOffset = CGPoint.init(x: 0, y:  -kHeight / 2.0)
        
        self.titleLabel = UILabel()
        self.titleLabel.backgroundColor = UIColor.clear
        self.titleLabel.textAlignment = NSTextAlignment.center
        self.titleLabel.textColor = UIColor.black
        self.titleLabel.font = UIFont.systemFont(ofSize: CGFloat(kFontSize))
        self.addSubview(self.titleLabel)

    }
    
    public func giveTitleText (text: String) {
        
        self.titleLabel.text = text
        
        self.titleLabel.sizeToFit()
        
        if self.titleLabel.frame.size.width > kMaxWidth {
            self.titleLabel.frame = CGRect.init(x: 0, y: 0, width: kMaxWidth, height: kHeight - kVertMargin * 2 - kArrorHeight)
        }
        
        self.bounds = CGRect.init(x: 0, y: 0, width: self.titleLabel.frame.size.width + KHoriMargin * 2, height: kHeight)
        
        self.titleLabel.center = CGPoint.init(x: self.bounds.midX, y: self.bounds.midY - kVertMargin)
    }
    
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

}
