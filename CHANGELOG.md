# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- `DateOfBirthError` enum with typed reasons (`tooYoung(minAge:)`, `invalidDate`) and `userMessage` for UI presentation.
- `minimumDate` (120 years before today) on the Date of Birth screen's `UIDatePicker`.
- `WeightError` enum (`invalidNumber`, `outOfRange(minDisplay:maxDisplay:unit:)`) with `userMessage` for UI presentation.

### Changed
- `DateOfBirthViewModel` no longer writes to `UserSession.dateOfBirth` until validation passes; selected dates are staged in a `pendingDate` field and only committed on successful continue.
- `DateOfBirthViewModel.continueIfValid() -> Bool` replaced with `validateAndContinue() -> DateOfBirthError?` so the view controller receives a typed reason on failure.
- Age-requirement alert message on the Date of Birth screen is now sourced from `DateOfBirthError.userMessage` instead of being hardcoded in the view controller.
- `DateOfBirthViewModel.initialDate` fallback changed from "today" to `maximumDate` when `dateOfBirth` components can't be resolved into a `Date`.
- `WeightViewModel.continueIfValid(displayValue:) -> Bool` replaced with `validateAndContinue(displayValue:) -> WeightError?` so the view controller receives a typed reason on failure.
- Weight out-of-range alert message is now sourced from `WeightError.userMessage`; imperial upper bound displayed as `1102 lb` (was `1100 lb`) — corrected rounding from the actual `500 kg × 2.20462` conversion.
- Magic conversion factor `2.20462` consolidated into `WeightViewModel.lbPerKg` constant (previously duplicated across three call sites).
- Per-file `private enum Constants` introduced across `Screens/*` and `Utilities/CalorieCalculator.swift` to namespace user-facing strings (under nested `Constants.Strings`) and domain/math constants (BMR coefficients, `lbPerKg`, `kcalToKj`, `minAge`, `maxAgeYears`, weight bounds). Existing in-class `static let` constants (`minAge`, `minKg`, `maxKg`, `lbPerKg`, `CalorieCalculator.pa`) migrated into the same namespace for uniformity. No behavior change.

### Fixed
- Double-tapping Continue on the Date of Birth screen no longer pushes the Calorie Budget screen twice — the button is disabled on tap and re-enabled only when validation fails.
- Double-tapping Continue on the Weight screen no longer pushes the Date of Birth screen twice — same disable-on-tap pattern.
