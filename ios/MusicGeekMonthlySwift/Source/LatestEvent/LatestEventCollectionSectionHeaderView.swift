import UIKit

class LatestEventCollectionSectionHeaderView: UICollectionReusableView {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.textAlignment = .center

        addSubview(label)

        let constraints: [NSLayoutConstraint] = label.anchorTo(view: self, inset: 4.0)
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
