//
//  RealtimeSocketPayloadRouter.swift
//  artive
//

import Foundation

struct RealtimeSocketPayloadContext {
    let appendLog: (String) -> Void
    let notifySessionSuperseded: () -> Void
}

protocol RealtimeSocketPayloadHandling {
    /// 서버 JSON `type` 필드와 동일한 값 (라우팅 키)
    var type: String { get }
    func handle(_ envelope: RealtimeSocketEnvelope, context: RealtimeSocketPayloadContext)
}

enum RealtimeSocketPayloadRouter {
    private static let handlers: [String: any RealtimeSocketPayloadHandling] = {
        let list: [any RealtimeSocketPayloadHandling] = [
            ConnectionTestPayloadHandler(),
            SessionSupersededPayloadHandler(),
        ]
        return Dictionary(uniqueKeysWithValues: list.map { ($0.type, $0) })
    }()

    static func route(_ envelope: RealtimeSocketEnvelope, context: RealtimeSocketPayloadContext) {
        if let handler = handlers[envelope.type] {
            handler.handle(envelope, context: context)
        } else {
            handleUnknown(envelope, context: context)
        }
    }

    private static func handleUnknown(_ envelope: RealtimeSocketEnvelope, context: RealtimeSocketPayloadContext) {
        let raw = envelope.rawJSONString
        let message = envelope.message
        DLog("RealtimeSocket 알 수 없는 type=\(envelope.type) body=\(raw)")
        context.appendLog("[\(envelope.type)] \(message.isEmpty ? raw : message)")
    }
}
