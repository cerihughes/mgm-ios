import UIKit

class FullWidthCollectionViewLayout: UICollectionViewLayout {
    private let defaultItemHeight: CGFloat
    private let borderSpacing: CGFloat
    private let itemSpacing: CGFloat
    private let sectionSpacing: CGFloat

    private var cache = [UICollectionViewLayoutAttributes]()

    init(itemHeight: CGFloat, spacing: CGFloat) {
        self.defaultItemHeight = itemHeight
        self.borderSpacing = spacing
        self.itemSpacing = spacing
        self.sectionSpacing = spacing

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func contentViewSize(in section: Int) -> CGSize {
        var contentWidth: CGFloat = 0.0
        if let collectionView = collectionView {
            contentWidth = collectionView.bounds.width - (2 * itemSpacing)
        }
        let height = itemHeight(in: section)
        let contentHeight = height - (2 * itemSpacing)
        return CGSize(width: contentWidth, height: contentHeight)
    }

    // MARK: UICollectionViewLayout

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }

        let contentWidth = collectionView.bounds.width
        var contentHeight: CGFloat = borderSpacing * 2.0

        for section in 0 ..< collectionView.numberOfSections {
            let items = CGFloat(collectionView.numberOfItems(inSection: section))
            let height = itemHeight(in: section)
            let sectionHeight = ((height + itemSpacing) * items) - itemSpacing

            contentHeight += sectionHeight + sectionSpacing
        }

        contentHeight -= sectionSpacing

        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

        cache.removeAll()

        let x: CGFloat = itemSpacing
        var y: CGFloat = itemSpacing
        let width = collectionView.bounds.width - (2 * itemSpacing)
        for section in 0 ..< collectionView.numberOfSections {
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let height = itemHeight(in: section)
                let frame = CGRect(x: x, y: y, width: width, height: height)
                attributes.frame = frame
                cache.append(attributes)
                y += height + itemSpacing
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }
        return collectionView.bounds.width != newBounds.width
    }

    // MARK: Private

    func itemHeight(in section: Int) -> CGFloat {
        return defaultItemHeight
    }
}
