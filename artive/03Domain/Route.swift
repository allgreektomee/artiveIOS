//
//  Route.swift
//  NewWonBiz
//
//  Created by Park Jae Young on 2/11/26.
//


import Foundation

enum Route: Hashable {
    case launch          // 초기 화면
    case login           // 로그인
    case main            // 메인 홈
    case webView(url: String) // 공통 웹뷰 (URL 전달 가능)
    
    // 필요 시 파라미터가 있는 화면 추가 가능
    // case detail(id: String)
}
