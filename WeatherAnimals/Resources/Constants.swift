import UIKit

struct Constants {
    static let greenColor = UIColor(red: 0.30, green: 0.85, blue: 0.39, alpha: 1.00)
    
    
    
    
    
    
}

enum SectionType: Int {
    case hour = 0
    case week
    case airQuality
    case sunset
    case rainFall

    var cellIdentifier: String {
        switch self {
        case .hour: return HourCell.identifier
        case .week: return WeekCell.identifier
        case .airQuality: return AirQualityCell.identifier
        case .sunset: return SunsetCell.identifier
        case .rainFall: return RainFallCell.identifier
        }
    }

    static func section(for index: Int) -> SectionType? {
        return SectionType(rawValue: index)
    }
}
