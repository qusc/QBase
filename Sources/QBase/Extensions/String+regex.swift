import Foundation

public extension String {
    func captureGroupsOfMatches(forRegex regex: NSRegularExpression) throws -> [String] {
        let results = regex.matches(in: self, range: NSRange(startIndex..., in: self))

        return results.flatMap { (match: NSTextCheckingResult) in
            (0..<match.numberOfRanges)
                .map { String(self[Range(match.range(at: $0), in: self)!]) }
                .dropFirst()
        }
    }
}
