//
//  ServiceAuth.swift
//  artive
//
//  Created by Park Jae Young on 3/19/26.
//

import Foundation
import Combine

protocol ServiceAuthProtocol {
    func login(requestBody: LoginRequest) -> AnyPublisher<LoginResponse, Error>
}


class ServiceAuth : ServiceAuthProtocol{

    
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
