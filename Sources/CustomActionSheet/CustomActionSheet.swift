








import UIKit



public enum ActionIcon {
    case system(name: String)
    case asset(name: String)
    case image(image: UIImage)
}

public struct ActionSheet{
    public let icon: ActionIcon
    public let title: String
    public init(icon: ActionIcon, title: String) {
        self.icon = icon
        self.title = title
    }
}

public struct ActionSheetStyle {
    public var itemTextColor: UIColor
    public var itemFont: UIFont
    public var cancelTextColor: UIColor
    public var cancelFont: UIFont
    public var titleTextColor: UIColor
    public var titleFont: UIFont
    public var iconTintColor: UIColor
    public var iconBackgroundColor: UIColor
    public var titleBackgroundColor: UIColor = .white
    public var itemBackgroundColor: UIColor = .white
    public var cancelBackgroundColor: UIColor = .white
    
    
    public init(
        itemTextColor: UIColor = .black,
        itemFont: UIFont = .boldSystemFont(ofSize: 16),
        cancelTextColor: UIColor = .systemBlue,
        cancelFont: UIFont = .boldSystemFont(ofSize: 18),
        titleTextColor: UIColor = .black,
        titleFont: UIFont = .boldSystemFont(ofSize: 18),
        iconTintColor: UIColor = .black,
        iconBackgroundColor: UIColor = .lightGray,
        titleBackgroundColor: UIColor = .white,
        itemBackgroundColor: UIColor = .white,
        cancelBackgroundColor: UIColor = .white
    ) {
        self.itemTextColor = itemTextColor
        self.itemFont = itemFont
        self.cancelTextColor = cancelTextColor
        self.cancelFont = cancelFont
        self.titleTextColor = titleTextColor
        self.titleFont = titleFont
        self.iconTintColor = iconTintColor
        self.iconBackgroundColor = iconBackgroundColor
        self.titleBackgroundColor = titleBackgroundColor
        self.itemBackgroundColor = itemBackgroundColor
        self.cancelBackgroundColor = cancelBackgroundColor
    }
}

public class CustomActionSheet: UIView {
    
    private let screen = UIScreen.main.bounds
    private let backgroundView = UIView()
    private let containerView = UIView()
    private let stackView = UIStackView()
    private let sheetTitle = UILabel()
    private let cancelButton = UIButton(type: .system)
    private let buttonHeight: CGFloat = 50
    private let spacing: CGFloat = 10
    private var style: ActionSheetStyle!
    private var onSelect: ((Int) -> Void)?
    
