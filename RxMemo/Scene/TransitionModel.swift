//
//  TransitionModel.swift
//  RxMemo
//
//  Created by 김동환 on 2021/07/30.
//

import Foundation

enum TrainsitionStyle {
    case root
    case push
    case modal
}

enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
