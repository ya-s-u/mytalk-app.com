<?php
class SendMailComponent extends Component {
	public $name = "SendMail";
	public $components = 'mail';
	
	
	public function send_to_person($type,$address) {
    	$vars = array (
    		'username'=> $this->request->data['User']['username'],
    		'mail'=> $this->request->data['User']['mail'],
    		'password'=> $this->request->data['User']['password'],
    		'comment'=> $this->request->data['User']['comment'],
    		'fb_link'=> $this->request->data['User']['fb_link'],
    		'tw_link'=> $this->request->data['User']['tw_link'],
    	);
		$email = new CakeEmail('smtp');
			try {
				$email->config(array('log' => 'emails'))
			  		->template('default','signup')
			  		->viewVars($vars)
			  		->to($this->request->data['User']['mail'])
			  		->bcc('info@f18-mag.com')
			 		->emailFormat('text')
			  		->subject($this->request->data['User']['username'].'さんのライター登録申請が完了しました')
			  		->send();
				$this->User->create();
				$this->request->data['User']['password'] = AuthComponent::password($this->request->data['User']['password']);
				$this->request->data['User']['type'] = 0;
				$this->request->data['User']['created'] = date("Y-m-d G:i:s");
				$this->request->data['User']['last_login'] = date("Y-m-d G:i:s");
				$this->User->save($this->data);
				
				if(is_uploaded_file($_FILES["upfile"]["tmp_name"])) {
					$image = WideImage::loadFromFile($_FILES['upfile']['tmp_name']);
					$id = $this->User->getLastInsertID();
					
					$resized1 = $image->resize(858,null,'inside');
					$resized1->saveToFile('../../app/webroot/img/users/original/img-'.$id.'.jpg');
					
					$resized = $image->resize(200,200,'outside');
					$cropped = $resized->crop('center','center',200,200);
					$cropped->saveToFile('../../app/webroot/img/users/resized/img-'.$id.'.jpg');
				}
				$this->redirect(array('action'=>'index','controller'=>'pages'));
			} catch(SocketException $e) {
 	  			$this->Session->setFlash('エラー：メールアドレスが正しくありません');
			}
	}
	
}