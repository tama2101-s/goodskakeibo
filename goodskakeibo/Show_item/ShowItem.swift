//
//  ShowItem.swift
//  goodskakeibo
//
//  Created by 田丸翔大 on 2023/09/19.
//

import UIKit
import RealmSwift

class ShowItem: UIViewController {
    @IBOutlet var background_circle1: UILabel!
    @IBOutlet var background_circle2: UILabel!
    
    @IBOutlet var GoodsName: UILabel!
    @IBOutlet var deadLine: UILabel!
    @IBOutlet var GoodsImage: UIImageView!
    @IBOutlet var price_: UILabel!
    @IBOutlet var buy_button: UIButton!
    
    var item:GoodsItem?
    var mode: String?
    var photoData_string: String? = nil
    let realm = try! Realm()

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
        photoData_string = item!.photofileName
//        print(photoData_string)
        GoodsImage.image = getImage()
        if item!.buyURL == ""{
            buy_button.setTitle("購入済みにする", for: .normal)
        }
        
        if mode == "bought"{
            buy_button.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func tapped_buy(){
        let goodsitem = GoodsItem()
        goodsitem.id = item!.id
        goodsitem.goodsName = item!.goodsName
        goodsitem.Price_ = item!.Price_
        goodsitem.photofileName = item!.photofileName
        goodsitem.buyURL = item!.buyURL
        goodsitem.is_bought = true
        goodsitem.timeDate = item!.timeDate
        goodsitem.month = item!.month
        goodsitem.years = item!.years
        
        try! realm.write{
            realm.add(goodsitem,update: .modified)
        }
        if item!.buyURL == ""{
            dismiss(animated: true)
        }else{
            
            UIApplication.shared.open(URL(string: item!.buyURL)!, options: [:], completionHandler: nil)
            dismiss(animated: true)
        }
    }
    
    func getImage() -> UIImage? {
        // photoFileNameがnilならnilを返却して抜ける
        guard let path = self.photoData_string else { return nil }
        // ドキュメントディレクトリのURLを取得
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // ファイルのURLを取得
        let fileURL = documentsDirectoryURL.appendingPathComponent(path)
        // ファイルからデータを読み込む
        do {
            let imageData = try Data(contentsOf: fileURL)
            
            // データをUIImageに変換して返却する
            return UIImage(data: imageData)
        } catch {
            print(error.localizedDescription)
            print("💀エラー")
            return nil
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
    
    override func viewWillAppear(_ animated: Bool) {
        presentingViewController?.beginAppearanceTransition(false, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentingViewController?.endAppearanceTransition()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.beginAppearanceTransition(true, animated: animated)
        presentingViewController?.endAppearanceTransition()
    }

}
