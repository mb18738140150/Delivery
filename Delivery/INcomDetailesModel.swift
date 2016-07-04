//
//  INcomDetailesModel.swift
//  Delivery
//
//  Created by 仙林 on 16/6/29.
//  Copyright © 2016年 仙林. All rights reserved.
//

import UIKit

class INcomDetailesModel: NSObject {

    var storeName:String!
    var orderId:String!
    var transactionAmount:NSNumber!
    var incomAmont:NSNumber!
    var commissionRatio:NSNumber!
    
    
    init(dic:NSDictionary) {
        storeName = dic["StoreName"] as!String
        orderId = dic["OrderId"] as! String
        transactionAmount = dic["TransactionAmount"] as! NSNumber
        incomAmont = dic["IncomeAmount"] as! NSNumber
        commissionRatio = dic["CommissionRatio"] as! NSNumber
    }
    
}
