//
//  ArtworkRow.swift
//  artive
//
//  Created by 20201385 on 2/5/26.
//

import SwiftUI

struct ArtworkRow: View {
    let artwork: ArtworkResponse // 아까 만든 모델 사용
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
                    // 1. 썸네일 이미지
                    AsyncImage(url: URL(string: artwork.thumbnailUrl )) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        ZStack {
                            Color.gray.opacity(0.1)
                            ProgressView().controlSize(.small)
                        }
                    }
                    .frame(width: 70, height: 70)
                    .cornerRadius(10)
                    .clipped()
                    
                    // 2. 정보 텍스트
                    VStack(alignment: .leading, spacing: 4) {
                        Text(artwork.title)
                            .font(.system(size: 16, weight: .bold))
                            .lineLimit(1)
                        
                        Text(artwork.title)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        // 3. 히스토리 배지
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 10))
                            Text("히스토리 \(artwork.totalHistoryCount)")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(4)
                        .padding(.top, 2)
                    }
                    
                    Spacer()
         
                }
                .padding(.vertical, 4)
    }
}
