// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - Misc

#if os(iOS) || os(tvOS)
public typealias EdgeInsets = UIEdgeInsets
public typealias LayoutPriority = UILayoutPriority
#elseif os(macOS)
public typealias EdgeInsets = NSEdgeInsets
public typealias LayoutPriority = NSLayoutConstraint.Priority

public extension NSEdgeInsets {
    static let zero = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}
#endif

extension NSLayoutConstraint.Relation {
    @usableFromInline var inverted: NSLayoutConstraint.Relation {
        switch self {
        case .greaterThanOrEqual: return .lessThanOrEqual
        case .lessThanOrEqual: return .greaterThanOrEqual
        case .equal: return self
        @unknown default: return self
        }
    }
}

// MARK: - Preview

#if DEBUG && (os(iOS) || os(tvOS))
import SwiftUI

@available(iOS 17.0, tvOS 17.0, *)
#Preview {
    // A scrolling gallery of common Align layouts, one per titled card.
    let cards = UIStackView()
    cards.axis = .vertical
    cards.spacing = 24
    cards.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
    cards.isLayoutMarginsRelativeArrangement = true

    // Pin all four edges with an inset.
    cards.addArrangedSubview(demoCard("Pin edges with insets") { canvas in
        let box = UIView(); box.backgroundColor = .systemBlue
        canvas.addSubview(box)

        box.anchors.edges.pin(insets: 12)
    })

    // Center the view and set an explicit size.
    cards.addArrangedSubview(demoCard("Center with fixed size") { canvas in
        let box = UIView(); box.backgroundColor = .systemPink
        canvas.addSubview(box)

        box.anchors.center.align()
        box.anchors.size.equal(CGSize(width: 120, height: 44))
    })

    // Place `b` 12pt to the right of `a`, matching its size.
    cards.addArrangedSubview(demoCard("Anchor-to-anchor spacing") { canvas in
        let a = UIView(), b = UIView()
        a.backgroundColor = .systemOrange
        b.backgroundColor = .systemGreen
        canvas.addSubview(a)
        canvas.addSubview(b)

        a.anchors.leading.pin(inset: 16)
        a.anchors.centerY.align()
        a.anchors.size.equal(CGSize(width: 60, height: 44))
        b.anchors.leading.spacing(12, to: a.anchors.trailing)
        b.anchors.centerY.equal(a.anchors.centerY)
        b.anchors.size.equal(a)
    })

    let scroll = UIScrollView()
    scroll.backgroundColor = .systemBackground
    scroll.addSubview(cards)

    // Match the content width to the scroll view so it scrolls vertically only.
    cards.anchors.edges.pin()
    cards.anchors.width.equal(scroll.anchors.width)
    return scroll
}

@MainActor private func demoCard(_ title: String, _ build: (UIView) -> Void) -> UIView {
    let label = UILabel()
    label.font = .systemFont(ofSize: 13, weight: .semibold)
    label.textColor = .secondaryLabel
    label.text = title
    let canvas = UIView()
    canvas.backgroundColor = .secondarySystemBackground
    canvas.anchors.height.equal(120)
    build(canvas)
    let stack = UIStackView(arrangedSubviews: [label, canvas])
    stack.axis = .vertical; stack.spacing = 6
    return stack
}
#endif
