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
    @Inject var realtimeSocket: RealtimeSocketServiceProtocol
    
    override init() {
        super.init()
        // isLoggedIn 은 login() 성공 시에만 true. 저장된 토큰만으로 true 하면
        // 로그인 화면에 들어왔을 때 아직 버튼도 안 눌렀는데 "성공"으로 보임.
        // (자동 로그인/메인 스킵은 런처·Root에서 토큰 유무로 따로 처리)
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

            self.realtimeSocket.connect(accessToken: loginData.accessToken)
            
            DLog("✅ 로그인 성공 → 소켓 로그 화면")
            self.destination = .realtimeSocket
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
