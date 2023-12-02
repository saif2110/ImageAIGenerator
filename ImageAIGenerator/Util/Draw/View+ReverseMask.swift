//
//  View+ReverseMask.swift
//  ImageAIGenerator
//
//  Created by Asil Arslan on 12.08.2023.
//

import Foundation
import SwiftUI

extension View {
  public func reverseMask<Mask: View>(@ViewBuilder _ mask: () -> Mask) -> some View {
    self.mask {
      Rectangle()
            .overlay(alignment: .center) {
                mask()
                    .blendMode(.destinationOut)
            }
        }
    }
}
