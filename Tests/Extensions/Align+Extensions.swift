// The MIT License (MIT)
//
// Copyright (c) 2017-2020 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)

import Align
import UIKit

// MARK: - UIView + Constraints

public extension UIView {
    @discardableResult @nonobjc func addSubview(_ a: UIView, constraints: (LayoutProxy<UIView>) -> Void) -> Constraints {
        addSubview(a)
        return Constraints(for: a, constraints)
    }

    @discardableResult @nonobjc func addSubview(_ a: UIView, _ b: UIView, constraints: (LayoutProxy<UIView>, LayoutProxy<UIView>) -> Void) -> Constraints {
        [a, b].forEach(addSubview)
        return Constraints(for: a, b, constraints)
    }

    @discardableResult @nonobjc func addSubview(_ a: UIView, _ b: UIView, _ c: UIView, constraints: (LayoutProxy<UIView>, LayoutProxy<UIView>, LayoutProxy<UIView>) -> Void) -> Constraints {
        [a, b, c].forEach(addSubview)
        return Constraints(for: a, b, c, constraints)
    }

    @discardableResult @nonobjc func addSubview(_ a: UIView, _ b: UIView, _ c: UIView, _ d: UIView, constraints: (LayoutProxy<UIView>, LayoutProxy<UIView>, LayoutProxy<UIView>, LayoutProxy<UIView>) -> Void) -> Constraints {
        [a, b, c, d].forEach(addSubview)
        return Constraints(for: a, b, c, d, constraints)
    }
}

#endif
