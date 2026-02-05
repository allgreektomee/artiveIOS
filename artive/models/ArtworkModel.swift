//
//  ArtworkModel.swift
//  artive
//
//  Created by 20201385 on 2/5/26.
//

import Foundation

// MARK: - Response
struct ArtworkResponse: Codable {
    let id: Int
    let thumbnailUrl: String
    let title: String
    let status: String
    let totalHistoryCount: Int
}


