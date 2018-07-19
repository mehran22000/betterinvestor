//
//  IAPHandler.swift
//
//  Created by Dejan Atanasov on 13/07/2017.
//  Copyright © 2017 Dejan Atanasov. All rights reserved.
//
import UIKit
import StoreKit

enum IAPHandlerAlertType{
    case disabled
    case restored
    case purchased
    
    func message() -> String{
        switch self {
        case .disabled: return "Purchases are disabled in your device!"
        case .restored: return "You've successfully restored your purchase!"
        case .purchased: return "You've successfully bought this purchase!"
        }
    }
}


class IAPHandler: NSObject {
    static let shared = IAPHandler()
    
    let CONSUMABLE_PURCHASE_PRODUCT_ID_1 = "20k_inapp_cash_credit"
    let CONSUMABLE_PURCHASE_PRODUCT_ID_2 = "50k_inapp_cash_credit"
    //var products = [Product]()
    
    // let NON_CONSUMABLE_PURCHASE_PRODUCT_ID = "non.consumable"
    
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    var iapProducts = [SKProduct]()
    
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    var availableProductsCompletion: (() -> Void)?
    var purchaseCompletion: (() -> Void)?
    var purchaseFailure: (() -> Void)?
    
    var tableView: UITableView?
    
    // MARK: - MAKE PURCHASE OF A PRODUCT
    func canMakePurchases() -> Bool {  return SKPaymentQueue.canMakePayments()  }
    
    func purchaseMyProduct(index: Int, success:@escaping () -> Void, failure:@escaping () -> Void  ) {
        self.purchaseCompletion = success;
        self.purchaseFailure = failure;
        
        if iapProducts.count == 0 { return }
        
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("PRODUCT TO PURCHASE: \(product.productIdentifier)")
            productID = product.productIdentifier
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - RESTORE PURCHASE
    func restorePurchase(){
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    
    // MARK: - FETCH AVAILABLE IAP PRODUCTS
    func fetchAvailableProducts(completion:@escaping () -> Void){
        let productIdentifiers = NSSet(objects: CONSUMABLE_PURCHASE_PRODUCT_ID_1,CONSUMABLE_PURCHASE_PRODUCT_ID_2)
        self.availableProductsCompletion = completion;
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
}

extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver{
    // MARK: - REQUEST IAP PRODUCTS
    func productsRequest (_ request:SKProductsRequest, didReceive response:SKProductsResponse) {
        if (response.products.count > 0) {
            iapProducts = response.products
            for product in iapProducts{
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                let price1Str = numberFormatter.string(from: product.price)
                print(product.localizedDescription + "\nfor just \(price1Str!)")
                self.availableProductsCompletion!();
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored)
    }
    
    // MARK:- IAP PAYMENT QUEUE
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.purchased)
                    
                    if (trans.payment.productIdentifier == Constants.product_id_20k){
                        
                        self.rewardCredit(source: Constants.product_id_20k as NSString)
                    }
                    else if (trans.payment.productIdentifier == Constants.product_id_50k){
                        
                        self.rewardCredit(source: Constants.product_id_50k as NSString)
                    }
                    break
                    
                case .failed:
                    print("failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    self.purchaseCompletion!();
                    break
                    
                case .restored:
                    print("restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    self.purchaseCompletion!();
                    break
                    
                default: break
                }}}
    }
    
    func rewardCredit (source: NSString) {
        let credit = Credit();
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        credit.requestOrder(user: appDelegate.user!, source: source)
        
        credit.requestCredit(successCompletion: {
            self.purchaseCompletion!();
        }) {
            self.purchaseFailure!();
        }
    }
}
