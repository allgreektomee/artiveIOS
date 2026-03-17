//
//  BaseViewModel.swift
//  NewWonBiz
//
//  Created by Park Jae Young on 2/10/26.
//

import Foundation
import Combine


class BaseViewModel: ObservableObject {
  
    @Published var isLoading: Bool = false
    @Published var error: Error? = nil
    //
    @Published var alertMessage: String? = nil
    @Published var shouldDismiss: Bool = false
    //
//    @Inject  var DeepLinkService: DeepLinkServiceProtocol
    
    // ✅ 이 부분이 반드시 있어야 합니다!
    @Published var destination: Route? = nil


    var cancellables = Set<AnyCancellable>()
    
    func showAlert(_ message: String) {
        self.alertMessage = message
    }
    
    func showAlertAndDismiss(_ message: String) {
        self.alertMessage = message
       
    }
    deinit {
        cancellables.removeAll()
        print("🗑 \(String(describing: self)) deinitialized")
    }
}



////
////  BaseViewModel.swift
////  artive
////
////  Created by 20201385 on 2/2/26.
////
//
//import Foundation
//import Combine
//
//class BaseViewModel: ObservableObject {
//
//    @Published var isLoading: Bool = false
//    @Published var error: Error? = nil
//
//    var cancellables = Set<AnyCancellable>()
//    
//
//    deinit {
//        // 뷰모델이 메모리에서 해제될 때 모든 통신을 안전하게 취소합니다.
//        cancellables.removeAll()
//        print("🗑 \(String(describing: self)) has been deinitialized")
//    }
//    
//    func bindApi<T>(_ publisher: AnyPublisher<T, Error>,
//                        onSuccess: @escaping (T) -> Void,
//                        onFailure: ((Error) -> Void)? = nil){
//   
//        publisher
//            .receive(on: RunLoop.main)
//            .handleEvents(receiveSubscription: { _ in self.isLoading = true },
//                          receiveCompletion: { _ in self.isLoading = false })
//            .sink(receiveCompletion: { [weak self] completion in
//                if case .failure(_) = completion {
//                    if case .failure(let error) = completion {
//                        print("❌ BaseViewModel APIError: \(error)")
//                        
//                        if let decodingError = error as? DecodingError {
//                            print("📦 디코딩 에러 상세: \(decodingError)")
//                        }
//                        
//                        self?.error = error
//                        onFailure?(error)
//                    }
//                }
//      
//            }, receiveValue: {[weak self] value in
//                self?.error = nil
//                onSuccess(value)
//            })
//            .store(in: &cancellables)
//    }
//    
//}
//
////extension Publisher {
////
////    func trackLoading(in viewModel: BaseViewModel) -> AnyPublisher<Output, Failure> {
////        return self
////            .handleEvents(receiveSubscription: { _ in
////                // 구독 시작할 때 (API 요청 출발)
////                DispatchQueue.main.async { viewModel.isLoading = true }
////            }, receiveCompletion: { _ in
////                // 작업 끝났을 때 (성공이든 실패든)
////                DispatchQueue.main.async { viewModel.isLoading = false }
////            })
////            .eraseToAnyPublisher()
////    }
////}
