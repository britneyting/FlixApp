//
//  DetailsViewController.h
//  FlixApp
//
//  Created by britneyting on 6/28/19.
//  Copyright © 2019 britneyting. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) NSDictionary *movie; // want to be able to display this movie. It's a public property and something other people can set and I can display properly

@end

NS_ASSUME_NONNULL_END

