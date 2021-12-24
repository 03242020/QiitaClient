//
//  tabBarViewController.swift
//  QiitaClient
//
//  Created by ryo.inomata on 2021/12/23.
//

import Foundation
import UIKit

class tabBarViewController: UITabBarController {
   
    var tag = 0
    
   override func viewDidLoad() {
       super.viewDidLoad()
       //タグの設定
       tabBar.items![0].tag = 0
       tabBar.items![1].tag = 1
   }
   
   //タブを選択した時のメソッド
   override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
       //tagの値がコンソール出力されます
       print("item.tag: ",item.tag)
       switch item.tag {
       case 0:
           print("foo")
       default:
           print("bar")
//           let storyboard = UIStoryboard(name: "ViewController", bundle: nil)
//           guard let viewController = storyboard.instantiateInitialViewController() as? ViewController else { return }
//           self.tag = 1
       }
   }
//    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
//            switch item.tag {
//            case 1:
//              println("foo")
//            default:
//              println("bar")
//            }
//        }
    
 }
