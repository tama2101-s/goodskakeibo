//
//  goodsItemCell.swift
//  goodskakeibo
//
//  Created by 田丸翔大 on 2023/09/20.
//

import UIKit

class goodsItemCell: UITableViewCell {
    
    @IBOutlet var goodsName: UILabel!
    @IBOutlet var DeadLineOrPrice: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(goodsName_: String, is_bought: Bool, Datetime: String, Price: Int){
        goodsName.text = goodsName_
        let date = DateUtils.dateFromString(string: Datetime, format: "yyyy/MM/dd HH:mm:ss")
        if is_bought == true{
            DeadLineOrPrice.text = "\(commaSeparate.ThreeDigits(Price))円"
        } else {
            if date < Date(){
                DeadLineOrPrice.textColor = UIColor.red
            }else{
                DeadLineOrPrice.textColor = UIColor.black
            }
            let datetoS = DateUtils.stringFromDate(date: date, format: "MM/dd HH:mm")
            DeadLineOrPrice.text = datetoS
        }
    }
    
    
    
}
