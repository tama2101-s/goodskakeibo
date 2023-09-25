//
//  preference.swift
//  goodskakeibo
//
//  Created by 田丸翔大 on 2023/09/19.
//

import UIKit

class preference: UIViewController {
    @IBOutlet var change_button: UIButton!
    @IBOutlet var limit_price_bg: UILabel!
    @IBOutlet var limit_price: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        change_button.layer.cornerRadius = 12
        change_button.clipsToBounds = true
        
        limit_price_bg.layer.cornerRadius = 12
        limit_price_bg.clipsToBounds = true

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let yosan = UserDefaults.standard.integer(forKey: "yosandata")
        self.limit_price.text = "\(commaSeparate.ThreeDigits(yosan))円"
    }
    
    @IBAction func change_price(){
        var textFieldOnAlert = UITextField()
        textFieldOnAlert.keyboardType = UIKeyboardType.numberPad
        
        let alert = UIAlertController(title: "予算を入力してください",
                                      message: nil,
                                      preferredStyle: .alert)
        
        alert.addTextField { textField in
            textFieldOnAlert = textField
            textFieldOnAlert.returnKeyType = .done
            
        }
        let doneAction = UIAlertAction(title: "決定", style: .default) { _ in
            
            let to_any : Any = textFieldOnAlert.text as Any
            let to_int = to_any as? Int
            
            print(type(of: to_int))
            
            if type(of: to_int) == Optional<Int>.self {
                
                UserDefaults.standard.set(textFieldOnAlert.text, forKey: "yosandata")
                let yosan = UserDefaults.standard.integer(forKey: "yosandata")
                self.limit_price.text = "\(commaSeparate.ThreeDigits(yosan))円"
            }else{
                let alert2 = UIAlertController(title: "数値で入力してください",
                                                  message: nil,
                                                  preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                    self.dismiss(animated: true, completion: nil)
                    
                }
                alert2.addAction(ok)
                self.present(alert2, animated: true)
                
                
            }
           
            
            
            
        }

        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel)

        alert.addAction(doneAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
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
