import SwiftUI



struct MainVIew2: View {
    var body: some View {
        // BaseView나 다른 래퍼가 있다면 감싸주시고, 여기서는 MagazineView2를 바로 호출합니다.
        MagazineView2()
    }
}

struct MagazineView2: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // 1. 커버 섹션 (기기 높이에 맞게 설정)
                CoverSection(title: "침묵의 기술", subtitle: "VOL.01 INSIGHT")
                    .frame(height: UIScreen.main.bounds.height * 0.85)
                
                // 2. 에디토리얼 로그
                EditorialLogSection()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 80)
                
                // 3. 메인 전시 피처
                ExhibitionFeatureSection()
                    .frame(maxWidth: .infinity)
                
                // 4. 작가 스포트라이트
                ArtistSpotlightSection()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 100)
                
                // 5. 아트워크 그리드
                ArtworkGridSection()
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 100)
                
                // 6. 엔딩 아웃트로
                VStack(spacing: 20) {
                    Divider().frame(width: 40).background(Color.black.opacity(0.3))
                    Text("ARTIVE Magazine").font(.system(size: 12, weight: .bold)).kerning(4)
                    Text("Your silence is your strength.").font(.custom("Baskerville-Italic", size: 14)).opacity(0.5)
                }
                .padding(.bottom, 80)
                .frame(maxWidth: .infinity)
            }
        }
        .background(Color(hex: "#F5F5F3"))
        .ignoresSafeArea()
    }
}

// --- 수정된 하위 섹션들 (가로폭 최적화) ---

struct EditorialLogSection: View {
    var body: some View {
        // HStack 대신 공간 확보를 위해 GeometryReader나 정밀한 레이아웃 사용
        HStack(alignment: .top, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("LOG 120D").font(.system(size: 10, weight: .bold)).kerning(2)
                Rectangle().frame(width: 1, height: 80).opacity(0.2)
            }
            .frame(width: 60) // 왼쪽 라벨 영역 고정
            
            VStack(alignment: .leading, spacing: 25) {
                Text("비움의 미학을 완성하기까지,\n우리가 보낸 120일의 기록.")
                    .font(.system(size: 19, weight: .light))
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("전시를 준비하며 가장 많이 한 질문은 '무엇을 더할까'가 아닌 '무엇을 뺄까'였습니다. 이 매거진은 그 치열한 덜어냄의 과정을 담고 있습니다.")
                    .font(.system(size: 14))
                    .lineSpacing(6)
                    .opacity(0.6)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 30) // 좌우 여백 확보
        .frame(maxWidth: UIScreen.main.bounds.width) // 기기 너비를 넘지 않도록 제한
    }
}

struct ExhibitionFeatureSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                // 이미지 가로폭이 잘리지 않게 조정
                Rectangle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(height: 500)
                    .overlay(
                        Image("exhibition_main") // 실제 이미지 자산
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    )
                    .clipped()
                
                Text("MAIN\nEXHIBITION")
                    .font(.system(size: 36, weight: .black))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.trailing)
                    .padding(30)
            }
            
            VStack(alignment: .leading, spacing: 15) {
                Text("빛과 그림자의 변주곡").font(.system(size: 24, weight: .bold))
                Text("공간 속에 스며든 빛이 캔버스가 되고, 그림자가 선이 되는 순간을 목격하십시오.")
                    .font(.system(size: 15))
                    .opacity(0.7)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(35)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
        }
    }
}

struct ArtistSpotlightSection: View {
    var body: some View {
        HStack(spacing: 25) {
            // 이미지 크기를 고정하거나 비율로 조절하여 텍스트 공간 확보
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(width: 140, height: 210)
                .overlay(
                    Image("artist_profile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .clipped()
            
            VStack(alignment: .leading, spacing: 15) {
                Text("ARTIST").font(.system(size: 10, weight: .bold)).kerning(3)
                Text("박재영 (J.P)").font(.system(size: 20, weight: .medium))
                Text("\"모든 공간은 자신만의 언어를 가지고 있습니다. 저는 그저 그 언어를 번역할 뿐입니다.\"")
                    .font(.system(size: 14, weight: .light))
                    .italic()
                    .lineSpacing(5)
                    .opacity(0.8)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 30)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ArtworkGridSection: View {
    let columns = [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("CURATED ARTWORKS")
                .font(.system(size: 11, weight: .bold))
                .kerning(3)
                .padding(.horizontal, 30)
            
            LazyVGrid(columns: columns, spacing: 25) {
                ForEach(0..<4) { i in
                    VStack(alignment: .leading, spacing: 12) {
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: i % 2 == 0 ? 220 : 180)
                            .overlay(
                                Image("artwork_\(i+1)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            )
                            .clipped()
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Silence \(i+1)").font(.system(size: 13, weight: .bold))
                            Text("Mixed Media, 2026").font(.system(size: 10)).opacity(0.5)
                        }
                    }
                }
            }
            .padding(.horizontal, 30)
        }
    }
}

// --- 매거진 구성 섹션들 ---



struct CoverSection: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        // GeometryReader를 사용하면 기기의 정확한 가로폭을 계산할 수 있어 안전합니다.
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                Spacer()
                
                // --- 텍스트 콘텐츠 그룹 ---
                VStack(alignment: .leading, spacing: 20) {
                    Text(subtitle)
                        .font(.system(size: 11, weight: .bold))
                        .kerning(4)
                    
                    Text(title)
                        .font(.system(size: 42, weight: .light))
                        .lineSpacing(10)
                        // 가로로 넘치지 않게 가로폭 제한
                        .frame(maxWidth: geometry.size.width * 0.8, alignment: .leading)
                    
                    Rectangle()
                        .frame(width: 40, height: 1)
                        .opacity(0.3)
                    
                    Text("채우는 것보다 비우는 것이 더 어려운 시대,\n우리는 그 여백 속에서 진정한 울림을 찾고자 합니다.")
                        .font(.system(size: 15))
                        .lineSpacing(8)
                        .opacity(0.7)
                        .fixedSize(horizontal: false, vertical: true) // 가로 고정, 세로 확장
                }
                .padding(.horizontal, 30) // ★ 여기서 좌우 여백을 확실히 줍니다.
                
                Spacer()
                
                // --- 하단 화살표 그룹 ---
                VStack(spacing: 8) {
                    Text("SCROLL DOWN")
                        .font(.system(size: 9, weight: .bold))
                        .kerning(2)
                        .opacity(0.4)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .light))
                        .opacity(0.4)
                }
                .frame(maxWidth: .infinity) // 화살표는 화면 중앙에 배치
                .padding(.bottom, 50)
            }
            .frame(width: geometry.size.width) // 섹션 전체 폭을 기기 너비에 고정
        }
    }
}


// 2. 아카이브 그리드에 들어갈 작품 셀
struct ArtworkCell2: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 이미지가 들어갈 자리 (더미 색상)
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .aspectRatio(0.8, contentMode: .fit)
                .overlay(
                    Text("Artwork Image").font(.caption2).opacity(0.3)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Unnamed Piece").font(.system(size: 12, weight: .bold))
                Text("2026").font(.system(size: 10)).opacity(0.5)
            }
        }
    }
}

// 3. 편리한 컬러 사용을 위한 Extension (기존 프로젝트에 없다면 추가)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}
