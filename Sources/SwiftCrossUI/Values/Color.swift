/// Semantic color types that adapt to the current color scheme.
package enum SemanticColorType: Sendable {
    case primary
    case secondary
    case tertiary
    case quaternary
}

/// An RGBA representation of a color.
public struct Color: Sendable {
    /// The red component (from 0 to 1).
    public var red: Float
    /// The green component (from 0 to 1).
    public var green: Float
    /// The blue component (from 0 to 1).
    public var blue: Float
    /// The alpha component (from 0 to 1).
    public var alpha: Float

    /// If this color is semantic, it will adapt to the color scheme.
    package var semantic: SemanticColorType?

    /// Creates a color from its components with values between 0 and 1.
    public init(
        _ red: Float,
        _ green: Float,
        _ blue: Float,
        _ alpha: Float = 1
    ) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
        self.semantic = nil
    }

    /// Creates a semantic color that adapts to the color scheme.
    package init(semantic: SemanticColorType) {
        // Initialize with placeholder values - will be resolved based on color scheme
        self.red = 0
        self.green = 0
        self.blue = 0
        self.alpha = 1
        self.semantic = semantic
    }

    /// Resolves this color based on the current color scheme.
    /// If the color is semantic, returns the appropriate color for the scheme.
    /// Otherwise, returns the color unchanged.
    package func resolve(in colorScheme: ColorScheme) -> Color {
        guard let semantic = semantic else {
            return self
        }
        return colorScheme.color(for: semantic)
    }

    /// Multiplies the opacity of the color by the given amount.
    public consuming func opacity(
        _ opacity: Float
    ) -> Color {
        self.alpha *= opacity
        return self
    }

    /// Pure black.
    public static let black = Color(0.00, 0.00, 0.00)
    /// Pure blue.
    public static let blue = Color(0.00, 0.48, 1.00)
    /// Pure brown.
    public static let brown = Color(0.64, 0.52, 0.37)
    /// Completely clear.
    public static let clear = Color(0.50, 0.50, 0.50, 0.00)
    /// Pure cyan.
    public static let cyan = Color(0.33, 0.75, 0.94)
    /// Pure gray.
    public static let gray = Color(0.56, 0.56, 0.58)
    /// Pure green.
    public static let green = Color(0.16, 0.80, 0.25)
    /// Pure indigo.
    public static let indigo = Color(0.35, 0.34, 0.84)
    /// Pure mint.
    public static let mint = Color(0.00, 0.78, 0.75)
    /// Pure orange.
    public static let orange = Color(1.00, 0.58, 0.00)
    /// Pure pink.
    public static let pink = Color(1.00, 0.18, 0.33)
    /// Pure purple.
    public static let purple = Color(0.69, 0.32, 0.87)
    /// Pure red.
    public static let red = Color(1.00, 0.23, 0.19)
    /// Pure teal.
    public static let teal = Color(0.35, 0.68, 0.77)
    /// Pure yellow.
    public static let yellow = Color(1.00, 0.80, 0.00)
    /// Pure white.
    public static let white = Color(1.00, 1.00, 1.00)

    // MARK: - Semantic Colors

    /// The primary foreground color that adapts to the color scheme.
    /// Black in light mode, white in dark mode.
    public static let primary = Color(semantic: .primary)

    /// A secondary foreground color that adapts to the color scheme.
    /// More subdued than primary, useful for secondary text or less important elements.
    public static let secondary = Color(semantic: .secondary)

    /// A tertiary foreground color that adapts to the color scheme.
    /// Even more subdued than secondary.
    public static let tertiary = Color(semantic: .tertiary)

    /// A quaternary foreground color that adapts to the color scheme.
    /// The most subdued semantic color, useful for placeholder text or disabled states.
    public static let quaternary = Color(semantic: .quaternary)
}

extension Color: ElementaryView {
    func asWidget<Backend: AppBackend>(backend: Backend) -> Backend.Widget {
        backend.createColorableRectangle()
    }

    func update<Backend: AppBackend>(
        _ widget: Backend.Widget,
        proposedSize: SIMD2<Int>,
        environment: EnvironmentValues,
        backend: Backend,
        dryRun: Bool
    ) -> ViewUpdateResult {
        if !dryRun {
            backend.setSize(of: widget, to: proposedSize)
            // Resolve semantic colors based on the current color scheme
            let resolvedColor = self.resolve(in: environment.colorScheme)
            backend.setColor(ofColorableRectangle: widget, to: resolvedColor)
        }
        return ViewUpdateResult.leafView(
            size: ViewSize(
                size: proposedSize,
                idealSize: SIMD2(10, 10),
                minimumWidth: 0,
                minimumHeight: 0,
                maximumWidth: nil,
                maximumHeight: nil
            )
        )
    }
}
