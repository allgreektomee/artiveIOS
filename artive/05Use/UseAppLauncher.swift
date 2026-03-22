//
//  UseAppLauncher.swift
//  artive
//
//  Created by Park Jae Young on 3/20/26.
//

import Foundation
import Combine

class UseAppLauncher: BindUse {
 

    func appInfo() {
        
        Just(true)
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                DLog("✅ 2초 경과: 화면 전환 실행")
                self?.destination = .main
            }
            .store(in: &cancellables) // BindUse에 선언된 cancellables에 저장
        
//        메모리 안전: [weak self]를 사용해 2초 사이에 혹시라도 이 객체가 메모리에서 해제될 경우 발생할 수 있는 크래시를 방지했습니다.
//
//        cancellables 활용: BindUse 부모 클래스에 아마 var cancellables = Set<AnyCancellable>()가 있을 겁니다. 거기에 .store 해줘야 2초 뒤의 동작이 취소되지 않고 정상 실행됩니다.

    }
    
}
