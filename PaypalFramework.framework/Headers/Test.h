//
//  Test.h
//  PaypalFramework
//
//  Created by SOTSYS122 on 23/06/16.
//  Copyright © 2016 SOTSYS122. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PayPal.h"

typedef enum PaymentStatuses {
    PAYMENTSTATUS_SUCCESS,
    PAYMENTSTATUS_FAILED,
    PAYMENTSTATUS_CANCELED,
} PaymentStatus;

typedef void (^PaypalResponse) (NSString *strId);

@interface Test : NSObject <PayPalPaymentDelegate>
{
    PaymentStatus status;
    NSString *pReturnId;
    PaypalResponse objPaypal;
}



-(void)main_initialiseWithAppId:(NSString *)AppID env:(int)environment;
-(void)paymentWithReciver:(NSArray*)reciver paymentPrimaryPrice:(NSString*)PPrice  paymentSecondaryPrice:(NSString*)SPrice primaryReciverEmail:(NSString *)reciverPEmail SecondaryReciverEmail:(NSString*)reciverSEmail itemDescription:(NSString*)Description itemName:(NSString*)iName
     andCompletionHandler:(PaypalResponse)completionHandler;
//-(void)paymentWithReciver:(NSArray*)reciver paymentPrimaryPrice:(NSDecimalNumber*)PPrice  paymentSecondaryPrice:(NSDecimalNumber*)SPrice primaryReciverEmail:(NSString *)reciverPEmail SecondaryReciverEmail:(NSString*)reciverSEmail itemDescription:(NSString*)Description itemName:(NSString*)iName;
@end
