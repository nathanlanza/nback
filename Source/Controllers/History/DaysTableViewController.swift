import UIKit
import RxCocoa
import RxSwift
import RxDataSources

protocol DaysTableViewControllerDelegate: class {
    func didSelectDay(_ day: Day)
}

class DaysTableViewController: ViewController {
    weak var delegate: DaysTableViewControllerDelegate!
    
   
    let tableView = UITableView()
    
    let monthInfos = Database.monthInfos
    var sections: [HistorySectionModel] = []
    let dataSource = RxTableViewSectionedAnimatedDataSource<HistorySectionModel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sections = monthInfos.map { HistorySectionModel.month(monthInfo: $0) }
        
        tableView.frame = view.frame
        view.addSubview(tableView)
        
        setupTableView()
    }
    
    
    
    func setupTableView() {
        Observable.just(sections).bindTo(tableView.rx.items(dataSource: dataSource)).addDisposableTo(db)
        
        dataSource.configureCell = { dataSource, tableView, indexPath, dayInfo in
            let cell = UITableViewCell()
            cell.textLabel?.text = String(dayInfo.day) + ", " + String(dayInfo.results.count)
            
            return cell
        }
    }
    
    let db = DisposeBag()
}


enum HistorySectionModel {
    case month(monthInfo: MonthInfo)
}

extension HistorySectionModel: AnimatableSectionModelType {
    
    var identity: YearMonth {
        switch self {
        case .month(monthInfo: let monthInfo):
            return YearMonth(year: monthInfo.year, month: monthInfo.month)
        }
    }
    
    typealias Item = DayInfo
    var items: [DayInfo] {
        switch self {
        case .month(monthInfo: let monthInfo):
            return monthInfo.dayInfoDict.values.sorted { $0.day > $1.day }
        }
    }
    init(original: HistorySectionModel, items: [DayInfo]) {
        switch original {
        case .month(monthInfo: let monthInfo):
            var newMonthInfo = MonthInfo(year: monthInfo.year, month: monthInfo.month)
            var dayInfoDict: [Int:DayInfo] = [:]
            for dayInfo in items {
                dayInfoDict[dayInfo.day] = dayInfo
            }
            newMonthInfo.dayInfoDict = dayInfoDict
            self = .month(monthInfo: newMonthInfo)
        }
    }
}
