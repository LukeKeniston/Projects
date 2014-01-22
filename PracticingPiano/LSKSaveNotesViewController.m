//
//  LSKSaveNotesViewController.m
//  PracticingPiano
//
//  Created by Luke Keniston on 12/14/13.
//  Copyright (c) 2013 Luke Keniston. All rights reserved.
//

#import "LSKSaveNotesViewController.h"


@interface LSKSaveNotesViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *composerTextField;
@property (weak, nonatomic) IBOutlet UITextField *infoTextField;


// cancels saving of the composistion
- (IBAction)cancelButtonPressed:(id)sender;

// saves the composition and returns to previous view controller
- (IBAction)saveButtonPressed:(id)sender;
@end

@implementation LSKSaveNotesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.nameTextField.delegate = self;
    self.composerTextField.delegate = self;
    self.infoTextField.delegate = self;}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate dismissMe];
}

- (IBAction)saveButtonPressed:(id)sender {
    NSString *name = self.nameTextField.text;
    NSString *composer = self.composerTextField.text;
    // makes sure that the user has something entered for the name of the composition
    if(![name isEqualToString:@""] && ![composer isEqualToString:@""])
    {
        NSDictionary *dictionary = @{@"name":name, @"composer":composer, @"tempo":self.tempo};
        [self.delegate saveEnteredData:dictionary];
        [self.delegate dismissMe];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Opps" message:@"A composition name and composer must be entered to save your composition" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
    }
}

@end