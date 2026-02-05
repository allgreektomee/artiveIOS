//
//  AuthViewModel.swift
//  artive
//
//  Created by 20201385 on 2/2/26.
//
import Foundation
import Combine

class UserViewModel: BaseViewModel {
    
    @Published var isLoggedIn: Bool = AuthManager.shared.isAuthenticated // 로그인 여부
    @Published var profile:ProfileResponse? // 내 정보 저장용
    
    private let api = APIService.shared
    private let userService = UserService.share
    
    
    func login(email: String, pw: String) {
        
        let requestBody = LoginRequest(email: email, password: pw)
        bindApi(userService.login(requestBody: requestBody)){ [weak self] loginData in
            AuthManager.shared.saveToken(loginData.accessToken)
            self?.fetchMyProfile()
        }
    }
 
    func fetchMyProfile() {
        bindApi(userService.getProfile()){ [weak self] profilenData in
            self?.profile = profilenData
        }
    }
   
}
