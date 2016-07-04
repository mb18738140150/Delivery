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
    var inComAcountLB:UILabel!
    var incomeAcountLabel:UILabel!
    var commissionRatioLB:UILabel!
    var commissionRatioLabel:UILabel!
    
    
    func RGBA (r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat)->UIColor { return UIColor (red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }
    
    // 重写init方法
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addAllSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubViews() {
        storeNameLB = UILabel(frame: CGRectMake(15, 25, 240, 15))
        storeNameLB.font = UIFont.systemFontOfSize(15)
        storeNameLB.textColor = UIColor.init(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.addSubview(storeNameLB)
        
        orderIDLB = UILabel(frame: CGRectMake(15, CGRectGetMaxY(storeNameLB!.frame) + 20, 65, 14))
        orderIDLB.text = "订单号:"
        orderIDLB.font = UIFont.systemFontOfSize(14)
        orderIDLB.textColor = UIColor.init(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.addSubview(orderIDLB)
        
        orderIDLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(orderIDLB!.frame) + 20, CGRectGetMinY(orderIDLB!.frame), 200, 14))
        orderIDLabel.text = "z151224111860731"
        orderIDLabel.font = UIFont.systemFontOfSize(14)
        orderIDLabel.textColor = RGBA(50, g: 50, b: 50, a: 1)
        self.addSubview(orderIDLabel)
        
        
        transationAcountLB = UILabel(frame: CGRectMake(15, CGRectGetMaxY(orderIDLB!.frame) + 15, 65, 14))
        transationAcountLB.text = "交易金额:"
        transationAcountLB.font = UIFont.systemFontOfSize(14)
        transationAcountLB.textColor = UIColor.init(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.addSubview(transationAcountLB)
        
        transationAcountLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(transationAcountLB!.frame) + 20, CGRectGetMinY(transationAcountLB!.frame), 200, 14))
        transationAcountLabel.text = "20.00"
        transationAcountLabel.font = UIFont.systemFontOfSize(14)
        transationAcountLabel.textColor = UIColor.init(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.addSubview(transationAcountLabel)
        
        
        inComAcountLB = UILabel(frame: CGRectMake(15, CGRectGetMaxY(transationAcountLB!.frame) + 15, 65, 14))
        inComAcountLB.text = "到账金额:"
        inComAcountLB.font = UIFont.systemFontOfSize(14)
        inComAcountLB.textColor = UIColor.init(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.addSubview(inComAcountLB)
        
        incomeAcountLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(inComAcountLB!.frame) + 20, CGRectGetMinY(inComAcountLB!.frame), 200, 14))
        incomeAcountLabel.text = "￥20.00"
        incomeAcountLabel.font = UIFont.systemFontOfSize(14)
        incomeAcountLabel.textColor = UIColor.init(colorLiteralRed: 253.0 / 255, green: 91.0 / 255, blue: 53.0 / 255, alpha: 1)
        self.addSubview(incomeAcountLabel)
        
        commissionRatioLB = UILabel(frame: CGRectMake(15, CGRectGetMaxY(inComAcountLB!.frame) + 15, 65, 14))
        commissionRatioLB.text = "提成比例:"
        commissionRatioLB.font = UIFont.systemFontOfSize(14)
        commissionRatioLB.textColor = UIColor.init(colorLiteralRed: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        self.addSubview(commissionRatioLB)
        
        commissionRatioLabel = UILabel(frame: CGRectMake(CGRectGetMaxX(commissionRatioLB!.frame) + 20, CGRectGetMinY(commissionRatioLB!.frame), 200, 14))
        commissionRatioLabel.text = "20%"
        commissionRatioLabel.font = UIFont.systemFontOfSize(14)
        commissionRatioLabel.textColor = UIColor.init(colorLiteralRed: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.addSubview(commissionRatioLabel)
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
