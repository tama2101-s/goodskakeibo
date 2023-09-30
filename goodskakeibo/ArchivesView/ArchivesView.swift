//
//  ArchivesView.swift
//  goodskakeibo
//
//  Created by 田丸翔大 on 2023/09/26.
//

import UIKit
import RealmSwift

class ArchivesView: UIViewController {
    
    var monthNow:Int!
    var yearNow: Int!
    var checkmonth: Int!
    var checkyear: Int!
    
    @IBOutlet var archivesbackLabel: UILabel!
    @IBOutlet var backmonthButton: UIButton!
    @IBOutlet var nextmonthButton: UIButton!
    @IBOutlet var nowMonthLabel: UILabel!
    @IBOutlet var nowYearLabel: UILabel!
    @IBOutlet var nowMonthBought: UILabel!
    @IBOutlet var segment_data: UISegmentedControl!
    
    @IBOutlet var sum_price_label: UILabel!
    
    @IBOutlet var UITableview_archives: UITableView!
    
    var items_bought: [GoodsItem] = []
    var show_data: GoodsItem?
    var sum_price: Int = 0
    var allGoods_sum: Int = 0
    let realm = try! Realm()
    
    
    
    //確定情報
    override func viewDidLoad() {
        super.viewDidLoad()
        
        archivesbackLabel.layer.cornerRadius = 15
        archivesbackLabel.clipsToBounds = true
        monthNow = Int(DateUtils.setCalender(format_: "M").string(from: Date()))!
        yearNow = Int(DateUtils.setCalender(format_: "yyyy").string(from: Date()))!
        checkmonth  = monthNow
        checkyear = yearNow
        
        
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segment_data.selectedSegmentIndex = 0
        allGoods_sum = 0
        
        chengePrevMonth()
        
        items_bought = readItems(is_bought: true, years: checkyear,month: checkmonth)
        UITableview_archives.dataSource = self
        UITableview_archives.delegate = self
        UITableview_archives.register(UINib(nibName: "goodsItemCell", bundle: nil), forCellReuseIdentifier: "ItemCell")
        let Allgoods:[GoodsItem] = Array(realm.objects(GoodsItem.self).filter("is_bought == %@",true))
        for item in Allgoods{
            allGoods_sum += item.Price_
        }
//        UITableview_bought.reloadData()
        
    }
    
    func readItems(is_bought:Bool, years:Int, month:Int) -> [GoodsItem]{
        sum_price = 0
        let goods:[GoodsItem] = Array(realm.objects(GoodsItem.self).filter("is_bought == %@ && years == %@ && month == %@",is_bought,years,month))
        
        for item in goods{
            sum_price += item.Price_
        }
        
        set_price(data: sum_price)
        
        return goods
    }
    
    
    func set_price(data: Int){
        sum_price_label.text = String(data) + "円"
    }
    
    @IBAction func changeMonthBack(){
        segment_data.selectedSegmentIndex = 0
        if checkmonth - 1 == 0{
            checkyear -= 1
            checkmonth = 12
        }else{
            checkmonth -= 1
        }
        
        chengePrevMonth()
        
        items_bought = readItems(is_bought: true, years: checkyear,month: checkmonth)
        UITableview_archives.reloadData()
    }
    
    @IBAction func changeNextMonth(){
        segment_data.selectedSegmentIndex = 0
        if checkmonth + 1 == 13{
            checkmonth = 1
            checkyear += 1
        }else{
            checkmonth += 1
        }
        
        chengePrevMonth()
        items_bought = readItems(is_bought: true, years: checkyear,month: checkmonth)
        UITableview_archives.reloadData()
    }
    
    func chengePrevMonth(){
        nowYearLabel.text = String(checkyear) + "年"
        nowMonthLabel.text = String(checkmonth) + "月"
        nowMonthBought.text = String(checkmonth) + "月の購入済みリスト"
        var checkmonth_back:Int = checkmonth
        var checkmonth_next:Int = checkmonth
        
        if checkmonth - 1 == 0{
            checkmonth_back = 12
        }else{
            checkmonth_back -= 1
        }
        if checkmonth + 1 == 13{
            checkmonth_next = 1
        }else{
            checkmonth_next += 1
        }
        
        if checkyear == yearNow && checkmonth == monthNow{
            nextmonthButton.setTitle("", for:.normal)
            backmonthButton.setTitle("＜" + String(checkmonth_back)+"月", for: .normal)
            nextmonthButton.isEnabled = false
        }else{
            nextmonthButton.setTitle(String(checkmonth_next) + "月＞", for: .normal)
            backmonthButton.setTitle("＜" + String(checkmonth_back)+"月", for: .normal)
            nextmonthButton.isEnabled = true
        }
    }
    
    @IBAction func select_segment(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            print("1")
            set_price(data: sum_price)
        case 1:
            print("2")
            set_price(data: allGoods_sum)
        default:
            print("存在しない番号")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowGoodsItem"{
            let showItemViewController = segue.destination as! ShowItem
            showItemViewController.item = show_data
            showItemViewController.mode = "bought"
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ArchivesView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items_bought.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! goodsItemCell
        print(items_bought)
        let item: GoodsItem = items_bought[indexPath.section]
//            sum_price! += item.Price_
        
        cell.setCell(goodsName_: item.goodsName, is_bought: item.is_bought, Datetime: item.timeDate, Price: item.Price_)
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.backgroundColor = .white
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 2
        cell.layer.shadowOffset = CGSize(width: 0, height: 1)
        cell.backgroundColor = UIColor(hexString: "#FFFEC4")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        show_data = self.items_bought[indexPath.section]
        
        self.performSegue(withIdentifier: "ShowGoodsItem", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
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
    
    
}
