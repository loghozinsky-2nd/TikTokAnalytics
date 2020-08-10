//
//  CountValueFormatter.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 08.08.2020.
//

import Foundation

protocol CountValueFormatter {
    func formatCountValue(countLabel: String) -> String
}

extension CountValueFormatter {
    func formatCountValue(countLabel: String) -> String {
        guard let count = Int(countLabel) else { return "0" }
        switch count {
            case 0 ..< 1_000:
                return String(count)
            case 1_000 ..< 100_000:
                let countOfDigits = Int(countLabel.count - (countLabel.count - 4))
                var cuttedString = String(countLabel.prefix(countOfDigits))
                cuttedString.insert(".", at: .init(utf16Offset: countOfDigits - 2, in: cuttedString))
                if cuttedString.last == "0" {
                    return cuttedString.dropLast(1) + "K"
                }
                return String(cuttedString) + "K"
            case 100_000 ..< 1_000_000:
                let countOfDigits = Int(countLabel.count - (countLabel.count - 3))
                let cuttedString = String(countLabel.prefix(countOfDigits))
                if cuttedString.last == "0" {
                    return cuttedString.dropLast(2) + "K"
                }
                return String(cuttedString) + "K"
            default:
                let countOfDigits = Int(countLabel.count - (countLabel.count - 2))
                var cuttedString = String(countLabel.prefix(countOfDigits))
                cuttedString.insert(".", at: .init(utf16Offset: countOfDigits - 1, in: cuttedString))
                if cuttedString.last == "0" {
                    return cuttedString.dropLast(2) + "M"
                }
                return String(cuttedString) + "M"
        }
    }
}
