//
//  Page2.swift
//  artive
//
//  Created by Park Jae Young on 3/20/26.
//
import SwiftUI
struct ExhibitionPage: View {
    @Binding var currentIndex: Int
    @Binding var totalCount: Int
    let mainTab: Int

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                
                // --- [SECTION 1: 전시 메인] ---
                VStack(alignment: .leading, spacing: 30) {
                    Color.clear.frame(height: 100)
                    
                    AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?q=80&w=800")) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: { Color.gray.opacity(0.1) }
                    .frame(height: 450)
                    .clipped()

                    VStack(alignment: .leading, spacing: 15) {
                        Text("MAIN FEATURE").tagStyle()
                        Text("Beyond the\nSilent Canvas").titleStyle()
                        Text("비움으로써 채워지는 예술의 역설을 경험해 보세요.")
                            .font(.system(size: 15)).foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 60)

                // --- [연결 라인 1] ---
                sectionDivider()

                // --- [SECTION 2: 아티스트 지그재그 리스트] ---
                VStack(spacing: 180) { // 스크롤이므로 간격을 넉넉히 배치
                    // Artist 01
                    ArtistWideRow(
                        name: "박재영 (J.P)",
                        role: "Creative Director",
                        img: "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=800",
                        isLeft: true,
                        desc: "공간의 본질은 무엇을 채우느냐가 아니라, 무엇을 남겨두느냐에 의해 결정됩니다. 이번 전시는 그 여백의 미학을 탐구합니다."
                    )
                    
                    // Artist 02
                    ArtistWideRow(
                        name: "이안 (Ian)",
                        role: "Sound Artist",
                        img: "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=800",
                        isLeft: false,
                        desc: "보이지 않는 소리를 통해 공간의 부피를 정의합니다. 청각적 침묵이 주는 무게감을 직접 느껴보시기 바랍니다."
                    )
                    
                    // Artist 03
                    ArtistWideRow(
                        name: "한수진 (S.J)",
                        role: "Installation Artist",
                        img: "https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=800",
                        isLeft: true,
                        desc: "빛의 궤적은 매 순간 다른 표정을 짓습니다. 고정된 캔버스를 넘어선 빛의 움직임을 기록했습니다."
                    )
                }
                .padding(.vertical, 100)
                
                // --- [연결 라인 2] ---
                sectionDivider()
                
                Spacer(minLength: 150)
            }
        }
        .background(Color(red: 0.97, green: 0.97, blue: 0.96))
        .onAppear { totalCount = 0 }
    }
    
    // 섹션 사이 연결 라인 함수
    func sectionDivider() -> some View {
        VStack {
            Rectangle()
                .fill(Color.black.opacity(0.1))
                .frame(width: 1, height: 100)
        }
        .frame(maxWidth: .infinity)
    }
}

// --- 2/3 이미지 & 하단 텍스트 컴포넌트 ---
struct ArtistWideRow: View {
    let name: String; let role: String; let img: String; let isLeft: Bool; let desc: String
    
    var body: some View {
        let imageWidth = UIScreen.main.bounds.width * 0.66 // 💡 가로의 2/3 차지
        
        VStack(alignment: isLeft ? .leading : .trailing, spacing: 35) {
            // 상단 이미지 + 타이틀 오버레이 영역
            ZStack(alignment: isLeft ? .bottomLeading : .bottomTrailing) {
                AsyncImage(url: URL(string: img)) { i in
                    i.resizable().aspectRatio(contentMode: .fill)
                } placeholder: { Color.gray.opacity(0.1) }
                .frame(width: imageWidth, height: 400)
                .grayscale(1.0)
                .clipped()
                
                // 💡 숫자 대신 파란 타이틀과 이름이 이미지 위에 걸쳐지게 배치
                VStack(alignment: isLeft ? .leading : .trailing, spacing: 4) {
                    Text(role)
                        .font(.system(size: 10, weight: .bold))
                        .kerning(2)
                        .foregroundColor(.blue)
                    Text(name)
                        .font(.custom("LibreBaskerville-Bold", size: 24))
                        .foregroundColor(.black)
                }
                .padding(25)
                .background(Color.white.opacity(0.9)) // 가독성을 위한 반투명 배경
                .offset(x: isLeft ? 40 : -40, y: 40) // 💡 이미지 경계에 걸치는 느낌
            }
            .padding(.leading, isLeft ? 0 : nil)
            .padding(.trailing, isLeft ? nil : 0)

            // 💡 소개글을 이미지 아래로 길게 배치
            Text(desc)
                .font(.system(size: 15))
                .lineSpacing(10)
                .foregroundColor(.black.opacity(0.7))
                .frame(width: 280, alignment: isLeft ? .leading : .trailing)
                .padding(.horizontal, 30)
                .padding(.top, 40)
        }
        .frame(maxWidth: .infinity, alignment: isLeft ? .leading : .trailing)
    }
}
