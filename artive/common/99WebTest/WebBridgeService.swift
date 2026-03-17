//
//  WebBridgeService.swift
//  NewWonBiz
//
//  Created by Park Jae Young on 3/6/26.
//

import Foundation
import Combine
import LocalAuthentication
import UIKit // 🚀 UIImagePicker를 위해 필요

protocol WebBridgeServiceProtocol {
    func executeFaceID() -> AnyPublisher<Bool, Error>
    func openCamera() -> AnyPublisher<String, Error>
}

class WebBridgeService: NSObject, WebBridgeServiceProtocol {
    private var cameraSubject = PassthroughSubject<String, Error>()
    
    // MARK: - 카메라 & 앨범 호출
    func openCamera() -> AnyPublisher<String, Error> {
        DLog("🚀 [WebBridgeService] openCamera 호출")
        cameraSubject = PassthroughSubject<String, Error>() // 호출 시마다 초기화
        
        DispatchQueue.main.async {
            // 1. 최상단 뷰컨트롤러 찾기 (모달 위에 띄우기 위해)
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
                DLog("❌ Root VC를 찾을 수 없음")
                return
            }
            
            var topVC = rootVC
            while let presentedVC = topVC.presentedViewController {
                topVC = presentedVC
            }

            let picker = UIImagePickerController()
            picker.delegate = self
            
            // 2. 소스 타입 결정 (카메라 -> 앨범 순서)
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                DLog("📸 카메라 사용 가능 - 카메라 실행")
                picker.sourceType = .camera
            } else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                DLog("🖼️ 카메라 차단됨 - 대신 앨범 실행")
                picker.sourceType = .photoLibrary
            } else {
                DLog("❌ 카메라와 앨범 모두 사용 불가")
                self.cameraSubject.send(completion: .failure(NSError(domain: "SourceError", code: -5, userInfo: [NSLocalizedDescriptionKey: "기기에서 카메라/앨범을 사용할 수 없습니다."])))
                return
            }
            
            // 3. UI 띄우기
            topVC.present(picker, animated: true)
        }
        
        return cameraSubject.eraseToAnyPublisher()
    }
    
    // MARK: - FaceID 인증
    func executeFaceID() -> AnyPublisher<Bool, Error> {
        DLog("executeFaceID")
        let subject = PassthroughSubject<Bool, Error>()
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "인증이 필요합니다") { success, _ in
                if success {
                    subject.send(true)
                    subject.send(completion: .finished)
                } else {
                    subject.send(completion: .failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "인증에 실패했습니다."])))
                }
            }
        } else {
            subject.send(completion: .failure(error ?? NSError(domain: "AuthError", code: -2, userInfo: [NSLocalizedDescriptionKey: "생체 인증을 지원하지 않는 기기입니다."])))
        }
        
        return subject.eraseToAnyPublisher()
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension WebBridgeService: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // 사진 선택/촬영 완료 시 호출
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            // 📸 카메라 촬영 사진 혹은 🖼️ 앨범 선택 사진 모두 여기서 처리됨
            if let image = info[.originalImage] as? UIImage {
                // 이미지를 Base64 문자열로 변환하여 웹으로 전송
                if let imageData = image.jpegData(compressionQuality: 0.5) {
                    let base64String = imageData.base64EncodedString()
                    let finalImageString = "data:image/jpeg;base64,\(base64String)"
                    
                    self?.cameraSubject.send(finalImageString)
                    self?.cameraSubject.send(completion: .finished)
                    DLog("✅ 이미지 전송 완료 (Base64)")
                }
            }
        }
    }
    
    // 취소 시 호출
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { [weak self] in
            DLog("⚠️ 사용자가 촬영/선택을 취소함")
            self?.cameraSubject.send(completion: .failure(NSError(domain: "CameraError", code: -3, userInfo: [NSLocalizedDescriptionKey: "사용자가 취소했습니다."])))
        }
    }
}
