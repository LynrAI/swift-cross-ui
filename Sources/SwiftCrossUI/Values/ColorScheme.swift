public enum ColorScheme: Sendable {
    case light
    case dark

    package var opposite: ColorScheme {
        switch self {
            case .light: .dark
            case .dark: .light
        }
    }

    public var defaultForegroundColor: Color {
        switch self {
            case .light: .black
            case .dark: .white
        }
    }

    /// Returns the concrete color value for a semantic color type based on this color scheme.
    /// These values match iOS/UIKit's label color hierarchy.
    package func color(for semantic: SemanticColorType) -> Color {
        switch (self, semantic) {
        case (.light, .primary):
            // Black - primary label color in light mode
            return Color(0.00, 0.00, 0.00, 1.00)
        case (.light, .secondary):
            // Dark gray at 60% opacity - secondary label in light mode
            return Color(0.235, 0.235, 0.263, 0.60)
        case (.light, .tertiary):
            // Dark gray at 30% opacity - tertiary label in light mode
            return Color(0.235, 0.235, 0.263, 0.30)
        case (.light, .quaternary):
            // Dark gray at 18% opacity - quaternary label in light mode
            return Color(0.235, 0.235, 0.263, 0.18)
        case (.dark, .primary):
            // White - primary label color in dark mode
            return Color(1.00, 1.00, 1.00, 1.00)
        case (.dark, .secondary):
            // Light gray at 60% opacity - secondary label in dark mode
            return Color(0.922, 0.922, 0.961, 0.60)
        case (.dark, .tertiary):
            // Light gray at 30% opacity - tertiary label in dark mode
            return Color(0.922, 0.922, 0.961, 0.30)
        case (.dark, .quaternary):
            // Light gray at 18% opacity - quaternary label in dark mode
            return Color(0.922, 0.922, 0.961, 0.18)
        }
    }
}
