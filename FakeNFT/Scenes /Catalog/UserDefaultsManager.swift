import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let sortingOptionKey = "SortingOptionKey"

    func saveSortingOption(_ option: SortingOption) {
        UserDefaults.standard.set(option.rawValue, forKey: sortingOptionKey)
    }

    func loadSortingOption() -> SortingOption {
        if let rawValue = UserDefaults.standard.value(forKey: sortingOptionKey) as? Int,
           let option = SortingOption(rawValue: rawValue) {
            return option
        }
        return .defaultSorting
    }
}
