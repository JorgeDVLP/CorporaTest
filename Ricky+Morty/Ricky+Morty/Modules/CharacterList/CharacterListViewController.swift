//
//  CharacterListViewController.swift
//  Ricky+Morty
//
//  Created by Jorge Martin Moreno on 3/6/22.
//

import UIKit

class CharacterListViewController: UIViewController, StoryBoarded {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterControl: UISegmentedControl!
    
    weak var eventDelegate: CharacterListEventDelegate?
    var viewModel: CharacterListViewModel!
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let noResultsIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "info.circle")
        img.contentMode = .scaleAspectFit
        img.tintColor = UIColor.gray
        return img
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No results"
        label.textColor = UIColor.gray
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Characters"
        configureCollectionView()
        bindView()
        configureBackgroundView()
        hideBackgroundView()
        self.viewModel.fetchData()
    }
    
    private func configureCollectionView() {
        self.collectionView.register(CharacterCollectionViewCell.nib(), forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier)
        self.collectionView.register(IndicatorCollectionViewCell.self, forCellWithReuseIdentifier: IndicatorCollectionViewCell.reuseIdentifier)
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.backgroundView = UIView(frame: CGRect.zero)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    private func configureBackgroundView() {
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate(
            [stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        
        stackView.addArrangedSubview(noResultsIcon)
        stackView.addArrangedSubview(noResultsLabel)
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillProportionally
    }
    
    private func showBackgroundView() {
        stackView.isHidden = false
    }
    
    private func hideBackgroundView() {
        stackView.isHidden = true
    }
    
    private func bindView() {
        self.viewModel.onDataFetched = { [weak self] count in
            self?.collectionView.reloadData()
            if count > 0 {
                self?.hideBackgroundView()
                self?.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            } else {
                self?.showBackgroundView()
            }
        }
        
        self.viewModel.onDataAdded = { [weak self] rows in
            self?.collectionView.performBatchUpdates { [weak self] in
                self?.collectionView.insertItems(at: rows)
            }
        }
        
        self.viewModel.onShouldDisplayIndicator = { [weak self] display in
            display == true ? self?.showActivityIndicator() : self?.removeActivityIndicator()
        }
        
        self.viewModel.onError = { [weak self] message in
            self?.showErrorAlert(message)
        }
    }
    
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func onFilterChanged() {
        self.viewModel.onFilterChanged(index: self.filterControl.selectedSegmentIndex)
    }
}

extension CharacterListViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.viewModel.numberOfItems(forSection: section)
        return count > 0 ? count + 1 : count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = self.viewModel.numberOfItems(forSection: indexPath.section)
        
        if indexPath.row == count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IndicatorCollectionViewCell.reuseIdentifier, for: indexPath) as! IndicatorCollectionViewCell
            cell.inidicator.startAnimating()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseIdentifier, for: indexPath)
        
        let item = viewModel.getItem(forIndex: indexPath)
        
        CellDrawer(strattegy: CharacterStrattegy()).draw(cell, model: item)
        
        return cell
    }
}

extension CharacterListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        let limit = self.collectionView.contentSize.height - 100 - scrollView.frame.size.height
        if position > limit {
            self.viewModel.fetchNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = self.viewModel.getItem(forIndex: indexPath)
        self.eventDelegate?.onCharacterSelected(item)
    }
}

extension CharacterListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minSize = 185.0
        let count = self.viewModel.numberOfItems(forSection: indexPath.section)
        let indicatorCellSize = collectionView.frame.size
        let fourCellWidth = (view.frame.width - 32) / 4
        let characterCellWidth = fourCellWidth < minSize ? minSize : fourCellWidth
        let size: CGSize = count == indexPath.row ? CGSize(width: indicatorCellSize.width, height: 180) : CGSize(width: characterCellWidth, height: 240)
        return size
    }
}
