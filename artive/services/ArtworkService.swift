//
//  Artwork.swift
//  artive
//
//  Created by 20201385 on 2/5/26.
//

import Foundation
import Combine


class ArtworkService: ObservableObject {
    static let share = ArtworkService()
    private let api = APIService.shared
    
    func getArtworkList() -> AnyPublisher<PageResponse<ArtworkResponse>, Error> {
        return api.get(url:ArtiveAPI.Artworks).eraseToAnyPublisher()
    }
    
}
