//
//  AppLauncherView.swift
//  artive
//
//  Created by Park Jae Young on 3/20/26.
//


import SwiftUI

struct AppLauncherView: View {
    
    // 1. 뷰모델(Use 레이어) 연결
    @StateObject var useAppLauncher = UseAppLauncher()
    
    var body: some View {
        // 2. BaseView로 감싸서 로딩/알럿/화면전환 기능을 공짜로 씁니다.
        BaseView(baseUse: useAppLauncher) {
            ZStack {
                Color.white.ignoresSafeArea() // 배경색
                
                VStack(spacing: 20) {
                    // 여기에 작가님 앱의 로고 이미지를 넣으시면 됩니다.
//                    Image(systemName: "paintpalette.fill") // 임시 로고
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 100, height: 100)
//                        .foregroundColor(.blue)
                    
                    Text("ARTIVE")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .tracking(5) // 자간 조절로 고급스럽게
                }
            }
        }
        // 3. 화면이 나타나자마자 런처 로직(2초 딜레이 등) 실행
        .onAppear {
            useAppLauncher.appInfo()
        }
    }
}
