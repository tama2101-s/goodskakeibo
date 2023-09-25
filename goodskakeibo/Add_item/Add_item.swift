//
//  HomeShow_item.swift
//  goodskakeibo
//
//  Created by 田丸翔大 on 2023/09/18.
//

import UIKit
import RealmSwift

class Add_item: UIViewController {
    
    let realm = try! Realm()
    
    @IBOutlet var goodsName: UITextField!
    @IBOutlet var deadline: UIDatePicker!
    @IBOutlet var price: UITextField!
    @IBOutlet var URL_text: UITextField!
    @IBOutlet var pick_Image: UIButton!
    @IBOutlet var pickImage: UIImageView!
    @IBOutlet var is_bought: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        add_setting()
        price.keyboardType = UIKeyboardType.numberPad
        
        

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func save(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let goodsitem = GoodsItem()
        goodsitem.goodsName = goodsName.text ?? ""
        goodsitem.Price_ = Int(price.text ?? "") ?? 0
        goodsitem.photofileName = Image_save.setImage(image: pickImage.image)
        goodsitem.buyURL = URL_text.text ?? ""
        goodsitem.is_bought = is_bought.isOn
        goodsitem.timeDate = formatter.string(from: deadline.date)
        goodsitem.years = Int(DateUtils.setCalender(format_: "yyyy").string(from: Date()))!
        goodsitem.month = Int(DateUtils.setCalender(format_: "M").string(from: Date()))!
        
        if goodsitem.goodsName == "" || goodsitem.Price_ == 0{
            print("失敗")
            dismiss(animated: true)
        }else{
            createGoodsItem(item: goodsitem)
            dismiss(animated: true)
        }
        
    }
    
    func createGoodsItem(item: GoodsItem){
        try! realm.write{
            realm.add(item)
        }
    }
    
    
    
    @IBAction func back(){
        dismiss(animated: true)
    }
    
    func add_setting(){
        goodsName.layer.cornerRadius = 12
        goodsName.layer.shadowOpacity = 0.3
        // 影のぼかしの大きさ
        goodsName.layer.shadowRadius = 2
        // 影の色
        goodsName.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        goodsName.layer.shadowOffset = CGSize(width: 0,height: 3)
        price.layer.cornerRadius = 12
        
        price.layer.shadowOpacity = 0.3
        // 影のぼかしの大きさ
        price.layer.shadowRadius = 2
        // 影の色
        price.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        price.layer.shadowOffset = CGSize(width: 0,height: 3)
        
        URL_text.layer.cornerRadius = 12
        
        URL_text.layer.shadowOpacity = 0.3
        // 影のぼかしの大きさ
        URL_text.layer.shadowRadius = 2
        // 影の色
        URL_text.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        URL_text.layer.shadowOffset = CGSize(width: 0,height: 3)
        
        pick_Image.layer.cornerRadius = 12
        pick_Image.layer.shadowOpacity = 0.3
        // 影のぼかしの大きさ
        pick_Image.layer.shadowRadius = 2
        // 影の色
        pick_Image.layer.shadowColor = UIColor.black.cgColor
        // 影の方向（width=右方向、height=下方向）
        pick_Image.layer.shadowOffset = CGSize(width: 0,height: 3)
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
