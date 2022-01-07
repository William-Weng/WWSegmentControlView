//
//  WWSegmentControlView.swift
//  WWSegmentControlView
//
//  Created by William.Weng on 2022/1/5.
//

import UIKit

public protocol WWSegmentControlDelegate: AnyObject {
    
    func willMoveSegmentControl(_ segmentControl: WWSegmentControlView, from fromIndex: Int, to toIndex: Int)
    func didMovedSegmentControl(_ segmentControl: WWSegmentControlView, to index: Int)
}

@IBDesignable
open class WWSegmentControlView: UIView {
    
    public typealias AnimationInfomation = (duration: Double, dampingRatio: Double)
    
    public enum WWSegmentControlViewAnimationType {
        case none
        case moving
        case dumping
    }
    
    @IBInspectable public var currentIndex: Int = 0
    @IBInspectable public var count: Int = 3
    @IBInspectable public var cornerRadius: CGFloat = 8

    @IBOutlet weak public var selectedButton: UIButton!

    @IBOutlet weak var myStackView: UIStackView!
    @IBOutlet weak var selectedButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedButtonLeadingConstraint: NSLayoutConstraint!
    
    public weak var myDelegate: WWSegmentControlDelegate?
    public var controlButtons: [UIButton] = []
    
    private var animationInfo = (
        start: (duration: 0.25, dampingRatio: 1.0),
        end: (duration: 0.25, dampingRatio: 0.7)
    )
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        _ = self._initViewFromXib()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _ = self._initViewFromXib()
    }
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        initCount(count)
        selectedIndex(currentIndex, animationType: .none)
    }
}

// MARK: - 開放的function
public extension WWSegmentControlView {
        
    /// [初始化](https://medium.com/彼得潘的-swift-ios-app-開發問題解答集/在-storyboard-加入-xib-的-view-e94826a7a8f3)
    func initCount(_ count: Int) {
        
        guard count > 0 else { return }
        
        (0..<count).forEach { index in
            
            let button = UIButton()
            button.backgroundColor = .gray
            button.setTitle("\(index)", for: .normal)
            button.tag = index
                        
            controlButtons.append(button)
            myStackView.addArrangedSubview(button)
        }
        
        selectedButton.layer._maskedCorners(radius: cornerRadius)
        layer._maskedCorners(radius: cornerRadius)
    }
    
    /// 移動到被該index
    /// - Parameters:
    ///   - index: Int
    ///   - animationType: WWSegmentControlViewAnimationType
    func selectedIndex(_ index: Int, animationType: WWSegmentControlViewAnimationType = .none) {
        
        switch animationType {
        case .none: didSelectedIndex(at: index)
        case .dumping: didSelectedIndexWithDamping(at: index)
        case .moving: didSelectedIndexWithMoveing(at: index)
        }
    }
    
    /// 設定動畫的時間 / Q度
    /// - Parameters:
    ///   - start: AnimationInfomation
    ///   - end: AnimationInfomation
    func animationInfomation(start: AnimationInfomation, end: AnimationInfomation) {
        animationInfo.start = start
        animationInfo.end = end
    }
}

// MARK: - 開放的function
private extension WWSegmentControlView {
    
    /// 移動到被該index (無動畫)
    /// - Parameter index: Int
    func didSelectedIndex(at index: Int) {
        
        selectedButtonWidthConstraint = selectedButtonWidthConstraint._multiplier(1 / count._CGFloat())
        selectedButtonHeightConstraint = selectedButtonHeightConstraint._multiplier(1.0)
        
        guard let selectedButton = myStackView.arrangedSubviews[safe: index] as? UIButton else { return }
        
        selectedButtonLeadingConstraint = selectedButtonLeadingConstraint._secondItem(selectedButton)
        currentIndex = index
        myDelegate?.didMovedSegmentControl(self, to: index)
        
        layoutIfNeeded()
    }
    
    /// 移動到被該index (有QQ動畫)
    /// - Parameter index: Int
    func didSelectedIndexWithDamping(at index: Int) {
        
        guard let selectedButton = myStackView.arrangedSubviews[safe: index] else { return }
                
        myDelegate?.willMoveSegmentControl(self, from: currentIndex, to: index)
        
        let animator = UIViewPropertyAnimator(duration: animationInfo.start.duration, dampingRatio: animationInfo.start.dampingRatio, animations: {
            if (index < self.currentIndex) { self.selectedButtonLeadingConstraint = self.selectedButtonLeadingConstraint._secondItem(selectedButton) }
            self.constraintAnimation(with: index)
        })
        
        animator.addCompletion({ _ in
            
            UIViewPropertyAnimator(duration: self.animationInfo.end.duration, dampingRatio: self.animationInfo.end.dampingRatio, animations: {
                
                if (index > self.currentIndex) { self.selectedButtonLeadingConstraint = self.selectedButtonLeadingConstraint._secondItem(selectedButton) }
                self.didSelectedIndex(at: index)
                
            }).startAnimation()
        })
        
        animator.startAnimation()
    }
    
    /// 移動到被該index (有移動動畫)
    /// - Parameter index: Int
    func didSelectedIndexWithMoveing(at index: Int) {
        
        guard let selectedButton = myStackView.arrangedSubviews[safe: index] else { return }
        
        myDelegate?.willMoveSegmentControl(self, from: currentIndex, to: index)
        
        UIViewPropertyAnimator(duration: animationInfo.start.duration, dampingRatio: animationInfo.start.dampingRatio, animations: {
            self.selectedButton.center = selectedButton.center
            self.didSelectedIndex(at: index)
        }).startAnimation()
    }
    
    /// constraintd的動畫效果
    /// - Parameter index: Int
    func constraintAnimation(with index: Int) {
        
        let indexDistance = abs(index - currentIndex) + 1
        let multiplier = indexDistance._CGFloat() / count._CGFloat()
        
        selectedButtonWidthConstraint = selectedButtonWidthConstraint._multiplier(multiplier)
        selectedButtonHeightConstraint = selectedButtonHeightConstraint._multiplier(1 / indexDistance._CGFloat())
        
        layoutIfNeeded()
    }
}
