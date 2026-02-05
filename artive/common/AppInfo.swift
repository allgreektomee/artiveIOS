//
//  CommonType.swift
//  artive
//
//  Created by 20201385 on 2/3/26.
// 앱. 서버정보 

import UIKit


enum ServerType: Int {
    case REAL
    case DEV
    case STAGING
}



class AppInfoModel: NSObject{
    static let shared = AppInfoModel()

    var serverType: ServerType = ServerType.DEV

}
