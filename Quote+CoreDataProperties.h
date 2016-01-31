//
//  Quote+CoreDataProperties.h
//  QuotesToGo
//


#import "Quote.h"

NS_ASSUME_NONNULL_BEGIN

@interface Quote (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *content;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) Author *author;

@end

NS_ASSUME_NONNULL_END
