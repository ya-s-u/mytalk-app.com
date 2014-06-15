<?php 
App::uses('AuthComponent', 'Controller/Component');

class User extends AppModel {
	public $name = 'User';
		
	/*public $validate = array(
		'address' => array(
			'rule' => array(
				'email', true,
				'notEmpty',
				'isUnique',
				array('maxLength', '30'),
				'alphaNumeric',
			),
			'message' => 'このアドレスは既に登録されています'
		),
		'password' => array(
			'rule' => array(
				'notEmpty',
				'alphaNumeric',
				array('minLength', '6'),
			),
			'message' => '6文字以上にしてください'
		),
	);*/
	
    /*public $hasMany = array (
		'Talk' => array(
			'className' => 'Talk',
			'dependent' => false,
			'foreignKey' => 'user_id'
		)
	);*/
}
?>


