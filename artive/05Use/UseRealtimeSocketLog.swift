//
//  UseRealtimeSocketLog.swift
//  artive
//
//  WebSocket 수신·연결 로그 — @Published 로 SwiftUI에 바인딩 (NotificationCenter 대신)
//

import Foundation
import Combine

final class UseRealtimeSocketLog: ObservableObject {

    struct Line: Identifiable, Equatable {
        let id = UUID()
        let text: String
    }

    @Published private(set) var lines: [Line] = []
    private let maxLines = 300

    /// 타임스탬프를 붙여 한 줄 추가 (서비스에서 호출)
    func appendLog(_ line: String) {
        let t = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        let full = "[\(t)] \(line)"
        appendRaw(full)
    }

    /// 이미 완성된 문자열 한 줄 (뷰 등에서 선택)
    func appendRaw(_ text: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.lines.append(Line(text: text))
            if self.lines.count > self.maxLines {
                self.lines.removeFirst(self.lines.count - self.maxLines)
            }
        }
    }

    func clear() {
        DispatchQueue.main.async { [weak self] in
            self?.lines.removeAll()
        }
    }
}
