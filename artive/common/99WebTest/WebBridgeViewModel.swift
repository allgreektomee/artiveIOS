import Foundation
import Combine

class WebBridgeViewModel: BindViewModel {
    @Inject var bridgeService: WebBridgeServiceProtocol
    @Published var bridgeResponse: [String: Any]?

    func handleAction(action: String, id: String, params: [String: Any]?) {
        switch action {
        case "REQ_FACE_ID":
            bind(bridgeService.executeFaceID()) { [weak self] success in
                self?.sendResponse(action: action, id: id, status: "SUCCESS", data: ["verified": success])
            } onFailure: { [weak self] error in
                self?.sendResponse(action: action, id: id, status: "FAIL", message: error.localizedDescription)
            }
        case "REQ_CAMERA":
            bind(bridgeService.openCamera()) { [weak self] imagePath in
                    // 사진 촬영 성공 시: 이미지 경로(또는 데이터) 전달
                    self?.sendResponse(
                        action: action,
                        id: id,
                        status: "SUCCESS",
                        data: ["imageUrl": imagePath] // 웹의 useCamera 훅에서 받을 키값
                    )
            } onFailure: { [weak self] error in
                self?.sendResponse(
                    action: action,
                    id: id,
                    status: "FAIL",
                    message: error.localizedDescription
                )
            }
        default:
            print("알 수 없는 액션")
        }
    }

    private func sendResponse(action: String, id: String, status: String, data: [String: Any] = [:], message: String? = nil) {
        // 🚀 리액트 수신부 구조에 맞춰 평면화
        self.bridgeResponse = [
            "action": action,
            "id": id,
            "status": status,
            "data": data,
            "message": message ?? ""
        ]
    }
}
