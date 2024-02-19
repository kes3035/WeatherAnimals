import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            self.addSubview(view)
        }
    }
    
    func partialBackgroundColor(low: Double, high: Double, tempData: [Double]) {
        self.backgroundColor = UIColor(named: "black")
        /*
         10일간 데이터들 중
         최저 : -10도 ==> minLow
         최고 :  20도 ==> maxHigh
         
         칸 갯수는 20 - (-10) + 1 ==> number
         
         만약 오늘 온도가 -3 ~ 12도
         
         
         */
        let minLow = tempData[0] //전체 데이터의 최소
        
        let maxHigh = tempData[1] //전체 데이터의 최대
        
        let sepCoeff = tempData[2] - 1 //
        let frameSize: Double = 120

        let ratio = frameSize/sepCoeff // 기준길이/프레임길이
        
        let widthOfMyWeather = (maxHigh - minLow)

        print("10일간의 날씨 데이터중 최솟값 : \(minLow)")
        print("10일간의 날씨 데이터중 최댓값 : \(maxHigh)")
        print("날씨 데이터중 최솟값 : \(low)")
        print("날씨 데이터중 최댓값 : \(high)")
        print("맞춰야할 프레임의 길이 : \(self.frame.width)")
        let view = UIView()
        view.backgroundColor = Constants.greenColor
        self.addSubview(view)
        view.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(
                abs(low-minLow)/abs(widthOfMyWeather)*abs(frameSize/widthOfMyWeather)
            )
            $0.width.equalTo(abs(high - low)*ratio)
//            $0.width.equalTo(
//                abs(high - low)/abs(widthOfMyWeather)*abs(frameSize/widthOfMyWeather)
//            )
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

