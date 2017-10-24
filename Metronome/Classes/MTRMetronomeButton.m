//
//  MTRMetronomeButton.m
//  Metronome
//
//  Created by Yurii Kupratsevich on 10/24/17.
//

#import "MTRMetronomeButton.h"

static CGFloat const kCircleLineWidth = 4.0;
static CGFloat const kPlaySymbolLineWidth = 3.0;

IB_DESIGNABLE
@implementation MTRMetronomeButton

#pragma mark - PublicMethods

- (void)setOn:(BOOL)on {
    _on = on;
    [self setNeedsDisplay];
}

- (void)setDisplayedBPM:(NSUInteger)displayedBPM {
    _displayedBPM = displayedBPM;
    [self setNeedsDisplay];
}

#pragma mark - Private Methods

CGRect CGRectByReducingRect(CGRect rect, CGFloat reduceBy) {
    return CGRectMake(CGRectGetMinX(rect) + reduceBy * 0.5,
                      CGRectGetMinY(rect) + reduceBy * 0.5,
                      CGRectGetWidth(rect) - reduceBy,
                      CGRectGetHeight(rect) - reduceBy);
}

CGRect CGRectMakeWithCenterPoint(CGPoint center, CGFloat width, CGFloat height) {
    return CGRectMake(center.x - width * 0.5,
                      center.y - height * 0.5,
                      width,
                      height);
}

- (void)configure {
    _on = NO;
}

- (double)radForDeg:(double)deg {
    return deg * M_PI / 180;
}

- (void)drawCircleInRect:(CGRect)rect {
    CGRect circleRect = CGRectByReducingRect(self.bounds, kCircleLineWidth);
    UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:circleRect];
    circle.lineWidth = kCircleLineWidth;
    [UIColor.blackColor setStroke];
    [circle stroke];
}

- (void)drawPlaySymbolWithSide:(CGFloat)side center:(CGPoint)center {
    // Radius of a triangle's circumcircle
    CGFloat r = side / sqrt(3);
    CGFloat x0 = center.x;
    CGFloat y0 = center.y;
    CGFloat x1 = x0 - r * cos([self radForDeg:60]);
    CGFloat y1 = y0 - r * sin([self radForDeg:60]);
    CGFloat x2 = x0 - r * cos([self radForDeg:180]);
    CGFloat y2 = y0 - r * sin([self radForDeg:180]);
    CGFloat x3 = x0 - r * cos([self radForDeg:300]);
    CGFloat y3 = y0 - r * sin([self radForDeg:300]);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(x1, y1)];
    [path addLineToPoint:CGPointMake(x2, y2)];
    [path addLineToPoint:CGPointMake(x3, y3)];
    [path closePath];
    path.lineWidth = kPlaySymbolLineWidth;
    path.lineJoinStyle = kCGLineJoinRound;
    [UIColor.blackColor set];
    [path stroke];
    [path fill];
}

- (void)drawPauseSymbolWithSide:(CGFloat)side center:(CGPoint)center {
    CGRect rect = CGRectMakeWithCenterPoint(center, side, side);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [UIColor.blackColor set];
    [path stroke];
    [path fill];
    
    CGFloat clearRectWidth = side * 0.2;
    CGFloat clearRectHeight = side;
    CGRect clearRect = CGRectMakeWithCenterPoint(center, clearRectWidth, clearRectHeight);
    UIBezierPath *clearPath = [UIBezierPath bezierPathWithRect:clearRect];
    [clearPath strokeWithBlendMode:kCGBlendModeClear alpha:1.0];
    [clearPath fillWithBlendMode:kCGBlendModeClear alpha:1.0];
}

- (void)drawText:(NSString *)text withFontSize:(CGFloat)size center:(CGPoint)center {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    UIFont *font = [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
    NSDictionary *textAttrs = @{
                                NSForegroundColorAttributeName: UIColor.blackColor,
                                NSFontAttributeName: font,
                                NSParagraphStyleAttributeName: paragraphStyle
                                };
    CGSize textSize = [text sizeWithAttributes:textAttrs];
    CGRect textRect = CGRectMakeWithCenterPoint(center, textSize.width, textSize.height);
    [text drawInRect:textRect withAttributes:textAttrs];
}

#pragma mark - UIView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configure];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // 1. Draw circle outline
    [self drawCircleInRect:self.bounds];
    
    // 2. Draw playback symbol depending on the button's state
    CGRect circleInnerRect = CGRectByReducingRect(self.bounds, kCircleLineWidth * 2);
    CGFloat playbackSymbolSide = CGRectGetWidth(circleInnerRect) * 0.25;
    CGFloat playbackSymbolCenterX = CGRectGetMinX(circleInnerRect) + CGRectGetWidth(circleInnerRect) * 0.5;
    CGFloat playbackSymbolCenterY = CGRectGetMinY(circleInnerRect) + CGRectGetHeight(circleInnerRect) * 0.75;
    if (self.on) {
        [self drawPauseSymbolWithSide:playbackSymbolSide
                               center:CGPointMake(playbackSymbolCenterX, playbackSymbolCenterY)];
    }
    else {
        [self drawPlaySymbolWithSide:playbackSymbolSide
                              center:CGPointMake(playbackSymbolCenterX, playbackSymbolCenterY)];
    }
    
    // 3. Draw BPM value as text
    CGPoint textCenter = CGPointMake(CGRectGetMinX(circleInnerRect) + CGRectGetWidth(circleInnerRect) * 0.5,
                                     CGRectGetMinY(circleInnerRect) + CGRectGetHeight(circleInnerRect) * 0.35);
    NSString *displayedBPMString = [NSString stringWithFormat:@"%lu", (unsigned long)self.displayedBPM];
    [self drawText:displayedBPMString withFontSize:19 center:textCenter];
}

#pragma mark - UIControl

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [super endTrackingWithTouch:touch withEvent:event];
    CGPoint touchLocation = [touch locationInView:self];
    if ([self pointInside:touchLocation withEvent:nil]) {
        self.on = !self.on;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
}

@end
