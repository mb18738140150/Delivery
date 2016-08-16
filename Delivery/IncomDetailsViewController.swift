//
//  IncomDetailsViewController.swift
//  Delivery
//
//  Created by 仙林 on 16/6/29.
//  Copyright © 2016年 仙林. All rights reserved.
//

import UIKit

class IncomDetailsViewController: UITableViewController , HTTPPostDelegate{

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
        
        let backItem = UIBarButtonItem(title: "", style: .Plain , target: self, action: #selector(IncomDetailsViewController.backAction))
        var image = UIImage(named: "back_black.png")
        backItem.image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.navigationItem.leftBarButtonItem = backItem
        
        self.tableView.registerClass(IncomDetailsTableViewCell.self, forCellReuseIdentifier: "cell")
        self.setupRefresh()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.header.beginRefreshing()
    }
    
    func backAction()
    {
        self.navigationController?.popViewControllerAnimated(true)
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
    func downLoadDate(commend:NSInteger, page:NSInteger, count:NSInteger) {
        var dic:NSDictionary = NSDictionary()
        let userid:NSNumber = UserInfo.shareUserInfo().userId
        dic = ["Command":commend, "UserId":userid, "CurPage":page, "CurCount":count]
        
        self.playPostWithDictionary(dic)
    }
    
    func playPostWithDictionary(dic:NSDictionary)
    {
        let jsontr:String = dic.JSONString()
        print(jsontr)
        let str:String = jsontr.stringByAppendingString("131139")
        let md5Str:String = str.md5()
        let urlString:String = POST_URL_swift.stringByAppendingString(md5Str)
        HTTPPost.shareHTTPPost().delegate = self
        HTTPPost.shareHTTPPost().post(urlString, HTTPBody: jsontr.dataUsingEncoding(NSUTF8StringEncoding))
    }
    
    func refresh(data: AnyObject!) {
        let dic = data as! NSDictionary
        print(dic.description)
        
        if dic["Result"]?.intValue == 1 {
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
                alert.addButtonWithTitle("确定")
                alert.show()
            }else
            {
                
                let arr = dic["AmountList"] as! NSArray
                for  useDic in arr {
                    let model = INcomDetailesModel(dic:useDic as! NSDictionary)
                    self.dataSource.addObject(model)
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
            alert.addButtonWithTitle("确定")
            alert.show()
            
        }
        
        
    }
    
    func failWithError(error: NSError!) {
        print("加载失败")
    }
    
    // tableViewdelegate
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! IncomDetailsTableViewCell
        
        let model = dataSource[indexPath.row] as! INcomDetailesModel
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
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
