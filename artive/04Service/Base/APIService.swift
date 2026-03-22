import Foundation
import Combine

// MARK: - Interface
protocol APIServiceProtocol {
    func get<T: Codable>(url: String, params: [String: String]) -> AnyPublisher<T, Error>
    func post<T: Codable>(url: String, body: Codable) -> AnyPublisher<T, Error>
    func put<T: Codable>(url: String, body: Codable) -> AnyPublisher<T, Error>
    func delete<T: Codable>(url: String) -> AnyPublisher<T, Error>
}

// MARK: - Network Support
enum NetworkError: Error {
    case invalidURL
    case decodingError
    case serverError(String)
}

enum HTTPMethod: String {
    case get = "GET", post = "POST", put = "PUT", delete = "DELETE"
}

// MARK: - Implementation
class APIService: BaseService, APIServiceProtocol {
    
    private let session = URLSession.shared
    @Inject var storage: ServiceStorageProtocol
    
    // MARK: - 1. Request 생성 (토큰 주입 로직 포함)
    private func createRequest(
        url: String,
        method: HTTPMethod,
        params: [String: String],
        body: Codable?
    ) -> URLRequest? {
        guard var components = URLComponents(string: url) else { return nil }
        
        if !params.isEmpty {
            components.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let finalURL = components.url else { return nil }
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ✅ [수정] 부모(BaseService)로부터 주입받은 storage를 직접 사용
        if let token = storage.getToken(), !token.isEmpty {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try? JSONEncoder().encode(body)
        }
        
        return request
    }
    
    // MARK: - 2. 핵심 실행 로직
    private func request<T: Codable>(
        url: String,
        method: HTTPMethod,
        params: [String: String] = [:],
        body: Codable? = nil
    ) -> AnyPublisher<T, Error> {
        
        guard let request = createRequest(url: url, method: method, params: params, body: body) else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        DLog("🌐 [API REQUEST] \(method.rawValue) : \(url)")
        
        return session.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: { output in
                #if DEBUG
                if let str = String(data: output.data, encoding: .utf8) {
                    DLog("✅ [API RESPONSE] : \(url)\n\(str)")
                }
                #endif
            })
            .tryMap { [weak self] output in
                guard let self = self else { throw NetworkError.serverError("인스턴스 해제됨") }
                
                let statusCode = (output.response as? HTTPURLResponse)?.statusCode ?? -1
                
                // ✅ [수정] 401 Unauthorized 처리 (토큰 만료 시)
                if statusCode == 401 {
                    DLog("⚠️ 401 Unauthorized: 세션 만료, 로그아웃 처리", type: .warning)
                    self.storage.clearAll() // 부모의 storage 사용
                    NotificationCenter.default.post(name: NSNotification.Name("LogoutRequired"), object: nil)
                }
                
                // 서버 응답 규격(ApiResponse)에 맞춰 파싱
                // T는 실제 데이터 모델, ApiResponse는 success, message, data를 담은 공통 포맷
                let response = try JSONDecoder().decode(ApiResponse<T>.self, from: output.data)
                
                if response.success ?? false, let data = response.data {
                    return data
                } else {
                    throw NSError(
                        domain: "NetworkError",
                        code: statusCode,
                        userInfo: [NSLocalizedDescriptionKey: response.message ?? "서버 오류 발생"]
                    )
                }
            }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
    
    // MARK: - 3. Interface 구현 (외부 노출)
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
