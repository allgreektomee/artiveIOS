//
//  RealtimeSocketService.swift
//  artive
//
//  서버 네이티브 WebSocket: /ws/realtime?token=...
//

import Foundation

protocol RealtimeSocketServiceProtocol: AnyObject {
    /// 로그인 직후 받은 액세스 토큰으로 연결 (기존 연결은 끊고 재연결)
    func connect(accessToken: String)
    func disconnect()
    /// 다른 기기/탭 로그인 등으로 서버가 보낸 `SESSION_SUPERSEDED` 수신 시 (메인 스레드)
    var onSessionSuperseded: (() -> Void)? { get set }
}

final class RealtimeSocketService: BaseService, RealtimeSocketServiceProtocol {

    @Inject private var useRealtimeLog: UseRealtimeSocketLog

    private let urlSession: URLSession
    private var webSocketTask: URLSessionWebSocketTask?
    var onSessionSuperseded: (() -> Void)?

    override init() {
        self.urlSession = URLSession(configuration: .default)
        super.init()
    }

    func connect(accessToken: String) {
        disconnect()
        guard let url = ArtiveAPI.realtimeWebSocketURL(accessToken: accessToken) else {
            DLog("RealtimeSocket: URL 생성 실패", type: .error)
            emitLogLine("연결 실패: URL 생성 불가")
            return
        }
        let task = urlSession.webSocketTask(with: url)
        webSocketTask = task
        task.resume()
        let host = url.host ?? ""
        DLog("RealtimeSocket: 연결 시작 \(host)")
        emitLogLine("연결 시작: \(host) \(url.path)")
        receiveLoop()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        webSocketTask = nil
        DLog("RealtimeSocket: 연결 종료")
        emitLogLine("연결 종료 (클라이언트)")
    }

    private func receiveLoop() {
        guard let task = webSocketTask else { return }
        task.receive { [weak self] result in
            guard let self else { return }
            switch result {
            case .failure(let error):
                let desc = error.localizedDescription
                DLog("RealtimeSocket receive: \(desc)", type: .warning)
                self.emitLogLine("수신 오류: \(desc)")
            case .success(let message):
                switch message {
                case .string(let jsonString):
                    self.handlePayload(jsonString)
                case .data(let data):
                    if let jsonString = String(data: data, encoding: .utf8) {
                        self.handlePayload(jsonString)
                    }
                @unknown default:
                    break
                }
                self.receiveLoop()
            }
        }
    }

    private func handlePayload(_ jsonString: String) {
        guard let envelope = RealtimeSocketEnvelope.parse(jsonString: jsonString) else {
            DLog("RealtimeSocket 수신(파싱 불가): \(jsonString)", type: .warning)
            emitLogLine("수신 (JSON 아님): \(jsonString.prefix(200))")
            return
        }
        let context = RealtimeSocketPayloadContext(
            appendLog: { [weak self] line in self?.emitLogLine(line) },
            notifySessionSuperseded: { [weak self] in self?.onSessionSuperseded?() }
        )
        RealtimeSocketPayloadRouter.route(envelope, context: context)
    }

    private func emitLogLine(_ line: String) {
        useRealtimeLog.appendLog(line)
    }
}
