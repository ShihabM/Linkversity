//
//  TwicketSegmentedControl.swift
//  TwicketSegmentedControlDemo
//
//  Created by Pol Quintana on 7/11/15.
//  Copyright © 2015 Pol Quintana. All rights reserved.
//

import UIKit

public protocol TwicketSegmentedControlDelegate: class {
    func didSelect(_ segmentIndex: Int)
}

class TwicketSegmentedControl: UIControl {
    static let height: CGFloat = Constants.height + Constants.topBottomMargin * 2

    struct Constants {
        static let height: CGFloat = 30
        static let topBottomMargin: CGFloat = 5
        static let leadingTrailingMargin: CGFloat = 10
    }

    class SliderView: UIView {
        // MARK: - Properties
        let sliderMaskView = UIView()

        var cornerRadius: CGFloat! {
            didSet {
                layer.cornerRadius = cornerRadius
                sliderMaskView.layer.cornerRadius = cornerRadius
            }
        }

        override var frame: CGRect {
            didSet {
                sliderMaskView.frame = frame
            }
        }

        override var center: CGPoint {
            didSet {
                sliderMaskView.center = center
            }
        }

        init() {
            super.init(frame: .zero)
            setup()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }

        private func setup() {
            layer.masksToBounds = true
            sliderMaskView.backgroundColor = UIColor.black
            //sliderMaskView.addShadow(with: UIColor.blackColor())
        }
    }

    weak var delegate: TwicketSegmentedControlDelegate?

    var defaultTextColor: UIColor = Palette.defaultTextColor {
        didSet {
            updateLabelsColor(with: defaultTextColor, selected: false)
        }
    }

    var highlightTextColor: UIColor = Palette.highlightTextColor {
        didSet {
            updateLabelsColor(with: highlightTextColor, selected: true)
        }
    }

    var segmentsBackgroundColor: UIColor = Palette.segmentedControlBackgroundColor {
        didSet {
            backgroundView.backgroundColor = backgroundColor
        }
    }

    var sliderBackgroundColor: UIColor = Palette.sliderColor {
        didSet {
            selectedContainerView.backgroundColor = sliderBackgroundColor
        }
    }

    var font: UIFont = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium) {
        didSet {
            updateLabelsFont(with: font)
        }
    }

    private(set) var selectedSegmentIndex: Int = 0

    var segments: [String] = []

    var numberOfSegments: Int {
        return segments.count
    }

    var segmentWidth: CGFloat {
        return self.backgroundView.frame.width / CGFloat(numberOfSegments)
    }

    var correction: CGFloat = 0

    lazy var containerView: UIView = UIView()
    lazy var backgroundView: UIView = UIView()
    lazy var selectedContainerView: UIView = UIView()
    lazy var sliderView: SliderView = SliderView()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    func setup() {
        addSubview(containerView)
        containerView.addSubview(backgroundView)
        containerView.addSubview(selectedContainerView)
        containerView.addSubview(sliderView)

        selectedContainerView.layer.mask = sliderView.sliderMaskView.layer
        addTapGesture()
        addDragGesture()
    }

    func setSegmentItems(_ segments: [String]) {
        guard !segments.isEmpty else { fatalError("Segments array cannot be empty") }

        self.segments = segments
        configureViews()

        clearLabels()

        for (index, title) in segments.enumerated() {
            let baseLabel = createLabel(with: title, at: index, selected: false)
            let selectedLabel = createLabel(with: title, at: index, selected: true)
            backgroundView.addSubview(baseLabel)
            selectedContainerView.addSubview(selectedLabel)
        }

        setupAutoresizingMasks()
    }

    func configureViews() {
        containerView.frame = CGRect(x: Constants.leadingTrailingMargin,
                                     y: Constants.topBottomMargin,
                                     width: bounds.width - Constants.leadingTrailingMargin * 2,
                                     height: Constants.height)
        let frame = containerView.bounds
        backgroundView.frame = frame
        selectedContainerView.frame = frame
        sliderView.frame = CGRect(x: 0, y: 0, width: segmentWidth, height: backgroundView.frame.height)

        let cornerRadius = backgroundView.frame.height / 2
        [backgroundView, selectedContainerView].forEach { $0.layer.cornerRadius = cornerRadius }
        sliderView.cornerRadius = cornerRadius

        backgroundColor = segmentsBackgroundColor
        backgroundView.backgroundColor = segmentsBackgroundColor
        selectedContainerView.backgroundColor = sliderBackgroundColor

        //selectedContainerView.addShadow(with: sliderBackgroundColor)
    }

    func setupAutoresizingMasks() {
        containerView.autoresizingMask = [.flexibleWidth]
        backgroundView.autoresizingMask = [.flexibleWidth]
        selectedContainerView.autoresizingMask = [.flexibleWidth]
        sliderView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
    }

    // MARK: Labels

    func clearLabels() {
        backgroundView.subviews.forEach { $0.removeFromSuperview() }
        selectedContainerView.subviews.forEach { $0.removeFromSuperview() }
    }

    func createLabel(with text: String, at index: Int, selected: Bool) -> UILabel {
        let rect = CGRect(x: CGFloat(index) * segmentWidth, y: 0, width: segmentWidth, height: backgroundView.frame.height)
        let label = UILabel(frame: rect)
        label.text = text
        label.textAlignment = .center
        label.textColor = selected ? highlightTextColor : defaultTextColor
        label.font = font
        label.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleWidth]
        return label
    }

    func updateLabelsColor(with color: UIColor, selected: Bool) {
        let containerView = selected ? selectedContainerView : backgroundView
        containerView.subviews.forEach { ($0 as? UILabel)?.textColor = color }
    }

    func updateLabelsFont(with font: UIFont) {
        selectedContainerView.subviews.forEach { ($0 as? UILabel)?.font = font }
        backgroundView.subviews.forEach { ($0 as? UILabel)?.font = font }
    }

    // MARK: Tap gestures

    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tap)
    }

    func addDragGesture() {
        let drag = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        sliderView.addGestureRecognizer(drag)
    }

    @objc func didTap(tapGesture: UITapGestureRecognizer) {
        moveToNearestPoint(basedOn: tapGesture)
    }

    @objc func didPan(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .cancelled, .ended, .failed:
            moveToNearestPoint(basedOn: panGesture, velocity: panGesture.velocity(in: sliderView))
        case .began:
            correction = panGesture.location(in: sliderView).x - sliderView.frame.width/2
        case .changed:
            let location = panGesture.location(in: self)
            sliderView.center.x = location.x - correction
        case .possible: ()
        }
    }

    // MARK: Slider position

    func moveToNearestPoint(basedOn gesture: UIGestureRecognizer, velocity: CGPoint? = nil) {
        var location = gesture.location(in: self)
        if let velocity = velocity {
            let offset = velocity.x / 12
            location.x += offset
        }
        let index = segmentIndex(for: location)
        move(to: index)
        delegate?.didSelect(index)
    }

    func move(to index: Int) {
        let correctOffset = center(at: index)
        animate(to: correctOffset)

        selectedSegmentIndex = index
    }

    func segmentIndex(for point: CGPoint) -> Int {
        var index = Int(point.x / sliderView.frame.width)
        if index < 0 { index = 0 }
        if index > numberOfSegments - 1 { index = numberOfSegments - 1 }
        return index
    }

    func center(at index: Int) -> CGFloat {
        let xOffset = CGFloat(index) * sliderView.frame.width + sliderView.frame.width / 2
        return xOffset
    }

    func animate(to position: CGFloat) {
        UIView.animate(withDuration: 0.2, animations: {
            self.sliderView.center.x = position
        })
    }
}
