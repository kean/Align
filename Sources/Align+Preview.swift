// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

#if DEBUG && (os(iOS) || os(tvOS))
import SwiftUI

@available(iOS 17.0, tvOS 17.0, *)
#Preview {
    // A scrolling gallery of the highest-value Align layouts, one per titled card.
    let cards = UIStackView()
    cards.axis = .vertical
    cards.spacing = 24
    cards.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
    cards.isLayoutMarginsRelativeArrangement = true

    // The bread-and-butter Align idiom: fill the container with uniform insets.
    cards.addArrangedSubview(demoCard("Pin edges with insets") { canvas in
        let box = UIView(); box.backgroundColor = .systemBlue
        canvas.addSubview(box)

        box.anchors.edges.pin(insets: 16)
    })

    // `pin` also accepts an `alignment` to anchor a fixed-size view to a corner.
    cards.addArrangedSubview(demoCard("Pin to a corner") { canvas in
        let button = UIView(); button.backgroundColor = .systemIndigo
        canvas.addSubview(button)

        button.anchors.size.equal(CGSize(width: 96, height: 40))
        button.anchors.edges.pin(insets: 16, alignment: .bottomTrailing)
    })

    // Center the view and give it an explicit size — a classic badge/dialog layout.
    cards.addArrangedSubview(demoCard("Center with fixed size") { canvas in
        let box = UIView(); box.backgroundColor = .systemPink
        canvas.addSubview(box)

        box.anchors.center.align()
        box.anchors.size.equal(CGSize(width: 120, height: 44))
    })

    // Anchor arithmetic: pin horizontally, then drive height from width for a 2:1 banner.
    cards.addArrangedSubview(demoCard("Aspect ratio with arithmetic") { canvas in
        let banner = UIView(); banner.backgroundColor = .systemTeal
        canvas.addSubview(banner)

        banner.anchors.edges.pin(insets: 16, axis: .horizontal)
        banner.anchors.centerY.align()
        banner.anchors.height.equal(banner.anchors.width * 0.5)
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
    canvas.anchors.height.equal(140)
    build(canvas)
    let stack = UIStackView(arrangedSubviews: [label, canvas])
    stack.axis = .vertical; stack.spacing = 6
    return stack
}
#endif
