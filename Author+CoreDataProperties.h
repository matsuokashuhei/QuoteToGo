//
//  Author+CoreDataProperties.h
//  QuotesToGo
//


#import "Author.h"

NS_ASSUME_NONNULL_BEGIN

@interface Author (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *image;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Quote *> *quote;

@end

@interface Author (CoreDataGeneratedAccessors)

- (void)addQuoteObject:(Quote *)value;
- (void)removeQuoteObject:(Quote *)value;
- (void)addQuote:(NSSet<Quote *> *)values;
- (void)removeQuote:(NSSet<Quote *> *)values;

@end

NS_ASSUME_NONNULL_END
