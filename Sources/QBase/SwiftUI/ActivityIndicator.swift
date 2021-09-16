import Foundation
import SwiftUI
import UIKit

@available(iOS 14.0, *)
public struct ActivityIndicator: UIViewRepresentable {
    let color: UIColor

    public init(color: UIColor = .white) {
        self.color = color
    }

    public func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>)
    -> UIActivityIndicatorView {
        let acticityIndicatorView = UIActivityIndicatorView(style: .medium)
        acticityIndicatorView.startAnimating()
        acticityIndicatorView.color = color
        return acticityIndicatorView
    }

    public func updateUIView(
        _ uiView: UIActivityIndicatorView,
        context: UIViewRepresentableContext<ActivityIndicator>
    ) {
        uiView.color = color
    }
}
