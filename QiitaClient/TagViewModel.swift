////
////  TagViewModel.swift
////  QiitaClient
////
////  Created by ryo.inomata on 2022/01/04.
////
//
//import Foundation
//import RxSwift
//import RxCocoa
//
//struct CounterViewModelInput {
////    let countUpButton: Observable<Void>
////    let countDownButton: Observable<Void>
////    let countResetButton: Observable<Void>
//    let buttonIos: Observable<Void>
//    let buttonKotlin: Observable<Void>
//    let buttonJava: Observable<Void>
//}
//
//protocol CounterViewModelOutput {
//    var counterText: Driver<String?> { get }
//}
//
//protocol CounterViewModelType {
//    var outputs: CounterViewModelOutput? { get }
//    func setup(input: CounterViewModelInput)
//}
//
//class CounterRxViewModel: CounterViewModelType {
//    var outputs: CounterViewModelOutput?
//
////    private let countRelay = BehaviorRelay<Int>(value: 0)
//    //要確認
//    private let countReley = BehaviorRelay<String>(value: "iOS")
////    private let initialCount = 0
//    private let initialTag = "iOS"
//    private let disposeBag = DisposeBag()
//
//    init() {
//        self.outputs = self
//        resetCount()
//    }
//
//    func setup(input: CounterViewModelInput) {
////        input.countUpButton
//        input.buttonIos
//            .subscribe(onNext: { [weak self] in
//                self?.counterText
//            })
//            .disposed(by: disposeBag)
//
////        input.countDownButton
//        input.buttonKotlin
//            .subscribe(onNext: { [weak self] in
//            self?.decrementCount()
//            })
//            .disposed(by: disposeBag)
//
////        input.countResetButton
//        input.buttonJava
//            .subscribe(onNext: { [weak self] in
//            self?.resetCount()
//            })
//            .disposed(by: disposeBag)
//    }
//
////    private func incrementCount() {
//    private func pushButtonIos() {
//        let tag = countRelay.value.add("iOS")
//        countRelay.accept(count)
//    }
//
//    private func decrementCount() {
//        let count = countRelay.value - 1
//        countRelay.accept(count)
//    }
//
//    private func resetCount() {
//        countRelay.accept(initialCount)
//    }
//}
//
//extension CounterRxViewModel: CounterViewModelOutput {
//    var counterText: Driver<String?> {
//        return countRelay
//            .map { "Rx pattern: \($0)" }
//            .asDriver(onErrorJustReturn: nil)
//    }
//}
