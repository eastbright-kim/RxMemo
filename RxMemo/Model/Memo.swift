//
//  Memo.swift
//  RxMemo
//
//  Created by 김동환 on 2021/07/29.
//

import Foundation

struct Memo: Equatable {
    var content: String
    var insertDate: Date
    var identity: String
    
    init(content: String, insertDate: Date = Date()) {
        self.content = content
        self.insertDate = insertDate
        self.identity = "\(insertDate.timeIntervalSinceReferenceDate)"
    }
    
    init(original: Memo, updatedContent: String) {
        self = original
        self.content = updatedContent
        //업데이트 된 내용으로 새로운 인스턴스를 생성할 때 쓰임
    }
    
}
