//
//  TaskNoticeTableViewCell.h
//  HiHome
//
//  Created by Rain on 15/10/19.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskNoticeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mReleaseTaskPerson;
@property (weak, nonatomic) IBOutlet UILabel *mDate;
@property (weak, nonatomic) IBOutlet UILabel *mStatus;
@property (weak, nonatomic) IBOutlet UILabel *mStartDate;
@property (weak, nonatomic) IBOutlet UILabel *mEndDate;
@property (weak, nonatomic) IBOutlet UILabel *mDoing;
@property (weak, nonatomic) IBOutlet UILabel *mRemind;
@property (weak, nonatomic) IBOutlet UILabel *mRepeat;
@property (weak, nonatomic) IBOutlet UILabel *mExecutor;

@end
