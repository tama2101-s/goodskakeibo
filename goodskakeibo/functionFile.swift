//
//  functionFile.swift
//  goodskakeibo
//
//  Created by 田丸翔大 on 2023/09/20.
//

import Foundation
import UIKit

class DateUtils {
    class func dateFromString(string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }
    
    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
    class func setCalender(format_: String) -> DateFormatter{
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dateFormatter.dateFormat = format_
        return dateFormatter
    }
}

class commaSeparate{
    class func ThreeDigits(_ amount:Int) -> String{
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.groupingSize = 3
        nf.groupingSeparator = ","
        let result = nf.string(from: NSNumber(integerLiteral: amount)) ?? "\(amount)"
        return result
    }
}

class Image_save{
    class func setImage(image: UIImage?) -> String? {
        // 画像がnilだったらnilを返却して処理から抜ける
        guard let image = image else { return nil }
        // ファイル名をUUIDで生成し、拡張子を".jpeg"にする
        let fileName = UUID().uuidString + ".jpeg"
        // ドキュメントディレクトリのURLを取得
        let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        // ファイルのURLを作成
        var fileURL = documentsDirectoryURL.appendingPathComponent(fileName)
        // UIImageをJPEGデータに変換
        let data = image.jpegData(compressionQuality: 1.0)
        // 【追加】URLResourceValuesをインスタンス化
        var values = URLResourceValues()
        // 【追加】iCloudの自動バックアップから除外する
        values.isExcludedFromBackup = true
        // JPEGデータをファイルに書き込み
        do {
            // 【追加】iCloudの自動バックアップから除外する設定の登録
            try fileURL.setResourceValues(values)
            try data!.write(to: fileURL)
            print(fileName)
        } catch {
            print(error.localizedDescription)
        }
        return fileName
    }
}


class swipeLayout{
    func delete_layout(data: UIContextualAction){
        data.image = UIImage(systemName: "trash.fill")
        data.backgroundColor = .red
    }
    
    func edit_layout(data: UIContextualAction){
        data.image = UIImage(systemName: "pencil")
        data.backgroundColor = .blue
    }
    
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        // 不要なスペースや改行があれば除去
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // スキャナーオブジェクトの生成
        let scanner = Scanner(string: hexString)

        // 先頭(0番目)が#であれば無視させる
        if (hexString.hasPrefix("#")) {
            scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        }

        var color:Int64 = 0
        // 文字列内から16進数を探索し、Int64型で color変数に格納
        scanner.scanHexInt64(&color)

        let mask:Int = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }

}

