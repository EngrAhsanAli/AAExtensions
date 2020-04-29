![](https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions.png)


# Table of Contents

- [AAExtensions](#section-id-4)
- [Description](#section-id-10)
- [Demonstration](#section-id-16)
- [Requirements](#section-id-26)
- [Installation](#section-id-32)
- [CocoaPods](#section-id-37)
- [Carthage](#section-id-63)
- [Manual Installation](#section-id-82)
- [Getting Started](#section-id-87)
- [Contributions & License](#section-id-156)


<div id='section-id-4'/>

#AAExtensions


[![Swift 5.0](https://img.shields.io/badge/Swift-4.2-orange.svg?style=flat)](https://developer.apple.com/swift/) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage) [![CocoaPods](https://img.shields.io/cocoapods/v/AAExtensions.svg)](http://cocoadocs.org/docsets/AAExtensions) [![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://github.com/Carthage/Carthage) [![Build Status](https://travis-ci.org/EngrAhsanAli/AAExtensions.svg?branch=master)](https://travis-ci.org/EngrAhsanAli/AAExtensions) 
![License MIT](https://img.shields.io/github/license/mashape/apistatus.svg) [![CocoaPods](https://img.shields.io/cocoapods/p/AAExtensions.svg)]()
![AA-Creations](https://img.shields.io/badge/AA-Creations-green.svg)
![Country](https://img.shields.io/badge/Made%20with%20%E2%9D%A4-pakistan-green.svg)


<div id='section-id-10'/>

##Description


AAExtensions are a set of UI Extensions and Helper functions for iOS applications which is written in Swift 4.2.


<div id='section-id-16'/>

##Demonstration


To run the example project, clone the repo, and run `pod install` from the Example directory first.


<div id='section-id-26'/>

##Requirements

- iOS 10.0+
- Xcode 8.0+
- Swift 4.2+

<div id='section-id-32'/>

# Installation

`AAExtensions` can be installed using CocoaPods, Carthage, or manually.


<div id='section-id-37'/>

##CocoaPods

`AAExtensions` is available through [CocoaPods](http://cocoapods.org). To install CocoaPods, run:

`$ gem install cocoapods`

Then create a Podfile with the following contents:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
pod 'AAExtensions', '0.1.5'
end

```

Finally, run the following command to install it:
```
$ pod install
```



<div id='section-id-63'/>

##Carthage

To install Carthage, run (using Homebrew):
```
$ brew update
$ brew install carthage
```
Then add the following line to your Cartfile:

```
github "EngrAhsanAli/AAExtensions" "master"
```

Then import the library in all files where you use it:
```swift
import AAExtensions
```


<div id='section-id-82'/>

##Manual Installation

If you prefer not to use either of the above mentioned dependency managers, you can integrate `AAExtensions` into your project manually by adding the files contained in the Classes folder to your project.


<div id='section-id-87'/>

#Getting Started
----------

## AAExtensions List

<details>
<summary>Designables</summary> 
</br>
<ul>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Designables/Designable%2BUILabel.swift"><code>UILabel Designable Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Designables/Designable%2BUITableView.swift"><code>UITableView Designable Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Designables/Designable%2BUITextField.swift"><code>UITextField Designable Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Designables/Designable%2BUIView.swift"><code>UIView Designable Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Designables/Designable%2BUIViewController.swift"><code>UIViewController Designable Extensions</code></a></li>
</ul>
</details>

<details>
<summary>Extensions</summary> 
</br>
<ul>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Basic/AAExtension%2BArray.swift"><code>Array Extensions</code></a></li>

<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Basic/AAExtension%2BCollection.swift"><code>Collection Extensions</code></a></li>

<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Basic/AAExtension%2BData.swift"><code>Data Extensions</code></a></li>

<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Basic/AAExtension%2BDictionary.swift"><code>Dictionary Extensions</code></a></li>

<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Basic/AAExtension%2BSequence.swift"><code>Sequence Extensions</code></a></li>

<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Basic/AAExtension%2BString.swift"><code>String Extensions</code></a></li>

</ul>

<ul>

<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/DataTypes/AAExtension%2BBool.swift"><code>Bool Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/DataTypes/AAExtension%2BDouble.swift"><code>Double Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/DataTypes/AAExtension%2BFloat.swift"><code>Float Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/DataTypes/AAExtension%2BInt.swift"><code>Int Extensions</code></a></li>


</ul>

<ul>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Other/AAExtension%2BArrayElement.swift"><code>ArrayElement Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Other/AAExtension%2BDate.swift"><code>Date Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Other/AAExtension%2BDispatchQueue.swift"><code>DispatchQueue Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Other/AAExtension%2BNSAttributedString.swift"><code>NSAttributedString Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Other/AAExtension%2BOptional.swift"><code>Optional Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Other/AAExtension%2BPHAsset.swift"><code>PHAsset Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/Other/AAExtension%2BStringProtocol.swift"><code>StringProtocol Extensions</code></a></li>


</ul>




<ul>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BNSLayoutConstraint.swift"><code>NSLayoutConstraint Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUIApplication.swift"><code>UIApplication Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUIBarButtonItem.swift"><code>UIBarButtonItem Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUICollectionView.swift"><code>UICollectionView Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUICollectionViewCell.swift"><code>UICollectionViewCell Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUIControl.swift"><code>UIControl Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUIFont.swift"><code>UIFont Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUIImage.swift"><code>UIImage Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUIImageView.swift"><code>UIImageView Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUILabel.swift"><code>UILabel Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUINavigationController.swift"><code>UINavigationController Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUIRefreshControl.swift"><code>UIRefreshControl Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUIScrollView.swift"><code>UIScrollView Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUISegmentedControl.swift"><code>UISegmentedControl Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUIStackView.swift"><code>UIStackView Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUIStoryboard.swift"><code>UIStoryboard Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUITabBar.swift"><code>UITabBar Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUITableView.swift"><code>UITableView Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUITableViewCell.swift"><code>UITableViewCell Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUITextField.swift"><code>UITextField Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUIView.swift"><code>UIView Extensions</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Extensions/UI/AAExtension%2BUIViewController.swift"><code>UIViewController Extensions</code></a></li>
</ul>


</details>

<details>
<summary>Modules</summary> 
</br>
<ul>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BAAClosureSleeve.swift"><code>AAClosureSleeve</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BAATimer.swift"><code>AATimer</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BAAUpdateModule.swift"><code>AAUpdateModule</code></a></li>

<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BNSLayoutConstraint/Module%2BAADualConstantConstraint.swift"><code>AADualConstantConstraint</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BNSLayoutConstraint/Module%2BAAKeyboardLayoutConstraint.swift"><code>AAKeyboardLayoutConstraint</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BNSLayoutConstraint/Module%2BAAReversibleConstraint.swift"><code>AAReversibleConstraint</code></a></li>



<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BStackView/Module%2BAAStackViewSeparator.swift"><code>AAStackViewSeparator</code></a></li>

<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUIButton/Module%2BAABackButton.swift"><code>AABackButton</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUIButton/Module%2BAALoadingButton.swift"><code>AALoadingButton</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUIButton/Module%2BAARoundedButton.swift"><code>AARoundedButton</code></a></li>



<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUICollection/Module%2BAACarouselFlowLayout.swift"><code>AACarouselFlowLayout</code></a></li>


<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUILabel/Module%2BAAExpandableLabel.swift"><code>AAExpandableLabel</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUILabel/Module%2BAAGradientLabel.swift"><code>AAGradientLabel</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUILabel/Module%2BAALabelParagraph.swift"><code>AALabelParagraph</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUILabel/Module%2BAALinedLabel.swift"><code>AALinedLabel</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUILabel/Module%2BAATimerLabel.swift"><code>AATimerLabel</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUILabel/Module%2BAAVerticalAlignLabel.swift"><code>AAVerticalAlignLabel</code></a></li>



<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUITextFeild/Module%2BAAFloatingTextField.swift"><code>AAFloatingTextField</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUITextFeild/Module%2BAAIconTextField.swift"><code>AAIconTextField</code></a></li>

<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUITextView/Module%2BAAPlaceholderTextView.swift"><code>AAPlaceholderTextView</code></a></li>


<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUIView/Module%2BAABorderLinesView.swift"><code>AABorderLinesView</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUIView/Module%2BAACurvedView.swift"><code>AACurvedView</code></a></li>
<li><a href="https://github.com/EngrAhsanAli/AAExtensions/blob/master/AAExtensions/Classes/Modules/Module%2BUIView/Module%2BAASegmentButton.swift"><code>AASegmentButton</code></a></li>


</ul>



</details>


<div id='section-id-156'/>

#Contributions & License

`AAExtensions` is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.

Pull requests are welcome! The best contributions will consist of substitutions or configurations for classes/methods known to block the main thread during a typical app lifecycle.

I would love to know if you are using `AAExtensions` in your app, send an email to [Engr. Ahsan Ali](mailto:hafiz.m.ahsan.ali@gmail.com)
