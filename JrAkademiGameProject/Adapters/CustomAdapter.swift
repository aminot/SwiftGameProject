

//
//  customizeAdapter.swift
//  JrAkademiGameProject
//
//  Created by ufuk donmez on 5.06.2023.
//

import Carbon
class CustomTableViewAdapter: UITableViewAdapter {
    var isLast = false
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex  {
            print("Son hücre", lastRowIndex , indexPath)
            isLast = true
            NotificationCenter.default.post(name: NSNotification.Name("İslemTamamlandi"), object: nil, userInfo: ["veri": isLast])
        }
    }
}
