//
//  PhotoDetailViewController.swift
//  PhotoProject
//
//  Created by 박신영 on 1/18/25.
//

import UIKit

final class PhotoDetailViewController: BaseViewController {
    
    private let mainView = PhotoDetailView()
    var photoDetailModel: PhotoDetailModel?
    
    override func loadView() {
        view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let photoDetailModel else {return}
        mainView.setDataUI(photoDetailModel: photoDetailModel)
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
