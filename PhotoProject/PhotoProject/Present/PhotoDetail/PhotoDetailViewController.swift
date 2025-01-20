//
//  PhotoDetailViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit
import DGCharts

final class PhotoDetailViewController: BaseViewController {
    
    private let mainView = PhotoDetailView()
    var photoDetailModel: PhotoDetailModel?
    
//    lazy var graphArray = Array(repeating: "", count: photoDetailModel?.day30DownCount.count ?? 0)
    var graphArray: [String] = ["09시", "10시", "11시", "12시", "13시", "14시", "15시", "16시", "17시", "18시"]

    let barUnitsSold = [10.0, 17.0, 9.0, 1.0, 8.0, 13.0, 16.0, 14.0, 7.0, 1.0]
    let lineUnitsSold = [10.0, 18.0, 7.0, 1.0, 5.0, 15.0, 14.0, 17.0, 7.0, 1.0]
    
    override func loadView() {
        view = mainView
        print(#function)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let photoDetailModel else {return}
        DispatchQueue.main.async {
            self.mainView.setDataUI(photoDetailModel: photoDetailModel)
            print(#function)
        }
        print(#function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setNavUI()
        setAddtarget()
        setChart(dataPoints: graphArray, barValues: barUnitsSold, lineValues: lineUnitsSold)
        print(#function)
    }
    
    func setChart(dataPoints: [String], barValues: [Double], lineValues: [Double]) {
        var barDataEntries: [BarChartDataEntry] = []
        var lineDataEntries: [ChartDataEntry] = []
                
        for i in 0..<dataPoints.count {
            let barDataEntry = BarChartDataEntry(x: Double(i), y: barValues[i])
            let lineDataEntry = ChartDataEntry(x: Double(i), y: lineValues[i])
            barDataEntries.append(barDataEntry)
            lineDataEntries.append(lineDataEntry)
        }

        let barChartDataSet = BarChartDataSet(entries: barDataEntries, label: "")
        let lineChartDataSet = LineChartDataSet(entries: lineDataEntries, label: "")
        
        lineChartDataSet.colors = [.blue]
        lineChartDataSet.circleColors = [.white]

        let data: CombinedChartData = CombinedChartData()

        // bar 데이터 지정
        data.barData = BarChartData(dataSet: barChartDataSet)
        // line 데이터 지정
        data.lineData = LineChartData(dataSet: lineChartDataSet)
        
        lineChartDataSet.mode = .cubicBezier

        // 콤비 데이터 지정
        mainView.combinedChartView.data = data
        
        mainView.combinedChartView.do {
            $0.xAxis.valueFormatter = IndexAxisValueFormatter(values: graphArray)
            $0.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        }
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
    
}

//MARK: - @objc private extension
private extension PhotoDetailViewController {
    
    @objc
    func navLeftBtnTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func segmentedControlTapped(_ sender: UISegmentedControl) {
        print(#function)
        sender.selectedSegmentIndex = (sender.selectedSegmentIndex == 0)
        ? 1 : 0
    }
    
}
