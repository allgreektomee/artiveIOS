//
//  RootView.swift
//  artive
//
//  Created by Park Jae Young on 2/9/26.
//

import SwiftUI

struct RootView: View {
    @State private var isShowingLaunchView = true
    
    init() {
        // APIService에서 401 에러 발생 시 보내는 'LogoutRequired' 알림을 수신합니다.
        // AuthManager의 상태 변경으로 대부분의 UI가 업데이트되지만,
        // 강제 로그아웃 시 추가적인 화면 전환(예: 뷰 스택 초기화)이 필요할 때 유용합니다.
        NotificationCenter.default.addObserver(forName: NSNotification.Name("LogoutRequired"), object: nil, queue: .main) { _ in
            print("RootView: 강제 로그아웃 알림 수신")
        }
    }

    var body: some View {
        if isShowingLaunchView {
            LaunchView(isShowingLaunchView: $isShowingLaunchView)
        } else {
            ArtworkView()
        }
    }
}