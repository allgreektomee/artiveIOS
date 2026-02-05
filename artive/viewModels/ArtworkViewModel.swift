//
//  ArtworkViewModel.swift
//  artive
//
//  Created by 20201385 on 2/5/26.
//

import Foundation
import Combine

class ArtworkViewModel: BaseViewModel {
    @Published var totalElements: Int = 0
    @Published var artworks: [ArtworkResponse] = []
    
    private let api = APIService.shared
    private let artworkService = ArtworkService.share
    
    func getArtworkList() {
        
        bindApi(artworkService.getArtworkList()){ [weak self] (pageData: PageResponse<ArtworkResponse>) in
            self?.artworks = pageData.content
        }
    }
    
}
