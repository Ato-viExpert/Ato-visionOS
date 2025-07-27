extension LabMolecule {
    /// 분자식 (예: H2O, CO2 등)
    var molecularFormula: String {
        let symbolCount = atoms.reduce(into: [:]) { counts, atom in
            counts[atom.symbol, default: 0] += 1
        }
        
        return createMolecularFormula(from: symbolCount)
    }

    /// 분자식 생성을 위한 내부 함수
    private func createMolecularFormula(from symbolCount: [String: Int]) -> String {
        var formula = ""
        var remainingSymbols = symbolCount
        
        // 1. C가 있으면 먼저 처리
        if let carbonCount = remainingSymbols["C"] {
            formula += carbonCount > 1 ? "C\(carbonCount)" : "C"
            remainingSymbols.removeValue(forKey: "C")
            
            // 2. C가 있는 경우 H를 다음으로 처리
            if let hydrogenCount = remainingSymbols["H"] {
                formula += hydrogenCount > 1 ? "H\(hydrogenCount)" : "H"
                remainingSymbols.removeValue(forKey: "H")
            }
        }
        
        // 3. 나머지 원자들을 알파벳 순으로 처리
        for symbol in remainingSymbols.keys.sorted() {
            if let count = remainingSymbols[symbol] {
                formula += count > 1 ? "\(symbol)\(count)" : symbol
            }
        }
        
        return formula
    }
}