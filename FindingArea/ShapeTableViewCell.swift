import UIKit

final class ShapeTableViewCell: UITableViewCell {

    static let reuseIdentifier = "ShapeTableViewCell"

    private let finding: FindingAreaServiceProtocol

    private lazy var backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .darkGray.withAlphaComponent(0.25)
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 24)
        label.text = "Shape"
        return label
    }()

    private lazy var image: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .orange
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 12
        return image
    }()

    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()

    private lazy var firstLabel: UILabel = {
        return defaultLabel("a  =  ")
    }()
    private lazy var firstTextView: UITextView = {
        return defaultTextView("")
    }()
    private lazy var firstStack: UIStackView = {
        return defaultHorizontalStackView(firstLabel, firstTextView)
    }()

    private lazy var secondLabel: UILabel = {
        return defaultLabel("b  =  ")
    }()
    private lazy var secondTextView: UITextView = {
        return defaultTextView("")
    }()
    private lazy var secondStack: UIStackView = {
        return defaultHorizontalStackView(secondLabel, secondTextView)
    }()

    private lazy var thirdLabel: UILabel = {
        return defaultLabel("c  =  ")
    }()
    private lazy var thirdTextView: UITextView = {
        return defaultTextView("")
    }()
    private lazy var thirdStack: UIStackView = {
        return defaultHorizontalStackView(thirdLabel, thirdTextView)
    }()

    private lazy var areaLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "S = 0.00"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.finding = FindingAreaService()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupContentView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func defaultLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18)
        label.text = text
        return label
    }

    private func defaultTextView(_ parameter: String) -> UITextView {
        let text = UITextView()
        text.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        text.backgroundColor = .lightGray
        text.layer.cornerRadius = 10
        text.isEditable = true
        text.isScrollEnabled = false
        text.textColor = .black
        text.font = .systemFont(ofSize: 18)
        text.delegate = self
        return text
    }

    private func defaultHorizontalStackView(_ view1: UILabel, _ view2: UITextView) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.addArrangedSubview(view1)
        stack.addArrangedSubview(view2)
        return stack
    }

    private func setupContentView() {
        backgroundColor = .black

        [backView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        [titleLabel, image, verticalStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            backView.addSubview($0)
        }

        [firstStack, secondStack, thirdStack, areaLabel].forEach {
            verticalStack.addArrangedSubview($0)
        }

        setConstraints()
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            // backView
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),

            // image
            image.topAnchor.constraint(greaterThanOrEqualTo: titleLabel.bottomAnchor, constant: 20),
            image.bottomAnchor.constraint(greaterThanOrEqualTo: backView.bottomAnchor, constant: -20),
            image.trailingAnchor.constraint(equalTo: backView.centerXAnchor, constant: -10),
            image.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 20),

            // verticalStack
            verticalStack.topAnchor.constraint(lessThanOrEqualTo: titleLabel.bottomAnchor, constant: 20),
            verticalStack.bottomAnchor.constraint(lessThanOrEqualTo: backView.bottomAnchor, constant: -20),
            verticalStack.centerYAnchor.constraint(equalTo: image.centerYAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),
            verticalStack.leadingAnchor.constraint(equalTo: backView.centerXAnchor, constant: 10),
        ])
    }

    func setup(withType: ShapeType) {
        switch withType {
        case .circle:
            titleLabel.text = "Circle"
            firstLabel.text = "r  =  "
            secondStack.isHidden = true
            thirdStack.isHidden = true
        case .triangle:
            titleLabel.text = "Triangle"
        }
    }

    private func areaOfCircle() -> String {
        let r = Double(firstTextView.text) ?? 0
        return finding.areaOfCircle(withParameters: r)
    }

    private func areaOfTriangle() -> String {
        let a = Double(firstTextView.text) ?? 0
        let b = Double(secondTextView.text) ?? 0
        let c = Double(thirdTextView.text) ?? 0
        return finding.areaOfTriangle(withParameters: a, b, c)
    }
}

extension ShapeTableViewCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        return updatedText.count <= 3
    }

    func textViewDidChange(_ textView: UITextView) {
        if firstLabel.text == "r  =  " {
            areaLabel.text = "S = \(areaOfCircle())"
        } else {
            areaLabel.text = "S = \(areaOfTriangle())"
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear]) {
            textView.backgroundColor = .systemOrange
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear]) {
            textView.backgroundColor = .lightGray
        }
    }
}
