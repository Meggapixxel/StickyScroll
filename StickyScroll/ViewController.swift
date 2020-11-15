//
//  ViewController.swift
//  StickyScroll
//
//  Created by Vadim Zhydenko on 15.11.2020.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var tableViewTopConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bounces = false
        tableViewTopConstraint.constant = LocalConstans.maxConst
    }
    
}

private extension ViewController {
    
    struct LocalConstans {
        
        static var minConst: CGFloat { 0 }
        static var maxConst: CGFloat { UIScreen.main.bounds.height / 4 }
        
    }
    
}

extension ViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView)
        if velocity.y == 0 {
            if scrollView.contentInset.top == LocalConstans.maxConst && scrollView.contentOffset.y <= 0 {
                print(#function, "??", scrollView.contentOffset.y, tableViewTopConstraint.constant)
                if tableViewTopConstraint.constant - scrollView.contentOffset.y > LocalConstans.maxConst {
                    scrollView.contentInset.top = 0
                    tableViewTopConstraint.constant = LocalConstans.maxConst
                } else {
                    tableViewTopConstraint.constant -= scrollView.contentOffset.y
                    scrollView.contentOffset.y = 0
                }
            } else if tableViewTopConstraint.constant != LocalConstans.minConst {
                print(#function, "?↑", scrollView.contentOffset.y, tableViewTopConstraint.constant)
                if tableViewTopConstraint.constant - scrollView.contentOffset.y < LocalConstans.minConst {
                    scrollView.contentOffset.y = scrollView.contentOffset.y - tableViewTopConstraint.constant
                    tableViewTopConstraint.constant = LocalConstans.minConst
                    scrollView.contentInset.top = LocalConstans.maxConst
                } else {
                    tableViewTopConstraint.constant -= scrollView.contentOffset.y
                    scrollView.contentOffset.y = 0
                }
            } else {
                print(#function, "?", scrollView.contentOffset.y, velocity.y)
            }
        } else {
            if velocity.y > 0 {
                print(#function, "↓", scrollView.contentOffset.y, tableViewTopConstraint.constant)
                guard scrollView.contentOffset.y < 0 && tableViewTopConstraint.constant != LocalConstans.maxConst else { return }
                if tableViewTopConstraint.constant - scrollView.contentOffset.y > LocalConstans.maxConst {
                    scrollView.contentOffset.y = (LocalConstans.maxConst - tableViewTopConstraint.constant) - scrollView.contentOffset.y 
                    tableViewTopConstraint.constant = LocalConstans.maxConst
                } else {
                    tableViewTopConstraint.constant -= scrollView.contentOffset.y
                    scrollView.contentOffset.y = 0
                }
            } else {
                print(#function, "↑", scrollView.contentOffset.y, tableViewTopConstraint.constant)
                guard scrollView.contentOffset.y > 0 && tableViewTopConstraint.constant != LocalConstans.minConst else { return }
                if tableViewTopConstraint.constant - scrollView.contentOffset.y < LocalConstans.minConst {
                    scrollView.contentOffset.y = scrollView.contentOffset.y - tableViewTopConstraint.constant
                    tableViewTopConstraint.constant = LocalConstans.minConst
                    scrollView.contentInset.top = LocalConstans.maxConst
                } else {
                    tableViewTopConstraint.constant -= scrollView.contentOffset.y
                    scrollView.contentOffset.y = 0
                }
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print(#function, scrollView.contentOffset.y, targetContentOffset.pointee.y)
        if scrollView.contentOffset.y == targetContentOffset.pointee.y && targetContentOffset.pointee.y <= LocalConstans.maxConst  {
            if tableViewTopConstraint.constant < LocalConstans.maxConst / 2 {
                tableViewTopConstraint.constant = LocalConstans.minConst
                scrollView.contentInset.top = LocalConstans.maxConst
            } else {
                tableViewTopConstraint.constant = LocalConstans.maxConst
                scrollView.contentInset.top = 0
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        else if scrollView.contentOffset.y < 0 && targetContentOffset.pointee.y == 0 {
            guard tableViewTopConstraint.constant != LocalConstans.maxConst else { return }
            tableViewTopConstraint.constant = LocalConstans.maxConst
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        else if scrollView.contentOffset.y > 0 && targetContentOffset.pointee.y < 0 && scrollView.contentInset.top == LocalConstans.maxConst && targetContentOffset.pointee.y != -scrollView.contentInset.top {
            targetContentOffset.pointee.y = -scrollView.contentInset.top
        }
        else {
            
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = indexPath.description
        return cell
    }
    
}
