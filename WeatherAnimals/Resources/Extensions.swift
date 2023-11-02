import UIKit


extension UIView {
    func addSubViews(views: UIView...) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
}
