//
//  ArtworkServiceProtocol.swift
//  artive
//
//  Created by Park Jae Young on 2/9/26.
//

import Foundation
import Combine

// 💡 인터페이스 정의
protocol ArtworkServiceProtocol {
    func getArtworkList() -> AnyPublisher<PageResponse<ArtworkResponse>, Error>
}
