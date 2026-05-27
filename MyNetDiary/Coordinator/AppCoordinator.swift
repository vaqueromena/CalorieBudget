import UIKit

final class AppCoordinator: Coordinator {
    let navigationController: UINavigationController
    private let session = UserSession()
    private let healthKitService = HealthKitService()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let vm = WelcomeViewModel()
        vm.onStart = { [weak self] in self?.showGender() }
        navigationController.pushViewController(WelcomeViewController(viewModel: vm), animated: false)
    }

    func showGender() {
        let vm = GenderViewModel(session: session)
        vm.onContinue = { [weak self] in self?.showHealthImport() }
        navigationController.pushViewController(GenderViewController(viewModel: vm), animated: true)
    }

    func showHealthImport() {
        let vm = HealthImportViewModel(session: session, healthKitService: healthKitService)
        vm.onImportComplete = { [weak self] in self?.showWeight() }
        navigationController.pushViewController(HealthImportViewController(viewModel: vm), animated: true)
    }

    func showWeight() {
        let vm = WeightViewModel(session: session)
        vm.onContinue = { [weak self] in self?.showDateOfBirth() }
        navigationController.pushViewController(WeightViewController(viewModel: vm), animated: true)
    }

    func showDateOfBirth() {
        let vm = DateOfBirthViewModel(session: session)
        vm.onContinue = { [weak self] in self?.showCalorieBudget() }
        navigationController.pushViewController(DateOfBirthViewController(viewModel: vm), animated: true)
    }

    func showCalorieBudget() {
        let vm = CalorieBudgetViewModel(session: session)
        navigationController.pushViewController(CalorieBudgetViewController(viewModel: vm), animated: true)
    }
}
