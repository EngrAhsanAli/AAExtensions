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
    let normalImage: UIImage
    let selectedImage: UIImage
    let height: CGFloat
    
    public init(isSingle: Bool, choices: [String], selections: [Int]?, normalImage: UIImage, selectedImage: UIImage, height: CGFloat = 30) {
        self.isSingle = isSingle
        self.choices = choices
        self.selections = selections
        self.normalImage = normalImage
        self.selectedImage = selectedImage
        self.height = height
    }
    
}


@available(iOS 9.0, *)
fileprivate class WrappedChoices {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let model: AAStackedChoices
    var totalChoices: Int = -1
    var choices = [UIButton]()
    var selectionDidChange: (([Int]) -> ())?
    
    init(_ model: AAStackedChoices, view: UIView) {
        self.model = model
        view.aa_addAndFitSubview(stackView)
    }
    
    func addChoices(_ choices: [String], config: ((UIButton) -> ())?) {
        choices.forEach {
            let choice = makeChoice($0)
            config?(choice)
            choice.aa_constantConstaint(attr: .height, constant: model.height)
            self.stackView.addArrangedSubview(choice)
        }
    }
    
    func makeChoice(_ text: String) -> UIButton {
        totalChoices += 1
        
        let choice = AAImageButton()
        choice.choiceButton(model.isSingle, text: text, normalImage: model.normalImage, selectedImage: model.selectedImage)
        choice.tag = totalChoices
        
        choice.aa_addAction {
            self.makeSingleSelection()
            
            UIView.transition(with: $0.imageView!, duration: 0.3, options: .transitionFlipFromBottom,
                              animations: {
                                choice.isSelected.aa_toggle()
            }, completion: nil)
            
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
