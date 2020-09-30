import UIKit

class FullWidthCollectionViewLayout: UICollectionViewLayout {
    enum Element: String {
        case sectionHeader
        case item

        var value: String {
            return rawValue
        }
    }

    private let sectionHeaderHeight: CGFloat
    private let defaultItemHeight: CGFloat
    private let itemHeightOverrides: [Int: CGFloat]

    private let borderSpacing: CGFloat
    private let itemSpacing: CGFloat
    private let sectionSpacing: CGFloat

    private var itemCache: [UICollectionViewLayoutAttributes] = []
    private var sectionHeaderCache: [UICollectionViewLayoutAttributes] = []

    init(sectionHeaderHeight: CGFloat, defaultItemHeight: CGFloat, itemHeightOverrides: [Int: CGFloat], spacing: CGFloat) {
        self.sectionHeaderHeight = sectionHeaderHeight
        self.defaultItemHeight = defaultItemHeight
        self.itemHeightOverrides = itemHeightOverrides
        borderSpacing = spacing
        itemSpacing = spacing
        sectionSpacing = spacing

        super.init()
    }

    convenience init(defaultItemHeight: CGFloat, itemHeightOverrides: [Int: CGFloat], spacing: CGFloat) {
        self.init(sectionHeaderHeight: 0.0, defaultItemHeight: defaultItemHeight, itemHeightOverrides: itemHeightOverrides, spacing: spacing)
    }

    convenience init(sectionHeaderHeight: CGFloat, itemHeight: CGFloat, spacing: CGFloat) {
        self.init(sectionHeaderHeight: sectionHeaderHeight, defaultItemHeight: itemHeight, itemHeightOverrides: [:], spacing: spacing)
    }

    convenience init(itemHeight: CGFloat, spacing: CGFloat) {
        self.init(defaultItemHeight: itemHeight, itemHeightOverrides: [:], spacing: spacing)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
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
            var headerHeight: CGFloat = 0.0
            if sectionHeaderHeight > 0.0 {
                headerHeight = sectionHeaderHeight + itemSpacing
            }
            let height = itemHeight(in: section)
            let sectionHeight = headerHeight + ((height + itemSpacing) * items) - itemSpacing

            contentHeight += sectionHeight + sectionSpacing
        }

        contentHeight -= sectionSpacing

        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

        itemCache.removeAll()
        sectionHeaderCache.removeAll()

        let x: CGFloat = itemSpacing
        var y: CGFloat = itemSpacing
        let width = collectionView.bounds.width - (2 * itemSpacing)
        for section in 0 ..< collectionView.numberOfSections {
            if sectionHeaderHeight > 0.0 {
                let indexPath = IndexPath(item: 0, section: section)
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: Element.sectionHeader.value, with: indexPath)
                let frame = CGRect(x: x, y: y, width: width, height: sectionHeaderHeight)
                attributes.frame = frame
                sectionHeaderCache.append(attributes)
                y += sectionHeaderHeight + itemSpacing
            }

            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                let height = itemHeight(in: section)
                let frame = CGRect(x: x, y: y, width: width, height: height)
                attributes.frame = frame
                itemCache.append(attributes)
                y += height + itemSpacing
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in sectionHeaderCache + itemCache {
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
        guard let itemHeight = itemHeightOverrides[section] else {
            return defaultItemHeight
        }
        return itemHeight
    }
}

extension UICollectionViewLayout {
    func createCollectionView(frame: CGRect = .zero) -> UICollectionView {
        return UICollectionView(frame: frame, collectionViewLayout: self)
    }
}
