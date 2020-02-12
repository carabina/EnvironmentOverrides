import SwiftUI

// MARK: - Bindings

extension Binding {
    
    func map<T>(_ keyPath: WritableKeyPath<Value, T>) -> Binding<T> {
        return .init(get: {
            self.wrappedValue[keyPath: keyPath]
        }, set: {
            self.wrappedValue[keyPath: keyPath] = $0
        })
    }
    
    func map<T>(toValue: @escaping (Value) -> T,
                fromValue: @escaping (T) -> Value) -> Binding<T> {
        return .init(get: {
            toValue(self.wrappedValue)
        }, set: { value in
            self.wrappedValue = fromValue(value)
        })
    }
}

// MARK: - EnvironmentValues

extension ContentSizeCategory {
    
    static var stride: CGFloat {
        return 1 / CGFloat(allCases.count - 1)
    }
    
    var floatValue: CGFloat {
        let index = CGFloat(ContentSizeCategory.allCases.firstIndex(of: self) ?? 0)
        return index * ContentSizeCategory.stride
    }
    
    init(floatValue: CGFloat) {
        let index = Int(round(floatValue / ContentSizeCategory.stride))
        self = ContentSizeCategory.allCases[index]
    }
    
    var name: String {
        switch self {
        case .extraSmall: return "XS"
        case .small: return "S"
        case .medium: return "M"
        case .large: return "L"
        case .extraLarge: return "XL"
        case .extraExtraLarge: return "XXL"
        case .extraExtraExtraLarge: return "XXXL"
        case .accessibilityMedium: return "Accessibility M"
        case .accessibilityLarge: return "Accessibility L"
        case .accessibilityExtraLarge: return "Accessibility XL"
        case .accessibilityExtraExtraLarge: return "Accessibility XXL"
        case .accessibilityExtraExtraExtraLarge: return "Accessibility XXXL"
        @unknown default: return "Unknown"
        }
    }
}

extension EnvironmentValues {
    
    static var supportedLocales: [Locale] = {
        let bundle = Bundle.main
        return bundle.localizations.map { Locale(identifier: $0) }
    }()
    
    static var currentLocale: Locale? {
        let current = Locale.current
        let fullId = current.identifier
        let shortId = String(fullId.prefix(2))
        return supportedLocales.locale(withId: fullId) ??
            supportedLocales.locale(withId: shortId)
    }
}

private extension Array where Element == Locale {
    func locale(withId identifier: String) -> Element? {
        first(where: { $0.identifier.hasPrefix(identifier) })
    }
}