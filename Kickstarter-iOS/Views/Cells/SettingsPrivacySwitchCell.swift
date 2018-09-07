import Foundation
import Library
import Prelude

protocol SettingsPrivacySwitchCellDelegate: class {
  func privacySettingsSwitchCell(_ cell: SettingsPrivacySwitchCell,
                                 didTogglePrivacySwitch on: Bool)
}

final class SettingsPrivacySwitchCell: UITableViewCell, ValueCell, NibLoading {
  @IBOutlet fileprivate weak var lineLayer: UIView!
  @IBOutlet fileprivate weak var primaryDescriptionLabel: UILabel!
  @IBOutlet fileprivate weak var titleLabel: UILabel!
  @IBOutlet fileprivate weak var topLineLayer: UIView!
  @IBOutlet fileprivate weak var secondaryDescriptionLabel: UILabel!
  @IBOutlet fileprivate weak var switchButton: UISwitch!

  private let viewModel = SettingsPrivacySwitchCellViewModel()

  weak var delegate: SettingsPrivacySwitchCellDelegate?

  func configureWith(value: SettingsPrivacyCellValue) {
    self.viewModel.configure(with: value.user)

    _ = self.titleLabel
    |> UILabel.lens.text .~ value.cellType.titleString

    _ = self.primaryDescriptionLabel
    |> UILabel.lens.text .~ value.cellType.primaryDescriptionString

    _ = self.secondaryDescriptionLabel
    |> UILabel.lens.text .~ value.cellType.secondaryDescriptionString
  }

  override func bindStyles() {
    super.bindViewModel()

    _ = self
      |> UIView.lens.backgroundColor .~ .ksr_grey_100

    _ = self.titleLabel
      |> settingsTitleLabelStyle

    _ = self.primaryDescriptionLabel
      |> settingsDescriptionLabelStyle

    _ = self.secondaryDescriptionLabel
      |> settingsDescriptionLabelStyle

    _ = self.switchButton
      |> settingsSwitchStyle

    _ = self.lineLayer
      |> settingsSeparatorStyle

    _ = self.topLineLayer
      |> settingsSeparatorStyle

    self.bringSubview(toFront: topLineLayer)
  }

  override func bindViewModel() {
    super.bindViewModel()

    self.switchButton.rac.on = self.viewModel.privacySwitchEnabled

    self.viewModel.privacySwitchToggledOn
      .observeForControllerAction()
      .observeValues { [weak self] (privacyEnabled) in
        guard let `self` = self else { return }

        self.delegate?.privacySettingsSwitchCell(self, didTogglePrivacySwitch: privacyEnabled)
    }
  }

  @IBAction func switchToggled(_ sender: UISwitch) {
    self.viewModel.switchToggled(on: sender.isOn)
  }
}
