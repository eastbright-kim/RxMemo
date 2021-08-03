//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by 김동환 on 2021/07/29.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoListViewModel: CommonViewModel {
    
    
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            return self.storage.update(memo: memo, content: input).map{_ in}
            //옵저버블이 방출하는 형식이 void. update메소드가 리턴하는 옵저버블은 편집된 메모를 방출함 -> map으로 해결
        }
    }
    
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            return self.storage.delete(memo: memo).map{_ in}
        }
    }
    
    //의존성 주입 생성자, 바인딩에 사용되는 속성과 메소드 추가. 화면전환 메모 저장 처리. scene coordinator와 메모 스토리지 활용. 뷰모델을 생성하는 시점에 생성자를 통해서 의존성을 주입해야 함.
    
    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            return self.storage.createMemo(content: "")
                .flatMap { memo -> Observable<Void> in
                    let composeViewModel = MemoComposeViewModel(title: "새 메모", sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))
                    
                    let composeScene = Scene.compose(composeViewModel)
                    return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true).asObservable().map{_ in}
                }
        }
    }
    
    lazy var detailAction: Action<Memo, Void> = {
        return Action<Memo, Void> { memo in
            let viewModel = MemoDetailViewModel(memo: memo, title: "메모 보기", sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            
            let scene = Scene.detail(viewModel)
            
            return self.sceneCoordinator.transition(to: scene, using: .push, animated: true).asObservable().map {_ in}
        }
    }()
    
    
    
    
}
