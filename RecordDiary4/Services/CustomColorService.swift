//
//  CustomColorService.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 14.07.2025.
//

import Foundation
import SwiftUI

class CustomColorService {
    static let red = Color(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1))
    static let orange = Color(#colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1))
    static let yellow = Color(#colorLiteral(red: 0.9995340705, green: 0.988355577, blue: 0.4726552367, alpha: 1))
    static let green = Color(#colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1))
    static let blue = Color(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1))
    static let purple = Color(#colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1))
    static let pink = Color(#colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1))
    static let cyan = Color(#colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1))
    static let grayLight = Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1))
    static let black = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    static let white = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
}

extension ColorTheme {
    var color: Color {
        switch self {
        case .red: return CustomColorService.red
        case .orange: return CustomColorService.orange
        case .yellow: return CustomColorService.yellow
        case .green: return CustomColorService.green
        case .blue: return CustomColorService.blue
        case .purple: return CustomColorService.purple
        case .pink: return CustomColorService.pink
        case .cyan: return CustomColorService.cyan
        case .grayLight: return CustomColorService.grayLight
        case .black: return CustomColorService.black
        case .white: return CustomColorService.white
        }
    }
}

enum ColorTheme: String, CaseIterable, Codable {
    case red, orange, yellow, green, blue, purple, pink, cyan, grayLight, black, white
}


