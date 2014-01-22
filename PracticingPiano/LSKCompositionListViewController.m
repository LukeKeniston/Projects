//
//  LSKCompositionListViewController.m
//  PracticingPiano
//
//  Created by Luke Keniston on 12/14/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import "LSKCompositionListViewController.h"
#import "MyDataManager.h"
#import "DataSource.h"
#import "ScaleNote.h"
#import "LSKScaleController.h"
#import "Composition.h"


@interface LSKCompositionListViewController ()
@property (nonatomic, strong) DataSource *dataSource;
@property (nonatomic,strong) MyDataManager *myDataManager;
@end

@implementation LSKCompositionListViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _myDataManager = [[MyDataManager alloc] init];
        [self findDataSourceForTable];
        _dataSource.delegate = self;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self.dataSource;
    self.dataSource.tableView = self.tableView;
    
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    
}
// displays all of the compositions that were created
-(void)findDataSourceForTable
{
    // Core data finds all the results, tempo is unique to just the parent entity
    NSString* searchPredicateString = @"tempo != 0";
    NSPredicate *predicate  =[NSPredicate predicateWithFormat:searchPredicateString];
    MyDataManager *myDataManger = [[MyDataManager alloc] init];
    _dataSource = [[DataSource alloc] initForEntity:@"Composition" sortKeys:@[@"pieceName"] predicate:predicate sectionNameKeyPath:nil dataManagerDelegate:myDataManger];
}
-(NSString*)cellIdentifierForObject:(id)object {
    return @"ScaleCell";
    
}
-(void)configureCell:(UITableViewCell *)cell withObject:(id)object {
    Composition *composition = object;
    
    cell.textLabel.text = composition.pieceName;
    cell.detailTextLabel.text = composition.composer;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark - editing
-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LSKScaleController *compositionController = segue.destinationViewController;
    
    // get current cells information
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    Composition *composition = [self.dataSource objectAtIndexPath:indexPath];
    
    // retrives all the data for that composition
    NSPredicate *pieceName = [NSPredicate predicateWithFormat:@"pieceName == %@", composition.pieceName];
    NSPredicate *composer = [NSPredicate predicateWithFormat:@"composer == %@", composition.composer];
    NSArray *subpredicates = [NSArray arrayWithObjects:pieceName, composer, nil];
    NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    MyDataManager *myDataManger = [[MyDataManager alloc] init];
    // fetches all of the data for that composition
    _dataSource = [[DataSource alloc] initForEntity:@"ScaleNote" sortKeys:@[@"noteType"] predicate:predicate sectionNameKeyPath:nil dataManagerDelegate:myDataManger];
    NSArray *testing = [self.dataSource fetchResultsInArray];
    NSMutableArray *notesArray = [[NSMutableArray alloc] init];
    for(ScaleNote *note in testing)
    {
        NSDictionary *noteInfo =@{@"type":note.noteType, @"xPosition": note.xPosition, @"yPosition": note.yPosition};
        [notesArray addObject:noteInfo];
    }
    [compositionController intialNotePlacement:notesArray andTempo:composition.tempo];
    
}

@end
