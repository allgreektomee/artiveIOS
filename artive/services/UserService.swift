//
//  UserService.swift
//  artive
//
//  Created by 20201385 on 2/3/26.
//

import Foundation
import Combine

protocol UserServiceProtocol {
    func login(requestBody: LoginRequest) -> AnyPublisher<LoginResponse, Error>
}


class UserService : UserServiceProtocol{
//    static let share = UserService()
//    private let api = APIService.shared
    
    @Inject var api: APIServiceProtocol
    init() {}
    
    func login(requestBody: LoginRequest) -> AnyPublisher<LoginResponse, Error> {
        return api.post(url: ArtiveAPI.login.url,  body: requestBody).eraseToAnyPublisher()
    }
    
    
//    func getProfile() -> AnyPublisher<ProfileResponse, Error> {
//        return api.get(url:ArtiveAPI.MyProfile).eraseToAnyPublisher()
//    }
    
//    func logout(){
//   
//    }
}

