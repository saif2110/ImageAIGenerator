

import SwiftUI

extension Color {
    static let icon = Color.primary
    static let darkRed = Color("DarkRed")
    static let darkOrange = Color("DarkOrange")
}

extension UIColor {
    static let darkRed = UIColor(named: "DarkRed") ?? .red
    static let darkOrange = UIColor(named: "DarkOrange") ?? .orange
}
