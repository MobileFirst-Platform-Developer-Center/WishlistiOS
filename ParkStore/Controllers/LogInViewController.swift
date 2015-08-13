/**
* Copyright 2015 IBM Corp.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import UIKit

class LogInViewController: UIViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    weak var challengeHandler : ParkStoreChallengeHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction private func doneButtonPressed(sender: AnyObject!) {
        
        view.endEditing(true)
        self.doneButton.enabled = false
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        challengeHandler.submitLogin(username, password: password)
        //access any secured item and on success move to next screen
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LogInViewController: UITextFieldDelegate {

    @IBAction func textFieldDidChange(sender: UITextField) {
        if (!usernameTextField.text.isEmpty && !passwordTextField.text.isEmpty){
            doneButton.enabled = true
        } else {
            doneButton.enabled = false
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField?.becomeFirstResponder()
            usernameTextField?.resignFirstResponder()
            
            return true
        } else {
            textField.resignFirstResponder()
            doneButtonPressed(doneButton)
            return true
        }
    }
}
