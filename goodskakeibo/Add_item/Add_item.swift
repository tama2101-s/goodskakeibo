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
    var yosan_data:Int!
    
    @IBOutlet var goodsName: UITextField!
    @IBOutlet var deadline: UIDatePicker!
    @IBOutlet var price: UITextField!
    @IBOutlet var URL_text: UITextField!
    @IBOutlet var pick_Image: UIButton!
    @IBOutlet var pickImage: UIImageView!
    @IBOutlet var is_bought: UISwitch!
    
    var item_edit: GoodsItem?
    var segue_name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        add_setting()
        price.keyboardType = UIKeyboardType.numberPad
        
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        
        if segue_name == "E"{
            yosan_data += item_edit!.Price_
            goodsName.text = item_edit!.goodsName
            price.text = String(item_edit!.Price_)
            deadline.date = DateUtils.dateFromString(string: item_edit!.timeDate, format: "yyyy/MM/dd HH:mm:ss")
            is_bought.isOn = item_edit!.is_bought
        }
        
        
        
        // Do any additional setup after loading the view.
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
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
        if goodsitem.goodsName == "" || goodsitem.Price_ == 0{
            print("失敗")
            dismiss(animated: true)
        }else{
            if segue_name == "E"{
                goodsitem.id = item_edit!.id
                
                try! realm.write{
                    realm.add(goodsitem,update: .modified)
                }
                dismiss(animated: true)
            }else{
                alert_data(goodsitem: goodsitem)
            }
            
            
        }
        
        
        
        
        
    }
    
    func createGoodsItem(item: GoodsItem){
        try! realm.write{
            realm.add(item)
        }
    }
    
    @IBAction  func selectImage() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerView = UIImagePickerController()
            pickerView.sourceType = .photoLibrary
            pickerView.delegate = self
            self.present(pickerView, animated: true)
        }
    }
    
    func alert_data(goodsitem: GoodsItem){
        //9月がマイナス行ったときの処理
        if yosan_data - goodsitem.Price_ < 0{
            //アラート処理
            let alert = UIAlertController(title: "今月予算オーバー", message: "今月に購入し、来月の予算を減らすか\n来月に購入するか選んでください", preferredStyle: .alert)
            
            let delete = UIAlertAction(title: "今月購入", style: .default, handler: { (action) -> Void in
                goodsitem.years = Int(DateUtils.setCalender(format_: "yyyy").string(from: Date()))!
                goodsitem.month = Int(DateUtils.setCalender(format_: "M").string(from: Date()))!
                goodsitem.is_kurikoshi = true
                self.createGoodsItem(item: goodsitem)
                self.dismiss(animated: true)
                
            })
            
            let cancel = UIAlertAction(title: "来月購入", style: .cancel, handler: { (action) -> Void in
                let years:Int = Int(DateUtils.setCalender(format_: "yyyy").string(from: Date()))!
                let month:Int = Int(DateUtils.setCalender(format_: "M").string(from: Date()))!
                var items_years_plus:Int = years
                var items_month_plus:Int = month
                
                if month+1 == 13{
                    items_month_plus  = 1
                    items_years_plus += 1
                }else{
                    items_month_plus += 1
                }
                goodsitem.years = items_years_plus
                goodsitem.month = items_month_plus
                self.createGoodsItem(item: goodsitem)
                
                self.dismiss(animated: true)
            })
            
            alert.addAction(delete)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
        }else{
            goodsitem.years = Int(DateUtils.setCalender(format_: "yyyy").string(from: Date()))!
            goodsitem.month = Int(DateUtils.setCalender(format_: "M").string(from: Date()))!
            createGoodsItem(item: goodsitem)
            dismiss(animated: true)
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

extension Add_item: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage // 選択された画像を取得
        pickImage.image = image      // imageViewプロパティに格納
        //        self.dismiss(animated: true) // 選択画面を閉じる
    }
}
