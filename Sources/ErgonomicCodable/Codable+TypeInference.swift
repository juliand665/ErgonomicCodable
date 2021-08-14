import Foundation

extension KeyedDecodingContainer {
	/// Type-inferred version of `decode(_:forKey:)` for when the type is just boilerplate.
	public func decodeValue<T>(forKey key: K) throws -> T where T: Decodable {
		try decode(T.self, forKey: key)
	}
	
	/// Type-inferred version of `decodeIfPresent(_:forKey:)` for when the type is just boilerplate.
	public func decodeValueIfPresent<T>(forKey key: K) throws -> T? where T: Decodable {
		try decodeIfPresent(T.self, forKey: key)
	}
}
