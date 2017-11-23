//
//  LineChart1ViewController.m
//  ChartsDemo
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

#import "LineChart1ViewController.h"
#import "Charts/Charts-Swift.h"

@interface LineChart1ViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet LineChartView *chartView;

@end

@implementation LineChart1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // self.title = @"";
    
    _chartView.delegate = self;
    _chartView.chartDescription.enabled = NO;
    _chartView.dragEnabled = NO;
    [_chartView setScaleEnabled:NO];
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    
    // x-axis limit line
    /*
     ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:10.0 label:@"Index 10"];
     llXAxis.lineWidth = 4.0;
     llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
     llXAxis.labelPosition = ChartLimitLabelPositionRightBottom;
     llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
     
     [_chartView.xAxis addLimitLine:llXAxis];
     */
    
    _chartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
    _chartView.xAxis.gridLineDashPhase = 0.f;
    
    /*
    ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:150.0 label:@" "];
    ll1.lineWidth = 4.0;
    ll1.lineDashLengths = @[@5.f, @5.f];
    ll1.labelPosition = ChartLimitLabelPositionRightTop;
    ll1.valueFont = [UIFont systemFontOfSize:10.0];
    
    ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:-30.0 label:@" "];
    ll2.lineWidth = 4.0;
    ll2.lineDashLengths = @[@5.f, @5.f];
    ll2.labelPosition = ChartLimitLabelPositionRightBottom;
    ll2.valueFont = [UIFont systemFontOfSize:10.0];
    */
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    // [leftAxis addLimitLine:ll1];
    // [leftAxis addLimitLine:ll2];
    leftAxis.axisMaximum = 15.0;
    leftAxis.axisMinimum = 0.0;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = NO;
    
    _chartView.rightAxis.enabled = NO;
    _chartView.leftAxis.enabled = NO;
    _chartView.xAxis.labelPosition = XAxisLabelPositionBottom;
    _chartView.xAxis.labelTextColor = [UIColor whiteColor];
    
    //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
    //[_chartView.viewPortHandler setMaximumScaleX: 2.f];
    
    /*
     BalloonMarker *marker = [[BalloonMarker alloc]
     initWithColor: [UIColor colorWithWhite:180/255. alpha:1.0]
     font: [UIFont systemFontOfSize:12.0]
     textColor: UIColor.whiteColor
     insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
     marker.chartView = _chartView;
     marker.minimumSize = CGSizeMake(80.f, 40.f);
     _chartView.marker = marker;
     */
    
    _chartView.legend.form = ChartLegendFormLine;
   // _chartView.backgroundColor = [UIColor colorWithRed:113.0/255 green:81.0/255 blue:120.0/255 alpha:1.0];
    
    
    // _sliderX.value = 45.0;
    // _sliderY.value = 100.0;
    // [self slidersValueChanged:nil];
    [self updateChartData];
    [_chartView animateWithXAxisDuration:2.5];

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
    
    [self setDataCount:10.0 range:100.0];
}

- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < count; i++)
    {
        double val = arc4random_uniform(range) + 3;
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:val/10 icon: [UIImage imageNamed:@"icon"]]];
    }
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = values;
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:values label:@" PERFORMANCE"];
        set1.drawIconsEnabled = NO;
        set1.lineDashLengths = @[@5.f, @2.5f];
        set1.highlightLineDashLengths = @[@5.f, @2.5f];
        [set1 setColor:UIColor.whiteColor];
        [set1 setCircleColor:UIColor.whiteColor];
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        set1.valueTextColor = [UIColor whiteColor];
        set1.formLineDashLengths = @[@5.f, @2.5f];
        set1.formLineWidth = 1.0;
        set1.formSize = 15.0;
        
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#715178"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#ffffff"].CGColor
                                    ];
        
        
        
         CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 1.f;
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        set1.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _chartView.data = data;
    }
}
@end
