//
//  ExpandableTextView.swift
//  ScotiaAssignment
//
//  Created by Yogin Kumar Suttroogun on 2026-04-24.
//

import UIKit

final class ExpandableTextView: UITextView {
    // MARK: - State
    private var isExpanded = false
    private let moreURL = URL(string: "action://more")!
    private let lessURL = URL(string: "action://less")!
    
    var model: TooltipModel = TooltipModel(collapsedMessage: "", expandedMessage: "") {
        didSet {
            updateText()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        
        linkTextAttributes = [
            .foregroundColor: UIColor.systemBlue
        ]
        
        delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUIState))
        self.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - UI changes
    @objc func handleUIState() {
        isExpanded.toggle()
        updateText()
    }
    
    private func updateText() {
        guard
            !model.collapsedMessage.isEmpty
        else { return }
        
        if isExpanded {
            attributedText = buildExpandedText()
        } else {
            attributedText = buildCollapsedText()
        }
    }
    
    func buildExpandedText() -> NSAttributedString {
        let text = "\(model.collapsedMessage)\n\n\(model.expandedMessage) \(model.showLessText)"
        let attributedString = NSMutableAttributedString(string: text)
        
        let range = (text as NSString).range(of: model.showLessText)
        attributedString.addAttribute(.link, value: lessURL, range: range)
        
        return attributedString
    }
    
    func buildCollapsedText() -> NSAttributedString {
        let text = "\(model.collapsedMessage) \(model.showMoreText)"
        
        let attributedString = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: model.showMoreText)
        attributedString.addAttribute(.link, value: moreURL, range: range)
        
        return attributedString
    }
}


// MARK: - Delegate
extension ExpandableTextView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        self.handleUIState()
        return false
    }
}
