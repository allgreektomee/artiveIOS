import SwiftUI
import Combine
import WebKit

struct NativeWebView: UIViewRepresentable {
    let url: URL
    @ObservedObject var viewModel: WebBridgeViewModel

    func makeCoordinator() -> Coordinator { Coordinator(viewModel: viewModel) }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.userContentController.add(context.coordinator, name: "iosBridge")
        let webView = WKWebView(frame: .zero, configuration: config)
        context.coordinator.webView = webView
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url == nil { uiView.load(URLRequest(url: url)) }
    }

    class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        var viewModel: WebBridgeViewModel
        weak var webView: WKWebView?
        var cancellables = Set<AnyCancellable>()

        init(viewModel: WebBridgeViewModel) {
            self.viewModel = viewModel
            super.init()
            // 뷰모델의 응답을 감시하다가 웹으로 전송
            self.viewModel.$bridgeResponse
                .compactMap { $0 }
                .receive(on: RunLoop.main)
                .sink { [weak self] response in self?.dispatchToWeb(response) }
                .store(in: &cancellables)
        }

        // 웹 -> 네이티브 수신
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            guard message.name == "iosBridge",
                  let body = message.body as? [String: Any],
                  let action = body["action"] as? String,             // ✅ 최상위 action
                  let header = body["header"] as? [String: Any],
                  let id = header["id"] as? String else {             // ✅ 헤더 안의 id
                print("❌ 규격 불일치")
                return
            }
            viewModel.handleAction(action: action, id: id, params: body["params"] as? [String: Any])
        }

        // 네이티브 -> 웹 발송
        private func dispatchToWeb(_ response: [String: Any]) {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: response),
                  let jsonString = String(data: jsonData, encoding: .utf8) else { return }
            
            // 🚀 window.onNativeCallback 함수 직접 호출
            let script = "window.onNativeCallback(\(jsonString));"
            webView?.evaluateJavaScript(script)
        }
    }
}
