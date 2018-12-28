#import "BaseModel.h"

@implementation BaseModel

- (NSString *)json
{
    NSDictionary *dictOfObject = [self dictionary];
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictOfObject options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json;
}

- (NSDictionary *)dictionary {
    return [self toDictionary];
}

@end
