//
//  OnboardingPresenter.swift
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

public protocol OnboardingPresenter: class {

    var pageCount: Int {
        get
    }

    var cellProviders: [Int: CellProvider] {
        get
    }

    var defaultProvider: CellProvider? {
        get
    }

    var onOnboardingSkipped: ( () -> () )? {
        get
        set
    }

    var onOnBoardingFinished: ( () -> () )? {
        get
        set
    }

    func visibilityChanged(for cell: UICollectionViewCell, at index: Int, amount: CGFloat)

    func style(pageControl: UIPageControl?)

    func style(collection: UICollectionView?)

    func style(skip: UIButton?)

    func style(cell: UICollectionViewCell, for page: Int)

    func reuseIdentifier(for page: Int) -> String

}

extension OnboardingPresenter {

    public func reuseIdentifier(for page: Int) -> String {
        guard let provider = cellProviders[page] == nil ? defaultProvider : cellProviders[page] else {
            return ""
        }
        switch provider {
        case .nib(_, let identifier, _):
            return identifier
        case .cellClass(_, let identifier):
            return identifier
        }
    }

}

public enum CellProvider {

    case nib(name:String, identifier: String, bundle: Bundle?)
    case cellClass(className: Swift.AnyClass, identifier: String)

}
