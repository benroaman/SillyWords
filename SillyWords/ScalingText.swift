//
//  ScalingText.swift
//  SillyWords
//
//  Created by Ben Roaman on 8/23/26.
//

import SwiftUI
import UIKit
 
/// A `Text` wrapper that shrinks its font to fit a single line within the
/// space it's given, and publishes the resolved point size via a binding so
/// sibling views can match it.
///
/// Unlike `.minimumScaleFactor(_:)`, this never gives you the size it landed
/// on — that's the whole reason this exists.
struct ScalingText: View {
    let text: String
    var font: UIFont
    var minFontSize: CGFloat = 8
 
    /// Set to the point size the text actually rendered at.
    /// Bind a sibling Text's `.font(.system(size:))` to this.
    @Binding var resolvedFontSize: CGFloat
 
    /// Small safety margin because NSString sizing and SwiftUI's text
    /// layout aren't pixel-identical. Tweak if you see clipping.
    private let widthSafetyFactor: CGFloat = 0.98
 
    var body: some View {
        GeometryReader { geometry in
            let fitted = fontThatFits(width: geometry.size.width)
 
            Text(text)
                .font(Font(fitted))
                .lineLimit(1)
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
                .onAppear { updateIfNeeded(fitted.pointSize) }
                .onChange(of: geometry.size.width) { _, _ in
                    updateIfNeeded(fontThatFits(width: geometry.size.width).pointSize)
                }
        }
        // GeometryReader has no intrinsic size, so give it the font's
        // natural single-line height to work with in a normal layout.
//        .frame(height: ceil(font.lineHeight))
    }
 
    private func updateIfNeeded(_ newSize: CGFloat) {
        if resolvedFontSize != newSize {
            resolvedFontSize = newSize
        }
    }
 
    private func fontThatFits(width: CGFloat) -> UIFont {
        guard width > 0 else { return font }
        let targetWidth = width * widthSafetyFactor
 
        // Fast path: the max size already fits.
        if measuredWidth(text, font: font) <= targetWidth {
            return font
        }
 
        var minSize = minFontSize
        var maxSize = font.pointSize
        var best = font.withSize(minSize)
 
        while maxSize - minSize > 0.5 {
            let mid = (minSize + maxSize) / 2
            let candidate = font.withSize(mid)
            if measuredWidth(text, font: candidate) <= targetWidth {
                best = candidate
                minSize = mid
            } else {
                maxSize = mid
            }
        }
        return best
    }
 
    private func measuredWidth(_ string: String, font: UIFont) -> CGFloat {
        (string as NSString).size(withAttributes: [.font: font]).width
    }
}
 
// MARK: - Usage
#Preview {
    ScalingTextExample()
}
 
struct ScalingTextExample: View {
    @State private var titleFontSize: CGFloat = 28
 
    var body: some View {
        HStack(spacing: 8) {
            ScalingText(
                text: "A title that might be way too long to fit",
                font: .systemFont(ofSize: 28, weight: .bold),
                minFontSize: 12,
                resolvedFontSize: $titleFontSize
            )
 
            // Sibling always matches whatever size the title landed on.
            Text("NEW")
                .font(.system(size: titleFontSize, weight: .bold))
                .foregroundStyle(.red)
                .fixedSize() // don't let this get squeezed by the HStack
        }
        .padding()
    }
}
