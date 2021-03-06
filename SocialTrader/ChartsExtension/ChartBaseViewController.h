//
//  DemoBaseViewController.h
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#import <UIKit/UIKit.h>
#import "Charts/Charts-Swift.h"


@interface ChartBaseViewController : UIViewController
{
}

@property (nonatomic, assign) BOOL shouldHideData;


- (void)updateChartData;
- (void)setupPieChartView:(PieChartView *)chartView;
- (void)setupBarLineChartView:(BarLineChartViewBase *)chartView;

@end
