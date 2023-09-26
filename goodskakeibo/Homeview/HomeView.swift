//
//  ViewController.swift
//  goodskakeibo
//
//  Created by 田丸翔大 on 2023/09/18.
//

import UIKit
import RealmSwift

class HomeView: UIViewController{
    
    var monthNow : Int = 0
    var yosan: Int = 0
    var defalt_yosan: Int = 0

    
    @IBOutlet var pinkLabel: UILabel!
    @IBOutlet var yosanLabel: UILabel!
    @IBOutlet var monthyosan: UILabel!
    @IBOutlet var nobuyLabel: UILabel!
    @IBOutlet var boughtLabel: UILabel!
    @IBOutlet var segment_data: UISegmentedControl!
    
    @IBOutlet var UITableview_nobuy: UITableView!
    @IBOutlet var UITableview_bought: UITableView!
    
    
    let dt:Date = Date()
    let realm = try! Realm()
    
    var items_nobuy: [GoodsItem] = []
    var items_bought: [GoodsItem] = []
    
    var show_data:GoodsItem?
    var sum_price: Int?
    var items_years:Int = 0
    var items_month:Int = 0
    var edit_item: GoodsItem?
    
    
    
    var tag:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UITableview_nobuy.dataSource = self
        UITableview_nobuy.delegate = self
        UITableview_nobuy.register(UINib(nibName: "goodsItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        
        UITableview_bought.dataSource = self
        UITableview_bought.delegate = self
        UITableview_bought.register(UINib(nibName: "goodsItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        
        // Do any additional setup after loading the view.
        
        
        
    }
    
    func check_table(_ tableView:UITableView) -> Void{
        if (tableView.tag == 0){
            tag = 0
        }else if(tableView.tag == 1){
            tag = 1
        }
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        check_table(tableView)
        if tag == 0 {
            return items_nobuy.count
        }else{
            return items_bought.count
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGoodsItem"{
            let showItemViewController = segue.destination as! ShowItem
            showItemViewController.item = show_data
            
        }else if segue.identifier == "add_Goods"{
            
            //UINavigationControllerへcastする
            let nav = segue.destination as! UINavigationController

            //目的の画面
            let svc = nav.topViewController as! Add_item

            //変数をset
            svc.yosan_data = yosan
        }else if segue.identifier == "EditMode"{
            //UINavigationControllerへcastする
            let nav = segue.destination as! UINavigationController

            //目的の画面
            let svc = nav.topViewController as! Add_item

            //変数をset
            svc.yosan_data = yosan
            svc.segue_name = "E"
            svc.item_edit = edit_item!
            
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.segment_data.selectedSegmentIndex = 0
        items_years = Int(DateUtils.setCalender(format_: "yyyy").string(from: dt))!
        items_month = Int(DateUtils.setCalender(format_: "M").string(from: dt))!
        
        monthNow = Int(DateUtils.setCalender(format_: "M").string(from: dt))!
        
        
        
        segment_data.setTitle("\(monthNow)月", forSegmentAt: 0)
        segment_data.setTitle("\(monthNow+1)月", forSegmentAt: 1)
        
        monthyosan.text =
        "\(monthNow)月の予算"
        pinkLabel.layer.cornerRadius = 15
        pinkLabel.clipsToBounds = true
        nobuyLabel.text = "\(monthNow)月の購入予定リスト"
        boughtLabel.text = "\(monthNow)月の購入済みリスト"
        
        callReadItem(item_years: items_years, item_month: items_month)
        

//        sum_price = 0
        
        
    }
    
    func callReadItem(item_years:Int,item_month:Int){
        if UserDefaults.standard.integer(forKey: "yosandata") == nil {
            yosanLabel.text = "設定から予算を設定してください"
            yosanLabel.font = yosanLabel.font.withSize(20)
            
        } else {
            defalt_yosan = UserDefaults.standard.integer(forKey: "yosandata")
            yosan = defalt_yosan
            items_nobuy = readItems(is_bought:false, years: item_years,month: item_month)
            UITableview_nobuy.reloadData()
            items_bought = readItems(is_bought: true, years: item_years,month: item_month)
            UITableview_bought.reloadData()
            
        }
    }
    
    
//    override func viewDidAppear(_ animated: Bool) {
//
//        minus_yosan()
//
//    }
 
    
    func readItems(is_bought:Bool, years:Int, month:Int) -> [GoodsItem]{
        
        sum_price = 0
        let goods:[GoodsItem] = Array(realm.objects(GoodsItem.self).filter("is_bought == %@ && years == %@ && month == %@",is_bought,years,month))
        
        for item in goods{
            sum_price! += item.Price_
            print(item)
        }
        
        yosan -= sum_price!
        let goods_kurikoshi:[GoodsItem]
        if month - 1  == 0{
            goods_kurikoshi = Array(realm.objects(GoodsItem.self).filter("is_bought == %@ && years == %@ && month == %@ && is_kurikoshi == %@",is_bought, years-1,12,true))
        }else{
            goods_kurikoshi = Array(realm.objects(GoodsItem.self).filter("is_bought == %@ &&years == %@ && month == %@ && is_kurikoshi == %@",is_bought,years,month-1,true))
        }
        for kurikoshi in goods_kurikoshi{
            print(kurikoshi.Price_)
            yosan -= kurikoshi.Price_
        }
        
        yosanLabel.text = commaSeparate.ThreeDigits(yosan) + "円"
        
        return goods
    }
    
    
    @IBAction func segmentControlltaped(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            print("当月分")
            monthNow = Int(DateUtils.setCalender(format_: "M").string(from: dt))!
            monthyosan.text =
            "\(monthNow)月の予算"
            nobuyLabel.text = "\(monthNow)月の購入予定リスト"
            boughtLabel.text = "\(monthNow)月の購入済みリスト"
            
            print(items_month)
            callReadItem(item_years: items_years, item_month: items_month)
            
            
            
            
            
        case 1:
            print("当月分+1")
            monthNow = Int(DateUtils.setCalender(format_: "M").string(from: dt))! + 1
            monthyosan.text =
            "\(monthNow)月の予算"
            nobuyLabel.text = "\(monthNow)月の購入予定リスト"
            boughtLabel.text = "\(monthNow)月の購入済みリスト"
            sum_price = 0
            var items_years_plus:Int = items_years
            var items_month_plus:Int = items_month
            
            if items_month+1 == 13{
                items_month_plus  = 1
                items_years_plus += 1
            }else{
                items_month_plus += 1
            }
            
            callReadItem(item_years: items_years_plus, item_month: items_month_plus)
            
//            minus_yosan()
            
        default:
            print("存在しない番号")
        }
    }
    
    
}

extension HomeView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        check_table(tableView)
        if tag == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! goodsItemCell
            let item: GoodsItem = items_nobuy[indexPath.section]
//            sum_price! += item.Price_
            
            
            cell.setCell(goodsName_: item.goodsName, is_bought: item.is_bought, Datetime: item.timeDate, Price: item.Price_)
            cell.layer.cornerRadius = 12
            cell.layer.masksToBounds = true
            cell.backgroundColor = .white
            cell.layer.shadowOpacity = 0.2
            cell.layer.shadowRadius = 2
            cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! goodsItemCell
            let item: GoodsItem = items_bought[indexPath.section]
//            sum_price! += item.Price_
            
            cell.setCell(goodsName_: item.goodsName, is_bought: item.is_bought, Datetime: item.timeDate, Price: item.Price_)
            cell.layer.cornerRadius = 12
            cell.layer.masksToBounds = true
            cell.backgroundColor = .white
            cell.layer.shadowOpacity = 0.2
            cell.layer.shadowRadius = 2
            cell.layer.shadowOffset = CGSize(width: 0, height: 1)
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNormalMagnitude  // Cell間に設けたい余白の高さを指定
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let marginView = UIView()
        marginView.backgroundColor = .clear  // 背景色を透過させる
        return marginView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 4  // 完全に表示させないようにする
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        check_table(tableView)
        if tag == 0{
            show_data  = self.items_nobuy[indexPath.section]
        } else {
            show_data = self.items_bought[indexPath.section]
        }
        
        self.performSegue(withIdentifier: "ShowGoodsItem", sender: nil)
    }
    
    
    // スワイプした時に表示するアクションの定義
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        self.check_table(tableView)
        if self.tag == 0{
            // 編集処理
            let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, view, completionHandler) in
                // 編集処理を記述
                self.edit_item = self.items_nobuy[indexPath.section]
                self.performSegue(withIdentifier: "EditMode", sender: nil)
                
                // 実行結果に関わらず記述
                completionHandler(true)
            }
            
            swipeLayout().edit_layout(data:editAction)
            
            // 削除処理
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
                //削除処理を記述
                do{
                    
                    try! self.realm.write{
                        
                        
                        if self.tag == 0{
                            self.realm.delete(self.items_nobuy[indexPath.section])
                        } else {
                            self.realm.delete(self.items_bought[indexPath.section])
                        }
                        
                    }
                }catch{
                    
                }
                self.callReadItem(item_years: self.items_years, item_month: self.monthNow)
                
                // 実行結果に関わらず記述
                completionHandler(true)
            }
            
            swipeLayout().delete_layout(data:deleteAction)
            
            // 定義したアクションをセット
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        }else{
            return UISwipeActionsConfiguration()
        }
    }

      
}







