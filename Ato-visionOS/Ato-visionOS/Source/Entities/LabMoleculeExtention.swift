import Foundation

extension LabMolecule {
    /// 분자식 계산 (Hill system: C, H 먼저, 나머지는 알파벳 순)
    var molecularFormula: String {
        var symbolCount: [String: Int] = [:]
        
        for atom in atoms {
            let symbol = atom.symbol
            symbolCount[symbol, default: 0] += 1
        }
        
        // Hill system: C, H 먼저, 나머지는 알파벳 순
        let sortedSymbols = symbolCount.keys.sorted { symbol1, symbol2 in
            // C가 있으면 항상 첫번째
            if symbol1 == "C" { return true }
            if symbol2 == "C" { return false }
            
            // C가 있는 경우 H는 두번째
            if symbolCount["C"] != nil {
                if symbol1 == "H" { return true }
                if symbol2 == "H" { return false }
            }
            
            // 나머지는 알파벳 순
            return symbol1 < symbol2
        }
        
        var formula = ""
        for symbol in sortedSymbols {
            let count = symbolCount[symbol] ?? 0
            formula += symbol
            if count > 1 {
                formula += "\(count)"
            }
        }
        
        return formula
    }
}