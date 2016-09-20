

#import "Test.h"
#import "PayPal.h"
#import "PayPalPayment.h"
#import "PayPalAdvancedPayment.h"
#import "PayPalAmounts.h"
#import "PayPalReceiverAmounts.h"
#import "PayPalAddress.h"
#import "PayPalInvoiceItem.h"

@implementation Test 
-(void)main_initialiseWithAppId:(NSString *)AppID env:(int)environment{
    [PayPal initializeWithAppID:AppID forEnvironment: environment];
}
-(void)paymentWithReciver:(NSArray*)reciver paymentPrimaryPrice:(NSString*)PPrice  paymentSecondaryPrice:(NSString*)SPrice primaryReciverEmail:(NSString *)reciverPEmail SecondaryReciverEmail:(NSString*)reciverSEmail itemDescription:(NSString*)Description itemName:(NSString*)iName
 andCompletionHandler:(PaypalResponse)completionHandler
{
    objPaypal = nil;
    objPaypal = completionHandler;
    //optional, set shippingEnabled to TRUE if you want to display shipping
    //options to the user, default: TRUE
   
    [PayPal getPayPalInst].shippingEnabled = FALSE;
    [PayPal getPayPalInst].delegate=self;
    //optional, set dynamicAmountUpdateEnabled to TRUE if you want to compute
    //shipping and tax based on the user's address choice, default: FALSE
    [PayPal getPayPalInst].dynamicAmountUpdateEnabled = FALSE;
    
    //optional, choose who pays the fee, default: FEEPAYER_EACHRECEIVER
    [PayPal getPayPalInst].feePayer = FEEPAYER_SECONDARYONLY;
    
    //for a payment with multiple recipients, use a PayPalAdvancedPayment object
    PayPalAdvancedPayment *payment = [[PayPalAdvancedPayment alloc] init];
    payment.paymentCurrency = @"GBP";
    
    //receiverPaymentDetails is a list of PPReceiverPaymentDetails objects
    payment.receiverPaymentDetails = [NSMutableArray array];
    
    NSArray *nameArray = reciver;//[NSArray arrayWithObjects:@"Frank's", @"Robert's",nil];
    
    for (int i = 0; i < 2; i++) {
        PayPalReceiverPaymentDetails *details = [[PayPalReceiverPaymentDetails alloc] init];
        
        details.description = Description;

        double primaryOrder;
        double secondaryOrder;
      
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        
        if (i==0)
        {
            details.recipient = [NSString stringWithFormat:@"%@",reciverSEmail];
            details.merchantName = @"SchoolReviewer";
            
            NSLog(@"SellerPrice ---->%@",SPrice);
            secondaryOrder = [[formatter numberFromString:SPrice] doubleValue];
            NSLog(@"index 0 order price is--->:%.2f",secondaryOrder);
        }
        else{
            details.recipient = [NSString stringWithFormat:@"%@",reciverPEmail];
            NSLog(@"Primary price is ---->%@",PPrice);
            details.merchantName = nameArray[0];
            primaryOrder = [[formatter numberFromString:PPrice] doubleValue];
            
             NSLog(@"index 1 order price is--->:%.2f",primaryOrder);
        }
         //[NSString stringWithFormat:@"%@",[nameArray objectAtIndex:i]];
        
        secondaryOrder = secondaryOrder + primaryOrder;
        details.subTotal = (NSDecimalNumber *)[NSDecimalNumber numberWithDouble:secondaryOrder];//secondaryOrder
       
        NSLog(@"subtotal is----%@",details.subTotal);
        details.invoiceData = [[PayPalInvoiceData alloc] init];
      
        details.invoiceData.invoiceItems = [NSMutableArray array];
        PayPalInvoiceItem *item = [[PayPalInvoiceItem alloc] init];
        item.totalPrice = details.subTotal;
        item.name = iName;
        [details.invoiceData.invoiceItems addObject:item];
        
        if (i == 1) {
            details.isPrimary = TRUE;
        }
        
        [payment.receiverPaymentDetails addObject:details];
    }
    
    [[PayPal getPayPalInst] advancedCheckoutWithPayment:payment];
}
/*
 - (void)chainedPayment {
	//dismiss any native keyboards
	[preapprovalField resignFirstResponder];
	
	//optional, set shippingEnabled to TRUE if you want to display shipping
	//options to the user, default: TRUE
	[PayPal getPayPalInst].shippingEnabled = TRUE;
	
	//optional, set dynamicAmountUpdateEnabled to TRUE if you want to compute
	//shipping and tax based on the user's address choice, default: FALSE
	[PayPal getPayPalInst].dynamicAmountUpdateEnabled = TRUE;
	
	//optional, choose who pays the fee, default: FEEPAYER_EACHRECEIVER
	[PayPal getPayPalInst].feePayer = FEEPAYER_PRIMARYRECEIVER;
	
	//for a payment with multiple recipients, use a PayPalAdvancedPayment object
	PayPalAdvancedPayment *payment = [[[PayPalAdvancedPayment alloc] init] autorelease];
	payment.paymentCurrency = @"GBP";
	
	//receiverPaymentDetails is a list of PPReceiverPaymentDetails objects
	payment.receiverPaymentDetails = [NSMutableArray array];
	
	NSArray *nameArray = [NSArray arrayWithObjects:@"Frank's", @"Robert's",nil];
	
	for (int i = 1; i < 3; i++) {
 PayPalReceiverPaymentDetails *details = [[[PayPalReceiverPaymentDetails alloc] init] autorelease];
 
 details.description = @"Bear Components";
 unsigned long long order, tax, shipping;
 
 if (i==1)
 {
 details.recipient = [NSString stringWithFormat:@"roy.goddard@alpha-sys-consult.co.uk"];
 order = 1 * 100;
 }
 else{
 details.recipient = [NSString stringWithFormat:@"meanand@gmail.com"];
 order = 2 * 100;
 }
 details.merchantName = [NSString stringWithFormat:@"%@ Bear Parts",[nameArray objectAtIndex:i-1]];
 
 
 //		tax = i * 7;
 //		shipping = i * 14;
 
 //subtotal of all items for this recipient, without tax and shipping
 details.subTotal = [NSDecimalNumber decimalNumberWithMantissa:order exponent:-2 isNegative:FALSE];
 
 //invoiceData is a PayPalInvoiceData object which contains tax, shipping, and a list of PayPalInvoiceItem objects
 details.invoiceData = [[[PayPalInvoiceData alloc] init] autorelease];
 //		details.invoiceData.totalShipping = [NSDecimalNumber decimalNumberWithMantissa:shipping exponent:-2 isNegative:FALSE];
 //		details.invoiceData.totalTax = [NSDecimalNumber decimalNumberWithMantissa:tax exponent:-2 isNegative:FALSE];
 
 //invoiceItems is a list of PayPalInvoiceItem objects
 //NOTE: sum of totalPrice for all items must equal details.subTotal
 //NOTE: example only shows a single item, but you can have more than one
 
 details.invoiceData.invoiceItems = [NSMutableArray array];
 PayPalInvoiceItem *item = [[[PayPalInvoiceItem alloc] init] autorelease];
 item.totalPrice = details.subTotal;
 item.name = @"Bear Stuffing";
 [details.invoiceData.invoiceItems addObject:item];
 
 //the only difference between setting up a chained payment and setting
 //up a parallel payment is that the chained payment must have a single
 //primary receiver.  the subTotal + totalTax + totalShipping of the
 //primary receiver must be greater than or equal to the sum of
 //payments being made to all other receivers, because the payment is
 //being made to the primary receiver, then the secondary receivers are
 //paid by the primary receiver.
 if (i == 2) {
 details.isPrimary = TRUE;
 }
 
 [payment.receiverPaymentDetails addObject:details];
	}
	
	[[PayPal getPayPalInst] advancedCheckoutWithPayment:payment];
 }

 */
