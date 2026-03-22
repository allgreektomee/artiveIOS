import SwiftUI

struct LogResponse: Codable, Identifiable {
    var id: String { title }
    let layoutType: String
    let tag: String
    let title: String
    let mainImage: String
    let subImage: String?
    let date: String
    let content: String // 상세 워딩 추가
}

let dummyLogs = [
    LogResponse(
        layoutType: "A",
        tag: "01 / STUDIO",
        title: "빛이 머무는 각도",
        mainImage: "https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=800",
        subImage: nil,
        date: "2026. 03. 01",
        content: "스튜디오에 처음 들어오는 오전 10시의 햇살은 늘 낯설게 느껴집니다. 우리는 캔버스를 채우기 전, 이 빛이 공간의 모서리에 닿아 부서지는 각도를 한 달간 기록했습니다. 채우는 것보다 중요한 것은 이미 존재하는 빛을 어떻게 머무르게 할 것인가에 대한 고민이었습니다."
    ),
    LogResponse(
        layoutType: "B",
        tag: "02 / RAW",
        title: "가공되지 않은\n선들의 기록",
        mainImage: "https://images.unsplash.com/photo-1541963463532-d68292c34b19?q=80&w=800",
        subImage: nil,
        date: "2026. 03. 10",
        content: "다듬어지지 않은 선들은 투박하지만 정직합니다. 완벽한 형태를 만들기 위해 덧칠하기보다, 처음 그은 선의 떨림을 그대로 남겨두기로 했습니다. 정교함보다는 생명력을, 완성도보다는 과정을 보여주는 것이 이번 전시의 핵심입니다."
    ),
    LogResponse(
        layoutType: "C",
        tag: "03 / PROCESS",
        title: "질감의 레이어",
        mainImage: "https://images.unsplash.com/photo-1554188248-986adbb73be4?q=80&w=800",
        subImage: "https://images.unsplash.com/photo-1579783902614-a3fb3927b6a5?q=80&w=400",
        date: "2026. 03. 20",
        content: "시간은 질감을 만듭니다. 물감이 마르고 다시 그 위에 덧칠되는 과정은 단순한 작업이 아니라 시간의 층을 쌓는 행위입니다. 만져질 듯 생생한 마티에르 사이로 우리가 보냈던 120일의 무게가 고스란히 녹아들어 있습니다."
    )
]
