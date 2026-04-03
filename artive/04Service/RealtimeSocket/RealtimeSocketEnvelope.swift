//
//  RealtimeSocketEnvelope.swift
//  artive
//

import Foundation

/// WebSocket 수신 JSON의 최소 봉투. `type`으로만 라우팅하고, 필드 해석은 각 핸들러에서 한다.
struct RealtimeSocketEnvelope {
    let type: String
    let dictionary: [String: Any]
    /// 수신 프레임 원문(UTF-8 JSON 문자열)
    let rawJSONString: String

    var message: String {
        dictionary["message"] as? String ?? ""
    }

    static func parse(jsonString: String) -> RealtimeSocketEnvelope? {
        guard let data = jsonString.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let type = obj["type"] as? String else {
            return nil
        }
        return RealtimeSocketEnvelope(type: type, dictionary: obj, rawJSONString: jsonString)
    }
}
