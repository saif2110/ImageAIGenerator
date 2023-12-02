//
//  Line.swift
//  ImageAIGenerator
//
//  Created by Asil Arslan on 12.08.2023.
//

import Foundation
import SwiftUI

public struct Line {
    var points: [Point]
    var color: Color
    var width: Float
    
    public init(points: [Point], color: Color, width: Float) {
        self.points = points
        self.color = color
        self.width = width
    }
}
