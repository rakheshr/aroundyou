//
//  DetailsActionViewCell.h
//  AroundYou
//
//  Created by Ankit Nitin Shah on 2/23/14.
//  Copyright (c) 2014 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsActionViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
- (IBAction)callAction:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)shareAction:(id)sender;

@end
