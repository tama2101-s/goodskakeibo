//
//  GoodsItem.swift
//  goodskakeibo
//
//  Created by 田丸翔大 on 2023/09/21.
//

import Foundation
import RealmSwift

class GoodsItem: Object {
    @Persisted var id = UUID()
    @Persisted var goodsName: String = ""
    @Persisted var Price_: Int = 0
    @Persisted var timeDate: String = ""
    @Persisted var years: Int
    @Persisted var month: Int
    @Persisted var buyURL: String = ""
    @Persisted var photofileName: String? = nil
    @Persisted var is_bought: Bool
    @Persisted var is_kurikoshi: Bool = false
    
    override static func primaryKey() -> String? {
                return "id"
        }
}
