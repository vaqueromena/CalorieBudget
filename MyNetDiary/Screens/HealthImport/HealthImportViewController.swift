import UIKit

private enum Constants {
    enum Strings {
        static let title = "Health Import"
        static let bodyText = "Import your health data from the Health app to pre-fill your profile."
        static let importButtonTitle = "Import from Health"
        static let skipButtonTitle = "Skip"
    }
}

final class HealthImportViewController: UIViewController {
    private let viewModel: HealthImportViewModel
    private let activityIndicator = UIActivityIndicatorView(style: .medium)

    init(viewModel: HealthImportViewModel) {
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
        let bodyLabel = UILabel()
        bodyLabel.text = Constants.Strings.bodyText
        bodyLabel.numberOfLines = 0
        bodyLabel.textAlignment = .center
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false

        let importButton = UIButton(configuration: .filled())
        importButton.setTitle(Constants.Strings.importButtonTitle, for: .normal)
        importButton.addTarget(self, action: #selector(importTapped), for: .touchUpInside)
        importButton.translatesAutoresizingMaskIntoConstraints = false

        let skipButton = UIButton(configuration: .plain())
        skipButton.setTitle(Constants.Strings.skipButtonTitle, for: .normal)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        skipButton.translatesAutoresizingMaskIntoConstraints = false

        let buttonStack = UIStackView(arrangedSubviews: [importButton, skipButton])
        buttonStack.axis = .vertical
        buttonStack.spacing = Layout.spacing12
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true

        let contentStack = UIStackView(arrangedSubviews: [bodyLabel, activityIndicator, buttonStack])
        contentStack.axis = .vertical
        contentStack.spacing = Layout.spacing24
        contentStack.alignment = .center
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.spacing24),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.spacing24),
            contentStack.widthAnchor.constraint(lessThanOrEqualToConstant: Layout.maxContentWidth),
            importButton.widthAnchor.constraint(equalTo: buttonStack.widthAnchor),
            skipButton.widthAnchor.constraint(equalTo: buttonStack.widthAnchor),
        ])
    }

    @objc private func importTapped() {
        activityIndicator.startAnimating()
        Task {
            await viewModel.importHealthData()
            activityIndicator.stopAnimating()
        }
    }

    @objc private func skipTapped() {
        viewModel.skip()
    }
}
