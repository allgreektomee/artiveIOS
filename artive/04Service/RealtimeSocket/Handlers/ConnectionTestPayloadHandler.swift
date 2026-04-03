//
//  ConnectionTestPayloadHandler.swift
//  artive
//

import Foundation

struct ConnectionTestPayloadHandler: RealtimeSocketPayloadHandling {
    let type = "CONNECTION_TEST"

    func handle(_ envelope: RealtimeSocketEnvelope, context: RealtimeSocketPayloadContext) {
        let ts = (envelope.dictionary["timestamp"] as? NSNumber)?.int64Value ?? 0
        let msg = envelope.message
        DLog("RealtimeSocket CONNECTION_TEST: \(msg) (ts: \(ts))", type: .success)
        context.appendLog("[CONNECTION_TEST] \(msg) ts=\(ts)")
    }
}
