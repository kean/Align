//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Yalta


class MyViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UILabel()
        let title = UILabel()
        let subtitle = UILabel()

        view.backgroundColor = UIColor.white
        logo.font = UIFont.systemFont(ofSize: 30)
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        subtitle.font = UIFont.systemFont(ofSize: 15)

        logo.text = "⛵️"
        title.text = "Welcome to Yalta!"
        subtitle.text = "Micro Auto Layout DSL"

        let right = Stack([title, subtitle], axis: .vertical)
        let stack = Stack([logo, right], spacing: 10, alignment: .center)

        view.addSubview(stack)
        stack.al.axis.centerInSuperview()
    }
}

PlaygroundPage.current.liveView = MyViewController()
