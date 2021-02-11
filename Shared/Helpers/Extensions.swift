//
//  Extensions.swift
//  Signal
//
//  Created by Jakša Tomović on 14.12.2020..
//

import Foundation
import SwiftUI

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}

