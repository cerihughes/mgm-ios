import UIKit

enum Award {
    case gold, silver, bronze, none

    var awardImage: UIImage? {
        switch self {
        case .gold:
            return .goldAward
        case .silver:
            return .silverAward
        case .bronze:
            return .plateAward
        default:
            return .noAward
        }
    }

    var ratingFontColor: UIColor {
        switch self {
        case .gold:
            return .goldCup
        case .silver:
            return .silverCup
        case .bronze:
            return .bronzeCup
        default:
            return .greenCup
        }
    }

    static func award(for score: Float) -> Award {
        if score > 8.5 {
            return .gold
        }
        if score > 7.0 {
            return .silver
        }
        if score > 5.5 {
            return .bronze
        }
        return .none
    }
}

extension UIColor {
    static var goldCup = UIColor(red: 238.0 / 255.0, green: 187.0 / 255.0, blue: 100.0 / 255.0, alpha: 1.0)
    static var silverCup = UIColor(red: 180.0 / 255.0, green: 180.0 / 255.0, blue: 185.0 / 255.0, alpha: 1.0)
    static var bronzeCup = UIColor(red: 217.0 / 255.0, green: 162.0 / 255.0, blue: 129.0 / 255.0, alpha: 1.0)
    static var greenCup = UIColor(red: 55.0 / 255.0, green: 106.0 / 255.0, blue: 77.0 / 255.0, alpha: 1.0)
}
