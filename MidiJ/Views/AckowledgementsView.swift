import OnionUI
import UIKit

final class AckowledgementsView: StrictlySetupView {
    override func setupViewHierarchy() {
        super.setupViewHierarchy()
        addPinnedSubView {
            UIView()
                .addPinnedSubView(withPadding: .make(all: .Constants.spacing16)) {
                    UILabel()
                        .mutated { it in
                            it.attributedText = .from(markDowntext: .Copy.Acknowledgements.Libraries.all)
                            it.numberOfLines = 0
                        }
                }
                .verticalyScollable()
        }
    }
}
