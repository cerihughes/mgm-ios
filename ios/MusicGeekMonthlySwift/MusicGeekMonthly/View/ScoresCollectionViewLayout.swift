import UIKit

class ScoresCollectionViewLayout: UICollectionViewLayout {
    private let itemHeight: CGFloat
    private let verticalSpacing: CGFloat

    private var cache = [UICollectionViewLayoutAttributes]()

    init(itemHeight: CGFloat, verticalSpacing: CGFloat) {
        self.itemHeight = itemHeight
        self.verticalSpacing = verticalSpacing

        super.init()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UICollectionViewLayout

    override var collectionViewContentSize: CGSize {
        guard let collectionView = collectionView else {
            return .zero
        }

        let numberOfItems = CGFloat(collectionView.numberOfItems(inSection: 0))
        let contentWidth = collectionView.bounds.width
        let contentHeight = ((itemHeight + verticalSpacing) * numberOfItems) - verticalSpacing

        return CGSize(width: contentWidth, height: contentHeight)
    }

    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

        cache.removeAll(keepingCapacity: false)

        let x: CGFloat = 0.0
        var y: CGFloat = 0.0
        let width = collectionView.bounds.size.width
        let numberOfItems = collectionView.numberOfItems(inSection: 0)
        for i in 0 ..< numberOfItems {
            let indexPath = IndexPath(item: i, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            let frame = CGRect(x: x, y: y, width: width, height: itemHeight)
            attributes.frame = frame
            cache.append(attributes)
            y += itemHeight + verticalSpacing
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
        return false
    }
}
