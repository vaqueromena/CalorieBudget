import UIKit

private enum Constants {
    enum Strings {
        static let title = "Date of Birth"
        static let continueTitle = "Continue"
        static let ageRequirementAlertTitle = "Age Requirement"
        static func ageLabelText(age: Int) -> String { "Age: \(age) years" }
    }
}

final class DateOfBirthViewController: UIViewController {
    private let viewModel: DateOfBirthViewModel
    private let datePicker = UIDatePicker()
    private let ageLabel = UILabel()
    private let continueButton = UIButton(configuration: .filled())

    init(viewModel: DateOfBirthViewModel) {
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
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = viewModel.maximumDate
        datePicker.minimumDate = viewModel.minimumDate
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        datePicker.translatesAutoresizingMaskIntoConstraints = false

        let maxDate = viewModel.maximumDate
        let minDate = viewModel.minimumDate
        let initial = viewModel.initialDate
        let clampedDate = min(max(initial, minDate), maxDate)
        datePicker.date = clampedDate

        ageLabel.font = .preferredFont(forTextStyle: .headline)
        ageLabel.textAlignment = .center
        ageLabel.translatesAutoresizingMaskIntoConstraints = false

        continueButton.setTitle(Constants.Strings.continueTitle, for: .normal)
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(datePicker)
        view.addSubview(ageLabel)
        view.addSubview(continueButton)

        NSLayoutConstraint.activate([
            datePicker.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),

            ageLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: Layout.spacing16),
            ageLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),

            continueButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Layout.spacing24),
            continueButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Layout.spacing24),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -Layout.spacing16),
        ])

        updateAgeLabel(for: clampedDate)
    }

    @objc private func dateChanged() {
        updateAgeLabel(for: datePicker.date)
    }

    private func updateAgeLabel(for date: Date) {
        let age = viewModel.setDate(date)
        ageLabel.text = Constants.Strings.ageLabelText(age: age)
    }

    @objc private func continueTapped() {
        continueButton.isEnabled = false
        guard let error = viewModel.validateAndContinue() else { return }
        let alert = UIAlertController(
            title: Constants.Strings.ageRequirementAlertTitle,
            message: error.userMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.continueButton.isEnabled = true
        })
        present(alert, animated: true)
    }
}
