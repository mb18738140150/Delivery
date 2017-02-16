//
//  IncomDetailsViewController.swift
//  Delivery
//
//  Created by 仙林 on 16/6/29.
//  Copyright © 2016年 仙林. All rights reserved.
//

import UIKit

class IncomDetailsViewController: UITableViewController , HTTPPostDelegate{
    public func refresh(_ data: Any!) {
        let dic = data as! NSDictionary
        print(dic.description)
        
        if (dic["Result"] as! NSNumber).int32Value == 1 {
            self.allCount = dic["AllCount"] as! NSInteger
            if self.pageIndex == 1 {
                self.dataSource .removeAllObjects()
                self.tableView.header.endRefreshing()
            }else
            {
                self.tableView.footer.endRefreshing()
            }
            if self.allCount == 0{
                let alert = UIAlertView()
                alert.title = "提示"
                alert.message = "暂无数据"
                alert.addButton(withTitle: "确定")
                alert.show()
            }else
            {
                let arr = dic["AmountList"] as! NSArray
                for  useDic in arr {
                    let model = INcomDetailesModel(dic:useDic as! NSDictionary)
                    self.dataSource.add(model)
                }
                self.tableView.reloadData()
            }
        }else
        {
            if self.pageIndex == 1 {
                self.tableView.header.endRefreshing()
            }else
            {
                self.tableView.footer.endRefreshing()
            }
            
            let message = dic["ErrorMsg"] as! String
            let alert = UIAlertView()
            alert.title = "提示"
            alert.message = message
            alert.addButton(withTitle: "确定")
            alert.show()
            
        }
        
        
    }
    

    var pageIndex = 1
    var allCount = 0
    lazy var dataSource:NSMutableArray = NSMutableArray()
    // 测试
//    let POST_URL_swift = "http://test.p3o1r7t.vlifee.com/delivery_getdata.ashx?md5="
    // 正式
    let  POST_URL_swift = "http://p3o1r7t.vlifee.com/delivery_getdata.ashx?md5="
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "明细"
        
        let backItem = UIBarButtonItem(title: "", style: .plain , target: self, action: #selector(IncomDetailsViewController.backAction))
        let image = UIImage(named: "back_black.png")
        backItem.image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.tableView.register(IncomDetailsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.setupRefresh()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.header.beginRefreshing()
    }
    
    func backAction()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupRefresh() {
        self.tableView.header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(IncomDetailsViewController.shuaxin))
        self.tableView.footer = MJRefreshBackFooter(refreshingTarget: self, refreshingAction: #selector(IncomDetailsViewController.getMore))
    }
    
    func shuaxin()
    {
        pageIndex = 1
        self.downLoadDate(15, page: pageIndex, count: 10)
    }
    
    func getMore()
    {
        if dataSource.count<allCount {
            pageIndex += 1
            self.downLoadDate(15, page: pageIndex, count: 10)
        }else
        {
            self.tableView.footer.endRefreshingWithNoMoreData()
        }
    }
    
    // 数据请求
    func downLoadDate(_ commend:NSInteger, page:NSInteger, count:NSInteger) {
        var dic:NSDictionary = NSDictionary()
        let userid:NSNumber = UserInfo.share().userId
        dic = ["Command":commend, "UserId":userid, "CurPage":page, "CurCount":count]
        
        self.playPostWithDictionary(dic)
    }
    
    func playPostWithDictionary(_ dic:NSDictionary)
    {
        let jsontr:String = dic.jsonString()
        print(jsontr)
        let str:String = jsontr + "131139"
        let md5Str:String = str.md5()
        let urlString:String = POST_URL_swift + md5Str
        HTTPPost.share().delegate = self
        HTTPPost.share().post(urlString, httpBody: jsontr.data(using: String.Encoding.utf8))
    }
    
//   public func refresh(_ data: AnyObject!) {
//        let dic = data as! NSDictionary
//        print(dic.description)
//        
//        if (dic["Result"] as AnyObject).int32Value == 1 {
//            self.allCount = dic["AllCount"] as! NSInteger
//            if self.pageIndex == 1 {
//                self.dataSource .removeAllObjects()
//                self.tableView.header.endRefreshing()
//            }else
//            {
//                self.tableView.footer.endRefreshing()
//            }
//            if self.allCount == 0{
//                let alert = UIAlertView()
//                alert.title = "提示"
//                alert.message = "暂无数据"
//                alert.addButton(withTitle: "确定")
//                alert.show()
//            }else
//            {
//                
//                let arr = dic["AmountList"] as! NSArray
//                for  useDic in arr {
//                    let model = INcomDetailesModel(dic:useDic as! NSDictionary)
//                    self.dataSource.add(model)
//                }
//                self.tableView.reloadData()
//            }
//        }else
//        {
//            if self.pageIndex == 1 {
//                self.tableView.header.endRefreshing()
//            }else
//            {
//                self.tableView.footer.endRefreshing()
//            }
//            
//            let message = dic["ErrorMsg"] as! String
//            let alert = UIAlertView()
//            alert.title = "提示"
//            alert.message = message
//            alert.addButton(withTitle: "确定")
//            alert.show()
//            
//        }
//        
//        
//    }
    
    
   public func failWithError(_ error: NSError!) {
        print("加载失败")
    }
    
    // tableViewdelegate
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IncomDetailsTableViewCell
        
        let model = dataSource[(indexPath as NSIndexPath).row] as! INcomDetailesModel
//        let  dics:NSDictionary!  = ["StoreName":"哈哈哈哈", "OrderId":"z2874783tr98", "TransactionAmount":43, "IncomeAmount":10, "CommissionRatio":15]
//        let model = INcomDetailesModel(dic:dics as NSDictionary)
//        model.storeName = "哈哈哈哈"
//        model.orderId = "z2874783tr98"
//        model.transactionAmount = 43
//        model.commissionRatio = 15
//        model.incomAmont = 10
        cell.storeNameLB?.text = model.storeName
        cell.orderIDLabel?.text = model.orderId
        cell.transationAcountLabel?.text = model.transactionAmount.stringValue
        cell.incomeAcountLabel?.text = "￥ " + model.incomAmont.stringValue
        cell.commissionRatioLabel?.text = model.commissionRatio.stringValue + "%"
        cell.deliveryFeeLabel?.text = model.deliveryFee.stringValue + " 元/单"
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
