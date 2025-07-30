//
//  DetailAtomMockData.swift
//  Ato-visionOS
//
//  Created by jeongminji on 7/23/25.
//

enum DetailAtomMockData {
    
    //MARK: - Methods
    
    /// 심볼로 특정 원자 설명 조회 함수
    /// - Parameter symbol: 심볼 String 값
    /// - Returns: DetailAtomModel
    static func find(bySymbol symbol: String) -> DetailAtomModel? {
        allDescriptions.first { $0.symbol == symbol }
    }
    
    /// 원자번호로 특정 원자 설명 조회 함수
    /// - Parameter id: 원자 번호 Int 값
    /// - Returns: DetailAtomModel
    static func find(byId id: Int) -> DetailAtomModel? {
        allDescriptions.first { $0.id == id }
    }
    
    static let allDescriptions: [DetailAtomModel] = [
        DetailAtomModel(
            id: 1,
            symbol: "H",
            name: "수소",
            description: """
            화학 원소 수소(H, 원자번호 1)는 주기율표 1족 1주기에 위치한 비금속 기체입니다. 표준 원자량은 약 1.008이며, 질량 기준으로 우주 질량의 약 75%를 차지하는 우주에서 가장 흔한 원소입니다. 실온에서는 일반적으로 H₂ 분자 형태로 존재하며, 동위원소로는 중수소(²H)와 삼중수소(³H)가 있습니다.
            """),
        DetailAtomModel(
            id: 2,
            symbol: "He",
            name: "헬륨",
            description: """
            화학 원소 헬륨(He, 원자번호 2)은 안정한 비활성 기체로, 끓는점이 매우 낮아 절대영도에서도 기체 상태로 남는 특성이 있습니다. 우주에서 수소 다음으로 풍부하며, 안정 동위원소는 ³He와 ⁴He 두 종류가 존재합니다.
            """),
        DetailAtomModel(
            id: 3,
            symbol: "Li",
            name: "리튬",
            description: """
            화학 원소 리튬(Li, 원자번호 3)은 은백색의 알칼리 금속입니다. 표준 원자량은 약 6.94이며, 그리스어 λίθος(돌)에서 유래한 이름처럼 광석에서 주로 발견됩니다. 동위원소는 ⁶Li와 ⁷Li가 있으며, 리튬 이온 전지, 합금, 윤활유 첨가제로 널리 사용됩니다.
            """),
        DetailAtomModel(
            id: 4,
            symbol: "Be",
            name: "베릴륨",
            description:"""
        화학 원소 베릴륨(Be, 원자번호 4)은 희귀한 경금속으로, 독성과 높은 융점(약 1,287 °C)을 지니며, 우주·항공 산업의 구조용 합금 및 X‑선 창재료로 사용됩니다.
        """),
        DetailAtomModel(
            id: 5,
            symbol: "B",
            name: "붕소",
            description: """
        화학 원소 붕소(B, 원자번호 5)은 비금속 원소로, 세라믹, 유리 및 섬유 강화 복합 재료의 구성 요소로 사용되며, 불꽃 반응 시 아름다운 녹색 빛을 냅니다.
        """),
        DetailAtomModel(
            id: 6,
            symbol: "C",
            name: "탄소",
            description: """
        화학 원소 탄소(C, 원자번호 6)은 비금속이며, 원자가 전자 4개를 가지며 흑연, 다이아몬드, 탄소 나노튜브 등 다양한 동소체가 존재합니다. 우주에서 수소, 헬륨, 산소 다음으로 풍부하며, 유기 화합물의 핵심 원소입니다.
        """),
        DetailAtomModel(
            id: 7,
            symbol: "N",
            name: "질소",
            description: """
        화학 원소 질소(N, 원자번호 7)은 상온에서 무색·무취의 비활성 기체이며, 대기의 약 78%를 차지하는 주요 성분입니다. 생물의 아미노산·단백질·핵산의 구성 원소이기도 합니다.
        """),
        DetailAtomModel(
            id: 8,
            symbol: "O",
            name: "산소",
            description: """
        화학 원소 산소(O, 원자번호 8)은 산소 분자(O₂) 형태로 존재하는 무색·무미·무취의 기체입니다. 지구 대기의 약 21%를 차지하며, 모든 호흡 생물에게 필수적입니다. 지구 대기에 산소가 많아지면서 오존층을 형성하고, 복잡한 생명 진화를 가능하게 했습니다.
        """),
        DetailAtomModel(
            id: 9,
            symbol: "F",
            name: "플루오린",
            description: """
        화학 원소 플루오린(F, 원자번호 9)은 17족의 할로겐 원소로, 가장 전기음성도가 높은 비금속이며, 상온에서는 독성이 강한 연두색 기체입니다. 불소 화합물은 치아용 불소, 테플론, 냉매 등에 널리 사용됩니다.
        """),
        DetailAtomModel(
            id: 10,
            symbol: "Ne",
            name: "네온",
            description: """
        화학 원소 네온(Ne, 원자번호 10)은 비활성 기체로, 공기 중에는 매우 적게 존재합니다. 방전 시 밝은 붉은 주황색 빛을 발산하여, 네온사인과 조명용으로 주로 사용됩니다.
        """),
        DetailAtomModel(
            id: 11,
            symbol: "Na",
            name: "나트륨",
            description: """
        화학 원소 나트륨(Na, 원자번호 11)은 1족 알칼리 금속으로, 부드러운 은백색 금속입니다. 자연에서는 NaCl(소금) 형태로 가장 흔하며, 생체 내 및 산업 공정( 표백제, 비누, 화학 합성 )에 사용됩니다.
        """),
        DetailAtomModel(
            id: 12,
            symbol: "Mg",
            name: "마그네슘",
            description: """
        화학 원소 마그네슘(Mg, 원자번호 12)은 은백색의 가볍고 강한 금속입니다. 지각에서 8번째로 풍부하며, 합금, 화학제품, 플래시등 및 의학(제산제) 등에 사용됩니다.
        """),
        DetailAtomModel(
            id: 13,
            symbol: "Al",
            name: "알루미늄",
            description: """
        화학 원소 알루미늄(Al, 원자번호 13)은 3족 전이 금속에 가까운 경금속입니다. 지각에서 세 번째로 풍부하며, 가볍고 내식성이 좋아 건축·포장재·비행기 등 다양한 산업에 사용됩니다.
        """),
        DetailAtomModel(
            id: 14,
            symbol: "Si",
            name: "규소",
            description: """
        화학 원소 규소(Si, 원자번호 14)은 준금속으로, 반도체 산업의 핵심 원소입니다. 지각에서 산소 다음으로 두 번째로 풍부하며, 유리·시멘트·세라믹 등 다양한 재료에 사용됩니다.
        """),
        DetailAtomModel(
            id: 15,
            symbol: "P",
            name: "인",
            description: """
        화학 원소 인(P, 원자번호 15)은 5족 비금속으로, 여러 동소체(백색, 빨간 인)가 있으며, 비료·세제·불꽃색 화약·반도체 소재 등에 사용됩니다.
        """),
        DetailAtomModel(
            id: 16,
            symbol: "S",
            name: "황",
            description: """
        화학 원소 황(S, 원자번호 16)은 비금속이며, 주요 황 화합물(황산 등)의 원료입니다. 유황 냄새가 나는 황화수소와 화약·비료·의약품 등에 사용됩니다.
        """),
        DetailAtomModel(
            id: 17,
            symbol: "Cl",
            name: "염소",
            description: """
        화학 원소 염소(Cl, 원자번호 17)은 7족 할로겐 원소로, 연두색 기체입니다. 강력한 소독·표백 작용이 있어 수돗물, 풀장, 살균제 등에 널리 사용됩니다.
        """),
        DetailAtomModel(
            id: 18,
            symbol: "Ar",
            name: "아르곤",
            description:"""
        화학 원소 아르곤(Ar, 원자번호 18)은 대량 존재하는 비활성 기체로, 공기 중 약 0.93%를 차지하며, 비활성 보호 가스로 용접·전구 충진 등에 사용됩니다.
        """),
        DetailAtomModel(
            id: 19,
            symbol: "K",
            name: "칼륨",
            description:  """
            화학 원소 칼슘(Ca, 원자번호 20)은 2족 알칼리 토금속으로 은회색의 무른 금속입니다. 지각에서 다섯 번째로 풍부하며, 탄산칼슘·황산칼슘 형태로 존재합니다. 생체 내에서는 뼈·치아 구성과 근육·세포 신호에 관여합니다.
            """),
        DetailAtomModel(
            id: 20,
            symbol: "Ca",
            name: "칼슘",
            description: """
            화학 원소 칼슘(Ca, 원자번호 20)은 2족 알칼리 토금속으로 은회색의 무른 금속입니다. 지각에서 다섯 번째로 풍부하며, 탄산칼슘·황산칼슘 형태로 존재합니다. 생체 내에서는 뼈·치아 구성과 근육·세포 신호에 관여합니다.
            """),
        DetailAtomModel(
            id: 35,
            symbol: "Br",
            name: "브로민",
            description: """
            화학 원소 브로민(Br, 원자번호 35)은 17족 할로겐 원소로, 상온에서 붉은 갈색의 휘발성 액체입니다. 강한 자극성 냄새를 가지며, 난연제·소독제·유기합성 중간체로 널리 사용됩니다.
            """),
        DetailAtomModel(
            id: 53,
            symbol: "I",
            name: "아이오딘",
            description: """
            화학 원소 아이오딘(I, 원자번호 53)은 17족 할로겐 원소 중 가장 무거운 안정 동위원소 원소입니다. 광택 있는 검보라색 고체로, 승화 시 보라색 기체를 방출하며, 갑상선호르몬의 핵심 성분입니다. 방사성 동위원소 ^131I는 진단·치료용으로 사용됩니다.
            """)
    ]
}
