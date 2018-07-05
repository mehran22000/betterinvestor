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

#ifdef IS_DEV
#import "SocialTraderDev-Swift.h"
#endif

#ifdef IS_ADHOC
#import "SocialTraderAdHoc-Swift.h"
#endif

#ifdef IS_PROD
#import "SocialTrader-Swift.h"
#endif

@interface HalfPieChartViewController () <ChartViewDelegate>
    @property (nonatomic, strong) IBOutlet PieChartView *chartView;
@end

@implementation HalfPieChartViewController

AppDelegate *appDelegate;
NSMutableArray *gainArray, *lossArray;
NSArray* greenPlate, *redPlate;


- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateChartData];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    greenPlate = [NSArray arrayWithObjects:
                           [UIColor colorWithRed:3.0/255 green:35.0/255 blue:22.0/255 alpha:1.0],
                           [UIColor colorWithRed:4.0/255 green:70.0/255 blue:56.0/255 alpha:1.0],
                           [UIColor colorWithRed:28/255 green:99.0/255 blue:80.0/255 alpha:1.0],
                           [UIColor colorWithRed:42.0/255 green:116.0/255 blue:93.0/255 alpha:1.0],
                           [UIColor colorWithRed:49.0/255 green:112.0/255 blue:91.0/255 alpha:1.0],
                           nil];
    
    
    redPlate = [NSArray arrayWithObjects:
                         [UIColor colorWithRed:252.0/255 green:72.0/255 blue:73.0/255 alpha:1.0],
                         [UIColor colorWithRed:247.0/255 green:141.0/255 blue:143.0/255 alpha:1.0],
                         [UIColor colorWithRed:130.0/255 green:0.0/255 blue:0.0/255 alpha:1.0],
                         [UIColor colorWithRed:180.0/255 green:0.0/255 blue:0.0/255 alpha:1.0],
                         [UIColor colorWithRed:254.0/255 green:0.0/255 blue:2.0/255 alpha:1.0],
                         nil];

    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self setupPieChartView:_chartView];
    
    _chartView.delegate = self;
    
    _chartView.holeColor = [UIColor clearColor];
    _chartView.transparentCircleColor = [UIColor colorWithRed:111.0/255 green:82.0/255 blue:121.0/255 alpha:1.0];
    _chartView.holeRadiusPercent = 0.58;
    _chartView.rotationEnabled = NO;
    _chartView.highlightPerTapEnabled = NO;
    
    _chartView.maxAngle = 180.0; // Half chart
    _chartView.rotationAngle = 180.0; // Rotate to make the half on the upper side
    _chartView.centerTextOffset = CGPointMake(0.0, 0.0);
    
    ChartLegend *l = _chartView.legend;
    l.enabled = false;
    
    // entry label styling
    _chartView.entryLabelColor = UIColor.whiteColor;
    _chartView.entryLabelFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:12.f];
    
    [self splitGianAndLossPositions];
    [self updateChartData];
    
    [_chartView animateWithXAxisDuration:4.4 easingOption:ChartEasingOptionEaseOutBack];
    
}
     

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) splitGianAndLossPositions
{
    gainArray = [[NSMutableArray alloc] init];
    lossArray = [[NSMutableArray alloc] init];
    for (int i=0; i< appDelegate.user.portfolio.positions.count; i++)
    {
        if (appDelegate.user.portfolio.positions[i].gain >= 0){
            [gainArray addObject:appDelegate.user.portfolio.positions[i]];
        }
        else {
            [lossArray addObject:appDelegate.user.portfolio.positions[i]];
        }
    }
}


- (void)updateChartData
{
    if (self.shouldHideData)
    {
        _chartView.data = nil;
        return;
    }
    
    if ((self.isGainMode == true) && (gainArray.count> 0 )) {
        [self setDataCount:(int) gainArray.count range:100];
    }
    else if ((self.isGainMode == false) && (lossArray.count> 0 )) {
        [self setDataCount:(int) lossArray.count range:100];
    }
    
}

- (void)setDataCount:(int)count range:(double)range
{

    NSMutableArray *values = [[NSMutableArray alloc] init];
    NSMutableArray *posArray;
    Position *pos;
    
    if (self.isGainMode)
        posArray = gainArray;
    else
        posArray = lossArray;
    
    // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
    for (int i = 0; i < posArray.count; i++)
    {
        pos = (Position*) posArray[i];
        [values addObject:[[PieChartDataEntry alloc] initWithValue:fabs(pos.gain)   label:pos.symbol.uppercaseString]];
    }
    
    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:values label:@""];
    dataSet.sliceSpace = 3.0;
    dataSet.selectionShift = 5.0;
    
    //    dataSet.colors = ChartColorTemplates.vordiplom;
    
    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];
    
    if (self.isGainMode){
        dataSet.colors = greenPlate;
        [data setValueTextColor:UIColor.whiteColor];
    }
    else {
        dataSet.colors = redPlate;
        [data setValueTextColor:UIColor.whiteColor];
    }
    
    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.f]];
    
    
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
