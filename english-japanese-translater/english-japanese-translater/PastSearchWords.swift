//
//  PastSearchWords.swift
//  english-japanese-translater
//
//  Created by 佐藤和希 on 2016/08/14.
//  Copyright © 2016年 kaz. All rights reserved.
//

import Foundation
import RealmSwift

class PastSearchWords: Object {
    dynamic var id = 0
    dynamic var word = ""
    dynamic var date = NSDate()
    
    // idをプライマリキーに設定
    override static func primaryKey() -> String? {
        return "id"
    }
}