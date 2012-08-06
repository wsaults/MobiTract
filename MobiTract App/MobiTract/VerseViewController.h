//
//  VerseViewController.h
//  MobiTract
//
//  Created by William Saults on 3/7/12.
//  Copyright (c) 2012 UTVCA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VerseViewController : UIViewController{
    UILabel *verseOutlet;
    UITextView *scriptureOutlet;
    int verseIndex;
    UIStepper *stepper;
    NSArray *verseArray;
    NSMutableArray *scriptureArray;
}

@property (strong, nonatomic) IBOutlet UILabel *verseOutlet;
@property (strong, nonatomic) IBOutlet UITextView *scriptureOutlet;
@property (strong, nonatomic) NSArray *verseArray;
@property (strong, nonatomic) NSMutableArray *scriptureArray;
@property (strong, nonatomic) UIStepper *stepper;
- (IBAction)stepperValueChanged:(UIStepper *)sender;

@end

