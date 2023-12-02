//
//  Point.swift
//  ImageAIGenerator
//
//  Created by Asil Arslan on 12.08.2023.
//

import Foundation

public struct Point {
    let currentPoint: CGPoint
    let lastPoint: CGPoint
    
    public init(currentPoint: CGPoint, lastPoint: CGPoint) {
        self.currentPoint = currentPoint
        self.lastPoint = lastPoint
    }
}
