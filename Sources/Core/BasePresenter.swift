//
//  BasePresenter.swift
//  Ahoy (https://github.com/xmartlabs/Ahoy)
//
//  Copyright (c) 2017 Xmartlabs ( http://xmartlabs.com )
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
import UIKit

public struct OnboardingSlide {

    public let titleText: String
    public let bodyText: String
    public let image: UIImage?

    public init(titleText: String, bodyText: String, image: UIImage?) {
        self.titleText = titleText
        self.bodyText = bodyText
        self.image = image
    }

}

open class BasePresenter: OnboardingPresenter {

    // MARK: Customizable properties
    public var cellBackgroundColor: UIColor = .orange
    public var doneButtonColor: UIColor = .white
    public var doneButtonTextColor: UIColor = .black
    public var textColor: UIColor = .white
    public var swipeLabelText = ""
    public var titleFont: UIFont = .boldSystemFont(ofSize: 24)
    public var bodyFont: UIFont = .systemFont(ofSize: 18)
    public var skipColor: UIColor = .white
    public var skipTitle: String = NSLocalizedString("Skip", comment: "")
    open var model: [OnboardingSlide] = [
        OnboardingSlide(titleText: "Title 1",
         bodyText: "Subtitle 1",
         image: nil),
        OnboardingSlide(titleText: "Title 2",
         bodyText: "Subtitle 2",
         image: nil),
        OnboardingSlide(titleText: "Title 3",
         bodyText: "Subtitle 3",
         image: nil)
        ]

    // MARK: OnboardingPresenter protocol
    public var onOnBoardingFinished: (() -> ())?
    public var onOnboardingSkipped: (() -> ())?

    public var cellProviders: [Int: CellProvider] {
        return [:]
    }

    public var defaultProvider: CellProvider? = .nib(
        name:"OnboardingCell",
        identifier: OnboardingCell.reuseIdentifier,
        bundle: Resources.bundle
    )
    
    public var pageCount: Int {
        return model.count
    }

    public init() {}

    open func visibilityChanged(for cell: UICollectionViewCell, at index: Int, amount: CGFloat) {
        guard let cell = cell as? OnboardingCell, index == pageCount - 1  else { return }
        cell.doneButtonBottomConstraint.constant = 60 * amount
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }

    open func style(pageControl: UIPageControl?) {
        pageControl?.backgroundColor = .clear
        pageControl?.numberOfPages = pageCount
        pageControl?.pageIndicatorTintColor = .lightGray
        pageControl?.currentPageIndicatorTintColor = .white
    }

    open func style(collection: UICollectionView?) { }

    open func style(skip: UIButton?) {
        skip?.setTitle(skipTitle, for: .normal)
        skip?.setTitleColor(skipColor, for: .normal)
    }

    @objc open func didFinishOnboarding() {
        onOnBoardingFinished?()
    }

    open func didSkipOnobarding() {
        onOnboardingSkipped?()
    }

    open func style(cell: UICollectionViewCell, for page: Int) {
        guard let cell = cell as? OnboardingCell else { return }
        cell.backgroundColor = cellBackgroundColor
        cell.imageView?.image = model[page].image

        cell.label.text = model[page].titleText
        cell.label.textColor = textColor
        cell.label.font = titleFont

        cell.bodyLabel.text = model[page].bodyText
        cell.bodyLabel.textColor = textColor
        cell.bodyLabel.font = bodyFont

        cell.doneButton.isHidden = page != model.count - 1
        cell.doneButton.addTarget(self, action: #selector(BasePresenter.didFinishOnboarding), for: .touchUpInside)
        cell.doneButton.backgroundColor = doneButtonColor
        cell.doneButton.setTitleColor(doneButtonTextColor, for: .normal)

        cell.swipeLabel.isHidden = page != 0
        cell.swipeLabel.textColor = textColor
        cell.swipeLabel.text = swipeLabelText
    }

}
