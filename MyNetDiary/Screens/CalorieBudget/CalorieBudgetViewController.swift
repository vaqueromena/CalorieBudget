import UIKit

private enum Constants {
    enum Strings {
        static let title = "Daily Calorie Budget"
        static let subtitleText = "Your estimated daily calorie budget:"
        static let doneTitle = "Done"
    }
}

final class CalorieBudgetViewController: UIViewController {
    private let viewModel: CalorieBudgetViewModel

    init(viewModel: CalorieBudgetViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.Strings.title
        navigationItem.backButtonTitle = ""
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        let subtitleLabel = UILabel()
        subtitleLabel.text = Constants.Strings.subtitleText
        subtitleLabel.font = .preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        let budgetLabel = UILabel()
        budgetLabel.text = viewModel.budgetText
        budgetLabel.font = .preferredFont(forTextStyle: .largeTitle)
        budgetLabel.textAlignment = .center
        budgetLabel.adjustsFontSizeToFitWidth = true
        budgetLabel.translatesAutoresizingMaskIntoConstraints = false

        let contentStack = UIStackView(arrangedSubviews: [subtitleLabel, budgetLabel])
        contentStack.axis = .vertical
        contentStack.spacing = Layout.spacing16
        contentStack.alignment = .center
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let doneButton = UIButton(configuration: .filled())
        doneButton.setTitle(Constants.Strings.doneTitle, for: .normal)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentStack)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.spacing24),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.spacing24),
            contentStack.widthAnchor.constraint(lessThanOrEqualToConstant: Layout.maxContentWidth),

            doneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.spacing24),
            doneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.spacing24),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.spacing16),
        ])
    }

    @objc private func doneTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}
