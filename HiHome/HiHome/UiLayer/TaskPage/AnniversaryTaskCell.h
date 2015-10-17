//
//  AnniversaryTaskCell.h
//  HiHome
//
//  Created by Rain on 15/10/17.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnniversaryTaskCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mImage;
@property (weak, nonatomic) IBOutlet UILabel *mName;
@property (weak, nonatomic) IBOutlet UILabel *mDate;

@property(strong,nonatomic)UITextView *mTextView;
@property(strong,nonatomic)UIImageView *mShowImage;

@end
