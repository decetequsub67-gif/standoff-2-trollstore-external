#import <Foundation/Foundation.h>

NSArray<NSString *> *cfg_get_list(void);
void cfg_create(NSString *name);
void cfg_load(NSString *name);
void cfg_delete(NSString *name);
