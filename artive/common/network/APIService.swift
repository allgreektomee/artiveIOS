//
//  APIService.swift
//  artive
//
//  Created by 20201385 on 2/2/26.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case serverError(String)
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class APIService : APIServiceProtocol {
    
//    static let shared = APIService()
//    private init() {}
    
    
    private let session = URLSession.shared
    init() {}
    
    
    // MARK: requset 생성 분리
    private func createRequest(
        url: String,
        method: HTTPMethod,
        params: [String: String],
        body: Codable?
    ) -> URLRequest? {
        guard var components = URLComponents(string: url) else { return nil }
        
        //  Query Items 설정
        if !params.isEmpty {
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let finalURL = components.url else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        
        // 공통 헤더 설정
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //  토큰 자동 주입
        if let token = AuthManager.shared.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
    
        // 바디 인코딩
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        
        return request
    }
    
    // MARK: - 메인 리퀘스트
    private func request<T: Codable>(
        url: String,
        method: HTTPMethod,
        params: [String: String] = [:],
        body: Codable? = nil
    ) -> AnyPublisher<T, Error> {
        
       
        guard let request = createRequest(url: url, method: method, params: params, body: body) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        #if DEBUG
        print("✅ [API REQUEST] \(method.rawValue) : \(url)")
        if let body = request.httpBody, let str = String(data: body, encoding: .utf8) {
            print("✅ Body: \(str)")
        }
        #endif
            
        
        return session.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { output in
                        #if DEBUG
                        print("✅ [API RESPONSE] : \(url)")
                        if let str = String(data: output.data, encoding: .utf8) {
                         
                            if let json = try? JSONSerialization.jsonObject(with: output.data),
                               let prettyData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted),
                               let prettyStr = String(data: prettyData, encoding: .utf8) {
                                print(prettyStr)
                            } else {
                                print(str)
                            }
                        }
                        #endif
                    })
            .tryMap { output in
                // 1. 서버가 준 데이터가 몇 바이트인지 확인
                print("📏 데이터 크기: \(output.data.count) bytes")
                // 2. 데이터를 문자열로 변환해서 출력
                if let rawString = String(data: output.data, encoding: .utf8) {
                    print("📝 서버 응답 원문: \(rawString)")
                } else {
                    print("❌ 데이터를 문자열로 변환할 수 없음 (바이너리이거나 비어있음)")
                }
                
                let statusCode = (output.response as? HTTPURLResponse)?.statusCode ?? -1
                
                if statusCode == 401 {
                        AuthManager.shared.clearToken()
                        NotificationCenter.default.post(name: NSNotification.Name("LogoutRequired"), object: nil)
                    }
                
                let response = try JSONDecoder().decode(ApiResponse<T>.self, from: output.data)
                
                if response.success ?? false, let data = response.data {
                    return data
                } else {
                    throw NSError(
                        domain: "NetworkError",
                        code: statusCode, // 지금은 http 코드, 추후 서버 코드잇으면 세팅
                        userInfo: [NSLocalizedDescriptionKey: response.message ?? "서버 미지정 오류 발생"]
                    )
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    

    func get<T: Codable>(url: String, params: [String: String] = [:]) -> AnyPublisher<T, Error> {
        request(url: url, method: .get, params: params)
    }
    
    func post<T: Codable>(url: String, body: Codable) -> AnyPublisher<T, Error> {
        request(url: url, method: .post, body: body)
    }
    
    func put<T: Codable>(url: String, body: Codable) -> AnyPublisher<T, Error> {
        request(url: url, method: .put, body: body)
    }
    
    func delete<T: Codable>(url: String) -> AnyPublisher<T, Error> {
        request(url: url, method: .delete)
    }


}
