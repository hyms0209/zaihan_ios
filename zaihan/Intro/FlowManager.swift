


import Foundation
import UserNotifications
import UIKit
import Moya

/*
 * 초기 구동 처리
 * 최초 구동
 *  => 스플래시 -> 접근권한 안내 -> 앱 업데이트 유무 -> 튜토리얼 -> 메인노출
 */

enum TaskFlow: Int {
    case appemgNotice       = 0    // 긴급시스템 공지
    case appUpdate          = 1    // 앱업데이트
    case permission         = 2    // 권한동의
    case main               = 3    // 메인
}

protocol FlowManageDelegate {
    func onCancel(_ sender: TaskFlow)
    func onNext(_ sender: TaskFlow, param: [String: Any]?)
}

class FlowManager: FlowManageDelegate {
    
    deinit {
//        print("FlowManager deinit!!!")
    }
    
    var context:UIViewController?
    
    var queue:[TaskFlow] = []
    
    init(viewcontroller:UIViewController) {
        context         = viewcontroller
    }
    
    /**
     * 플로우 큐의 초기화( 타스크 진행 순서대로 추가 )
     * @param nil
     * @returns nil
     */
    func taskItem() {
        
        // 큐에 진행할 플로우 추가
        queue.removeAll()
        
        queue.append(.appemgNotice)
        queue.append(.appUpdate)
        queue.append(.permission)
        queue.append(.main)
    }
    
    /**
     * 플로우 큐의 아이템 취득 ( init에 쌓은 순서 )
     * @param   nil
     * @returns nil
     */
    func nextTask() -> TaskFlow {
        let task = queue.first
//        print("=====> NEXT TASK : \(task.debugDescription)")
        return task!
    }
    
    
    /**
     * 플로우 매니저 시작
     * @param
     * @returns
     */
    func start() {
        taskItem()
        runFlow(task: nextTask(), param:nil)
    }
    
    /**
     * 실제 기능을 실행
     * @param
     * @returns
     */
    func runFlow(task:TaskFlow, param:[String:Any]?) {
//        print("=====> RUN TASK : \(task)")
        switch task {

        case .permission:                       // 앱 접근 권한 실행
            goPermisson(param: param)
            break
        case .appemgNotice:                   // 앱 기본정보 취득
            goAppEmergencyNotice()
            break
        case .appUpdate:                      // 앱 업데이트 정보 취득
            goAppUpdateInfo(param: param)
            break
        case .main:                             // 메인 실행
            goMain(param: param)
            break
        }
        
    }
    
    func end() {
        
    }
    
    /**
     * 해당타스크 뒤로 이동
     * @param       sender : 현재 실행했던 타스크
     * @returns
     */
    func onBack(_ sender: TaskFlow) {
        
    }
    
    /**
     * 해당타스크 실패
     * @param       sender : 현재 실행했던 타스크
     * @returns
     */
    func onCancel(_ sender: TaskFlow) {
        switch sender {
        case .permission:
            break
        case .appemgNotice:
            onNext(.appemgNotice, param: nil)
            break
        case .appUpdate:
            onNext(.appUpdate, param: nil)
            break
        case .main:
            break
        default: break
        }
    }
    
    /**
     * 다음 타스크 진행
     * @param
     * @returns
     */
    func onNext(_ sender: TaskFlow, param: [String : Any]?) {
        queue = queue.filter({$0 != sender})
        runFlow(task: nextTask(), param:param)
    }
    
    
    /**
     * 접근권한 동의 처리
     * @param
     * @returns
     */
    func goPermisson(param:[String:Any]?) {
        print("=====>PERMISSION ")
       
        
        
//        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//            if let error = error {
//                print("D'oh: \(error.localizedDescription)")
//            } else {
//                if granted {
//                    DispatchQueue.main.async {
//                        UIApplication.shared.registerForRemoteNotifications()
//                    }
//                }
//            }
//        }
//
        PermissionVC.requiredPermissionCheck({
//            print("permission check ok")
            self.onNext(.permission, param: nil)
        })
    }
    
    /**
     * 앱 시스템점검 확인 처리
     * @param
     * @returns
     */
    func goAppEmergencyNotice() {
        print("=====> EMERGENCYNOTICE")
        mainFlowProvider.rx.request(MainFlowType.emergency)
            .asObservable()
            .mapObject(Emergency.Response.self)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                var vc = EmergencyPopup.instance()
                vc.modalPresentationStyle = .overCurrentContext
                vc.content = result
                vc.complete = {[weak self] in
//                    exit(0)
                    guard let self = self else { return }
                    self.onNext(.appemgNotice, param: nil)
                }
                self.context?.navigationController?.present(vc, animated: false, completion: nil)
            }, onError: { error in
                
            }, onCompleted: {
                
            })
    }
    
    /**
     * 앱 업데이트 정보 처리
     * @param
     * @returns
     */
    func goAppUpdateInfo(param:[String:Any]?) {
//        print("=====> APPUPDATEINFO")
        onNext(.appUpdate, param: nil)
        let appUpdateInfo = AppUpdateInfo()
//        appUpdateInfo.delegate = self
//        appUpdateInfo.context  = self.context
//        appUpdateInfo.start()
    }

    
    /**
     * 메인 이동 처리
     * @param
     * @returns
     */
    func goMain(param:[String:Any]?) {
//        print("================ MAIN ================")
        //context?.navigationController?.popToRootViewController(animated: false)
        
        let vc = MainVC.instance()
        self.context?.navigationController?.setViewControllers([vc], animated: true)
    }
}

