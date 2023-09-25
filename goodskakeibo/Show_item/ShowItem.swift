//
//  ShowItem.swift
//  goodskakeibo
//
//  Created by 田丸翔大 on 2023/09/19.
//

import UIKit

class ShowItem: UIViewController {
    @IBOutlet var background_circle1: UILabel!
    @IBOutlet var background_circle2: UILabel!
    
    @IBOutlet var GoodsName: UILabel!
    @IBOutlet var deadLine: UILabel!
    @IBOutlet var price_: UILabel!
    
    var item:GoodsItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        background_circle1.layer.cornerRadius = 100
        background_circle1.clipsToBounds = true
        background_circle2.layer.cornerRadius = 100
        background_circle2.clipsToBounds = true
        
        
        GoodsName.text = item?.goodsName
        var time_date = DateUtils.dateFromString(string: item!.timeDate, format: "yyyy/MM/dd HH:mm:ss")
        var date_data = DateUtils.stringFromDate(date: time_date, format: "yyyy年MM月dd日 HH:mm")
        deadLine.text = date_data
        price_.text = "\(commaSeparate.ThreeDigits(item!.Price_))円"
        
        // Do any additional setup after loading the view.
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
