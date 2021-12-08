//
//  CoveringGradientView.swift
//  Haystack
//
//  Created by Quirin Schweigert on 05.08.21.
//

import SwiftUI

public struct CoveringGradientView<ContentView>: View where ContentView: View {
    let contentView: () -> ContentView
    
    let alignment: Alignment
    let color: Color
    let size: CGFloat
    let isVisible: Bool
    
    public var body: some View {
        contentView()
            .overlay(
                LinearGradient(
                    gradient: Gradient(
                        colors: [color, color.opacity(0)]
                    ),
                    startPoint: unitPoint(for: inverseAlignment(of: alignment)),
                    endPoint: unitPoint(for: alignment)
                )
                    .frame(
                        width: alignment == .leading || alignment == .trailing ? size : nil,
                        height: alignment == .top || alignment == .bottom ? size : nil
                    )
                    .allowsHitTesting(false)
                    .opacity(isVisible ? 1 :0),
                alignment: alignment
            )
    }
    
    func inverseAlignment(of alignment: Alignment) -> Alignment {
        switch alignment {
        case .top:
            return .bottom
        case .bottom:
            return .top
        case .leading:
            return .trailing
        case .trailing:
            return .leading
        default:
            return alignment
        }
    }
    
    func unitPoint(for alignment: Alignment) -> UnitPoint {
        switch alignment {
        case .top:
            return .bottom
        case .bottom:
            return .top
        case .leading:
            return .trailing
        case .trailing:
            return .leading
        default:
            return .center
        }
    }
}

public extension View {
    func coveringGradient(
        alignment: Alignment = .top,
        color: Color = .white,
        size: CGFloat = 20,
        isVisible: Bool = true
    )
    -> some View {
        CoveringGradientView(
            contentView: { self },
            alignment: alignment,
            color: color,
            size: size,
            isVisible: isVisible
        )
    }
}
