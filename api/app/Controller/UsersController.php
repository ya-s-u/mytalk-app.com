<?php
App::uses('ApiController', 'Controller');

class UsersController extends ApiController {
	public $name = 'Users';
	public $uses = array('User','Talk');
	public $helpers = array('Html','Form','Session');

	/* 前処理 */
	public function beforeFilter() {
		parent::beforeFilter();

		$this->Auth->allow('ping');
		$this->Auth->allow('ping2');

		$this->Auth->allow('signup');
		$this->Auth->allow('login');

        //Blowfishのコスト値
        Security::setCost(15);
	}

	/* Ping */
	public function ping() {
		return $this->success('接続ok!!(￣▽￣)δ⌒☆');
	}

	/* Ping2 */
	public function ping2() {
		return $this->success($_POST);
	}


	/* ユーザー情報取得 */
	public function index() {
		$dump['User'] = array(
			'address' => $this->Auth->user('address'),
			'type' => $this->Auth->user('type'),
		);

		return $this->success($dump);
	}


	/* ユーザー登録 */
	public function signup() {
   		$this->User->create();

   		$id = uniqid(rand(10,19));
		$this->request->data['User']['id'] = $id;
        $this->request->data['User']['address'] = $_POST['address'];
		$this->request->data['User']['password'] = Security::hash($_POST['password'], 'blowfish');
		$this->request->data['User']['created'] = date("Y-m-d G:i:s");

		if($this->User->save($this->data)) {
			if($this->Auth->login($this->request->data['User'])) {
				return $this->success('ok:)');
			} else {
				return $this->error('error:<');
			}
		} else {
			return $this->error('error:<');
		}
	}


	/* ログイン */
	public function login() {
        $this->request->data['User']['address'] = $_POST['address'];
        $this->request->data['User']['password'] = $_POST['password'];

		if($this->Auth->login()) {
			return $this->success('ok:)');
		} else {
			return $this->error('error:<');
		}
	}


	/* ログアウト */
	public function logout() {
		if($this->Auth->logout()) {
			return $this->success('ok:)');
		} else {
			return $this->error('error:<');
		}

	}

}
