import Foundation

/// Shared helpers for encoding/decoding [UUID] as a JSON string in SwiftData attributes.
enum UUIDArrayCoding {
    static func encode(_ uuids: [UUID]) -> String {
        let strings = uuids.map(\.uuidString)
        guard let data = try? JSONEncoder().encode(strings),
              let json = String(data: data, encoding: .utf8) else { return "[]" }
        return json
    }

    static func decode(_ json: String) -> [UUID] {
        guard let data = json.data(using: .utf8),
              let strings = try? JSONDecoder().decode([String].self, from: data) else { return [] }
        return strings.compactMap { UUID(uuidString: $0) }
    }
}
