//
//  MovieFanOnboardingController.swift
//  Ahoy ( https://github.com/xmartlabs/Xniffer)
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
import Ahoy

class MovieFanOnboardingController: OnboardingViewController {

    override func viewDidLoad() {
        presenter = MovieFanPresenter()
        presenter.onOnBoardingFinished = { [weak self] in
            _ = self?.navigationController?.popViewController(animated: true)
        }
        super.viewDidLoad()
    }

}

class MovieFanPresenter: BasePresenter {

    override init() {
        super.init()
        model = [
            (titleText: "For movie lovers",
             bodyText: "View what’s in theaters, trending movies and much more.",
             image: #imageLiteral(resourceName: "onboarding1")),
            (titleText: "Indiana would use it",
             bodyText: "It’s just so sleek and smooth. MovieFan is for you, the fan of movies.",
             image: #imageLiteral(resourceName: "onboarding2")),
            (titleText: "Ready?",
             bodyText: "The onboarding is finished, you are now ready to enjoy movies like never before.",
             image: #imageLiteral(resourceName: "onboarding3"))
        ]
        doneButtonColor = UIColor(colorLiteralRed: 255/255, green: 78/255, blue: 73/255, alpha: 1)
        doneButtonTextColor = .white
        cellBackgroundColor = .black
        textColor = .white
        titleFont = UIFont(name: "Hoefler text", size: 28)!
        bodyFont = UIFont(name: "Hoefler text", size: 20)!
    }

    override func style(cell: UICollectionViewCell, for page: Int) {
        super.style(cell: cell, for: page)
        guard let cell = cell as? OnboardingCell else { return }
        cell.doneButton.layer.cornerRadius = cell.doneButton.frame.height / 2
        cell.doneButton.setTitle("Let's go!", for: .normal)
    }

    override func visibilityChanged(for cell: UICollectionViewCell, at index: Int, amount: CGFloat) {
        guard let cell = cell as? OnboardingCell, index == pageCount - 1  else { return }
        cell.doneButtonBottomConstraint.constant = 60 * amount
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
    }
    
}
