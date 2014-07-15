<?php
App::uses('AuthComponent', 'Controller/Component');

class User extends AppModel {
	public $name = 'User';

	//ユーザのハッシュ化されたパスワードを返す
	public function getPasswordById($id) {
	    $user = $this->find('first', array(
	        'conditions' => array(
				'User.id' => $id
			),
	        'fields' => 'password',
	    ));

	    return $user['User']['password'];
	}

}
