//
//  ViewController.swift
//  goodskakeibo
//
//  Created by 田丸翔大 on 2023/09/18.
//

import UIKit
import RealmSwift

class HomeView: UIViewController, UITableViewDataSource{
    
    var monthNow : Int = 0
    var yosan: Int = 0
    
    @IBOutlet var pinkLabel: UILabel!
    @IBOutlet var yosanLabel: UILabel!
    @IBOutlet var monthyosan: UILabel!
    @IBOutlet var segment_data: UISegmentedControl!
    
    @IBOutlet var UITableview_nobuy: UITableView!
    @IBOutlet var UITableview_bought: UITableView!
    
    let dt:Date = Date()
    let realm = try! Realm()
    
    var items_nobuy: [GoodsItem] = []
    var items_bought: [GoodsItem] = []
    
    var show_data:GoodsItem?
    var sum_price: Int?
    
    
    
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
        monthNow = Int(DateUtils.setCalender(format_: "M").string(from: dt))!
        
        
        segment_data.setTitle("\(monthNow)月", forSegmentAt: 0)
        segment_data.setTitle("\(monthNow+1)月", forSegmentAt: 1)
        
        monthyosan.text =
        "\(monthNow)月の予算"
        pinkLabel.layer.cornerRadius = 15
        pinkLabel.clipsToBounds = true
        
        
        
    }
    
    func check_table(_ tableView:UITableView) -> Void{
        if (tableView.tag == 0){
            tag = 0
        }else if(tableView.tag == 1){
            tag = 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        check_table(tableView)
        if tag == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! goodsItemCell
            let item: GoodsItem = items_nobuy[indexPath.section]
            print(item)
            print(item.years,item.month)
            sum_price! += item.Price_
            
            
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
            sum_price! += item.Price_
            
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
            
        }
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        sum_price = 0
        items_nobuy = readItems(is_bought:false, years: Int(DateUtils.setCalender(format_: "yyyy").string(from: Date()))!,month: Int(DateUtils.setCalender(format_: "M").string(from: Date()))!)
        UITableview_nobuy.reloadData()
        items_bought = readItems(is_bought: true, years: Int(DateUtils.setCalender(format_: "yyyy").string(from: Date()))!,month: Int(DateUtils.setCalender(format_: "M").string(from: Date()))!)
        UITableview_bought.reloadData()
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.integer(forKey: "yosandata") == nil {
            yosanLabel.text = "設定から予算を設定してください"
            yosanLabel.font = yosanLabel.font.withSize(20)
            
        } else {
            yosan = UserDefaults.standard.integer(forKey: "yosandata")
            yosan -= sum_price!
            yosanLabel.text = commaSeparate.ThreeDigits(yosan) + "円"
            
        }
        
        
    }
    
    
    
    func readItems(is_bought:Bool, years:Int, month:Int) -> [GoodsItem]{
        print(is_bought,years,month)
        return Array(realm.objects(GoodsItem.self).filter("is_bought == %@ && years == %@ && month == %@",is_bought,years,month))
    }
    
    
}

extension HomeView: UITableViewDelegate {
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
            show_data  = self.items_nobuy[indexPath.row]
        } else {
            show_data = self.items_bought[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "ShowGoodsItem", sender: nil)
    }
}




