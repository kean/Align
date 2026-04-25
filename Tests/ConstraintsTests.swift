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
@Suite struct ConstraintsTests {
    let container = View()
    let view = View()

    init() {
        container.addSubview(view)
    }

    @Test func canChangePriorityInsideInit() {
        Constraints {
            let c = view.anchors.top.pin()
            #expect(c.priority.rawValue == 1000)
            c.priority = LayoutPriority(999)
            #expect(c.priority.rawValue == 999)
        }
    }

    // MARK: Nesting

    @Test func callsCanBeNested() { // no arguments
        Constraints() {
            expectEqualConstraints(
                view.anchors.top.pin(),
                NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top)
            )
            Constraints() {
                expectEqualConstraints(
                    view.anchors.bottom.pin(),
                    NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom)
                )
            }
        }
    }
}

@MainActor
@Suite struct ConstraintsArityTests {
    let container = View()
    let a = View()
    let b = View()
    let c = View()
    let d = View()

    init() {
        container.addSubview(a)
        container.addSubview(b)
        container.addSubview(c)
        container.addSubview(d)
    }

    // MARK: Test That Behaves Like Standard Init

    @Test func arity() {
        Constraints(for: a, b) { a, b in
            let constraint = a.top.equal(b.top)
            expectEqualConstraints(constraint, NSLayoutConstraint(
                item: self.a,
                attribute: .top,
                relation: .equal,
                toItem: self.b,
                attribute: .top
            ))
        }
    }

    @Test func canChangePriorityInsideInit() {
        Constraints(for: a) {
            let cons = $0.top.pin()
            #expect(cons.priority.rawValue == 1000)
            cons.priority = LayoutPriority(999)
            #expect(cons.priority.rawValue == 999)
        }
    }

    @Test func callsCanBeNested() {
        Constraints(for: a) {
            expectEqualConstraints(
                $0.top.pin(),
                NSLayoutConstraint(item: a, attribute: .top, toItem: container, attribute: .top)
            )
            Constraints(for: a) {
                expectEqualConstraints(
                    $0.bottom.pin(),
                    NSLayoutConstraint(item: a, attribute: .bottom, toItem: container, attribute: .bottom)
                )
            }
        }
    }

    @Test func collection() {
        let constraints = Constraints {
            a.anchors.top.pin()
            a.anchors.bottom.pin()
        }

        expectEqualConstraints(constraints.constraints, [
            NSLayoutConstraint(item: a, attribute: .top, toItem: container, attribute: .top),
            NSLayoutConstraint(item: a, attribute: .bottom, toItem: container, attribute: .bottom)
        ])

        expectEqualConstraints(
            constraints.constraints[0],
            NSLayoutConstraint(item: a, attribute: .top, toItem: container, attribute: .top)
        )

        expectEqualConstraints(
            constraints.constraints[1],
            NSLayoutConstraint(item: a, attribute: .bottom, toItem: container, attribute: .bottom)
        )
    }

    // MARK: Multiple Arguments

    @Test func one() {
        Constraints(for: a) {
            #expect($0.item === a)
            return
        }
    }

    @Test func two() {
        Constraints(for: a, b) {
            #expect($0.item === a)
            #expect($1.item === b)
        }
    }

    @Test func three() {
        Constraints(for: a, b, c) {
            #expect($0.item === a)
            #expect($1.item === b)
            #expect($2.item === c)
        }
    }

    @Test func four() {
        Constraints(for: a, b, c, d) {
            #expect($0.item === a)
            #expect($1.item === b)
            #expect($2.item === c)
            #expect($3.item === d)
        }
    }
}

#if os(iOS) || os(tvOS)
@MainActor
@Suite struct AddingSubviewsTests {
    let container = View()
    let a = View()
    let b = View()
    let c = View()
    let d = View()

    @Test func one() {
        container.addSubview(a) {
            #expect($0.item.superview === container)
            #expect($0.item === a)
            return
        }
    }

    @Test func two() {
        container.addSubview(a, b) {
            #expect($0.item.superview === container)
            #expect($1.item.superview === container)
            #expect($0.item === a)
            #expect($1.item === b)
        }
    }

    @Test func three() {
        container.addSubview(a, b, c) {
            #expect($0.item.superview === container)
            #expect($1.item.superview === container)
            #expect($2.item.superview === container)
            #expect($0.item === a)
            #expect($1.item === b)
            #expect($2.item === c)
        }
    }

    @Test func four() {
        container.addSubview(a, b, c, d) {
            #expect($0.item.superview === container)
            #expect($1.item.superview === container)
            #expect($2.item.superview === container)
            #expect($3.item.superview === container)
            #expect($0.item === a)
            #expect($1.item === b)
            #expect($2.item === c)
            #expect($3.item === d)
        }
    }
}
#endif
