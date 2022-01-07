//
//  ViewController.swift
//  WWSegmentControlView
//
//  Created by William.Weng on 2022/01/05.
//  ~/Library/Caches/org.swift.swiftpm/
//  file:///Users/william/Desktop/WWSegmentControlView

import UIKit

final class ViewController: UIViewController {
    
    private enum SegmentControlViewType: Int {
        case base = 1000
        case plus = 2000
    }
    
    @IBOutlet weak var selectedLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var baseSegmentControlView: WWSegmentControlView!
    @IBOutlet weak var plusSegmentControlView: WWSegmentControlView!

    private let selectedImages = [#imageLiteral(resourceName: "LightHighlight"), #imageLiteral(resourceName: "LightOn"), #imageLiteral(resourceName: "LightOff")]
    private var currentIndex: Int = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        baseSegmentControlView.myDelegate = self
        plusSegmentControlView.myDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initSetting()
    }
    
    @objc func didSelectBaseButton(_ sender: UIButton) {
        baseSegmentControlView.selectedIndex(sender.tag, animationType: .moving)
    }
    
    @objc func didSelectPlusButton(_ sender: UIButton) {
        plusSegmentControlView.selectedIndex(sender.tag, animationType: .dumping)
    }
}

// MARK: - WWSegmentControlDelegate
extension ViewController: WWSegmentControlDelegate {
    
    func willMoveSegmentControl(_ segmentControl: WWSegmentControlView, from fromIndex: Int, to toIndex: Int) {
        selectedLabel.text = "\(fromIndex) to \(toIndex)"
    }
    
    func didMovedSegmentControl(_ segmentControl: WWSegmentControlView, to index: Int) {
        
        guard let type = SegmentControlViewType.init(rawValue: segmentControl.tag) else { return }
        
        switch type {
        case .base:
            selectedLabel.text = "\(index)"
        case .plus:
            selectedLabel.text = "\(index)"
            selectedImageView.image = selectedImages[safe: index]
        }
    }
}

// MARK: - 小工具
extension ViewController {
    
    /// 初始化設定
    func initSetting() {
        
        baseSegmentControlView.tag = SegmentControlViewType.base.rawValue
        baseSegmentControlView.selectedButton.backgroundColor = .black.withAlphaComponent(0.3)
        baseSegmentControlView.controlButtons.forEach { button in
            currentIndex += 1
            button.addTarget(self, action: #selector(didSelectBaseButton(_:)), for: .touchDown)
            button.backgroundColor = .gray
            button.setTitle("\(currentIndex)", for: .normal)
        }
        
        plusSegmentControlView.tag = SegmentControlViewType.plus.rawValue
        plusSegmentControlView.animationInfomation(start: (0.25, 1.0), end: (0.25, 0.8))
        plusSegmentControlView.selectedButton.backgroundColor = .black.withAlphaComponent(0.3)
        plusSegmentControlView.controlButtons.forEach { button in
            button.addTarget(self, action: #selector(didSelectPlusButton(_:)), for: .touchDown)
            button.backgroundColor = .yellow
            button.setTitle("", for: .normal)
            button.setImage(selectedImages[button.tag % selectedImages.count], for: .normal)
        }
    }
}
