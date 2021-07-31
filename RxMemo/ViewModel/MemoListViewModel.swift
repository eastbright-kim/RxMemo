//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 김동환 on 2021/07/29.
//

import Foundation
import RxSwift
import RxCocoa

class MemoListViewModel: CommonViewModel {
    
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
    
    //의존성 주입 생성자, 바인딩에 사용되는 속성과 메소드 추가. 화면전환 메모 저장 처리. scene coordinator와 메모 스토리지 활용. 뷰모델을 생성하는 시점에 생성자를 통해서 의존성을 주입해야 함.
    
    
    
}
