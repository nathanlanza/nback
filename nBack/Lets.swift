import Foundation
import CoreGraphics

struct Lets {
    static let playl10n = NSLocalizedString("Play", comment: "")
    static let historyl10n = NSLocalizedString("History", comment: "")
    
    static let matchButtonHeight = CGFloat(60)
    
    static let timeBetweenTurnsKey = "timeBetweenTurns"
    static let squareHighlightTimeKey = "squareHighlightTime"
    static let typesKey = "types"
    static let levelKey = "level"
    static let rowsKey = "rows"
    static let columnsKey = "columns"
    static let numberOfTurnsKey = "numberOfTurns"
}



extension Double {
    var nanoseconds: Double {
        return Double(Int64(self * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    }
}
