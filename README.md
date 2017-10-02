# Ahoy

<p align="left">
<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" />
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift4-compatible-4BC51D.svg?style=flat" alt="Swift 3 compatible" /></a>
<a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible" /></a>
<a href="https://cocoapods.org/pods/Ahoy"><img src="https://img.shields.io/cocoapods/v/Ahoy.svg" alt="CocoaPods compatible" /></a>
<a href="https://raw.githubusercontent.com/xmartlabs/Ahoy/master/LICENSE"><img src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" /></a>
</p>

By [Xmartlabs SRL](http://xmartlabs.com).

## Introduction

Ahoy is a swift library that helps you build awesome onboarding experiences for your users.


<img src="./movie.gif" width="300" height="550"/>
<img src="./bottom.gif" width="300" height="550"/>

## Usage
In order to setup your onboarding you need to define 2 components:
* The specific view controller that you are going to use, which should subclass from `OnboardingViewController`. This will handle all the specific logic related to displaying the slides and managing any global control that you want to use (an skip button for example).
* A `Presenter` which should implement the protocol `OnboardingPresenter`. This will handle all the specific functionality of each cell (which text goes where, the type of cells, etc.)

#### Basic setup
* Create your own presenter implementation, either implementing `OnboardingPresenter` protocol or subclassing from `BasePresenter`.
* Create your `OnboardingViewController` subclass and set the `presenter` property to an instance of your presenter's class. This must be done **before** calling `super.viewDidLoad()`.

After this you are ready to go! You can add any other ui components that you want via IBOutlets or directly by code.
##### Example

```swift
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
  // Your presenter implementation's here
}
```

#### Callbacks
In order to manage user interaction, when the onboarding is finished, skipped or when a slide is being displayed. Ahoy provides a few helpers to manage this consistently:
  * `onOnboardingSkipped`: Is called by the controller when the user taps on the skip action.
  * `onOnBoardingFinished`: Is called by the controller when the user taps on finish.
  * `visibilityChanged(for cell: UICollectionViewCell, at index: Int, amount: CGFloat)`: is called each time the visibility of a cell changes, this can be used to implement some cool animations between each cell.

#### BasePresenter
By default, Ahoy provides an implementation of `OnboardingPresenter`, `BasePresenter` which handles basic functionality and has some customization parameters:

```swift
public var cellBackgroundColor: UIColor
public var doneButtonColor: UIColor
public var doneButtonTextColor: UIColor
public var textColor: UIColor
public var swipeLabelText: String
public var titleFont: UIFont
public var bodyFont: UIFont
public var skipColor: UIColor
public var skipTitle: String
public var model: [OnboardingSlide]
public var onOnBoardingFinished: (() -> ())?
public var onOnboardingSkipped: (() -> ())?
```

#### BottomOnobardingController
Ahoy provides another implementation of the `OnboardingViewController` that has global controls at the bottom of the screen. The `BottomOnobardingController` uses `BottomPresenter` as a Presenter.

## Requirements

* iOS 9.0+
* Xcode 9.0+

## Getting involved

* If you **want to contribute** please feel free to **submit pull requests**.
* If you **have a feature request** please **open an issue**.
* If you **found a bug** or **need help** please **check older issues, [FAQ](#faq) and threads on [StackOverflow](http://stackoverflow.com/questions/tagged/Ahoy) (Tag 'Ahoy') before submitting an issue.**.

Before contribute check the [CONTRIBUTING](https://github.com/xmartlabs/Ahoy/blob/master/CONTRIBUTING.md) file for more info.

If you use **Ahoy** in your app We would love to hear about it! Drop us a line on [twitter](https://twitter.com/xmartlabs).

## Examples

Follow these 3 steps to run Example project: Clone Ahoy repository, open Ahoy workspace and run the *Example* project.

## Installation

#### CocoaPods

[CocoaPods](https://cocoapods.org/) is a dependency manager for Cocoa projects.

To install Ahoy, simply add the following line to your Podfile:

```ruby
pod 'Ahoy', '~> 2.0'
```

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a simple, decentralized dependency manager for Cocoa.

To install Ahoy, simply add the following line to your Cartfile:

```ogdl
github "xmartlabs/Ahoy" ~> 2.0
```

## Author

* [Mauricio Cousillas](https://github.com/mcousillas6)

# Change Log

This can be found in the [CHANGELOG.md](CHANGELOG.md) file.
