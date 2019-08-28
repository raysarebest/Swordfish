//
//  SchedulesTableViewController.swift
//  iPortal for Binusmaya
//
//  Created by Kevin Yulias on 08/08/19.
//  Copyright © 2019 Kevin Yulias. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SchedulesTableViewController: UITableViewController {
    
    @IBOutlet weak var topNavigation: UINavigationItem!
    
    var courses: BehaviorRelay<[SectionModel<String, CourseModel>]> = BehaviorRelay(value: [])
    var disposeBag = DisposeBag()
    var schedulesViewModel: SchedulesViewModel = SchedulesViewModel(dependencies: SchedulesViewModelDependencies())
    let rc: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
    }
    
    func setup () {
        self.configureRefreshControl()
        self.setTableView()
        self.setNavigationBarTitleToCurrentDate()
    }
    
    func setNavigationBarTitleToCurrentDate () {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL dd"
        let fullDate = dateFormatter.string(from: now)
        
        topNavigation.title = "Today, \(fullDate)"
    }
    
    func configureRefreshControl () {
        self.rc.attributedTitle = NSAttributedString(string: "Fetching schedules...", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.black
        ])
        self.rc.tintColor = UIColor.black
        self.rc.addTarget(self, action: #selector(self.onRefresh(_:)), for: .valueChanged)
        self.tableView.refreshControl = self.rc
    }
    
    @objc func onRefresh (_ sender: Any) {
        self.schedulesViewModel.sync { event in
            self.courses.accept(event)
            self.rc.endRefreshing()
        }
    }
    
    func setTableView () {
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.tableView.rowHeight = UITableView.automaticDimension
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CourseModel>>(
            configureCell: { (dataSource, tv, indexPath, item) -> UITableViewCell in
                let cell = tv.dequeueReusableCell(withIdentifier: "SchedulesTableViewCell", for: indexPath) as! SchedulesTableViewCell
                cell.courseTitle.text = item.COURSE_TITLE_LONG
                cell.courseRoom.text = item.ROOM
                cell.courseStart.text = item.MEETING_TIME_START
                cell.courseType.text = item.N_DELIVERY_MODE
                cell.classCampus.text = item.LOCATION
                cell.classSection.text = item.CLASS_SECTION
                
                return cell
            }
        )
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            let dateString = dataSource.sectionModels[index].model[0...10]
            
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd"
            
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "EEEE, MMMM dd"
            
            let date = dateFormatterGet.date(from: dateString)
            
            let fullDate = dateFormatterPrint.string(from: date!)
            return fullDate
        }
       
        self.courses
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        self.schedulesViewModel.getScheduleData { courses in
            self.courses.accept(courses)
        }
    }
    

}
