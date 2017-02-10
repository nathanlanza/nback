import UIKit
import RxSwift
import RxCocoa
import Reuse

class PlayView: UIView {
  init() {
    super.init(frame: CGRect())
  }
  
  required init?(coder aDecoder: NSCoder) { fatalError() }
}

protocol PlayViewControllerDelegate: class {
  func newGameTapped()
}

class PlayViewController: ViewController {
  
  weak var delegate: PlayViewControllerDelegate!
  
  var lastGameResult: GameResultRealm?
  
  var lastGameLabel: Label!
  
  var secondsBetweenTurnsButton: UIButton!
  
  var squareButton: UIButton!
  var numberButton: UIButton!
  var colorButton: UIButton!
  
  var levelButton: UIButton!
  var turnsButton: UIButton!
  
  var rowsButton: UIButton!
  var columnsButton: UIButton!
  
  var playGameButton: UIButton!
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    let defaults = UserDefaults.standard
    
    let lastScoreString = defaults[.lastScoreString]
    let lastResultString = defaults[.lastResultString]
    lastGameLabel.text = "Last Game \n" + lastResultString + "\n" + lastScoreString
  }
  override func loadView() {
    view = View()
    
    lastGameLabel = Label()
    lastGameLabel.numberOfLines = 0
    lastGameLabel.font = Theme.Fonts.lastGameLabel
    lastGameLabel.textColor = Theme.Colors.secondary
    lastGameLabel.layer.cornerRadius = 5
    lastGameLabel.clipsToBounds = true
    
    secondsBetweenTurnsButton = UIButton.button(title: Lets.secondsBetweenTurnsString, target: self, selector: #selector(secondsBetweenTurnsButtonTapped), font: Theme.Fonts.playLabels)
    let secondsBetweenTurnsStackView = StackView(arrangedSubviews: [secondsBetweenTurnsButton], axis: .horizontal, spacing: 8, distribution: .fillEqually)
    
    squareButton = UIButton.button(title: Lets.squaresString, target: self, selector: #selector(squareButtonTapped), font: Theme.Fonts.playLabels )
    squareButton.titleLabel?.numberOfLines = 2
    squareButton.titleLabel?.textAlignment = .center
    numberButton = UIButton.button(title: Lets.numbersString, target: self, selector: #selector(numberButtonTapped), font: Theme.Fonts.playLabels)
    numberButton.titleLabel?.numberOfLines = 2
    numberButton.titleLabel?.textAlignment = .center
    colorButton = UIButton.button(title: Lets.colorsString, target: self, selector: #selector(colorButtonTapped), font: Theme.Fonts.playLabels)
    colorButton.titleLabel?.numberOfLines = 2
    colorButton.titleLabel?.textAlignment = .center
    
    levelButton = UIButton.button(title: Lets.levelString, target: self, selector: #selector(levelButtonTapped), font: Theme.Fonts.playLabels)
    turnsButton = UIButton.button(title: Lets.turnsString, target: self, selector: #selector(turnsButtonTapped), font: Theme.Fonts.playLabels)
    let levelAndTurnsStackView = StackView(arrangedSubviews: [levelButton, turnsButton], axis: .horizontal, spacing: 8, distribution: .fillEqually)
    
    let squaresIsOn = GameSettings.types.contains(.squares)
    rowsButton = UIButton.button(title: Lets.rowsString, target: self, selector: #selector(rowsButtonTapped), font: Theme.Fonts.playLabels)
    rowsButton.isEnabled = squaresIsOn
    columnsButton = UIButton.button(title: Lets.columnsString, target: self, selector: #selector(columnsButtonTapped), font: Theme.Fonts.playLabels)
    columnsButton.isEnabled = squaresIsOn
    let rowsAndColumnsStackView = StackView(arrangedSubviews: [rowsButton,columnsButton], axis: .horizontal, spacing: 8, distribution: .fillEqually)
    
    playGameButton = UIButton.button(title: Lets.playl10n, target: self, selector: nil, font: Theme.Fonts.playLabels)
    playGameButton.rx.tap.subscribe(onNext: delegate.newGameTapped).addDisposableTo(db)
    
    playGameButton.backgroundColor = Theme.Colors.playButtonBackground
    playGameButton.setTitleColor(Theme.Colors.playButtonFont, for: UIControlState())
    playGameButton.layer.cornerRadius = 5
    let playGameButtonStackView = StackView(arrangedSubviews: [playGameButton], axis: .horizontal, spacing: 0, distribution: .fillEqually)
    
    var views: [UIView]
    
    if UIScreen.main.bounds.height > 0 {
      views = [secondsBetweenTurnsStackView, squareButton, numberButton, colorButton, levelAndTurnsStackView,rowsAndColumnsStackView,playGameButtonStackView]
    } else {
      let typeButtonsStackView = StackView(arrangedSubviews: [squareButton,numberButton,colorButton], axis: .horizontal, spacing: 8, distribution: .fillEqually)
      views = [secondsBetweenTurnsStackView, typeButtonsStackView, levelAndTurnsStackView, rowsAndColumnsStackView, playGameButtonStackView]
    }
    
    let preStackView = StackView(arrangedSubviews: views, axis: .vertical, spacing: 8, distribution: .fillEqually)
    let stackView = StackView(arrangedSubviews: [lastGameLabel,preStackView], axis: .vertical, spacing: 8, distribution: .fill)
    stackView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stackView)
    
    var constraints = [NSLayoutConstraint]()
    
    let centerConstraint = stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    centerConstraint.priority = 100
    constraints.append(centerConstraint)
    constraints.append(stackView.topAnchor.constraint(greaterThanOrEqualTo: topLayoutGuide.bottomAnchor, constant: 16))
    constraints.append(stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomLayoutGuide.topAnchor, constant: -16))
    constraints.append(stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor))
    constraints.append(stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor))
    
    NSLayoutConstraint.activate(constraints)
    view.setNeedsLayout()
  }
  
  func secondsBetweenTurnsButtonTapped() {
    if GameSettings.secondsBetweenTurns == Lets.secondsBetweenTurns.max {
      GameSettings.secondsBetweenTurns = Lets.secondsBetweenTurns.min
    } else {
      GameSettings.secondsBetweenTurns += Lets.secondsBetweenTurns.increment
    }
    secondsBetweenTurnsButton.set(title: Lets.secondsBetweenTurnsString)
  }
  func typeButtonTapped(type: NBackType, button: UIButton) {
    var types = GameSettings.types
    if let index = types.index(of: type) {
      types.remove(at: index)
      GameSettings.types = types
    } else {
      types.append(type)
      GameSettings.types = types
    }
    if GameSettings.types.count == 0 {
      playGameButton.isEnabled = false
    } else {
      playGameButton.isEnabled = true
    }
  }
  func numberButtonTapped() {
    typeButtonTapped(type: .numbers, button: numberButton)
    numberButton.set(title: Lets.numbersString)
  }
  func squareButtonTapped() {
    typeButtonTapped(type: .squares, button: squareButton)
    squareButton.set(title: Lets.squaresString)
    let isOn = GameSettings.types.contains(.squares)
    rowsButton.isEnabled = isOn
    columnsButton.isEnabled = isOn
  }
  func colorButtonTapped() {
    typeButtonTapped(type: .colors, button: colorButton)
    colorButton.set(title: Lets.colorsString)
  }
  
  func levelButtonTapped() {
    if GameSettings.level == Lets.levels.max {
      GameSettings.level = Lets.levels.min
    } else {
      GameSettings.level += Lets.levels.increment
    }
    levelButton.set(title: Lets.levelString)
  }
  func turnsButtonTapped() {
    if GameSettings.numberOfTurns == Lets.turns.max {
      GameSettings.numberOfTurns = Lets.turns.min
    } else {
      GameSettings.numberOfTurns += Lets.turns.increment
    }
    turnsButton.set(title: Lets.turnsString)
  }
  
  func rowsButtonTapped() {
    if GameSettings.rows == Lets.rows.max {
      GameSettings.rows = Lets.rows.min
    } else {
      GameSettings.rows += Lets.rows.increment
    }
    rowsButton.set(title: Lets.rowsString)
  }
  
  func columnsButtonTapped() {
    if GameSettings.columns == Lets.columns.max {
      GameSettings.columns = Lets.columns.min
    } else {
      GameSettings.columns += Lets.columns.increment
    }
    columnsButton.set(title: Lets.columnsString)
  }
  
  let db = DisposeBag()
}





