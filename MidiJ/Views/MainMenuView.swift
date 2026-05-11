import SourceSeeds
import OnionUI
import UIKit

class MainMenuView: StrictlySetupView {
    
    let title: String
    let rows: [UIView]
    
    internal init(title: String, @ArrayBuilder rows: () -> [UIView]) {
        self.title = title
        self.rows = rows()
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupViewHierarchy() {
        layoutMargins = .init(top: .zero, left: .Constants.spacing16, bottom: .Constants.spacing16, right: .Constants.spacing16)
        addPinnedSubView() {
            UIStackView()
                .verticalize()
                .setting(spacing: .Constants.spacing20)
                .addArrangedSubViews {
                    UILabel()
                        .setting(font: .systemFont(ofSize: .Constants.fontSize48))
                        .setting(text: title)
                    UIStackView()
                        .verticalize()
                        .setting(allignment: .fill)
                        .setting(distribution: .fill)
                        .setting(spacing: .Constants.spacing20)
                        .addArrangedSubViews(
                            rows
                                .mutated { it in
                                    it.first?
                                        .mutated { it in
                                            it.setContentHuggingPriority(.required, for: .vertical)
                                        }
                                }
                        )
                        .verticalyScollable()
                        .mutated { it in
                            it.layoutMargins = .zero
                        }
                }
        }
    }
}

extension Array: Mutatable {}
