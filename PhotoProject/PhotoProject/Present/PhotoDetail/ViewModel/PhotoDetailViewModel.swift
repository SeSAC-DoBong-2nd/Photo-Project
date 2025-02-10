//
//  PhotoDetailViewModel.swift
//  PhotoProject
//
//  Created by 박신영 on 2/10/25.
//

import Foundation

final class PhotoDetailViewModel: ViewModelProtocol {
    
    private(set) var input: Input
    private(set) var output: Output
    
    struct Input {
        let loadPhotoDetailData: Observable<Void> = Observable(())
        let loadChart: Observable<Int> = Observable(0)
    }
    
    struct Output {
        let setPhotoDetailData: Observable<PhotoDetailModel?> = Observable(nil)
        let setChart: Observable<MonthData?> = Observable(nil)
    }
    
    let photoDetailModel: PhotoDetailModel
    let isSuccessLoad: Bool
    
    init(photoDetailModel: PhotoDetailModel, isSuccessLoad: Bool) {
        input = Input()
        output = Output()
        self.photoDetailModel = photoDetailModel
        self.isSuccessLoad = isSuccessLoad
        
        transform()
    }
    
    internal func transform() {
        input.loadPhotoDetailData.lazyBind { [weak self] _ in
            self?.isValidPhotoDetailData()
        }
        
        input.loadChart.lazyBind { [weak self] selectedIndex in
            guard let self else {return}
            if selectedIndex == 0 {
                output.setChart.value = photoDetailModel.monthView
            } else {
                output.setChart.value = photoDetailModel.monthDownload
            }
        }
    }
    
}

private extension PhotoDetailViewModel {
    
    func isValidPhotoDetailData() {
        if isSuccessLoad {
            output.setPhotoDetailData.value = photoDetailModel
            output.setChart.value = photoDetailModel.monthDownload
        }
    }
    
}
