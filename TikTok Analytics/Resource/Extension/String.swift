//
//  String.swift
//  TikTok Analytics
//
//  Created by Aleksander Loghozinsky on 08.08.2020.
//

import Foundation

extension String {
    func capitalizing() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalize() {
        self = self.capitalizing()
    }
}
