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

#ifdef IS_DEV
#import "SocialTraderDev-Swift.h"
#endif

#ifdef IS_ADHOC
#import "SocialTraderAdHoc-Swift.h"
#endif

#ifdef IS_PROD
#import "SocialTrader-Swift.h"
#endif

@interface LineChart1ViewController () <ChartViewDelegate>

@property (nonatomic, strong) IBOutlet LineChartView *chartView;

@end

@implementation LineChart1ViewController

AppDelegate *mainAppDelegate;
double maxVal,minVal;
int sampleNo;
NSString *fromMonth, *endMonth;

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateChartData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mainAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self setChartLayout];
    [self updateChartData];
    
}

- (void) setChartLayout {
    
    _chartView.delegate = self;
    _chartView.chartDescription.enabled = NO;
    _chartView.dragEnabled = NO;
    [_chartView setScaleEnabled:NO];
    _chartView.pinchZoomEnabled = NO;
    _chartView.drawGridBackgroundEnabled = NO;
    _chartView.legend.form = ChartLegendFormLine;
    
    _chartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
    _chartView.xAxis.gridLineDashPhase = 0.f;
    _chartView.xAxis.labelCount = sampleNo - 1;
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    leftAxis.axisMaximum = maxVal + 0.1;
    leftAxis.axisMinimum = minVal - 0.1;
    
    leftAxis.gridLineDashLengths = @[@2.f, @2.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = NO;
    leftAxis.labelTextColor = [UIColor whiteColor];
    
    _chartView.rightAxis.enabled = NO;
    _chartView.leftAxis.enabled = YES;
    _chartView.xAxis.enabled = NO;
    
    _chartView.legend.form = ChartLegendFormLine;
    _chartView.legend.textColor = [UIColor whiteColor];
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
    
    [self setDataCount:15.0 range:100.0];
}

- (void)setDataCount:(int)count range:(double)range
{
    GainHistoryFilter *filter = [[GainHistoryFilter alloc] init];
    NSMutableArray *gain_history = mainAppDelegate.user.gain_history;
    NSMutableArray *samples =  [filter getSamplesWith_gainHistory:gain_history _isMonth:self.isMonthMode];
    sampleNo = (int) samples.count;
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < samples.count; i++)
    {
    
        GainHistoryItem* gain_item = (GainHistoryItem*) samples[i];
        double val = gain_item.gain;
        [values addObject:[[ChartDataEntry alloc] initWithX:i y: val  icon: [UIImage imageNamed:@"icon"]]];
    
        if (i == 0) {
            maxVal = val;
            minVal = val;
            fromMonth = gain_item.monthStr;
        }
        else {
            if (val > maxVal) maxVal = val;
            if (val < minVal) minVal = val;
            endMonth = gain_item.monthStr;
        }
    }

    
    [self setChartLayout];
    
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
        NSString* lbl;
        if ([fromMonth isEqualToString:endMonth]) {
            lbl = [NSString stringWithFormat:@"Gain Precentage (%@)",fromMonth];
        }
        else {
             lbl = [NSString stringWithFormat:@"Gain Precentage (%@-%@)",fromMonth,endMonth];
        }
        set1 = [[LineChartDataSet alloc] initWithValues:values label:lbl];
        set1.lineDashLengths = @[@1.f, @1.f];
        set1.drawIconsEnabled = NO;
        set1.highlightLineDashLengths = @[@5.f, @2.5f];
        [set1 setColor:UIColor.whiteColor];
        [set1 setCircleColor:UIColor.whiteColor];
        set1.lineWidth = 1.0;
        set1.circleRadius = 1.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        set1.valueTextColor = [UIColor clearColor];
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
