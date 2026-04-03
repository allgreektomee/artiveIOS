//
//  SessionSupersededPayloadHandler.swift
//  artive
//

import Foundation

struct SessionSupersededPayloadHandler: RealtimeSocketPayloadHandling {
    let type = "SESSION_SUPERSEDED"

    func handle(_ envelope: RealtimeSocketEnvelope, context: RealtimeSocketPayloadContext) {
        let msg = envelope.message
        DLog("RealtimeSocket SESSION_SUPERSEDED: \(msg)", type: .warning)
        context.appendLog("[SESSION_SUPERSEDED] \(msg)")
        DispatchQueue.main.async {
            context.notifySessionSuperseded()
        }
    }
}
