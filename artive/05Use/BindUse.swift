//
//  BindUse.swift
//  NewWonBiz
//
//  Created by Park Jae Young on 2/9/26.
//


import Foundation
import Combine


class BindUse: BaseUse {

    func bind<T>(_ publisher: AnyPublisher<T, Error>,
                        onSuccess: @escaping (T) -> Void,
                        onFailure: ((Error) -> Void)? = nil){
   
        publisher
            .receive(on: RunLoop.main)
            .handleEvents(receiveSubscription: { _ in self.isLoading = true },
                          receiveCompletion: { _ in self.isLoading = false })
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(_) = completion {
                    if case .failure(let error) = completion {
                        print("❌  APIError: \(error)")
                   
                        if let decodingError = error as? DecodingError {
                            switch decodingError {
                            case .keyNotFound(let key, _): print(" 키 없음: \(key.stringValue)")
                            case .typeMismatch(let type, let context): print(" 타입 불일치: \(type), \(context.debugDescription)")
                            case .valueNotFound(let type, _): print(" 값 없음: \(type)")
                            case .dataCorrupted(let context): print(" 데이터 손상: \(context.debugDescription)")
                            @unknown default: print(" 알 수 없는 디코딩 에러")
                            }
                        }
                        
                        self?.error = error
                        if let onFailure = onFailure {
                            onFailure(error)
                        } else {
                            // 에러처리 안넘어 올경우 여기서 공통 에러 알림 처리
                            print(" onFailure?? : \(error.localizedDescription)")
                            self?.showAlert(error.localizedDescription)
                        }
                    }
                }
      
            }, receiveValue: {[weak self] value in
                self?.error = nil
                onSuccess(value)
            })
            .store(in: &cancellables)
    }
    
}
