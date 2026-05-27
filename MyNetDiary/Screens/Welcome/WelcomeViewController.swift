import UIKit

private enum Constants {
    enum Strings {
        static let title = "Welcome"
        static let startButtonTitle = "I am new to MyNetDiary"
    }
}

final class WelcomeViewController: UIViewController {
    private let viewModel: WelcomeViewModel

    init(viewModel: WelcomeViewModel) {
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
        let button = UIButton(type: .system)
        button.setTitle(Constants.Strings.startButtonTitle, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
        ])
    }

    @objc private func startTapped() {
        viewModel.onStart?()
    }
}
