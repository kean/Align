//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Align

class MyViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white

        let logo = UILabel()
        logo.font = UIFont.systemFont(ofSize: 30)

        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)

        let subtitle = UILabel()
        subtitle.font = UIFont.systemFont(ofSize: 15)
        subtitle.numberOfLines = 0

        let stack = UIStackView(spacing: 10, alignment: .top, [
            logo,
            UIStackView(axis: .vertical, [title, subtitle])
        ])
        view.addSubview(stack)

        /// Here's code written using Align

        stack.anchors.centerY.align()
        stack.anchors.edges.pin(to: view.layoutMarginsGuide, axis: .horizontal, alignment: .center)

        logo.text = "⛵️"
        title.text = "Welcome to Align!"
        subtitle.text = "An intuitive and powerful Auto Layout"
    }
}

extension UIStackView {
    @nonobjc convenience init(spacing: CGFloat = 10,
                              axis: NSLayoutConstraint.Axis = .horizontal,
                              alignment: UIStackView.Alignment = .fill,
                              _ views: [UIView]) {
        self.init(arrangedSubviews: views)
        self.spacing = spacing
        self.axis = axis
        self.alignment = alignment
    }
}

PlaygroundPage.current.liveView = MyViewController()
