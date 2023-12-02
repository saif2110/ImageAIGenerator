

import Foundation

enum PremiumPlan: String, CaseIterable {
    case monthly = "Monthly"
    case yearly = "Yearly"
    
    var cost: Double {
        switch self {
        case .monthly:
            return 6.99
        case .yearly:
            return 49.99
        }
    }
}
