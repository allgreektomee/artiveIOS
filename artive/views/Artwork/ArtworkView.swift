
//
//  ArtworkView.swift
//  artive
//
//  Created by 20201385 on 2/5/26.
//
import SwiftUI


struct ArtworkView: View {
    @StateObject var viewModel = ArtworkViewModel() // 아까 만든 뷰모델
    
    var body: some View {
        NavigationView {
            ZStack {

                // 데이터가 있을 때
                List(viewModel.artworks, id: \.id) { artwork in
                    NavigationLink(destination: Text("상세화면 준비중 (ID: \(artwork.id))")) {
                        ArtworkRow(artwork: artwork)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("작품 목록")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            AuthManager.shared.clearToken() // 키체인 토큰삭제
                            print("로그아웃 완료")
                        }) {
                            Image(systemName: "rectangle.portrait.and.arrow.right") // 로그아웃 아이콘
                                .foregroundColor(.red)
                        }
                    }
                }
                // 로딩 중일 
                if viewModel.isLoading {
                    ProgressView("데이터 가져오는 중...")
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                }
                
                // 에러 발생
                if let error = viewModel.error {
                    VStack {
                        Text(error.localizedDescription)
                            .foregroundColor(.red)
                        Button("다시 시도") {
                                viewModel.getArtworkList()
                        }
                    }
                }
            }
            .onAppear {
              
                viewModel.getArtworkList() // 화면 나타날 때 호출
            }
        }
    }
}
