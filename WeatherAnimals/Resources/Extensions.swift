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


extension String {
    static func toCelcius(with: String) -> String {
        let celcius = "o"
        
        
        return ""
    }
}
