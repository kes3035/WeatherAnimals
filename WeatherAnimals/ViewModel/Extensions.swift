import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
    
    func partialBackgroundColor(low: Double, high: Double, tempData: [Double]) {
        self.backgroundColor = UIColor(named: "black")
 
        let minLow = tempData[0]
        
        let maxHigh = tempData[1]
        
        let sepCoeff = tempData[2] - 1
        let frameSize: Double = 120

        let ratio = frameSize/sepCoeff
        
        let widthOfMyWeather = (maxHigh - minLow)

        let view = UIView()
        view.backgroundColor = Constants.greenColor
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(
                abs(low-minLow)/abs(widthOfMyWeather)*abs(frameSize/widthOfMyWeather)
            )
            $0.width.equalTo(abs(high - low)*ratio)
            $0.height.equalTo(2)
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
        let highlightedAttributes: [NSAttributedString.Key: Any] = [ NSAttributedString.Key.font: highlightFont as Any, NSAttributedString.Key.foregroundColor: highlightColor]
        
        attributedText.addAttributes(highlightedAttributes, range: range)
        self.attributedText = attributedText
    }
}

extension CALayer {
    func addBorder(_ arrEdge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arrEdge {
            let border = CALayer()
            switch edge {
            case .top:
                border.frame = CGRect(x: 0, y: 0, width: frame.width, height: width)
                break
            case .bottom:
                border.frame = CGRect(x: 20, y: frame.height - width, width: frame.width - 40, height: width)
            case .left:
                border.frame = CGRect(x: 0, y: 0, width: width, height: frame.height)
                break
            case .right:
                border.frame = CGRect(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor
            self.addSublayer(border)
        }
    }
    
    func addBottomBorder(color: UIColor, width: CGFloat, spacing: CGFloat) {
        let border = CALayer()
        
        border.frame = CGRect(x:spacing, y: bounds.height - width, width: bounds.width - 2*spacing, height: width)
        
        border.backgroundColor = color.cgColor
        
        self.addSublayer(border)
    }
}


extension UIControl {
    public typealias UIControlTargetClosure = (UIControl) -> ()

    private class UIControlClosureWrapper: NSObject {
        let closure: UIControlTargetClosure
        init(_ closure: @escaping UIControlTargetClosure) {
            self.closure = closure
        }
    }

    private struct AssociatedKeys {
        static var targetClosure = "targetClosure"
    }

    private var targetClosure: UIControlTargetClosure? {
        get {
            guard let closureWrapper = objc_getAssociatedObject(self, &AssociatedKeys.targetClosure) as? UIControlClosureWrapper else { return nil }
            return closureWrapper.closure

        } set(newValue) {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.targetClosure, UIControlClosureWrapper(newValue),
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    @objc func closureAction() {
        guard let targetClosure = targetClosure else { return }
        targetClosure(self)
    }

    public func addAction(for event: UIControl.Event, closure: @escaping UIControlTargetClosure) {
        targetClosure = closure
        addTarget(self, action: #selector(UIControl.closureAction), for: event)
    }

}

extension UIViewController {
    func showPopUp(title: String? = nil,
                   message: String? = nil,
                   attributedMessage: NSAttributedString? = nil,
                   leftActionTitle: String = "취소",
                   rightActionTitle: String = "확인",
                   leftActionCompletion: (() -> Void)? = nil,
                   rightActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopupVC(titleText: title,
                                                      messageText: message,
                                                      attributedMessageText: attributedMessage)
        showPopUp(popUpViewController: popUpViewController,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle,
                  leftActionCompletion: leftActionCompletion,
                  rightActionCompletion: rightActionCompletion)
    }

    func showPopUp(contentView: UIView,
                   leftActionTitle: String = "취소",
                   rightActionTitle: String = "확인",
                   leftActionCompletion: (() -> Void)? = nil,
                   rightActionCompletion: (() -> Void)? = nil) {
        let popUpViewController = PopupVC(contentView: contentView)

        showPopUp(popUpViewController: popUpViewController,
                  leftActionTitle: leftActionTitle,
                  rightActionTitle: rightActionTitle,
                  leftActionCompletion: leftActionCompletion,
                  rightActionCompletion: rightActionCompletion)
    }

    private func showPopUp(popUpViewController: PopupVC,
                           leftActionTitle: String,
                           rightActionTitle: String,
                           leftActionCompletion: (() -> Void)?,
                           rightActionCompletion: (() -> Void)?) {
        popUpViewController.addActionToButton(title: leftActionTitle,
                                              titleColor: .systemGray,
                                              backgroundColor: .secondarySystemBackground) {
            popUpViewController.dismiss(animated: false, completion: leftActionCompletion)
        }

        popUpViewController.addActionToButton(title: rightActionTitle,
                                              titleColor: .white,
                                              backgroundColor: UIColor(named: "myGreen") ?? .green) {
            popUpViewController.dismiss(animated: false, completion: rightActionCompletion)
        }
        present(popUpViewController, animated: false, completion: nil)
    }
}

extension UIColor {
    /// Convert color to image
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
