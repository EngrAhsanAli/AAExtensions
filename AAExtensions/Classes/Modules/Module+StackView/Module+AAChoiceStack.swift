//
//  Module+AAChoiceStack.swift
//  AAExtensions
//
//  Created by Muhammad Ahsan Ali on 2020/06/08.
//

import UIKit

@available(iOS 9.0, *)
public extension AA where Base: UIView {
    
    func addChoiceStack(_ model: AAStackedChoices, config: ((UIButton) -> ())?, didChange: (([Int]) -> ())?) {
        base.aa_removeSubViews()
        let wrapped = WrappedChoices(model, view: base)
        wrapped.selectionDidChange = didChange
        wrapped.addChoices(model.choices, config: config)
        model.selections?.forEach {
            wrapped.makeSelection($0, selected: true)
        }
    }
}

public struct AAStackedChoices {
    let isSingle: Bool
    let choices: [String]
    let selections: [Int]?
    let choiceImages: (UIImage, UIImage)?
    let font: UIFont
    
    public init(isSingle: Bool,
                choices: [String],
                selections: [Int]?,
                font: UIFont,
                choiceImages: (UIImage, UIImage)?) {
        self.isSingle = isSingle
        self.choices = choices
        self.selections = selections
        self.font = font
        self.choiceImages = choiceImages
    }
    
}


@available(iOS 9.0, *)
fileprivate class WrappedChoices {
    
    let model: AAStackedChoices
    var totalChoices: Int = -1
    var choices = [UIButton]()
    var selectionDidChange: (([Int]) -> ())?
    let view: UIView
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    init(_ model: AAStackedChoices, view: UIView) {
        self.model = model
        self.view = view
    }
    
    func addChoices(_ choices: [String], config: ((UIButton) -> ())?) {
        view.aa_removeSubViews()
        choices.forEach {
            let choice = makeChoice($0)
            choice.sizeToFit()
            config?(choice)
            
            var height: CGFloat = 30
            let calculatedHeight = $0.aa_height(withConstrainedWidth: view.frame.size.width, font: model.font)
            if calculatedHeight > height {
                height = calculatedHeight
            }
            choice.aa_constantConstaint(attr: .height, constant: height)
            stackView.addArrangedSubview(choice)
        }
        view.aa_addAndFitSubview(stackView, insets: .init(top: 10, left: 0, bottom: 0, right: 0))
        view.aa_findConstraint(.bottom)?.priority = .defaultLow
    }
    
    func makeChoice(_ text: String) -> UIButton {
        totalChoices += 1
        
        let choice: UIButton = {
            let btn = UIButton()
            if let choiceImages = model.choiceImages {
                btn.setImage(choiceImages.0, for: .normal)
                btn.setImage(choiceImages.1, for: .selected)
            }
            btn.titleEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 0)
            btn.imageView?.contentMode = .scaleAspectFit
            btn.contentHorizontalAlignment = .left
            btn.setTitle(text, for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.titleLabel?.lineBreakMode = .byWordWrapping
            btn.titleLabel?.numberOfLines = 0
            btn.titleLabel?.font = model.font
            btn.sizeToFit()
            
            return btn
        }()
        choice.tag = totalChoices
        
        choice.aa_addAction {
            self.makeSingleSelection()
            
            UIView.transition(with: $0.imageView!,
                              duration: 0.3,
                              options: .transitionFlipFromBottom,
                              animations: { choice.isSelected.toggle() }, completion: nil)
            
            self.selectionDidChange?(self.selections)
        }
        choices.append(choice)
        return choice
    }
    
    func makeSingleSelection() {
        guard model.isSingle else { return }
        choices.forEach { $0.isSelected = false }
    }
    
    func makeSelection(_ tag: Int, selected: Bool) {
        guard let choice = choices.filter({ $0.tag == tag }).first else {
            return
        }
        
        makeSingleSelection()
        choice.isSelected = selected
    }
    
    var selections: [Int] {
        choices.filter { $0.isSelected }.map { $0.tag }
    }
    
}