/*-(void)paymentWithReciver:(NSArray*)reciver paymentPrimaryPrice:(NSDecimalNumber*)PPrice  paymentSecondaryPrice:(NSDecimalNumber*)SPrice primaryReciverEmail:(NSString *)reciverPEmail SecondaryReciverEmail:(NSString*)reciverSEmail itemDescription:(NSString*)Description itemName:(NSString*)iName
{
        //paymentSuccessWithKey:andStatus: is a required method. in it, you should record that the payment
    //was successful and perform any desired bookkeeping. you should not do any user interface updates.
    //payKey is a string which uniquely identifies the transaction.
    //paymentStatus is an enum value which can be STATUS_COMPLETED, STATUS_CREATED, or STATUS_OTHER
}
 */

    - (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus {
        NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
        NSLog(@"severity: %@", severity);
        NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
        NSLog(@"category: %@", category);
        NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
        NSLog(@"errorId: %@", errorId);
        NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
        NSLog(@"message: %@", message);
        
       // pReturnId=payKey;
        status = PAYMENTSTATUS_SUCCESS;
        if (objPaypal != nil) {
            NSLog(@"calling block with key and key is--->:%@",payKey);
            objPaypal(payKey);
        }
        
    }
    
    //paymentFailedWithCorrelationID is a required method. in it, you should
    //record that the payment failed and perform any desired bookkeeping. you should not do any user interface updates.
    //correlationID is a string which uniquely identifies the failed transaction, should you need to contact PayPal.
    //errorCode is generally (but not always) a numerical code associated with the error.
    //errorMessage is a human-readable string describing the error that occurred.
    - (void)paymentFailedWithCorrelationID:(NSString *)correlationID {
        
        NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
        NSLog(@"severity: %@", severity);
        NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
        NSLog(@"category: %@", category);
        NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
        NSLog(@"errorId: %@", errorId);
        NSString *message = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
        NSLog(@"message: %@", message);
        
        status = PAYMENTSTATUS_FAILED;
    }
    
    //paymentCanceled is a required method. in it, you should record that the payment was canceled by
    //the user and perform any desired bookkeeping. you should not do any user interface updates.
    - (void)paymentCanceled {
        status = PAYMENTSTATUS_CANCELED;
    }
    
    //paymentLibraryExit is a required method. this is called when the library is finished with the display
    //and is returning control back to your app. you should now do any user interface updates such as
    //displaying a success/failure/canceled message.
    - (void)paymentLibraryExit {
        UIAlertView *alert = nil;
        switch (status) {
            case PAYMENTSTATUS_SUCCESS:
//                [self.navigationController pushViewController:[[SuccessViewController alloc] init] animated:TRUE];
                break;
            case PAYMENTSTATUS_FAILED:
                alert = [[UIAlertView alloc] initWithTitle:@"Order failed"
                                                   message:@"Your order failed. tap Buy Now to try again."
                                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                break;
            case PAYMENTSTATUS_CANCELED:
                alert = [[UIAlertView alloc] initWithTitle:@"Order cancelled"
                                                   message:@"You cancelled your order. tap Buy Now to try again."
                                                  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                break;
        }
        [alert show];
        //[alert release];
    }
    
    //adjustAmountsForAddress:andCurrency:andAmount:andTax:andShipping:andErrorCode: is optional. you only need to
    //provide this method if you wish to recompute tax or shipping when the user changes his/her shipping address.
    //for this method to be called, you must enable shipping and dynamic amount calculation on the PayPal object.
    //the library will try to use the advanced version first, but will use this one if that one is not implemented.
    - (PayPalAmounts *)adjustAmountsForAddress:(PayPalAddress const *)inAddress andCurrency:(NSString const *)inCurrency andAmount:(NSDecimalNumber const *)inAmount
andTax:(NSDecimalNumber const *)inTax andShipping:(NSDecimalNumber const *)inShipping andErrorCode:(PayPalAmountErrorCode *)outErrorCode {
    //do any logic here that would adjust the amount based on the shipping address
    PayPalAmounts *newAmounts = [[PayPalAmounts alloc] init];
    newAmounts.currency = @"GBP";
    newAmounts.payment_amount = (NSDecimalNumber *)inAmount;
    
    //change tax based on the address
    if ([inAddress.state isEqualToString:@"CA"]) {
        newAmounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[inAmount floatValue] * .1]];
    } else {
        newAmounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[inAmount floatValue] * .08]];
    }
    newAmounts.shipping = (NSDecimalNumber *)inShipping;
    
    //if you need to notify the library of an error condition, do one of the following
    //*outErrorCode = AMOUNT_ERROR_SERVER;
    //*outErrorCode = AMOUNT_CANCEL_TXN;
    //*outErrorCode = AMOUNT_ERROR_OTHER;
    
    return newAmounts;
}
    
    //adjustAmountsAdvancedForAddress:andCurrency:andReceiverAmounts:andErrorCode: is optional. you only need to
    //provide this method if you wish to recompute tax or shipping when the user changes his/her shipping address.
    //for this method to be called, you must enable shipping and dynamic amount calculation on the PayPal object.
    //the library will try to use this version first, but will use the simple one if this one is not implemented.
    - (NSMutableArray *)adjustAmountsAdvancedForAddress:(PayPalAddress const *)inAddress andCurrency:(NSString const *)inCurrency
andReceiverAmounts:(NSMutableArray *)receiverAmounts andErrorCode:(PayPalAmountErrorCode *)outErrorCode {
    NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:[receiverAmounts count]];
    for (PayPalReceiverAmounts *amounts in receiverAmounts) {
        //leave the shipping the same, change the tax based on the state
        if ([inAddress.state isEqualToString:@"CA"]) {
            amounts.amounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[amounts.amounts.payment_amount floatValue] * .1]];
        } else {
            amounts.amounts.tax = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.2f",[amounts.amounts.payment_amount floatValue] * .08]];
        }
        [returnArray addObject:amounts];
    }
    
    //if you need to notify the library of an error condition, do one of the following
    //*outErrorCode = AMOUNT_ERROR_SERVER;
    //*outErrorCode = AMOUNT_CANCEL_TXN;
    //*outErrorCode = AMOUNT_ERROR_OTHER;
    
    return returnArray;
}
@end
