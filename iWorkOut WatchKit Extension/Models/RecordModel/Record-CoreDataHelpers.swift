import Foundation
import CoreData
import SwiftUI

extension Record {
    var wrappedId: String {
        id ?? "999"
    }
}
