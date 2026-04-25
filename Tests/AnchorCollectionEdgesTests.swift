// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

import Testing
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import Align

@MainActor
@Suite struct AnchorCollectionEdgesTests {
    let container = View()
    let view = View()

    init() {
        container.addSubview(view)
    }

    // MARK: - Core API

    @Test func equal() {
        expectEqualConstraints(
            view.anchors.edges.equal(container),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .equal, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .leading, relation: .equal,toItem: container, attribute: .leading),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .equal, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .trailing, relation: .equal, toItem: container, attribute: .trailing)]
        )
    }

    @Test func equalAbsolute() {
        expectEqualConstraints(
            view.anchors.edges.absolute().equal(container),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .equal, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, relation: .equal,toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .equal, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, relation: .equal, toItem: container, attribute: .right)]
        )
    }

    @Test func equalWithInsets() {
        expectEqualConstraints(
            view.anchors.edges.equal(container, insets: 20),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .equal, toItem: container, attribute: .top, constant: 20),
             NSLayoutConstraint(item: view, attribute: .leading, relation: .equal,toItem: container, attribute: .leading, constant: 20),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .equal, toItem: container, attribute: .bottom, constant: -20),
             NSLayoutConstraint(item: view, attribute: .trailing, relation: .equal, toItem: container, attribute: .trailing, constant: -20)]
        )
    }

    @Test func pinToSuperviewLessThanOrEqual() {
        expectEqualConstraints(
            view.anchors.edges.lessThanOrEqual(container),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .greaterThanOrEqual, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .leading, relation: .greaterThanOrEqual,toItem: container, attribute: .leading),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .lessThanOrEqual, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .trailing, relation: .lessThanOrEqual, toItem: container, attribute: .trailing)]
        )
    }

    // MARK: - Semantic API

    @Test func pinToSuperview() {
        expectEqualConstraints(
            view.anchors.edges.pin(),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .leading, toItem: container, attribute: .leading),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .trailing, toItem: container, attribute: .trailing)]
        )
    }

    @Test func pinToSuperviewAbsolute() {
        expectEqualConstraints(
            view.anchors.edges.absolute().pin(),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right)]
        )
    }

    @Test func pinToSuperviewWithInsets() {
        let insets = EdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        expectEqualConstraints(
            view.anchors.edges.pin(insets: insets),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 1),
             NSLayoutConstraint(item: view, attribute: .leading, toItem: container, attribute: .leading, constant: 2),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom, constant: -3),
             NSLayoutConstraint(item: view, attribute: .trailing, toItem: container, attribute: .trailing, constant: -4)]
        )
    }

    @Test func pinToSuperviewLessThanOrEqualAlignmentCenter() {
        expectEqualConstraints(
            view.anchors.edges.pin(alignment: .center),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .greaterThanOrEqual, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .leading, relation: .greaterThanOrEqual,toItem: container, attribute: .leading),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .lessThanOrEqual, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .trailing, relation: .lessThanOrEqual, toItem: container, attribute: .trailing),
             NSLayoutConstraint(item: view, attribute: .centerX, relation: .equal, toItem: container, attribute: .centerX),
             NSLayoutConstraint(item: view, attribute: .centerY, relation: .equal, toItem: container, attribute: .centerY)]
        )
    }

    @Test func pinToSuperviewAlongAxis() {
         expectEqualConstraints(
            view.anchors.edges.pin(axis: .vertical),
             [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top),
              NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom)]
         )
         expectEqualConstraints(
             view.anchors.edges.pin(axis: .horizontal),
             [NSLayoutConstraint(item: view, attribute: .leading, toItem: container, attribute: .leading),
              NSLayoutConstraint(item: view, attribute: .trailing, toItem: container, attribute: .trailing)]
         )
     }
}
