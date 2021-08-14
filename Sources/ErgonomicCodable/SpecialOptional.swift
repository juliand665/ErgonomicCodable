import Foundation

/// Handles values that have obvious `nil` states but aren't represented as such in their encoded form, instead using an empty string or a date long ago.
@propertyWrapper
public struct SpecialOptional<Strategy: SpecialOptionalStrategy, Value: Codable>: Codable where Strategy.Value: Codable {
	public var wrappedValue: Value?
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let isNil = try container.decodeNil() // for compatibility with re-encoding
			|| Strategy.isNil(container.decode(Strategy.Value.self))
		wrappedValue = isNil ? nil : try container.decode(Value.self)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(wrappedValue)
	}
	
	public init(strategy: Strategy.Type = Strategy.self, wrappedValue: Value? = nil) {
		self.wrappedValue = wrappedValue
	}
	
	public init(_ strategy: Strategy, wrappedValue: Value? = nil) {
		self.wrappedValue = wrappedValue
	}
}

public protocol SpecialOptionalStrategy {
	associatedtype Value
	
	static func isNil(_ value: Value) -> Bool
}

/// Treats empty strings as `nil`.
public struct EmptyStringOptionalStrategy: SpecialOptionalStrategy {
	public static func isNil(_ value: String) -> Bool {
		value.isEmpty
	}
}

extension SpecialOptionalStrategy where Self == EmptyStringOptionalStrategy {
	public static var emptyString: Self { .init() }
}

/// Treats dates before unix epoch 0 (jan 1, 1970) as `nil`.
public struct DistantPastOptionalStrategy: SpecialOptionalStrategy {
	private static let validityCutoff = Date(timeIntervalSince1970: 0)
	
	public static func isNil(_ value: Date) -> Bool {
		value < validityCutoff
	}
}

extension SpecialOptionalStrategy where Self == DistantPastOptionalStrategy {
	public static var distantPast: Self { .init() }
}
