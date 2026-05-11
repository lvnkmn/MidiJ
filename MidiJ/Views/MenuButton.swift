import OnionUI
import Combine
import UIKit

class MenuButton: Control {
    internal init(
        menuVisibility: any Publisher<MenuVisibility, Never>,
        cancelables: Set<AnyCancellable> = Set<AnyCancellable>()
    ) {
        self.menuVisibility = menuVisibility
        self.cancelables = cancelables
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct MenuVisibility: Equatable {
        let isHidden: Bool
        let menuDepth: MenuDepth
        
        enum MenuDepth: Equatable {
            case displayedAtRoot, displayedAtSubLevel
            
            var isDisplayedAtRoot: Bool {
                switch self {
                case .displayedAtRoot: return true
                case .displayedAtSubLevel: return false
                }
            }
        }
        
        static var initial: MenuVisibility {
            .init(isHidden: true, menuDepth: .displayedAtRoot)
        }
    }
    
    private let chevronIconView = UIImageView()
    let menuVisibility: any Publisher<MenuVisibility, Never>
    
    private var cancelables = Set<AnyCancellable>()
    
    override func setupViewProperties() {
        super.setupViewProperties()
    
        menuVisibility
            .eraseToAnyPublisher()
            .map(\.chevronImageName)
            .map(UIImage.init(named:))
            .assign(to: \.image, on: chevronIconView)
            .store(in: &cancelables)
    }
    
    override func setupViewHierarchy() {
        addPinnedSubView {
            UIStackView()
                .horizontalize()
                .setting(spacing: .Constants.spacing08)
                .addArrangedSubViews {
                    UILabel()
                        .setting(text: "Menu")
                        .setting(font: .systemFont(ofSize: .Constants.fontSize20, weight: .semibold))
                    chevronIconView
                }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            setupViewProperties()
        }
    }
}

extension MenuButton.MenuVisibility {
    var chevronImageName: String {
        guard !isHidden else { return "Chevron-down" }
        
        switch menuDepth {
        case .displayedAtRoot:
            return "Chevron-up"
        case .displayedAtSubLevel:
            return "Chevron-left"
        }
    }
}
