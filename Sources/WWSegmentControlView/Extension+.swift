//
//  Extension+.swift
//  WWSegmentControlView
//
//  Created by William.Weng on 2022/1/5.
//

import UIKit

// MARK: - Int (class function)
extension Int {
    
    /// 轉成CGFloat
    /// - Returns: CGFloat
    func _CGFloat() -> CGFloat { return CGFloat(self) }
}

// MARK: - Collection (override class function)
extension Collection {

    /// [為Array加上安全取值特性 => nil](https://stackoverflow.com/questions/25329186/safe-bounds-checked-array-lookup-in-swift-through-optional-bindings)
    subscript(safe index: Index) -> Element? { return indices.contains(index) ? self[index] : nil }
}


// MARK: - CALayer (class function)
extension CALayer {
    
    /// 設定圓角
    /// - 可以個別設定要哪幾個角
    /// - 預設是四個角全是圓角
    /// - Parameters:
    ///   - radius: 圓的半徑
    ///   - corners: 圓角要哪幾個邊
    func _maskedCorners(radius: CGFloat, corners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]) {
        
        self.masksToBounds = true
        self.maskedCorners = corners
        self.cornerRadius = radius
    }
}

// MARK: - UIView (class function)
extension UIView {
    
    /// 讀取Nib畫面 => 加到View上面
    func _initViewFromXib(with bundle: Bundle = .module) -> Bool {
        
        guard let name = Optional.some(String(describing: Self.self)),
              let contentView = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? UIView
        else {
            return false
        }
        
        contentView.frame = bounds
        addSubview(contentView)
        
        return true
    }
}

// MARK: - NSLayoutConstraint (class function)
extension NSLayoutConstraint {
    
    /// [更新比例倍數](https://www.jianshu.com/p/afa79ad6605e)
    /// - Parameter multiplier: [CGFloat](https://stackoverflow.com/questions/37294522/ios-change-the-multiplier-of-constraint-by-swift)
    /// - Returns: NSLayoutConstraint
    func _multiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        
        guard let firstItem = firstItem else { fatalError() }
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier
        
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
    
    /// 修改第二個基準點
    func _secondItem(_ secondItem: UIView) -> NSLayoutConstraint {
        
        guard let firstItem = firstItem else { fatalError() }
        
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(
            item: firstItem,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier
                
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}

