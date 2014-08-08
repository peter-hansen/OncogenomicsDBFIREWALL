//
//  GSEAController.m
//  GeneAccess
//
//  Created by Hansen, Peter (NIH/NCI) [F] on 6/23/14.
//  Copyright (c) 2014 National Cancer Institue. All rights reserved.
//

#import "GseaController.h"
#import "ViewController.h"
@interface GSEAController ()
// Misc - These are objects that are used by all sample sets. All
// objects without description are exactly what the name implies
@property (strong, nonatomic) IBOutlet UIButton *runGSEA;
// Spinning wheel that indicates processing data
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
// the data that is sent from the server
@property (nonatomic) NSMutableData *responseData;
// the data in a readable string format
@property (nonatomic) NSString *response;
// texfield where samples are selected
@property (strong, nonatomic) IBOutlet UITextField *sampleSelect;
// textfield where all probes/not all probes is selected
@property (strong, nonatomic) IBOutlet UITextField *geneSelect;
// you get the point by now
@property (strong, nonatomic) IBOutlet UITextField *duplicateSelect;
// same as before
@property (strong, nonatomic) IBOutlet UITextField *genesetSelect;
// the rolling wheel that shows up to select samples
// all _____Picker objects correspond to that _____Select
@property (strong, nonatomic) UIPickerView *samplePicker;
@property (strong, nonatomic) UIPickerView *genePicker;
@property (strong, nonatomic) UIPickerView *duplicatePicker;
@property (strong, nonatomic) UIPickerView *genesetPicker;
// These arrays are what goes in the picker views
@property (strong, nonatomic) NSMutableArray *samples;
@property (strong, nonatomic) NSArray *gene;
@property (strong, nonatomic) NSArray *duplicate;
@property (strong, nonatomic) NSMutableDictionary *genesets;
@property (strong, nonatomic) NSMutableArray *activeObjects;
// This is the object that holds the response each switch should
// give if turned on
@property (strong, nonatomic) NSMutableDictionary *realKeys;
// This holds all switches that will be tracked
@property (strong, nonatomic) NSMutableArray *switches;
// NCI Objects
@property (strong, nonatomic) NSMutableArray *NCI;
// Sample.Drug
@property (strong, nonatomic) NSMutableArray *sampleDrug;
// ANN
@property (strong, nonatomic) NSMutableArray *ANN;
// Cell_Line
@property (strong, nonatomic) NSMutableArray *cellLine;
// Drug_Response
@property (strong, nonatomic) NSMutableArray *drugResponse;
// Germ_Cell_Tumors
@property (strong, nonatomic) NSMutableArray *germCellTumors;
// Leukemia
@property (strong, nonatomic) NSMutableArray *leukemia;
// Medulloblastoma
@property (strong, nonatomic) NSMutableArray *medulloblastoma;
// Neuroblastoma
@property (strong, nonatomic) NSMutableArray *neuroblastoma;
// Normal_Tissue
@property (strong, nonatomic) NSMutableArray *normalTissue;
// Pediatric_Cancers
@property (strong, nonatomic) NSMutableArray *pediatricCancers;
// Rhabdomyosarcoma
@property (strong, nonatomic) NSMutableArray *rhabdomyosarcoma;
// Sarcoma
@property (strong, nonatomic) NSMutableArray *Sarcoma;
// cMAP
@property (strong, nonatomic) NSMutableArray *cMAP;
// How far the page needs to be able to scroll
@property (nonatomic) NSUInteger scrollDist;
// Are the active objects pos/neg?
@property (nonatomic) BOOL posNeg;
// This label shows what datasets are currently displayed
@property (strong, nonatomic) IBOutlet UILabel *currentSet;
@property (strong, nonatomic) UIAlertView *alertView;
@end

