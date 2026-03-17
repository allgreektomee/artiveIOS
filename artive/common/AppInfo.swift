//
//  CommonType.swift
//  artive
//
//  Created by 20201385 on 2/3/26.
// 앱. 서버정보 

import UIKit

func DLog(_ message: Any, file: String = #file, function: String = #function, line: Int = #line) {
    #if DEBUG
    // 파일 경로에서 파일명만 추출
    let fileName = (file as NSString).lastPathComponent
    // [파일명] 함수명(라인) : 메시지 형태로 출력
    print("🚀 [\(fileName)] \(function)(\(line)) : \(message)")
    #endif
}

enum ServerType: Int {
    case REAL
    case DEV
    case STAGING
}



class AppInfoModel: NSObject{
    static let shared = AppInfoModel()

    var serverType: ServerType = ServerType.DEV

}
