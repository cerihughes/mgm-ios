import UIKit

extension UIView {

    func anchorTo(leadingAnchor: NSLayoutXAxisAnchor? = nil, leadingConstant: CGFloat = 0,
                  trailingAnchor: NSLayoutXAxisAnchor? = nil, trailingConstant: CGFloat = 0,
                  topAnchor: NSLayoutYAxisAnchor? = nil, topConstant: CGFloat = 0,
                  bottomAnchor: NSLayoutYAxisAnchor? = nil, bottomConstant: CGFloat = 0,
                  centerXAnchor: NSLayoutXAxisAnchor? = nil, centerXConstant: CGFloat = 0,
                  centerYAnchor: NSLayoutYAxisAnchor? = nil, centerYConstant: CGFloat = 0,
                  widthAnchor: NSLayoutDimension? = nil, widthConstant: CGFloat = 0, widthMultiplier: CGFloat = 1,
                  heightAnchor: NSLayoutDimension? = nil, heightConstant: CGFloat = 0, heightMultiplier: CGFloat = 1) -> [NSLayoutConstraint] {

        var constraints: [NSLayoutConstraint] = []

        if let anchor = leadingAnchor {
            constraints.append(self.leadingAnchor.constraint(equalTo: anchor, constant: leadingConstant))
        }

        if let anchor = trailingAnchor {
            constraints.append(self.trailingAnchor.constraint(equalTo: anchor, constant: trailingConstant))
        }

        if let anchor = topAnchor {
            constraints.append(self.topAnchor.constraint(equalTo: anchor, constant: topConstant))
        }

        if let anchor = bottomAnchor {
            constraints.append(self.bottomAnchor.constraint(equalTo: anchor, constant: bottomConstant))
        }

        if let anchor = centerXAnchor {
            constraints.append(self.centerXAnchor.constraint(equalTo: anchor, constant: centerXConstant))
        }

        if let anchor = centerYAnchor {
            constraints.append(self.centerYAnchor.constraint(equalTo: anchor, constant: centerYConstant))
        }

        if let anchor = widthAnchor {
            constraints.append(self.widthAnchor.constraint(equalTo: anchor, multiplier: widthMultiplier, constant: widthConstant))
        }

        if let anchor = heightAnchor {
            constraints.append(self.heightAnchor.constraint(equalTo: anchor, multiplier: heightMultiplier, constant: heightConstant))
        }

        return constraints
    }

    func anchorTo(view: UIView, inset: CGFloat = 0) -> [NSLayoutConstraint] {
        return anchorTo(leadingAnchor: view.leadingAnchor, leadingConstant: inset,
                        trailingAnchor: view.trailingAnchor, trailingConstant: -inset,
                        topAnchor: view.topAnchor, topConstant: inset,
                        bottomAnchor: view.bottomAnchor, bottomConstant: -inset)
    }

    func anchorTo(layoutGuide: UILayoutGuide, inset: CGFloat = 0) -> [NSLayoutConstraint] {
        return anchorTo(leadingAnchor: layoutGuide.leadingAnchor, leadingConstant: inset,
                        trailingAnchor: layoutGuide.trailingAnchor, trailingConstant: -inset,
                        topAnchor: layoutGuide.topAnchor, topConstant: inset,
                        bottomAnchor: layoutGuide.bottomAnchor, bottomConstant: -inset)
    }
}