@implementation GSEAController
// Turn off rotation of the device
- (BOOL)shouldAutorotate
{
    return NO;
}
// A method that catches all touches made. I am currently using it to close the keyboard
// if you touch on something that doesn't need it.
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    // If the touch isn't on a UITextField, close the keyboard,
    // we don't need it anymore
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
    [super touchesBegan:touches withEvent:event];
}
// The following methods map to the button of the same name
// Each one hides all objects that are currently being used
// and reveal the object corresponding to that sample set.
- (IBAction)cMAP:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _cMAP) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = true;
    _currentSet.text = @"cMAP";
    [self howFar];
}
- (IBAction)Sarcoma:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _Sarcoma) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = true;
    _currentSet.text = @"Sarcoma";
    [self howFar];
}
- (IBAction)Rhabdomyosarcoma:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _rhabdomyosarcoma) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = true;
    _currentSet.text = @"Rhabdomyosarcoma";
    [self howFar];
}
- (IBAction)Pediatric_Cancer:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _pediatricCancers) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = true;
    _currentSet.text = @"Pediatric_Cancer";
    [self howFar];
}
- (IBAction)Normal_Tissue:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _normalTissue) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = true;
    _currentSet.text = @"Normal_Tissue";
    [self howFar];
}
- (IBAction)Neuroblastoma:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _neuroblastoma) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = true;
    _currentSet.text = @"Neuroblastoma";
    [self howFar];
}
- (IBAction)Medulloblastoma:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _medulloblastoma) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = true;
    _currentSet.text = @"Medulloblastoma";
    [self howFar];
}
- (IBAction)Leukemia:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _leukemia) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = true;
    [self howFar];
    _currentSet.text = @"Leukemia";
}
- (IBAction)Germ_Cell_Tumors:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _germCellTumors) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = true;
    _currentSet.text = @"Germ_Cell_Tumors";
    [self howFar];
}
- (IBAction)Drug_Response:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _drugResponse) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = true;
    _currentSet.text = @"Drug_Response";
    [self howFar];
}
- (IBAction)Cell_Line:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _cellLine) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = true;
    _currentSet.text = @"Cell_Line";
    [self howFar];
}
- (IBAction)ANN:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _ANN) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = true;
    _currentSet.text = @"ANN";
    [self howFar];
}
- (IBAction)SampleDrug:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _sampleDrug) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = false;
    _currentSet.text = @"Sample.Drug";
    [self howFar];
}
- (IBAction)NCI:(id)sender {
    for (UIView *object in _activeObjects) {
        object.hidden = true;
    }
    [_activeObjects removeAllObjects];
    for (UIView *button in _NCI) {
        button.hidden = false;
        [_activeObjects addObject:button];
    }
    _posNeg = false;
    _currentSet.text = @"NCI";
    [self howFar];
}
// A method to figure out how far the screen should scroll
- (void)howFar {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // If _posNeg is true, the switches are pair together, one positive sample, one negative therefore each
        // row has four elements and since 19 rows and 2 columns can fit on the screen, after 19*2*4 elements
        // the page needs more space. Each row is 34 pixels so we need to add that and a little more just to
        // make it look nice
        if (_posNeg) {
            if ([_activeObjects count] > 152) {
                NSUInteger extra = [_activeObjects count]-160;
                _scrollDist = 15 + 34*extra/4;
            } else {
                _scrollDist = 0;
            }
        } else {
            // If _posNeg is false then we only need 19*2*2 elements, which is what we have here.
            if ([_activeObjects count] > 76) {
                NSUInteger extra = [_activeObjects count]-80;
                _scrollDist = 15 + 34*extra/2;
            }
        }
    } else {
        // the iPhone screen is far more limited than the iPad screen so it can only fit 1 column of 4 rows on
        // the screen (1*4*4)
        if (_posNeg) {
            if ([_activeObjects count] > 16) {
                NSUInteger extra = [_activeObjects count]-20;
                _scrollDist = 15 + 34*extra/4;
            } else {
                _scrollDist = 0;
            }
        } else {
            if ([_activeObjects count] > 8) {
                NSUInteger extra = [_activeObjects count]-10;
                _scrollDist = 15 + 34*extra/2;
            }
        }
    }
}
// A method that sends the user defined information to
// the server. It is activated by the Run GSEA button.
- (IBAction)runGSEA:(id)sender {
    [self.activityWheel startAnimating];
    // The following statements collect data from input sources and then convert the data to match what the server expects
    NSString *chosenGenes = _geneSelect.text;
    NSString *chosenGeneset = _genesets[_genesetSelect.text];
    chosenGeneset = [chosenGeneset stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *duplicateyn = _duplicateSelect.text;
    // this is how I clone the <select><option value=Y>Use all genes(probes)</option>... etc
    if ([chosenGenes isEqual:@"Use all genes(probes)"]) {
        chosenGenes = @"Y";
    } else {
        chosenGenes = @"N";
    }
    if([duplicateyn isEqual:@"Keep highest value(abs)"]) {
        duplicateyn = @"Y";
    } else {
        duplicateyn = @"N";
    }
    // If you do not define a starting value for a variable it must have memory ALLOCated and INITialized to become non nil
    NSMutableString *grp = [[NSMutableString alloc]init];
    // Check all the switches to see which ones are turned on and add that information to a string
    for (UISwitch *theswitch in _switches) {
        if ([theswitch isOn]) {
            [grp appendString:@"&grp="];
            [grp appendString:_realKeys[theswitch.accessibilityLabel]];
        }
    }
    // Create a request object with all the data we want to send to the server. This is how variadic functions are defined in objective C
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?rm=query_all;db=%@;source=genomic",globalURL, _db]]];
    request.HTTPMethod = @"POST";
    NSString *stringData = [NSString stringWithFormat:@"rm=query_all&frm=query_all&submitted_multi_expression_query=TRUErm=show_gsea&show_gsea=Run+GSEA&prerank_file=null&gsea_file=null&db=%@&smplid=%ld&geneset=%@&geneduprm=%@&gmx=%@%@", _db, (long)[self.samplePicker selectedRowInComponent:0], chosenGenes, duplicateyn, chosenGeneset, grp];
    NSData *requestBodyData = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = requestBodyData;
    // Create url connection and fire request
    // Here we cast it as void because we don't need to do anything
    // with the return value
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
}
// close the current view and return to the main page
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        // start tracking switch
        if(![_switches containsObject:sender]) {
            [_switches addObject:sender];
        }
    } else{
        // do nothing
    }
}
// Initialize everything when the view loads
- (void)viewDidLoad
{
    [super viewDidLoad];
    // It doesn't matter what posNeg starts as, it just has to have some value
    _posNeg = false;
    // We need to initialize how far we're letting the screen scroll. This statement
    // should be equivalent to _scrollDist = 0;
    [self howFar];
    _switches = [[NSMutableArray alloc]init];
    _realKeys = [[NSMutableDictionary alloc]init];
    _activeObjects = [[NSMutableArray alloc]init];
    _gene = @[@"Use all genes(probes)", @"Use current genes"];
    _duplicate = @[@"Keep highest value(abs)", @"keep all"];
    // The following set of code disects the <select> objects and extracts every option. The first one puts all the samples in _samples.
    NSArray *sampleFinder = [[NSArray alloc] initWithArray:[_html componentsSeparatedByString:@"<select NAME=\"smplid\">"]];
    NSArray *sampleFinder2 = [sampleFinder[1] componentsSeparatedByString:@"</select>"];
    NSArray *sampleFinder3 = [sampleFinder2[0] componentsSeparatedByString:@">"];
    // at this point all the <option>s for the sample  select are in sampleFinder3
    _samples = [[NSMutableArray alloc]init];
    NSString *sample = [[NSString alloc]init];
    for (NSString *object in sampleFinder3) {
        // Throw out anything that isn't an option and take the contents of option and put it in _sample
        if ([object rangeOfString:@"<option"].location == NSNotFound && [object length] != 8 && [object length] != 0) {
            sample = [object stringByReplacingOccurrencesOfString:@"</option" withString:@""];
            [_samples addObject:sample];
        }
    }
    // This one takes all the genesets and puts them in _genesets
    sampleFinder = [_html componentsSeparatedByString:@"<SELECT NAME=gmx"];
    sampleFinder2 = [sampleFinder[1] componentsSeparatedByString:@"</SELECT>"];
    sampleFinder3 = [sampleFinder2[0] componentsSeparatedByString:@"<OPTION value"];
    _genesets = [[NSMutableDictionary alloc]init];
    NSArray *sampleFinder4 = [[NSArray alloc]init];
    NSString *key = [[NSString alloc]init];
    NSString *url = [[NSString alloc]init];
    // each geneset has both a display name and an address for where the file is, so each display name (the key)
    // has to be mapped to the address (the url, or object)
    for (NSString *object in sampleFinder3) {
        sampleFinder4 = [object componentsSeparatedByString:@">"];
        if([sampleFinder4 count] == 3) {
            key = sampleFinder4[1];
            key = [key stringByReplacingOccurrencesOfString:@"   " withString:@" "];
            key = [key stringByReplacingOccurrencesOfString:@"</OPTION" withString:@""];
            url = sampleFinder4[0];
            url = [url stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            url = [url stringByReplacingOccurrencesOfString:@"=" withString:@""];
            [_genesets setObject:url forKey:key];
        }
    }
    // Getting all the preset checkboxes is a little more complicated, so here a lot of manipulation has to be done.
    // This isn't going to make a lot of sense unless you go and look at the html that's being recieved from the server.
    // when you see it, it will make sense why each of these manipulations are being done.
    // componentsSeparatedByString is the exact same as javascript .split("foobar");
    NSMutableArray *msampleFinder = [[_html componentsSeparatedByString:@"<div id='0."] mutableCopy];
    [msampleFinder removeObjectAtIndex:0];
    NSMutableArray *msampleFinder3 = [[[msampleFinder lastObject] componentsSeparatedByString:@"<div id='1."] mutableCopy];
    msampleFinder[[msampleFinder count]-1]  = msampleFinder3[0];
    [msampleFinder3 removeObjectAtIndex:0];
    // Put a break point here and just look at the contents of each msampleFinder and it'll make sense.
    NSMutableArray *msampleFinder4 = [[NSMutableArray alloc]init];
    for (NSString *finder in msampleFinder3) {
        // This will add each check box from the 1.____ sample sets (i.e. sets that require both a positive and negative
        // checkbox) to msamapleFinder4
        [msampleFinder4 addObjectsFromArray:[finder componentsSeparatedByString:@"<input type='checkbox' name=grp value='"]];
    }
    // The last object is just going to be a bunch of gunk html that gives us the rest of the page data, but we don't care about that
    // because we only wanted the check boxes
    [msampleFinder4 removeObjectAtIndex:0];
    NSMutableArray *msampleFinder2 = [[NSMutableArray alloc]init];
    for (NSString *finder in msampleFinder) {
        // This does the same thing that the earlier one did, just for 0.____ sample sets instead for msampleFinder2
        [msampleFinder2 addObjectsFromArray:[finder componentsSeparatedByString:@"<input type='checkbox' name=grp value='"]];
    }
    [msampleFinder2 removeObjectAtIndex:0];
    _NCI = [[NSMutableArray alloc]init];
    _sampleDrug = [[NSMutableArray alloc]init];
    _ANN = [[NSMutableArray alloc]init];
    _cellLine = [[NSMutableArray alloc]init];
    _drugResponse = [[NSMutableArray alloc]init];
    _germCellTumors = [[NSMutableArray alloc]init];
    _leukemia = [[NSMutableArray alloc]init];
    _medulloblastoma = [[NSMutableArray alloc]init];
    _neuroblastoma = [[NSMutableArray alloc]init];
    _normalTissue = [[NSMutableArray alloc]init];
    _pediatricCancers = [[NSMutableArray alloc]init];
    _rhabdomyosarcoma = [[NSMutableArray alloc]init];
    _Sarcoma = [[NSMutableArray alloc]init];
    _cMAP = [[NSMutableArray alloc]init];
    // If you add a whole new catagory of samples it is CRUCIAL that you add it to this array and initialize it the same way the others were. It also
    // has to be in order with the order they show up in the html, otherwise everything is going to get mixed up and/or crash the program.
    NSArray *sampleSets = @[_NCI, _sampleDrug, _ANN, _cellLine, _drugResponse, _germCellTumors, _leukemia, _medulloblastoma, _neuroblastoma, _normalTissue, _pediatricCancers, _rhabdomyosarcoma, _Sarcoma, _cMAP];
    // The following code generates the switches, the labels describing them, and the data each one will provide if turned on.
    // These are counters, c is what row the next switch should be generated on, and s is the catagory the next switch should be placed under.
    int c = 0;
    int s = 0;
    NSString *checkUrl = [[NSString alloc]init];
    NSArray *dummyArray = [[NSArray alloc]init];
    NSArray *dummyArray2 = [[NSArray alloc]init];
    // we need to figure out how many switches we're going to use for each catagory so we can devide them evenly between the
    // two columns on the iPad. The way I decided to do that was to just count up all of the elements of msampleFinder_ that
    // will eventually be turned into switches and labels. Note that int objects cannot be put into NSMutableArrays because
    // arrays can only hold pointers, and int is a native object without a pointer, so I recast it as an NSNumber.
    NSMutableArray *countsArray = [[NSMutableArray alloc]init];
    NSUInteger numberOfSwitchesNeeded = 0;
    for (NSString *str in msampleFinder2) {
        if ([[str substringWithRange:NSRangeFromString(@"0,5")] isEqualToString:@"/WWW/"]) {
            numberOfSwitchesNeeded++;
        } else {
            NSNumber *wrappedInt = [NSNumber numberWithUnsignedInteger:numberOfSwitchesNeeded];
            [countsArray addObject:wrappedInt];
            numberOfSwitchesNeeded = 0;
        }
        if ([str isEqual:[msampleFinder2 lastObject]]) {
            NSNumber *wrappedInt = [NSNumber numberWithUnsignedInteger:numberOfSwitchesNeeded];
            [countsArray addObject:wrappedInt];
            numberOfSwitchesNeeded = 0;
        }
    }
    // count is our overall number of switches + 1. The +1 is so that when necessary the next element in the array can be accessed
    // before it is iterated on
    int count = 1;
    // row should really be column, this will only ever be 0 (left) or 1 (right)
    int row = 0;
    // We start with the 0.___ samples that we earlier put in msampleFinder2
    for (NSString *str in msampleFinder2) {
        // The only time this condition will not be true is at the end of a catagory, where it states what the next catagory is
        if ([[str substringWithRange:NSRangeFromString(@"0,5")] isEqualToString:@"/WWW/"]) {
            dummyArray = [str componentsSeparatedByString:@"'>"];
            // Conviniently, with the way the html is being parsed the URL ends up in the first position of our array so
            // we'll just grab that
            checkUrl = dummyArray[0];
            // We don't need the beginning of our array anymore because we already captured it, so we're going to throw it away
            // and focus on the third element which is where our label information is going to be
            dummyArray2 = [dummyArray[2] componentsSeparatedByString:@"<span title='"];
            // Since the iPad is so much bigger, we're obviously going to put the switches in different positions, so right here
            // before we do that we check to see if the device is an iPad or not
            if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                // Since the iPad is big enough to fit two columns, we are going to use two columns! To figure out when we need to start
                // our new column we check to see if the number of rows in that column (c) exceeds half the number of switches in total.
                if (c > [countsArray[s] floatValue]/2.0 - 0.5) {
                    row = 1;
                    c= 0;
                }
                // Making the label that goes next to the switch. The parameters are (xpos, ypos, width, height)
                UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(54+50 +355*row, 362 +c*34, 280, 21)];
                myLabel.text = [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
                myLabel.font = [UIFont systemFontOfSize:14];
                // Place the label in the view that is on top. Otherwise it will be invisible
                [self.iPadView addSubview:myLabel];
                myLabel.hidden = true;
                // map the id of our switch to the url for tha data we want that switch to turn on
                [_realKeys setObject:checkUrl forKey:[NSString stringWithFormat:@"%i", count]];
                UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50+355*row, 357 + c*34, 0, 0)];
                [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                // give the switch a label corresponding to it's id
                mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
                [self.container addSubview:mySwitch];
                [self.container addSubview:myLabel];
                // Add the new switche and label to their catagory so that the buttons can turn them on and off
                [sampleSets[s] addObject:mySwitch];
                [sampleSets[s] addObject:myLabel];
                mySwitch.hidden = true;
            } else {
                // exact same thing, just different positioning to accomodate the iPhone's screen
                UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 412 +c*34, 280, 21)];
                myLabel.text = [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
                myLabel.font = [UIFont systemFontOfSize:14];
                [self.container addSubview:myLabel];
                myLabel.hidden = true;
                [_realKeys setObject:checkUrl forKey:[NSString stringWithFormat:@"%i", count]];
                UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 407 + c*34, 0, 0)];
                [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
                [self.container addSubview:mySwitch];
                [self.container addSubview:myLabel];
                [sampleSets[s] addObject:mySwitch];
                [sampleSets[s] addObject:myLabel];
                mySwitch.hidden = true;

            }
            c++;
            count++;
        } else {
            // end of a catagory, so move onto next one (s++) and go back to the top row (c=0)
            s++;
            c = 0;
            // row should be column, but it would be complicated to change it now and it doesn't make any difference
            row = 0;
        }
    }
    // rest the values for the next set of switches
    BOOL left = true;
    c = 0;
    s++;
    row = 0;
    numberOfSwitchesNeeded = 0;
    for (NSString *str in msampleFinder4) {
        if ([[str substringWithRange:NSRangeFromString(@"0,5")] isEqualToString:@"/WWW/"]) {
            numberOfSwitchesNeeded++;
        } else {
            NSNumber *wrappedInt = [NSNumber numberWithUnsignedInteger:numberOfSwitchesNeeded];
            [countsArray addObject:wrappedInt];
            numberOfSwitchesNeeded = 0;
        }
        if ([str isEqual:[msampleFinder4 lastObject]]) {
            NSNumber *wrappedInt = [NSNumber numberWithUnsignedInteger:numberOfSwitchesNeeded];
            [countsArray addObject:wrappedInt];
            numberOfSwitchesNeeded = 0;
        }
    }
    // exact same thing as above, just for sample sets that have positive and negative samples so
    // I added the BOOL left parameter, which just says whether each switch goes on the left or right
    // of the column.
    for (NSString *str in msampleFinder4) {
        if ([[str substringWithRange:NSRangeFromString(@"0,5")] isEqualToString:@"/WWW/"]) {
            if( left) {
                dummyArray = [str componentsSeparatedByString:@"'>"];
                checkUrl = dummyArray[0];
                [_realKeys setObject:checkUrl forKey:[NSString stringWithFormat:@"%i", count]];
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    // This is a tad bit different because there are two switches per row, so we need to divide
                    // by 4 instead of 2.
                    if (c > [countsArray[s] floatValue]/4.0 - 0.5) {
                        row = 1;
                        c= 0;
                    }
                    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50+355*row, 357 + c*34, 0, 0)];
                    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                    mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
                    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(50+54+355*row, 362 +c*34, 280, 21)];
                    myLabel.text = @"+";
                    myLabel.font = [UIFont systemFontOfSize:14];
                    [self.container addSubview:myLabel];
                    myLabel.hidden = true;
                    [self.container addSubview:mySwitch];
                    [self.container addSubview:myLabel];
                    [sampleSets[s] addObject:mySwitch];
                    [sampleSets[s] addObject:myLabel];
                    mySwitch.hidden = true;
                } else {
                    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 407 + c*34, 0, 0)];
                    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                    mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
                    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(54, 412 +c*34, 280, 21)];
                    myLabel.text = @"+";
                    myLabel.font = [UIFont systemFontOfSize:14];
                    [self.container addSubview:myLabel];
                    myLabel.hidden = true;
                    [self.container addSubview:mySwitch];
                    [self.container addSubview:myLabel];
                    [sampleSets[s] addObject:mySwitch];
                    [sampleSets[s] addObject:myLabel];
                    mySwitch.hidden = true;
                }
            } else {
                dummyArray = [str componentsSeparatedByString:@"'>"];
                checkUrl = dummyArray[0];
                dummyArray2 = [dummyArray[2] componentsSeparatedByString:@"<span title='"];
                if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(115+75+355*row, 362 +c*34, 280, 21)];
                    myLabel.text = [NSString stringWithFormat:@"-  %@", [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""]];
                    myLabel.font = [UIFont systemFontOfSize:14];
                    myLabel.hidden = true;
                    [_realKeys setObject:checkUrl forKey:[NSString stringWithFormat:@"%i", count]];
                    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(50+75+355*row, 357 + c*34, 0, 0)];
                    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                    mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
                    [self.container addSubview:mySwitch];
                    [self.container addSubview:myLabel];
                    [sampleSets[s] addObject:mySwitch];
                    [sampleSets[s] addObject:myLabel];
                    mySwitch.hidden = true;
                } else {
                    UILabel *myLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 412 +c*34, 280, 21)];
                    myLabel.text = [NSString stringWithFormat:@"-  %@", [dummyArray2[0] stringByReplacingOccurrencesOfString:@"</span>" withString:@""]];
                    myLabel.font = [UIFont systemFontOfSize:11];
                    myLabel.hidden = true;
                    [_realKeys setObject:checkUrl forKey:[NSString stringWithFormat:@"%i", count]];
                    UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(75, 407 + c*34, 0, 0)];
                    [mySwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
                    mySwitch.accessibilityLabel = [NSString stringWithFormat:@"%i", count];
                    [self.container addSubview:mySwitch];
                    [self.container addSubview:myLabel];
                    [sampleSets[s] addObject:mySwitch];
                    [sampleSets[s] addObject:myLabel];
                    mySwitch.hidden = true;
                }
                c++;
            }
            left = !left;
            count++;
        } else {
            s++;
            c = 0;
            row = 0;
        }
    }
    // These methods define that the pickerviews should be used instead of a
    // keyboard for the text boxes.
    // Allocate and initialize the memory for the pickerviews
    _samplePicker = [[UIPickerView alloc]init];
    _genePicker = [[UIPickerView alloc]init];
    _genesetPicker = [[UIPickerView alloc]init];
    _duplicatePicker = [[UIPickerView alloc]init];
    // Tell pickerView where to get information from
    [_samplePicker setDataSource:self];
    // Tell pickerview where to send data
    [_samplePicker setDelegate:self];
    // Tell pickerview to show what's being selected
    [_samplePicker setShowsSelectionIndicator:YES];
    // Tell picekrView to replace keyboard for textfield
    _sampleSelect.inputView = _samplePicker;
    // tell textfield to show the first object in the pickerView by default
    _sampleSelect.text = _samples[0];
    [_genePicker setDataSource:self];
    [_genePicker setDelegate:self];
    [_genePicker setShowsSelectionIndicator:YES];
    _geneSelect.inputView = _genePicker;
    _geneSelect.text = @"Use all genes(probes)";
    [_genesetPicker setDataSource:self];
    [_genesetPicker setDelegate:self];
    [_genesetPicker setShowsSelectionIndicator:YES];
    _genesetSelect.inputView = _genesetPicker;
    _genesetSelect.text = @"Select MSigDC gene set";
    [_duplicatePicker setDataSource:self];
    [_duplicatePicker setDelegate:self];
    [_duplicatePicker setShowsSelectionIndicator:YES];
    _duplicateSelect.inputView = _duplicatePicker;
    _duplicateSelect.text = @"Keep highest value(abs)";
    [_scrollView setDelegate:self];
}
// This sets the bottom of the dragable space below the screen. If any more samples are added than twice what Neuroblastoma currently has,
// the size of the webview will need to be increased. To do this go to the storyboard files and on each one locate the page that looks
// like the GSEA page, it should have the title "Controller" below it, and you need to click on it. On the left side of the screen a nesting
// display should show up with the top level being called "Controller Scene" open up the view nest and there should be a scroller view in it.
// Open up the scroller view and there should be another view in that one. Select that view you now see and go to the right side of the screen
// and open the size inspector (It looks like a ruler along the top row). Increase the height as much as necessary. Everything should work after
// that.
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (targetContentOffset->y > _scrollDist) {
        targetContentOffset->y = _scrollDist;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark PickerView dataSource
// This method sets the text of each textfield to the value selected on the pickerview
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component {
    if (pickerView == self.samplePicker) {
        [_sampleSelect setText:[self pickerView:_samplePicker titleForRow:[_samplePicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.genePicker) {
        [_geneSelect setText:[self pickerView:_genePicker titleForRow:[_genePicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.genesetPicker) {
        [_genesetSelect setText:[self pickerView:_genesetPicker titleForRow:[_genesetPicker selectedRowInComponent:0] forComponent:0]];
    }
    else if (pickerView == self.duplicatePicker) {
        [_duplicateSelect setText:[self pickerView:_duplicatePicker titleForRow:[_duplicatePicker selectedRowInComponent:0] forComponent:0]];
    }
}
// If you wanted more than on column for the pickerview you would define that here
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

// This defines the number of selectable items in the pickerview. Right now
// it is set to however many items we have to choose from
- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.samplePicker) {
        return [_samples count];
    }
    else if (pickerView == self.genePicker) {
        return [_gene count];
    }else if (pickerView == self.genesetPicker) {
        return [_genesets count];
    }else if (pickerView == self.duplicatePicker) {
        return [_duplicate count];
    }
    else{
        return 0;
    }
}
// This method defines the title of the row. In general, this is used very rarely.
- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    if (pickerView == self.samplePicker) {
        return _samples[row];
    }
    else if (pickerView == self.genePicker) {
        return _gene[row];
    }
    else if (pickerView == self.genesetPicker) {
        // this is a bit different because for the genesets it's the keys
        // that are displayed in the picker, not the objects themselves
        NSMutableArray *keys = [[_genesets allKeys] mutableCopy];
        [keys insertObject:@"Select MSigDC gene set" atIndex:0];
        return keys[row];
    }
    else if (pickerView == self.duplicatePicker) {
        return _duplicate[row];
    }
    else{
        return @"";
    }
}
// For a given row this defines what the row should display as text.
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* tView = (UILabel*)view;
    if (!tView){
        tView = [[UILabel alloc] init];
    }
    if (pickerView == self.samplePicker) {
        // These tend to be longer strings, so they need to be sized down
        tView.text=_samples[row];
        tView.font = [UIFont systemFontOfSize:14];
    }
    else if (pickerView == self.genePicker) {
        tView.text=_gene[row];
    }
    else if (pickerView == self.genesetPicker) {
        // Get the keys and add the Select MSigDC gene set so that it shows
        // up as a description but doesn't have to map to any real object
        // in the dictionary
        NSMutableArray *keys = [[_genesets allKeys] mutableCopy];
        [keys insertObject:@"Select MSigDC gene set" atIndex:0];
        tView.text=keys[row];
        tView.font = [UIFont systemFontOfSize:14];
    } else if (pickerView == self.duplicatePicker) {
        tView.text=_duplicate[row];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // if it's an iPad, it has room for larger font regardless of how long
        // the string is
        tView.font = [UIFont systemFontOfSize:30];
    }
    return tView;
}
#pragma mark NSURLConnection Delegate Methods
// These methods handle HTTP requests. The name of each one is pretty self explanitory.
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    _response = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
    if ([_response rangeOfString:@"login_submitted"].location != NSNotFound) {
        // find the appropriate storyboard for the given device
        UIStoryboard *storyboard = [[UIStoryboard alloc]init];
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Forced Logout" message:@"You have been inactive for too long and have been logged out. Please log in again."   delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        ViewController *ViewController2 = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"login"];
        [self presentViewController:ViewController2 animated:YES completion:nil];
        return;
    }
    // This method handles the response of the server. Here we check to see if the server
    // told us that it's running the program or not. We can change what we are looking for
    // by just changing what is in the rangeOfString: parameter
    if([_response rangeOfString:@"An email will be sent to you once it's finished."].location != NSNotFound) {
        NSString *message = @"The program is running... An email will be sent to you once it's finished.";
        if (self.isViewLoaded && self.view.window) {
            // viewController is visible
            _alertView = [[UIAlertView alloc] initWithTitle:@"Success" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [_alertView show];
        }
    } else {
        NSString *message = @"Could not run analysis";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self.activityWheel stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    NSString *message = @"Could not connect to server";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    [self.activityWheel stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
