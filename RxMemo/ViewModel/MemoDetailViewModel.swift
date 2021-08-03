//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by 김동환 on 2021/07/29.
//

import Foundation
import RxSwift
import RxCocoa
import Action


class MemoDetailViewModel: CommonViewModel {
    let bag = DisposeBag()
    let memo: Memo
    
    
    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "Ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    //테이블뷰에 방출할 것 - 문자열 두개. 비헤이비어 서브젝트인 이유 - 메모를 작성한 다음에 편집 화면으로 오면 해당 내용이 반영되어야 함. 이렇게 하기 위해서 새로운 문자열 배열을 방출해야함. 일반 옵저버블로 하면 불가
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        
        self.contents = BehaviorSubject<[String]>(value: [memo.content,
                                                  formatter.string(from: memo.insertDate)])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
//    lazy var closeAction: CocoaAction = {
//        return CocoaAction { _ in
//            return self.sceneCoordinator.close(animated: true).asObservable().map{_ in}
//        }
//    }()
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            //인풋으로 메모를 바꾼다.
//            self.contents.onNext([input, self.formatter.string(from: self.memo.insertDate)])
            self.storage.update(memo: memo, content: input)
                .subscribe(onNext: { memo in
                    self.contents.onNext([memo.content, self.formatter.string(from: memo.insertDate)])
                })
                .disposed(by: self.bag)
            //옵저버블이 방출하는 형식이 void. update메소드가 리턴하는 옵저버블은 편집된 메모를 방출함 -> map으로 해결
            return Observable.empty()
        }
    }
    
    func makeEditAction() -> CocoaAction {
        return CocoaAction {  _ in
            
            let viewModel = MemoComposeViewModel(title: "메모 편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            let scene = Scene.compose(viewModel)
            
            return self.sceneCoordinator.transition(to: scene, using: .modal, animated: true).asObservable().map{_ in}
        }
    }
    
//    func makeShareAction() -> Action<Void, UIActivityViewController> {
//        return Action { _ in
//
//            let vc = UIActivityViewController(activityItems: [self.memo.content], applicationActivities: nil)
//
//            return Observable.just(vc)
//        }
//    }
    
    func makeDeleteAction() -> CocoaAction {
        return Action { _ in
            self.storage.delete(memo: self.memo)
            return self.sceneCoordinator.close(animated: true).asObservable().map{_ in}
        }
    }
    
}