    public init(actions: [ActionSheet],title: String,style: ActionSheetStyle, onSelect: @escaping (Int) -> Void) {
        super.init(frame: UIScreen.main.bounds)
        self.onSelect = onSelect
        self.style = style
        setupUI(actions: actions, title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(actions: [ActionSheet], title: String) {
        
        self.backgroundColor = .clear
        self.frame = bounds
        backgroundView.frame = bounds
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0.3
        self.addSubview(backgroundView)
        
        backgroundView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        tapGesture.numberOfTapsRequired = 1
        backgroundView.addGestureRecognizer(tapGesture)
        containerView.backgroundColor = .clear
        
        let containerHeight = CGFloat(actions.count) * buttonHeight + 125 + buttonHeight
        containerView.frame = CGRect(x: 0, y: screen.height - containerHeight, width: screen.width, height: containerHeight)
        self.containerView.frame.origin.y = self.bounds.height
        self.addSubview(containerView)
        
        configureCancelButton()
        configureStackView(actions.count)
        for index in 0..<actions.count {
            let action = actions[index]
            let isFirst = index == 0
            let isLast = index == actions.count - 1
            let button = creatButton(action: action, tag: index, isFirst: isFirst, isLast: isLast)
            stackView.addArrangedSubview(button)
        }
        
        if title.isEmpty {
            sheetTitle.frame = CGRect(x: 15, y: 5, width: containerView.frame.width - 30, height: 0)
        }else {
            sheetTitle.frame = CGRect(x: 15, y: 5, width: containerView.frame.width - 30, height: 48)
        }
        sheetTitle.textColor = style.titleTextColor
        sheetTitle.font = style.titleFont
        sheetTitle.backgroundColor = style.titleBackgroundColor
        sheetTitle.textAlignment = .center
        sheetTitle.text = title
        sheetTitle.layer.masksToBounds = true
        sheetTitle.layer.cornerRadius = 10
        addShadow(on: sheetTitle)
        containerView.addSubview(sheetTitle)
        
    }
    private func configureStackView(_ count: Int){
        let totalHeight = CGFloat(count) * buttonHeight + 30
        containerView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 0.5
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .lightGray
        
        stackView.frame = CGRect(x: 15, y: containerView.frame.height - (totalHeight + buttonHeight + 30 + 10), width: screen.width - 30 , height: totalHeight)
        
        addShadow(on: stackView)
    }
    private func configureCancelButton(){
        containerView.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = style.cancelFont
        cancelButton.tintColor = style.cancelTextColor
        cancelButton.backgroundColor = style.cancelBackgroundColor
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 10
        NSLayoutConstraint.activate([
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            cancelButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            cancelButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            cancelButton.heightAnchor.constraint(equalToConstant: buttonHeight),
        ])
        
        cancelButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        addShadow(on: cancelButton)
    }
    
    private func creatButton(action: ActionSheet, tag: Int, isFirst: Bool, isLast: Bool)->UIView  {
        let iconBGHeight:CGFloat = buttonHeight * 0.65
        let iconHeight:CGFloat = buttonHeight * 0.45
        
        let view = UIView()
        view.backgroundColor = style.itemBackgroundColor
        view.frame.size = CGSize(width: screen.width - (2 * 20), height: 50)
        view.tag = tag
        view.layer.masksToBounds = true
        
        if isFirst {
            view.layer.cornerRadius = 10
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // top left + top right
        } else if isLast {
            view.layer.cornerRadius = 10
            view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner] // bottom left + bottom right
        } else {
            view.layer.cornerRadius = 0
        }
        
        let itemBGIcon = UIImageView()
        itemBGIcon.translatesAutoresizingMaskIntoConstraints = false
        itemBGIcon.contentMode = .scaleAspectFit
        itemBGIcon.backgroundColor = style.iconBackgroundColor
        
        let itemIcon = UIImageView()
        itemIcon.translatesAutoresizingMaskIntoConstraints = false
        itemIcon.contentMode = .scaleAspectFit
        
        let itemTitle = UILabel()
        itemTitle.translatesAutoresizingMaskIntoConstraints = false
        itemTitle.font = style.itemFont
        itemTitle.textColor = style.itemTextColor
        
        view.addSubview(itemBGIcon)
        view.addSubview(itemIcon)
        view.addSubview(itemTitle)
        itemTitle.text = action.title
        itemBGIcon.layer.masksToBounds = true
        itemIcon.layer.masksToBounds = true
        itemBGIcon.layer.cornerRadius = iconBGHeight / 2
        itemIcon.layer.cornerRadius = iconHeight / 2
        
        switch action.icon {
        case .system(let name):
            itemIcon.image = UIImage(systemName: name)
        case .asset(let name):
            itemIcon.image = UIImage(named: name)
        case .image(let image):
            itemIcon.image = image
        }
        setTintColor(itemIcon, style.iconTintColor)
        
        NSLayoutConstraint.activate([
            itemBGIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            itemBGIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            itemBGIcon.widthAnchor.constraint(equalToConstant: iconBGHeight),
            itemBGIcon.heightAnchor.constraint(equalToConstant: iconBGHeight),
        ])
        
        NSLayoutConstraint.activate([
            itemIcon.centerYAnchor.constraint(equalTo: itemBGIcon.centerYAnchor),
            itemIcon.centerXAnchor.constraint(equalTo: itemBGIcon.centerXAnchor),
            itemIcon.widthAnchor.constraint(equalToConstant: iconHeight),
            itemIcon.heightAnchor.constraint(equalToConstant: iconHeight),
        ])
        
        NSLayoutConstraint.activate([
            itemTitle.leadingAnchor.constraint(equalTo: itemBGIcon.trailingAnchor , constant: 16),
            itemTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor , constant: -10),
            itemTitle.centerYAnchor.constraint(equalTo: itemBGIcon.centerYAnchor, constant: 0),
        ])
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(itemTapping))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        return view
    }
    
    @objc public func dismiss() {
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.frame.origin.y = self.bounds.height
            self.backgroundView.alpha = 0
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
    public func present(in view: UIView) {
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) {
            window.addSubview(self)
        }
        let height = self.containerView.frame.height
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.frame.origin.y = self.bounds.height - height
            self.backgroundView.alpha = 0.3
        })
    }
    
    @objc func itemTapping(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag ?? 0
        if tag != -1 {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            onSelect?(tag)
        }
        dismiss()
    }
    
    private func setTintColor(_ imageView: UIImageView ,_ color: UIColor){
        guard let image = imageView.image else { return }
        let templateImage = image.withRenderingMode(.alwaysTemplate)
        imageView.image = templateImage
        imageView.tintColor = color
    }
    
    private func addShadow(on view: UIView){
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
    }
}
