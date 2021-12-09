#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FastEasyMapping.h"
#import "FEMAssignmentPolicy.h"
#import "FEMRelationshipAssignmentContext+Internal.h"
#import "FEMRelationshipAssignmentContext.h"
#import "FEMObjectCache.h"
#import "FEMDeserializer.h"
#import "FEMAttribute.h"
#import "FEMMapping.h"
#import "FEMProperty.h"
#import "FEMRelationship.h"
#import "FEMSerializer.h"
#import "FEMManagedObjectStore.h"
#import "FEMObjectStore.h"
#import "FEMRepresentationUtility.h"
#import "FEMTypeIntrospection.h"
#import "FEMTypes.h"

FOUNDATION_EXPORT double FastEasyMappingVersionNumber;
FOUNDATION_EXPORT const unsigned char FastEasyMappingVersionString[];

