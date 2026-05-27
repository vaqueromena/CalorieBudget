import UIKit

private enum Constants {
    enum Strings {
        static let title = "Gender"
        static let maleTitle = "Male"
        static let femaleTitle = "Female"
        static let continueTitle = "Continue"
    }
}

final class GenderViewController: UIViewController {
    private let viewModel: GenderViewModel
    private var selectedGender: Gender = .male

    private lazy var maleButton = makeGenderButton(title: Constants.Strings.maleTitle, gender: .male)
    private lazy var femaleButton = makeGenderButton(title: Constants.Strings.femaleTitle, gender: .female)

    init(viewModel: GenderViewModel) {
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
        updateSelection()
    }

    private func setupUI() {
        let genderStack = UIStackView(arrangedSubviews: [maleButton, femaleButton])
        genderStack.axis = .horizontal
        genderStack.spacing = Layout.spacing16
        genderStack.distribution = .fillEqually
        genderStack.translatesAutoresizingMaskIntoConstraints = false

        let continueButton = UIButton(configuration: .filled())
        continueButton.setTitle(Constants.Strings.continueTitle, for: .normal)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(genderStack)
        view.addSubview(continueButton)

        NSLayoutConstraint.activate([
            genderStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            genderStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            genderStack.widthAnchor.constraint(lessThanOrEqualToConstant: Layout.maxContentWidth),
            genderStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.spacing24),
            genderStack.trailingAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.spacing24),

            continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.spacing24),
            continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.spacing24),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.spacing16),
        ])
    }

    private func makeGenderButton(title: String, gender: Gender) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.title = title
        let button = UIButton(configuration: config)
        button.tag = gender == .male ? 0 : 1
        button.addTarget(self, action: #selector(genderTapped(_:)), for: .touchUpInside)
        return button
    }

    private func updateSelection() {
        var maleConfig = UIButton.Configuration.plain()
        maleConfig.title = Constants.Strings.maleTitle
        var femaleConfig = UIButton.Configuration.plain()
        femaleConfig.title = Constants.Strings.femaleTitle

        if selectedGender == .male {
            maleConfig = .filled()
            maleConfig.title = Constants.Strings.maleTitle
        } else {
            femaleConfig = .filled()
            femaleConfig.title = Constants.Strings.femaleTitle
        }
        maleButton.configuration = maleConfig
        femaleButton.configuration = femaleConfig
    }

    @objc private func genderTapped(_ sender: UIButton) {
        selectedGender = sender.tag == 0 ? .male : .female
        viewModel.selectGender(selectedGender)
        updateSelection()
    }

    @objc private func continueTapped() {
        viewModel.continueOnboarding()
    }
}
