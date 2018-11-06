//
//  Token.swift
//  TokenField
//
//  Created by Reid Chatham on 11/4/16.
//  Copyright © 2016 Reid Chatham. All rights reserved.
//

import UIKit

/// Delegate protocol for the Token object.
public protocol TokenDelegate: class {
    /// Returns when the token is tapped and the token that was tapped.
    func didTapToken(_ token: Token)
}

/// Represents a token view object in the token field.
public class Token: UIView {

    /// Token delegate gives access to the didTapToken(_ token: Token) method.
    public weak var delegate: TokenDelegate?

    /// Token's title. Immutable.
    public let title: String
    /// UIColor representing the color for the Token. Changing this value automatically calls the private method updateUI().
    public var colorScheme: TokenColorScheme = (textColor: .blue, backgroundColor: .clear)  { didSet { updateUI() } }
    /// Bool determing whether the Token is highlighted or not. Changing this value automatically calls the private method updateUI().
    internal var highlighted: Bool = false { didSet { updateUI() } }

    public var highlightedColorScheme: TokenColorScheme = (textColor: .white, backgroundColor: .blue) { didSet { updateUI() } }

    /// Takes the title for the token and returns a Token sublclass of UIView. The Token is not highlighted and is UIColor.blue.
    public init(title: String) {
        self.title = title
        super.init(frame: CGRect.zero)
        loadView()
        setup()
    }

    /// - warn: Not imlpemented! fatalError("init(coder:) has not been implemented")
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Returns the intrinsicContentSize. The preffered size of the view.
    public override var intrinsicContentSize: CGSize {
        let size = titleLabel.intrinsicContentSize
        return CGSize(width: size.width + 6, height: TokenField.Constants.defaultTokenHeight)
    }

    /// Returns the intrinsicContentSize.
    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        return intrinsicContentSize
    }

    /// Internal function that responds to the Token's tapGestureRecognizer.
    @objc internal func didTapToken(_ sender: UITapGestureRecognizer) {
        delegate?.didTapToken(self)
    }

    // MARK: - IBOutlet

    /// backgroundView of the Token.
    @IBOutlet weak var backgroundView: UIView!
    /// titleLabel of the Token.
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = title
            titleLabel.textColor = UIColor.white
            titleLabel.font = .systemFont(ofSize: 15)
        }
    }

    // MARK: - Private

    private var tapGestureRecognizer: UITapGestureRecognizer!

    private func loadView() {
        let bundleType = type(of: self)
        let bundle = Bundle(for: bundleType)
        let nib = UINib(nibName: String(describing: bundleType), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first! as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
    }

    private func setup() {
        backgroundView.layer.cornerRadius = 3
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Token.didTapToken(_:)))
        colorScheme = (textColor: tintColor, backgroundColor: .clear)
        highlightedColorScheme = (textColor: .white, backgroundColor: tintColor)
        addGestureRecognizer(tapGestureRecognizer)
    }

    private func updateUI() {
        let backgroundColor = highlighted ? highlightedColorScheme.backgroundColor : colorScheme.backgroundColor
        let textColor = highlighted ? highlightedColorScheme.textColor : colorScheme.textColor
        backgroundView.backgroundColor = backgroundColor
        titleLabel.textColor = textColor
        titleLabel.text = highlighted ? title : title + ","
    }

}
