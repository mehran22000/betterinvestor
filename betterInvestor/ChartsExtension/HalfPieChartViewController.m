//
//  HalfPieChartViewController.m
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#import "HalfPieChartViewController.h"
#import "Charts/Charts-Swift.h"

@interface HalfPieChartViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet PieChartView *chartView;


@end

@implementation HalfPieChartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Half Pie Bar Chart";
    
    self.options = @[
                     @{@"key": @"toggleValues", @"label": @"Toggle Y-Values"},
                     @{@"key": @"toggleXValues", @"label": @"Toggle X-Values"},
                     @{@"key": @"togglePercent", @"label": @"Toggle Percent"},
                     @{@"key": @"toggleHole", @"label": @"Toggle Hole"},
                     @{@"key": @"animateX", @"label": @"Animate X"},
                     @{@"key": @"animateY", @"label": @"Animate Y"},
                     @{@"key": @"animateXY", @"label": @"Animate XY"},
                     @{@"key": @"spin", @"label": @"Spin"},
                     @{@"key": @"drawCenter", @"label": @"Draw CenterText"},
                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
                     @{@"key": @"toggleData", @"label": @"Toggle Data"},
                     ];
    
    [self setupPieChartView:_chartView];
    
    _chartView.delegate = self;
    
    // _chartView.holeColor = [UIColor colorWithRed:133.0/255 green:103.0/255 blue:139.0/255 alpha:1.0];
    _chartView.holeColor = [UIColor clearColor];
    _chartView.transparentCircleColor = [UIColor colorWithRed:133.0/255 green:103.0/255 blue:139.0/255 alpha:1.0];
    _chartView.holeRadiusPercent = 0.58;
    _chartView.rotationEnabled = NO;
    _chartView.highlightPerTapEnabled = NO;
    
    _chartView.maxAngle = 180.0; // Half chart
    _chartView.rotationAngle = 180.0; // Rotate to make the half on the upper side
    _chartView.centerTextOffset = CGPointMake(0.0, -20.0);
    
    /*
    l.horizontalAlignment = ChartLegendHorizontalAlignmentCenter;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationHorizontal;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;
    */
    
    ChartLegend *l = _chartView.legend;
    l.enabled = false;
    
    // entry label styling
    _chartView.entryLabelColor = UIColor.whiteColor;
    _chartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    
    [self updateChartData];
    
    [_chartView animateWithXAxisDuration:4.4 easingOption:ChartEasingOptionEaseOutBack];

   //  _chartView.backgroundColor = [UIColor colorWithRed:133.0/255 green:103.0/255 blue:139.0/255 alpha:1.0];
    
    
}
     

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateChartData
{
    if (self.shouldHideData)
    {
        _chartView.data = nil;
        return;
    }
    
    [self setDataCount:4 range:100];
}

- (void)setDataCount:(int)count range:(double)range
{
    double mult = range;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
    for (int i = 0; i < count; i++)
    {
        [values addObject:[[PieChartDataEntry alloc] initWithValue:(arc4random_uniform(mult) + mult / 5) label:parties[i % parties.count]]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@"Election Results"];
    dataSet.sliceSpace = 3.0;
    dataSet.selectionShift = 5.0;
    
    // dataSet.colors = ChartColorTemplates.material;
    // Purple Plate
    /*
    dataSet.colors = [NSArray arrayWithObjects:[UIColor colorWithRed:118.0/255 green:102.0/255 blue:151.0/255 alpha:1.0],
                                               [UIColor colorWithRed:161.0/255 green:120.0/255 blue:198.0/255 alpha:1.0],
                                               [UIColor colorWithRed:87.0/255 green:63.0/255 blue:113.0/255 alpha:1.0],
                                               [UIColor colorWithRed:174.0/255 green:169.0/255 blue:249.0/255 alpha:1.0],
                                               [UIColor colorWithRed:108.0/255 green:82.0/255 blue:171.0/255 alpha:1.0],
                                               [UIColor colorWithRed:43.0/255 green:59.0/255 blue:121.0/255 alpha:1.0],
                                               [UIColor colorWithRed:52.0/255 green:32.0/255 blue:81.0/255 alpha:1.0],
                                               [UIColor colorWithRed:119.0/255 green:101.0/255 blue:153.0/255 alpha:1.0],
                                               [UIColor colorWithRed:149.0/255 green:160.0/255 blue:226.0/255 alpha:1.0],
                                               nil];
    */
    /*
    dataSet.colors = [NSArray arrayWithObjects:[UIColor colorWithRed:254.0/255 green:132.0/255 blue:131.0/255 alpha:1.0],
                      [UIColor colorWithRed:82.0/255 green:0.0/255 blue:2.0/255 alpha:1.0],
                      [UIColor colorWithRed:255.0/255 green:29.0/255 blue:36.0/255 alpha:1.0],
                      [UIColor colorWithRed:186.0/255 green:1.0/255 blue:0.0/255 alpha:1.0],
                      [UIColor colorWithRed:255.0/255 green:92.0/255 blue:93.0/255 alpha:1.0],
                      [UIColor colorWithRed:218.0/255 green:0.0/255 blue:0.0/255 alpha:1.0],
                      [UIColor colorWithRed:107.0/255 green:1.0/255 blue:1.0/255 alpha:1.0],
                      [UIColor colorWithRed:253.0/255 green:57.0/255 blue:58.0/255 alpha:1.0],
                      [UIColor colorWithRed:253.0/255 green:77.0/255 blue:77.0/255 alpha:1.0],
                      nil];
    */
    
    NSArray* greenPlate = [NSArray arrayWithObjects:[UIColor colorWithRed:0.0/255 green:59.0/255 blue:29.0/255 alpha:1.0],
                           [UIColor colorWithRed:11.0/255 green:129.0/255 blue:53.0/255 alpha:1.0],
                           [UIColor colorWithRed:88.0/255 green:176.0/255 blue:66.0/255 alpha:1.0],
                           [UIColor colorWithRed:133.0/255 green:179.0/255 blue:45.0/255 alpha:1.0],
                           [UIColor colorWithRed:181.0/255 green:208.0/255 blue:67.0/255 alpha:1.0],
                           nil];
    
    
    NSArray* redPlate = [NSArray arrayWithObjects:[UIColor colorWithRed:130.0/255 green:0.0/255 blue:0.0/255 alpha:1.0],
                           [UIColor colorWithRed:180.0/255 green:0.0/255 blue:0.0/255 alpha:1.0],
                           [UIColor colorWithRed:254.0/255 green:0.0/255 blue:2.0/255 alpha:1.0],
                           [UIColor colorWithRed:252.0/255 green:72.0/255 blue:73.0/255 alpha:1.0],
                           [UIColor colorWithRed:247.0/255 green:141.0/255 blue:143.0/255 alpha:1.0],
                           nil];
    
    dataSet.colors = redPlate;
    
    
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.f]];
    [data setValueTextColor:UIColor.whiteColor];
    
    

    _chartView.data = data;
    
    [_chartView setNeedsDisplay];
}


#pragma mark - Action

#pragma mark - ChartViewDelegate

/*
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}
*/
@end
