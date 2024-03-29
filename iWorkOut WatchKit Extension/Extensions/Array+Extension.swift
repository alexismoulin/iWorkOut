import Foundation

extension Array where Element: Hashable {
    func uniqued() -> Array {
        var buffer = Array()
        var added = Set<Element>()
        for elem in self {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
}

extension Array where Element == Exercise {
    func muscleFilter(filter: MuscleGroup) -> [Exercise] {
        return self.filter { $0.muscleGroup == filter.rawValue }
    }
}
