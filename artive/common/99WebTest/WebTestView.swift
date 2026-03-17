//
//  WebTestView.swift
//  NewWonBiz
//
//  Created by Park Jae Young on 3/6/26.
//
import SwiftUI

struct WebTestView: View {
 
    
    
    // 2. 웹뷰 전용 뷰모델 생성 (관리자님 스타일대로 별도 관리)
    @StateObject private var webViewModel: WebBridgeViewModel
    
    init() {
        // 뷰모델 생성 시 내부에서 @Inject가 서비스를 알아서 가져올 겁니다.
        _webViewModel = StateObject(wrappedValue: WebBridgeViewModel())
    }
    
    var body: some View {
        // 3. 기존 BaseView를 그대로 사용! (로딩 바 등 공통 UI 유지)
//        BaseView(viewModel: webViewModel) {
//            VStack(spacing: 0) {
//                // SwiftUI로 감싼 웹뷰 엔진
//                NativeWebView(url: URL(string: "http://artivefor.me/testpage")!, viewModel: webViewModel)
//                
//                
//            }
//        }
    }
    

}
