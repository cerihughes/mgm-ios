import UIKit

class FullWidthCollectionViewLayout: UICollectionViewLayout {
    private let itemHeight: CGFloat
    private let spacing: CGFloat

    private var cache = [UICollectionViewLayoutAttributes]()

    init(itemHeight: CGFloat, spacing: CGFloat) {
        self.itemHeight = itemHeight
        self.spacing = spacing

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var contentViewSize: CGSize {
        let dimension = itemHeight - (2 * spacing)
        return CGSize(width: dimension, height: dimension)
    }

    // MARK: UICollectionViewLayout

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }

        let numberOfItems = CGFloat(collectionView.numberOfItems(inSection: 0))
        let contentWidth = collectionView.bounds.width
        let contentHeight = ((itemHeight + spacing) * numberOfItems) + spacing

        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

        cache.removeAll(keepingCapacity: false)

        let x: CGFloat = spacing
        var y: CGFloat = spacing
        let width = collectionView.bounds.size.width - (2 * spacing)
        for section in 0 ..< collectionView.numberOfSections {
            for item in 0 ..< collectionView.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

                let frame = CGRect(x: x, y: y, width: width, height: itemHeight)
                attributes.frame = frame
                cache.append(attributes)
                y += itemHeight + spacing
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
}
