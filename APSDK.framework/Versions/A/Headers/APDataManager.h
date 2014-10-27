//
//  APDataManager.h
//  AnyPresence SDK
//

/*!
 @header APDataManager
 @abstract APDataManager class
 */

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>

/*!
 @const kAPDataManagerDataDidChangeNotification
 @abstract Notification that is posted when one or more @link //apple_ref/occ/clm/APObject @/link objects have changed.
 */
extern NSString * const kAPDataManagerDataDidChangeNotification;

/*!
 @enum APDataManagerStore
 @abstract Type of object storage.
 @constant kAPDataManagerStorePersistent Persistent store.
 @constant kAPDataManagerStoreInMemory In-memory store that is destroyed when app is stopped.
 */
typedef enum {
    kAPDataManagerStorePersistent,
    kAPDataManagerStoreInMemory
} APDataManagerStore;

/*!
 @class APDataManager
 @abstract Provides access to internal Core Data storage.
 */
@interface APDataManager : NSObject

/*!
 @var objectContext
 @abstract Core Data managed object context.
 */
@property (nonatomic, strong) NSManagedObjectContext * objectContext;
/*!
 @var objectModel
 @abstract Core Data managed object model.
 */
@property (nonatomic, strong, readonly) NSManagedObjectModel * objectModel;

/*!
 @method setDataManager:
 @param dataManager New data manager instance.
 @abstract Sets current instance of  @link //apple_ref/occ/clm/APDataManager @/link.
 */
+ (void)setDataManager:(APDataManager *)dataManager;
/*!
 @method dataManager
 @abstract Gets current instance of  @link //apple_ref/occ/clm/APDataManager @/link.
 */
+ (APDataManager *)dataManager;
/*!
 @method initWithStore:
 @abstract Creates new data manager instance with the given object store type.
 @param store Object store type.
 @discussion This method allows to use in-memory or persistent storage.
 */
- (id)initWithStore:(APDataManagerStore)store;

@end
