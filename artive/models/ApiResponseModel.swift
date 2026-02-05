//
//  ApiResponse.swift
//  artive
//
//  Created by 20201385 on 2/2/26.
//
// 서버 api 공통 포맷

import Foundation

struct ApiResponse<T: Codable> : Codable
{
    let success: Bool?
    let data: T?
    let message: String?
}

struct PageResponse<T: Codable> : Codable
{
    let content: [T]
    let totalElements: Int
    let totalPages: Int
    let last: Bool
    let size: Int
    let number: Int
}
