import UIKit

typealias ActionHandler = () -> Void

struct ErrorModel {
    let message: String
    var cancelText: String? = nil
    let actionText: String
    let action: ActionHandler?
}

protocol ErrorView {
    
    func showError(with model: ErrorModel)
    
    func errorModel(_ error: Error,
                    action: ActionHandler?) -> ErrorModel
}

extension ErrorView where Self: UIViewController {
    
    func showError(with model: ErrorModel) {
        let title = NSLocalizedString("Error.title", comment: "")
        let alert = UIAlertController(
            title: title,
            message: model.message,
            preferredStyle: .alert
        )
        
        if let cancelText = model.cancelText {
            let cancelAction = UIAlertAction(title: cancelText,
                                            style: UIAlertAction.Style.cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        
        if let doneAction = model.action {
            
            let alertAction = UIAlertAction(title: model.actionText,
                                      style: UIAlertAction.Style.default) {_ in
                doneAction()
            }
            
            alert.addAction(alertAction)
        }
        
        present(alert, animated: true)
    }
    
    func errorModel(_ error: Error, action: ActionHandler? = nil) -> ErrorModel {
        
        let message: String
        var cancelText: String?
        
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "") // или "Произошла ошибка сети"
        case is PaymentError:
            message = NSLocalizedString("Error.payment", comment: "") // Не удалось произвести оплату
            cancelText = "Отмена"
        default:
            message = NSLocalizedString("Error.unknown", comment: "") // или "Произошла неизвестная ошибка"
        }
        
        let actionText = NSLocalizedString("Error.repeat", comment: "") // или "Повторить"
        
        return ErrorModel(
            message: message,
            cancelText: cancelText,
            actionText: actionText,
            action: action
        )
    }
}
