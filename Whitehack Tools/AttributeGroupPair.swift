
import Foundation

struct AttributeGroupPair: Identifiable, Codable {
    let id: UUID
    var attribute: String
    var group: String

    init(id: UUID = UUID(), attribute: String, group: String) {
        self.id = id
        self.attribute = attribute
        self.group = group
    }
}
