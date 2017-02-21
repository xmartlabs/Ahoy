//
//  BottomOnboardingController.swift
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

open class BottomOnobardingController: OnboardingViewController {

    @IBOutlet weak var nextButton: UIButton!

    override open func viewDidLoad() {
        presenter = BottomPresenter()
        super.viewDidLoad()
        setupNextButton()
    }

    open func setupNextButton() {
        nextButton.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped(sender:)), for: .touchUpInside)
    }

    override open func pageChanged(to page: Int) {
        pageControl?.currentPage = page
        nextButton.setTitle(page == presenter.pageCount - 1 ? NSLocalizedString("Done", comment: "") : NSLocalizedString("Next", comment: ""), for: .normal)
    }

    open func nextTapped(sender: UIButton) {
        if currentPage == presenter.pageCount - 1 {
            _ = navigationController?.popViewController(animated: true)
        } else {
            currentPage = currentPage + 1
            let index = IndexPath(row: currentPage, section: 0)
            collectionView?.scrollToItem(at: index, at: UICollectionViewScrollPosition.left, animated: true)
        }
    }

}
