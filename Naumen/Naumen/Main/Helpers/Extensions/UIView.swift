import UIKit.UIView

public extension UIView {
    static var id: String { .init(describing: self) }
    static var nib: UINib { .init(nibName: id, bundle: nil) }
}
