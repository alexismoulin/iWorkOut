import Foundation

extension Record {

    var sum: Int {
        return Int(set1 + set2 + set3)
    }

    static func getRecord(CDRecord: Record?, exerciseId: String) -> Int64 {
        if let record = CDRecord {
            let record1: Int64 = record.set1
            let record2: Int64 = record.set2
            let record3: Int64 = record.set3
            return record1 + record2 + record3
        } else {
            return 0
        }
    }

}
