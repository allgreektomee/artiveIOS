//
//  UseAuth.swift
//  artive
//
//  Created by 20201385 on 2/2/26.
//
import Foundation
import Combine

class UseAuth: BindUse {
    
    // 1. 상태 관리
    @Published var isLoggedIn: Bool = false
    @Published var profile: ProfileResponse?
    
    // 2. 의존성 주입 (DI)
    @Inject var authService: ServiceAuthProtocol
    @Inject var storage: ServiceStorageProtocol
    
    override init() {
        super.init()
        // 시작 시 토큰 여부 확인
        self.isLoggedIn = storage.getToken() != nil
    }
    
    // MARK: - 로그인
    func login(email: String, pw: String) {
        let requestBody = LoginRequest(email: email, password: pw)
        
        // 부모(BindUse)의 bind 함수로 로딩/에러 자동 처리
        bind(authService.login(requestBody: requestBody)) { [weak self] loginData in
            guard let self = self else { return }
            
            // ✅ 싱글톤 대신 주입받은 storage 사용
            self.storage.saveToken(loginData.accessToken)
            self.isLoggedIn = true
            
            DLog("✅ 로그인 성공")
            self.destination = .main
        }
    }
    
    // MARK: - 내 프로필 로드
    func fetchMyProfile() {
//        bind(authService.getProfile()) { [weak self] profileData in
//            self?.profile = profileData
//            DLog("👤 프로필 로드 완료: \(profileData.nickname)")
//        }
    }
}
