import Foundation

public extension Int {
    func formatUsingAbbreviation() -> String {
        let numFormatter = NumberFormatter()
        let abbreviations = ["k", "m", "b"]

        var displayedValue = Double(self)
        var selectedAbbreviation = ""

        for abbreviation in abbreviations {
            guard displayedValue >= 1000 else { break }
            selectedAbbreviation = abbreviation
            displayedValue /= 1000
        }

        numFormatter.positiveSuffix = selectedAbbreviation
        numFormatter.negativeSuffix = selectedAbbreviation
        numFormatter.allowsFloats = true
        numFormatter.minimumIntegerDigits = 1
        numFormatter.minimumFractionDigits = 0
        numFormatter.maximumFractionDigits = 1

        return numFormatter.string(from: NSNumber(value: displayedValue))!
    }
}
