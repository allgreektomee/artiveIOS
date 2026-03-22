//
//  Inject.swift
//  artive
//
//  Created by Park Jae Young on 2/9/26.
//

import Foundation

@propertyWrapper
struct Inject<T> {
    var wrappedValue: T
    
    init() {
        // DependencyContainer에서 해당 타입(T)의 인스턴스를 찾아와서 넣어줌
        self.wrappedValue = DependencyContainer.shared.resolve(type: T.self)
    }
}

