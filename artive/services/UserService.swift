//
//  UserService.swift
//  artive
//
//  Created by 20201385 on 2/3/26.
//

import Foundation
import Combine



class UserService {
    static let share = UserService()
    private let api = APIService.shared
    
    
    func login(requestBody: LoginRequest) -> AnyPublisher<LoginResponse, Error> {
        return api.post(url: ArtiveAPI.Login,  body: requestBody).eraseToAnyPublisher()
    }
    
    
    func getProfile() -> AnyPublisher<ProfileResponse, Error> {
        return api.get(url:ArtiveAPI.MyProfile).eraseToAnyPublisher()
    }
    
    func logout(){
   
    }
}
