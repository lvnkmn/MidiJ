extension Settings {
    enum NudgeSensitivity: Int, CaseIterable, Codable {
        case plusMinus002
        case plusMinus005
        case plusMinus010
        case plusMinus050
    }
}

extension Settings.NudgeSensitivity {
    
    var localizedDescription: String {
        switch self {
        case .plusMinus002:
            "± 2%"
        case .plusMinus005:
            "± 5%"
        case .plusMinus010:
            "± 10%"
        case .plusMinus050:
            "± 50%"
        }
    }
    
    var multiplier: Percentage {
        switch self {
        case .plusMinus002:
            2
        case .plusMinus005:
            5
        case .plusMinus010:
            10
        case .plusMinus050:
            50
        }
    }
}
