//
//  PopupVC.swift
//  WeatherAnimals
//
//  Created by 김은상 on 8/24/24.
//

import UIKit
import Then
import SnapKit

final class PopupVC: UIViewController {
    //MARK: - Properties
    private var titleText: String?
    private var messageText: String?
    private var attributedMessageText: NSAttributedString?
    private var contentView: UIView?
    
    private lazy var containerView = UIView().then {
        $0.backgroundColor = .white
//        $0.layer.cornerRadius = 8
        
        /// 팝업이 등장할 때(viewWillAppear)에서 containerView.transform = .identity로 하여 애니메이션 효과 주는 용도
        $0.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    
    private lazy var containerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 12.0
        $0.alignment = .center
    }
    
    private lazy var buttonStackView = UIStackView().then {
        $0.spacing = 14.0
        $0.distribution = .fillEqually
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = titleText
        $0.textAlignment = .center
        $0.font = UIFont.neoDeungeul(size: 18)
        $0.numberOfLines = 0
        $0.textColor = .black
    }
    
    private lazy var messageLabel = UILabel().then  {
        guard messageText != nil || attributedMessageText != nil else { return }
        
        $0.text = messageText
        $0.textAlignment = .center
        $0.font = UIFont.neoDeungeul(size: 16)
        $0.textColor = .gray
        $0.numberOfLines = 0
        
        if let attributedMessageText = attributedMessageText {
            $0.attributedText = attributedMessageText
        }
        
    }
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addSubviews()
        makeConstraints()
        // Do any additional setup after loading the view.
    }
    convenience init(titleText: String? = nil,
                     messageText: String? = nil,
                     attributedMessageText: NSAttributedString? = nil) {
        self.init()
        
        self.titleText = titleText
        self.messageText = messageText
        self.attributedMessageText = attributedMessageText
        /// present 시 fullScreen (화면을 덮도록 설정) -> 설정 안하면 pageSheet 형태 (위가 좀 남아서 밑에 깔린 뷰가 보이는 형태)
        modalPresentationStyle = .overFullScreen
    }
    
    convenience init(contentView: UIView) {
        self.init()
        
        self.contentView = contentView
        modalPresentationStyle = .overFullScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // curveEaseOut: 시작은 천천히, 끝날 땐 빠르게
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // curveEaseIn: 시작은 빠르게, 끝날 땐 천천히
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn) { [weak self] in
            self?.containerView.transform = .identity
            self?.containerView.isHidden = true
        }
    }
    
    //MARK: - Helpers
    public func addActionToButton(title: String? = nil,
                                  titleColor: UIColor = .white,
                                  backgroundColor: UIColor = UIColor(named: "myGreen") ?? UIColor.myGreen,
                                  completion: (() -> Void)? = nil) {
        let button = UIButton()
        button.titleLabel?.font = UIFont.neoDeungeul(size: 18)
        
        // enable
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setBackgroundImage(backgroundColor.image(), for: .normal)
        
        // disable
        button.setTitleColor(.gray, for: .disabled)
        button.setBackgroundImage(UIColor.gray.image(), for: .disabled)
        
        // layer
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true
        
        button.addAction(for: .touchUpInside) { _ in
            completion?()
        }
        
        buttonStackView.addArrangedSubview(button)
    }
    
}


extension PopupVC {
    private func setupViews() {
        view.addSubview(containerView)
        containerView.addSubview(containerStackView)
        view.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    private func addSubviews() {
        view.addSubview(containerStackView)
        
        if let contentView = contentView {
            containerStackView.addSubview(contentView)
        } else {
                containerStackView.addArrangedSubview(titleLabel)
                containerStackView.addArrangedSubview(messageLabel)
            
        }
        
        if let lastView = containerStackView.subviews.last {
            containerStackView.setCustomSpacing(24.0, after: lastView)
        }
        
        containerStackView.addArrangedSubview(buttonStackView)
    }
    
    private func makeConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 32),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -32),
            
            containerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            containerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            containerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24),
            containerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            buttonStackView.heightAnchor.constraint(equalToConstant: 48),
            buttonStackView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor)
        ])
    }
   
}
