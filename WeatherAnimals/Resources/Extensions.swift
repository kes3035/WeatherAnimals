import UIKit

extension UIView {
    func addSubViews(_ views: UIView...) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
}

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addArrangedSubview(view)
        }
    }
}

extension UIFont {
    static func neoDeungeul(size: CGFloat, name: String = "NeoDunggeunmoPro-Regular") -> UIFont? {
        return UIFont(name: name, size: size)
    }
}


extension UILabel {
   func setHighlighted(_ text: String, with search: String) {
       let attributedText = NSMutableAttributedString(string: text)
       let range = NSString(string: text).range(of: search, options: .caseInsensitive)
       let highlightFont = UIFont.neoDeungeul(size: 16)
       let highlightColor = Constants.greenColor
       let highlightedAttributes: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.font: highlightFont, NSAttributedString.Key.foregroundColor: highlightColor]
       
       attributedText.addAttributes(highlightedAttributes, range: range)
       self.attributedText = attributedText
   }
}
