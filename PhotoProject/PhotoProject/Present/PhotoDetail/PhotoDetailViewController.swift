//
//  PhotoDetailViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

final class PhotoDetailViewController: BaseViewController {
    
    private let viewModel: PhotoDetailViewModel
    
    private let mainView = PhotoDetailView()
    
    init(viewModel: PhotoDetailViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    override func loadView() {
        print(#function)
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.input.loadPhotoDetailData.value = ()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavUI()
        setAddtarget()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.output.setPhotoDetailData.lazyBind { [weak self] result in
            guard let self, let result else {return}
            let photoDetailModel = result
            DispatchQueue.main.async {
                self.mainView.setDataUI(photoDetailModel: photoDetailModel)
                self.setChildrenViewLayout(view: self.mainView)
            }
        }
        
        viewModel.output.setChart.lazyBind { [weak self] chartResult in
            guard let self, let chartResult else {return}
            let title = (mainView.chartSegmentedControl.selectedSegmentIndex == 0) ? "한달 조회 수" : "한달 다운로드 수"
            DispatchQueue.main.async {
                self.mainView.setChart(title: title, dataPoints:
                                        chartResult.dates, lineValues: chartResult.values)
            }
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
        mainView.chartSegmentedControl.addTarget(self,
                                                 action: #selector(segmentedControlTapped),
                                                 for: .valueChanged)
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
        viewModel.input.loadChart.value = sender.selectedSegmentIndex
    }
    
}
