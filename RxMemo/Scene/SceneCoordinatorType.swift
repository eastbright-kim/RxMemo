//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by κΉλν on 2021/07/31.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    @discardableResult
    func transition(to scene: Scene, using style: TrainsitionStyle, animated: Bool) -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable
}
