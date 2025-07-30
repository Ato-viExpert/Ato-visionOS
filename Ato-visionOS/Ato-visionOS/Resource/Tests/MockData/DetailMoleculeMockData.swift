//
//  DetailMoleculeMockData.swift
//  Ato-visionOS
//
//  Created by ellllly on 7/23/25.
//

import Foundation


enum DetailMoleculeMockData {
    //MARK: - Methods
    
    /// 심볼로 특정 분자 설명 조회 함수
    /// - Parameter symbol: 심볼 String 값
    /// - Returns: DetailMoleculeModel
    static func find(bySymbol symbol: String) -> DetailMoleculeModel? {
        allDescriptions.first { $0.symbol == symbol }
    }
    
    /// 원자번호로 특정 분자 설명 조회 함수
    /// - Parameter id: 원자 번호 Int 값
    /// - Returns: DetailMoleculeModel
    static func find(byId id: Int) -> DetailMoleculeModel? {
        allDescriptions.first { $0.id == id }
    }
    
    static let allDescriptions: [DetailMoleculeModel] = [
        DetailMoleculeModel(
            id: 1,
            symbol: "H₂",
            name: "수소 분자",
            description: """
            수소(H₂)는 두 개의 수소 원자가 결합한 수소 분자입니다. 눈에 보이지 않는 기체이고, 공기보다 훨씬 가벼워서 예전에는 기구(열기구)를 띄우는 데 쓰이기도 했습니다. 하지만 불이 쉽게 붙기 때문에 지금은 헬륨처럼 더 안전한 기체로 대체되었고 수소는 우주에서 가장 많은 원소이기도 하고, H₂는 에너지를 만들 때 물만 남기는 깨끗한 연료라서 미래의 친환경 에너지원으로 주목받고 있습니다. 매우 가벼우며, 로켓 연료나 암모니아 생산, 수소 연료전지 등에 활용됩니다.
            """,
            composition: "H"
        ),
        DetailMoleculeModel(
            id: 2,
            symbol: "O₂",
            name: "산소 분자",
            description: """
            산소(O₂)는 두 개의 산소 원자로 이루어진 분자로, 우리가 숨 쉬는 데 꼭 필요한 기체입니다. 생명체의 호흡에 필수적이며, 불이 타기 위해서도 반드시 필요합니다. 공기 중 약 21%를 차지하고 있으며, 우리가 인지하지 못해도 매 순간 들이마시는 소중한 존재입니다. 연소 반응에 필수적이며, 의료나 산업에도 다양하게 사용됩니다.
            """,
            composition: "O"
        ),
        DetailMoleculeModel(
            id: 3,
            symbol: "N₂",
            name: "질소 분자",
            description: """
            질소(N₂)는 두 개의 질소 원자가 결합된 분자로, 공기 중 약 78%를 차지하는 가장 풍부한 기체입니다. 안정적이라 대부분의 생명체 호흡에는 관여하지 않지만, 식물의 성장에 중요한 질소 고정 과정에서 매우 중요한 역할을 합니다. 반응성이 낮아 산업에서 보호 기체로 자주 사용됩니다. 또한 비료 제조에 중요한 원소입니다.
            """,
            composition: "N"
        ),
        DetailMoleculeModel(
            id: 4,
            symbol: "CO₂",
            name: "이산화탄소",
            description: """
            이산화탄소(CO₂)는 하나의 탄소 원자와 두 개의 산소 원자가 결합된 분자입니다. 동물은 숨을 쉴 때 CO₂를 배출하고, 식물은 광합성을 통해 CO₂를 흡수해 산소를 만듭니다. 또한 온실가스로 지구온난화의 주요 원인 중 하나이기도 합니다. 이산화탄소는 동물의 호흡이나 연소 과정에서 발생하며, 식물의 광합성 원료이기도 합니다.
            """,
            composition: "C, O"
        ),
        DetailMoleculeModel(
            id: 5,
            symbol: "H₂O",
            name: "물",
            description: """
            물(H₂O)은 두 개의 수소와 하나의 산소로 이루어진 분자로, 우리가 마시고 씻고 사용하는 모든 물의 기본입니다. 지구상의 생명체에게 없어서는 안 될 화합물이며, 고체(얼음), 액체(물), 기체(수증기)로 존재할 수 있습니다. 대부분의 생화학 반응이 물 속에서 일어납니다.
            """,
            composition: "H, O"
        ),
        DetailMoleculeModel(
            id: 6,
            symbol: "NH₃",
            name: "암모니아",
            description: """
            암모니아(NH₃)는 비료의 원료로 많이 사용되며, 특유의 자극적인 냄새가 나는 무색 기체입니다. 수용액 상태에서는 약한 염기성을 띠며, 냉매로도 사용됩니다. 비료, 냉각제, 세척제 등 다양한 분야에 사용되고, 질소 화합물의 중요한 원료입니다.
            """,
            composition: "N, H"
        ),
        DetailMoleculeModel(
            id: 7,
            symbol: "CH₄",
            name: "메테인",
            description: """
            메테인(CH₄)은 탄소와 수소로 이루어진 가장 간단한 탄화수소로, 천연가스의 주요 성분입니다. 불이 잘 붙으며, 연료로 널리 사용됩니다. 연료로 널리 쓰이며, 강력한 온실가스이기도 합니다.
            """,
            composition: "C, H"
        ),
        DetailMoleculeModel(
            id: 8,
            symbol: "HCl",
            name: "염화수소",
            description: """
            염화수소(HCl)는 수소와 염소로 이루어진 무색의 자극적인 기체로, 공기 중에 노출되면 물과 쉽게 반응하여 강산성의 염산을 형성합니다. 염산은 실험실과 산업 현장에서 널리 사용되며, 금속 부식, 세정, 식품 제조, 화학 반응의 중간체 등 다양한 용도로 활용됩니다. 염화수소는 강한 부식성과 자극성을 가지고 있어 다룰 때 각별한 주의가 필요하며, 산업계에서는 정밀한 pH 조절에도 사용됩니다. 금속 가공 및 화학 합성에 널리 사용됩니다.
            """,
            composition: "H, Cl"
        ),

        DetailMoleculeModel(
            id: 9,
            symbol: "NaCl",
            name: "염화나트륨",
            description: """
            염화나트륨(NaCl)은 우리가 흔히 소금이라 부르는 물질로, 나트륨 이온(Na⁺)과 염화 이온(Cl⁻)이 결합한 결정성 고체입니다. 음식의 간을 맞추는 데 가장 흔히 사용되며, 생물의 체내 수분 및 전해질 균형 유지에 필수적인 역할을 합니다. 바닷물에 풍부하며, 산업적으로도 다양한 용도로 사용되는데, 예를 들어 염소 생산이나 도로 제설 등에 쓰입니다. 음식의 간을 맞추는 데 쓰이며, 생리학적으로도 중요한 전해질입니다.
            """,
            composition: "Na, Cl"
        ),

        DetailMoleculeModel(
            id: 10,
            symbol: "CaCO₃",
            name: "탄산칼슘",
            description: """
            탄산칼슘(CaCO₃)은 석회석, 대리석, 조개껍데기, 달걀 껍질 등에 자연적으로 존재하는 흰색 고체 화합물입니다. 건축 자재나 시멘트 제조, 칠판용 분필 등으로 사용되며, 산과 반응하면 이산화탄소를 발생시키는 성질을 가지고 있습니다. 또한 위산을 중화하는 제산제로 사용되기도 하며, 환경 정화나 수질 조절에도 활용됩니다. 건축자재, 치약, 도료, 제지 산업 등에서 많이 사용됩니다.
            """,
            composition: "Ca, C, O"
        ),

        DetailMoleculeModel(
            id: 11,
            symbol: "H₂SO₄",
            name: "황산",
            description: """
            황산(H₂SO₄)은 매우 강한 산성의 무색 액체로, 점성이 높고 물과 혼합 시 많은 열을 발생시키는 특성이 있습니다. 산업적으로 가장 많이 사용되는 화학물질 중 하나로, 비료 생산, 금속 처리, 자동차 배터리, 정유 공정 등 다양한 분야에서 쓰입니다. 특히 농축 황산은 물을 탈수시키는 성질이 강해 유기물에 접촉하면 탄화 반응이 일어나기도 합니다. 비료 제조, 금속 정제, 배터리 전해액 등 다양한 산업 공정에서 중요한 역할을 합니다.
            """,
            composition: "H, S, O"
        ),

        DetailMoleculeModel(
            id: 12,
            symbol: "NaOH",
            name: "수산화나트륨",
            description: """
            수산화나트륨(NaOH)은 가성소다라고도 불리며, 강한 염기성을 띠는 흰색 고체입니다. 물에 잘 녹아 강한 알칼리성 용액을 형성하고, 다양한 산업 공정에서 중요한 역할을 합니다. 예를 들어 비누 제조, 섬유 가공, 종이 생산, 폐수 처리 등에 사용됩니다. 사람의 피부에 닿으면 화상을 입을 수 있어 취급에 주의가 필요합니다. 강염기이며, 비누 제조, 청소용 세제, 종이 및 석유 가공에 사용됩니다.
            """,
            composition: "Na, O, H"
        ),

        DetailMoleculeModel(
            id: 13,
            symbol: "Ca(OH)₂",
            name: "수산화칼슘",
            description: """
            수산화칼슘(Ca(OH)₂)은 생석회를 물과 반응시켜 만든 흰색의 고체로, 석회수의 주요 성분입니다. 이산화탄소와 반응하면 탄산칼슘을 생성하며, 이를 통해 공기 중의 CO₂를 확인하는 실험에 자주 활용됩니다. 농업에서는 토양을 중화시키는 용도로, 건설 현장에서는 모르타르 제조 등에 사용됩니다. 흙의 산도를 낮추거나 폐수 정화, 건축용 모르타르에 사용됩니다.
            """,
            composition: "Ca, O, H"
        ),

        DetailMoleculeModel(
            id: 14,
            symbol: "KCl",
            name: "염화칼륨",
            description: """
            염화칼륨(KCl)은 칼륨과 염소로 이루어진 무색 결정성 물질로, 비료 성분으로 널리 사용됩니다. 칼륨은 식물 생장에 매우 중요한 영양소이며, 염화칼륨은 이 칼륨을 공급하는 주요 수단 중 하나입니다. 의학적으로는 전해질 보충이나 심장 기능 유지에도 활용됩니다. 비료로 많이 사용되는 칼륨 공급원이며, 전해질 보충용 의약품으로도 활용됩니다.
            """,
            composition: "K, Cl"
        ),

        DetailMoleculeModel(
            id: 15,
            symbol: "MgO",
            name: "산화마그네슘",
            description: """
            산화마그네슘(MgO)은 흰색의 고체로, 내열성과 절연성이 뛰어나 방화재료나 전자기기 절연체로 사용됩니다. 제약 분야에서는 제산제로 복용되며, 위산을 중화하는 효과가 있습니다. 높은 온도를 견디는 성질 때문에 도자기나 내화물 생산에도 활용됩니다. 위산을 중화하는 제산제 성분으로도 활용됩니다.
            """,
            composition: "Mg, O"
        ),

        DetailMoleculeModel(
            id: 16,
            symbol: "Al₂O₃",
            name: "산화알루미늄",
            description: """
            산화알루미늄(Al₂O₃)은 알루미늄이 산소와 결합한 화합물로, 경도와 내식성이 뛰어난 물질입니다. 루비와 사파이어 같은 보석의 주성분이며, 절연체, 연마제, 세라믹, 반도체 기판 등 다양한 산업 분야에서 활용됩니다. 자연에서는 보크사이트 광석에서 주로 얻습니다. 연마제, 절연체, 보석(루비·사파이어)의 주성분이며, 알루미늄 금속을 정제하는 데에도 사용됩니다.
            """,
            composition: "Al, O"
        ),

        DetailMoleculeModel(
            id: 17,
            symbol: "SiO₂",
            name: "이산화규소",
            description: """
            이산화규소(SiO₂)는 모래, 수정, 석영 등에 존재하는 화합물로, 유리와 반도체 산업에서 매우 중요한 물질입니다. 높은 내열성과 투명성을 지니며, 건축 자재, 광학 장비, 전자기기 등 다양한 분야에 활용됩니다. 자연계에서 매우 풍부하게 존재합니다. 유리 제조, 반도체 산업의 핵심 원료입니다.
            """,
            composition: "Si, O"
        ),

        DetailMoleculeModel(
            id: 18,
            symbol: "NaHCO₃",
            name: "탄산수소나트륨",
            description: """
            탄산수소나트륨(NaHCO₃)은 흔히 베이킹 소다라고 불리는 흰색 고체로, 산과 반응하여 이산화탄소 기체를 발생시키는 성질이 있습니다. 제과제빵에서 반죽을 부풀게 하는 팽창제로 사용되며, 청소, 탈취, 위산 중화제 등 가정과 산업에서 다양한 용도로 사용됩니다. 제과, 청소, 소화제 등 일상생활에 널리 쓰입니다.
            """,
            composition: "Na, H, C, O"
        ),

        DetailMoleculeModel(
            id: 19,
            symbol: "H₂CO₃",
            name: "탄산",
            description: """
            탄산(H₂CO₃)은 이산화탄소가 물과 반응하여 형성되는 약한 산으로, 자연수나 탄산음료에 존재합니다. 쉽게 CO₂와 물로 분해되기 때문에 오래 보존되기 어렵습니다. 인체 내에서도 혈액의 산염기 균형 조절에 중요한 역할을 하며, 생리학적으로 매우 중요한 물질입니다. 탄산음료나 생물학적 pH 조절에 중요한 역할을 합니다.
            """,
            composition: "H, C, O"
        )
    ]
}
