import UIKit

private enum Constants {
    enum Strings {
        static let title = "Current Weight"
        static let continueTitle = "Continue"
        static let metricSwitchLabel = "Use metric system"
        static let invalidWeightAlertTitle = "Invalid Weight"
        static let kgUnit = "kg"
        static let lbUnit = "lb"
        static let weightFieldFormat = "%.1f"
    }
}

final class WeightViewController: UIViewController {
    private let viewModel: WeightViewModel
    private let weightTextField = UITextField()
    private let unitLabel = UILabel()
    private let metricSwitch = UISwitch()
    private let continueButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = Constants.Strings.continueTitle
        return UIButton(configuration: config)
    }()

    init(viewModel: WeightViewModel) {
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
        populateInitialValues()
    }

    private func setupUI() {
        weightTextField.keyboardType = .decimalPad
        weightTextField.borderStyle = .roundedRect
        weightTextField.textAlignment = .center
        weightTextField.font = .preferredFont(forTextStyle: .title2)
        weightTextField.translatesAutoresizingMaskIntoConstraints = false

        unitLabel.font = .preferredFont(forTextStyle: .title2)
        unitLabel.translatesAutoresizingMaskIntoConstraints = false

        let fieldRow = UIStackView(arrangedSubviews: [weightTextField, unitLabel])
        fieldRow.axis = .horizontal
        fieldRow.spacing = Layout.spacing8
        fieldRow.alignment = .center
        fieldRow.translatesAutoresizingMaskIntoConstraints = false

        let metricLabel = UILabel()
        metricLabel.text = Constants.Strings.metricSwitchLabel
        metricLabel.font = .preferredFont(forTextStyle: .body)
        metricLabel.translatesAutoresizingMaskIntoConstraints = false

        metricSwitch.addTarget(self, action: #selector(metricSwitchChanged), for: .valueChanged)
        metricSwitch.translatesAutoresizingMaskIntoConstraints = false

        let switchRow = UIStackView(arrangedSubviews: [metricLabel, metricSwitch])
        switchRow.axis = .horizontal
        switchRow.spacing = Layout.spacing12
        switchRow.alignment = .center
        switchRow.translatesAutoresizingMaskIntoConstraints = false

        let contentStack = UIStackView(arrangedSubviews: [fieldRow, switchRow])
        contentStack.axis = .vertical
        contentStack.spacing = Layout.spacing24
        contentStack.alignment = .center
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(contentStack)
        view.addSubview(continueButton)

        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.spacing24),
            contentStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.spacing24),
            weightTextField.widthAnchor.constraint(equalToConstant: Layout.weightFieldWidth),

            continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.spacing24),
            continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.spacing24),
            continueButton.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor, constant: -Layout.spacing16),
        ])
    }

    private func populateInitialValues() {
        metricSwitch.isOn = viewModel.useMetricSystem
        weightTextField.text = String(format: Constants.Strings.weightFieldFormat, viewModel.initialDisplayWeight)
        unitLabel.text = viewModel.useMetricSystem ? Constants.Strings.kgUnit : Constants.Strings.lbUnit
    }

    @objc private func metricSwitchChanged() {
        let currentText = weightTextField.text?.replacingOccurrences(of: ",", with: ".") ?? ""
        let currentValue = Double(currentText) ?? viewModel.initialDisplayWeight
        let newValue = viewModel.convertDisplayValue(currentValue, toMetric: metricSwitch.isOn)
        viewModel.useMetricSystem = metricSwitch.isOn
        weightTextField.text = String(format: Constants.Strings.weightFieldFormat, newValue)
        unitLabel.text = metricSwitch.isOn ? Constants.Strings.kgUnit : Constants.Strings.lbUnit
    }

    @objc private func continueTapped() {
        continueButton.isEnabled = false
        let text = weightTextField.text?.replacingOccurrences(of: ",", with: ".") ?? ""
        let parsed = Double(text)
        guard let error = viewModel.validateAndContinue(displayValue: parsed) else { return }
        let alert = UIAlertController(
            title: Constants.Strings.invalidWeightAlertTitle,
            message: error.userMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.continueButton.isEnabled = true
        })
        present(alert, animated: true)
    }
}
