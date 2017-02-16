//
//  IncomDetailsTableViewCell.swift
//  Delivery
//
//  Created by 仙林 on 16/6/29.
//  Copyright © 2016年 仙林. All rights reserved.
//

import UIKit

class IncomDetailsTableViewCell: UITableViewCell {

    var storeNameLB:UILabel!
    var orderIDLB:UILabel!
    var orderIDLabel:UILabel!
    var transationAcountLB:UILabel!
    var transationAcountLabel:UILabel!
    var commissionRatioLB:UILabel!
    var commissionRatioLabel:UILabel!
    var deliveryFeeLB:UILabel!
    var deliveryFeeLabel:UILabel!
    var inComAcountLB:UILabel!
    var incomeAcountLabel:UILabel!
    
    
    func RGBA (_ r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor { return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }
    
    // 重写init方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addAllSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubViews() {
        storeNameLB = UILabel(frame: CGRect(x: 15, y: 25, width: 240, height: 15))
        storeNameLB.font = UIFont.systemFont(ofSize: 15)
        storeNameLB.textColor = UIColor.init(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.addSubview(storeNameLB)
        
        orderIDLB = UILabel(frame: CGRect(x: 15, y: storeNameLB!.frame.maxY + 20, width: 65, height: 14))
        orderIDLB.text = "订单号:"
        orderIDLB.font = UIFont.systemFont(ofSize: 14)
        orderIDLB.textColor = UIColor.init(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.addSubview(orderIDLB)
        
        orderIDLabel = UILabel(frame: CGRect(x: orderIDLB!.frame.maxX + 20, y: orderIDLB!.frame.minY, width: 200, height: 14))
        orderIDLabel.text = "z151224111860731"
        orderIDLabel.font = UIFont.systemFont(ofSize: 14)
        orderIDLabel.textColor = RGBA(50, g: 50, b: 50, a: 1)
        self.addSubview(orderIDLabel)
        
        
        transationAcountLB = UILabel(frame: CGRect(x: 15, y: orderIDLB!.frame.maxY + 15, width: 65, height: 14))
        transationAcountLB.text = "交易金额:"
        transationAcountLB.font = UIFont.systemFont(ofSize: 14)
        transationAcountLB.textColor = UIColor.init(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.addSubview(transationAcountLB)
        
        transationAcountLabel = UILabel(frame: CGRect(x: transationAcountLB!.frame.maxX + 20, y: transationAcountLB!.frame.minY, width: 200, height: 14))
        transationAcountLabel.text = "20.00"
        transationAcountLabel.font = UIFont.systemFont(ofSize: 14)
        transationAcountLabel.textColor = UIColor.init(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.addSubview(transationAcountLabel)
        
        commissionRatioLB = UILabel(frame: CGRect(x: 15, y: transationAcountLB!.frame.maxY + 15, width: 65, height: 14))
        commissionRatioLB.text = "提成比例:"
        commissionRatioLB.font = UIFont.systemFont(ofSize: 14)
        commissionRatioLB.textColor = UIColor.init(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.addSubview(commissionRatioLB)
        
        commissionRatioLabel = UILabel(frame: CGRect(x: commissionRatioLB!.frame.maxX + 20, y: commissionRatioLB!.frame.minY, width: 200, height: 14))
        commissionRatioLabel.text = "20%"
        commissionRatioLabel.font = UIFont.systemFont(ofSize: 14)
        commissionRatioLabel.textColor = UIColor.init(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.addSubview(commissionRatioLabel)
        
        
        deliveryFeeLB = UILabel(frame: CGRect(x: 15, y: commissionRatioLabel!.frame.maxY + 15, width: 65, height: 14))
        deliveryFeeLB.text = "配送费:"
        deliveryFeeLB.font = UIFont.systemFont(ofSize: 14)
        deliveryFeeLB.textColor = UIColor.init(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.addSubview(deliveryFeeLB)
        
        deliveryFeeLabel = UILabel(frame: CGRect(x: deliveryFeeLB!.frame.maxX + 20, y: deliveryFeeLB!.frame.minY, width: 200, height: 14))
        deliveryFeeLabel.text = "20 / 单"
        deliveryFeeLabel.font = UIFont.systemFont(ofSize: 14)
        deliveryFeeLabel.textColor = UIColor.init(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.addSubview(deliveryFeeLabel)
        
        inComAcountLB = UILabel(frame: CGRect(x: 15, y: deliveryFeeLabel!.frame.maxY + 15, width: 65, height: 14))
        inComAcountLB.text = "到账金额:"
        inComAcountLB.font = UIFont.systemFont(ofSize: 14)
        inComAcountLB.textColor = UIColor.init(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.addSubview(inComAcountLB)
        
        incomeAcountLabel = UILabel(frame: CGRect(x: inComAcountLB!.frame.maxX + 20, y: inComAcountLB!.frame.minY, width: 200, height: 14))
        incomeAcountLabel.text = "￥20.00"
        incomeAcountLabel.font = UIFont.systemFont(ofSize: 14)
        incomeAcountLabel.textColor = UIColor.init(colorLiteralRed: 253.0 / 255, green: 91.0 / 255, blue: 53.0 / 255, alpha: 1)
        self.addSubview(incomeAcountLabel)
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
