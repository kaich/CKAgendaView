//
//  CKAgendaView.swift
//  CKAgendaView
//
//  Created by mk on 2018/2/23.
//

import UIKit
import FSCalendar
import SnapKit

public class CKAgendaView: UIView {
    var calendar: FSCalendar!
    var tbEvent: UITableView!

    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm:ss"
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupViews() {
        
        calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        calendar.locale = Locale(identifier: "zh_CN")
        addSubview(calendar)
        
        tbEvent = UITableView()
        tbEvent.allowsSelection = false
        tbEvent.delegate = self
        tbEvent.dataSource = self
        tbEvent.tableFooterView = UIView()
        addSubview(tbEvent)
        
        addGestureRecognizer(scopeGesture)
        tbEvent.panGestureRecognizer.require(toFail: scopeGesture)
        tbEvent.register(CKAgendaTableViewCell.self, forCellReuseIdentifier: "CKAgendaTableViewCell")
        
        calendar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        tbEvent.snp.makeConstraints { (make) in
            make.top.equalTo(calendar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        CKAgendaManager.shared.dataChangedHandler = {
            self.tbEvent.reloadData()
        }
        CKAgendaManager.shared.selectedDate = Date()
    }
    
}


extension CKAgendaView: UIGestureRecognizerDelegate {
    
    override public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == scopeGesture else {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        
        let shouldBegin = self.tbEvent.contentOffset.y <= -self.tbEvent.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
}

extension CKAgendaView: FSCalendarDataSource, FSCalendarDelegate {
    
    public func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return CKAgendaManager.shared.entitiesFor(date: date).count > 0 ? 1 : 0
    }
    
    public func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
        }
    }
    
    public func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        
        CKAgendaManager.shared.selectedDate = date
    }
    
    public func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
}


extension CKAgendaView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CKAgendaManager.shared.entities.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CKAgendaTableViewCell", for: indexPath) as! CKAgendaTableViewCell
        let agenda = CKAgendaManager.shared.entities[indexPath.row]
        cell.lblTitle.text = agenda.title
        cell.lblMessage.text = agenda.message
        cell.lblTime.text = timeFormatter.string(from: agenda.date!)
        if let imageName = agenda.imageName {
            cell.ivImage.image = UIImage(named: imageName)
        }
        return cell
    }
    
    
}
