//
//  BaseUse.swift
//  NewWonBiz
//
//  Created by Park Jae Young on 2/10/26.
//

import Foundation
import Combine


class BaseUse: ObservableObject {
  
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

