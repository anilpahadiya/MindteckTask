//
//  HomeViewController.swift
//  MindteckTask
//
//  Created by Anil Pahadiya on 04/02/23.
//

import UIKit
import Contacts

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var currentInd : Int = 0
    var searchActive : Bool = false
    let searchBar = UISearchBar()
    var filterdata: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Mindteck Task"
        filterdata = productData[currentInd]
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource , UIGestureRecognizerDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section ==  1 {
            return 64
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let  headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 64))
        headerView.backgroundColor = .white
        searchBar.frame = CGRect.init(x: 5, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = " Search Here..."
        searchBar.sizeToFit()
        headerView.addSubview(searchBar)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if(searchActive) {
                return filterdata.count
            }else{
                return productData[currentInd].count
            }
            
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell : UITableViewCell = UITableViewCell()
        if indexPath.section == 0 {
            let cell:BannerCustomTVCell = self.tableView.dequeueReusableCell(withIdentifier: "bannercustom_tvcell") as! BannerCustomTVCell
            cell.cellDelegate = self
            cell.collectionView.reloadData()
            returnCell = cell
        } else if indexPath.section == 1 {
            let modelData : [String] = filterdata
            let cell:ProductTVCell = self.tableView.dequeueReusableCell(withIdentifier: "product_tvcell") as! ProductTVCell
            cell.lbl_Title.text = modelData[indexPath.row]
            returnCell = cell
        }
        return returnCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.section)
        print(indexPath.row)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }    
    
}

extension HomeViewController: CollectionViewBannerSwipeCellDelegate{
    func swipeLRCollectionView(Index: Int) {
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        currentInd = Index
        filterdata = productData[currentInd]
        tableView.reloadData()
    }
}
extension HomeViewController : UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.scrollToTop(section: 1)
        if self.searchBar.text?.isEmpty == false {
            self.searchBar.setShowsCancelButton(true, animated: true)
        }
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        self.searchBar.text = nil
        self.searchBar.resignFirstResponder()
        self.tableView.resignFirstResponder()
        self.searchBar.showsCancelButton = false
        self.filterdata = productData[currentInd]
        self.tableView.reloadData()
        self.scrollToTop(section: 0)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchActive = true;
        self.searchBar.showsCancelButton = true
        filterdata = [String]()
        if searchText == "" {
            filterdata = productData[currentInd]
        } else {
            let modelData : [String] = productData[currentInd]
            for word in modelData
            {
                if word.uppercased().contains(searchText.uppercased()){
                    self.filterdata.append(word)
                }
            }
        }
        self.tableView.reloadData()
    }
    
    
    func scrollToTop(section: Int) {
        let topRow = IndexPath(row: 0,
                               section: section)
        self.tableView.scrollToRow(at: topRow,
                                   at: .top,
                                   animated: true)
    }
    
}

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}


