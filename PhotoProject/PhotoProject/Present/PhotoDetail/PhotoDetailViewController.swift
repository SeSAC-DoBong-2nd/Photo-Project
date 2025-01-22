//
//  PhotoDetailViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit
import DGCharts

final class PhotoDetailViewController: BaseViewController {
    
    var photoDetailModel: PhotoDetailModel?
    
    private let mainView = PhotoDetailView()
    
    override func loadView() {
        view = mainView
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let photoDetailModel
        else {return}
        DispatchQueue.main.async {
            self.mainView.setDataUI(photoDetailModel: photoDetailModel)
            self.setChart(title: "한달 조회 수", dataPoints: photoDetailModel.monthView.monthViewDates, lineValues: photoDetailModel.monthView.monthViewValues)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavUI()
        setAddtarget()
    }
    
    

}

//MARK: - private extension
private extension PhotoDetailViewController {
    
    func setNavUI() {
        let navLeftItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                          style: .done,
                                          target: self,
                                          action: #selector(navLeftBtnTapped))
        navLeftItem.tintColor = .black
        navigationItem.leftBarButtonItem = navLeftItem
    }
    
    func setAddtarget() {
        mainView.chartSegmentedControl.addTarget(self, action: #selector(segmentedControlTapped), for: .valueChanged)
    }
    
    func setChart(title: String, dataPoints: [String], lineValues: [Int]) {
        var lineDataEntries: [ChartDataEntry] = []
                
        for i in 0..<dataPoints.count {
            let lineDataEntry = ChartDataEntry(x: Double(i), y: Double(lineValues[i]))
            lineDataEntries.append(lineDataEntry)
        }

        let lineChartDataSet = LineChartDataSet(entries: lineDataEntries, label: title)
        
        lineChartDataSet.colors = [.cyan]
        lineChartDataSet.circleColors = [.blue]

        let data: CombinedChartData = CombinedChartData()
        
        data.lineData = LineChartData(dataSet: lineChartDataSet)
        
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.circleHoleRadius = 2.0
        lineChartDataSet.circleRadius = 3

        // 콤비 데이터 지정
        mainView.combinedChartView.data = data
        
        mainView.combinedChartView.do {
            $0.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
            $0.backgroundColor = .clear
        }
    }
    
}

//MARK: - @objc private extension
private extension PhotoDetailViewController {
    
    @objc
    func navLeftBtnTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func segmentedControlTapped(_ sender: UISegmentedControl) {
        guard let monthView = photoDetailModel?.monthView,
              let monthDownload = photoDetailModel?.monthDownload
        else { return print("segmentedControlTapped") }
        
        switch sender.selectedSegmentIndex {
        case 0:
            print("000")
            self.setChart(title: "한달 조회 수", dataPoints: monthView.monthViewDates, lineValues: monthView.monthViewValues)
        case 1:
            print("111")
            self.setChart(title: "한달 다운로드 수", dataPoints: monthDownload.monthDownloadDates, lineValues: monthDownload.monthDownloadValues)
        default: return
        }
    }
    
}
