//
//  SelectTaskNoticeCell.h
//  HiHome
//
//  Created by Rain on 15/10/19.
//  Copyright © 2015年 zykj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTaskNoticeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *mImageView;
@property (weak, nonatomic) IBOutlet UILabel *mReleaseTaskPerson;
@property (weak, nonatomic) IBOutlet UILabel *mStartDate;
@property (weak, nonatomic) IBOutlet UILabel *mEndDate;
@property (weak, nonatomic) IBOutlet UILabel *mDoing;
@property (weak, nonatomic) IBOutlet UILabel *mRemind;
@property (weak, nonatomic) IBOutlet UILabel *mRepeat;
@property (weak, nonatomic) IBOutlet UILabel *mExecutor;
@property (weak, nonatomic) IBOutlet UIButton *mReceive;
@property (weak, nonatomic) IBOutlet UIButton *mReject;

@end
