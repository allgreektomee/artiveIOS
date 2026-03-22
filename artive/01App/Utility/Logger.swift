//
//  Logger.swift
//  artive
//
//  Created by Park Jae Young on 3/19/26.
//


import Foundation

enum LogType {
    case info, error, success, warning
    
    var symbol: String {
        switch self {
        case .info: return "ℹ️"
        case .error: return "❌"
        case .success: return "✅"
        case .warning: return "⚠️"
        }
    }
}

func DLog(_ message: Any, type: LogType = .info, file: String = #file, function: String = #function, line: Int = #line){
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    // 선택한 타입의 심볼을 포함하여 출력
    print("\(type.symbol) [\(fileName)] \(function)(\(line)) : \(message)")
    #endif
}
