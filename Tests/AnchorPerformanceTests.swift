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

// WARNING: Don't forget to compile for Release mode!
@MainActor
@Suite struct AnchorPerformanceTests {
    @available(iOS 16, tvOS 16, macOS 13, watchOS 9, *)
    @Test func pin() {
        let view = View()
        let container = View()
        container.addSubview(view)

        let clock = ContinuousClock()
        let elapsed = clock.measure {
            for _ in 0...10_000 {
                view.anchors.edges.pin(alignment: .center)
            }
        }
        print("testPin: \(format(elapsed))")
    }

    @available(iOS 16, tvOS 16, macOS 13, watchOS 9, *)
    @Test func batchedPin() {
        let view = View()
        let container = View()
        container.addSubview(view)

        let clock = ContinuousClock()
        let elapsed = clock.measure {
            for _ in 0...10_000 {
                Constraints {
                    view.anchors.edges.pin(alignment: .center)
                }
            }
        }
        print("batchedPin: \(format(elapsed))")
    }

    @available(iOS 16, tvOS 16, macOS 13, watchOS 9, *)
    @Test func constraintsPin() {
        let view = View()
        let container = View()
        container.addSubview(view)

        Constraints(for: view, container) { view, container in
            view.top.equal(container.top)
        }

        let clock = ContinuousClock()
        let elapsed = clock.measure {
            Constraints {
                for _ in 0...10_000 {
                    view.anchors.width.equal(view.anchors.height)
                }
            }
        }
        print("testConstraintsPin: \(format(elapsed))")
    }

    @available(iOS 16, tvOS 16, macOS 13, watchOS 9, *)
    private func format(_ duration: Duration) -> String {
        let ms = Double(duration.components.seconds) * 1_000 + Double(duration.components.attoseconds) / 1e15
        return String(format: "%.3f ms", ms)
    }
}
