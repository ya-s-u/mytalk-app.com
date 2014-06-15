<?php
App::uses('ApiController', 'Controller');

class TalksController extends ApiController {
	public $name = 'Talks';
	public $uses = array('User','Talk');
	
	
	public function getList() {
		$params = array(
			'order' => 'Talk.created desc',
			'limit' => 999,
			'conditions' => array(
				'Talk.user_id' => $this->Auth->user('id'),
				'NOT' => array(
				)
			)
		);
		$Data = $this->Talk->find('all',$params);
		
		foreach($Data as $key => $data) {
			$temp = file_get_contents('../../../s3/talks/'.$data['Talk']['id'].'.json'); //temp
			$temp = json_decode($temp); //temp
			
			$dump['Talk'][$key] = array(
				'id' => $data['Talk']['id'],
				'type' => $data['Talk']['type'],
				'created' => $data['Talk']['created'],
				
				'title' => $temp->head->title, //temp
				'member' => $temp->head->member, //temp
				'count' => $temp->head->count, //temp
			);
		};
		
		return $this->success($dump);
	}
	
	
	public function getTalk() {
		$id = $this->request->query['id'];
		$params = array(
			'conditions' => array(
				'Talk.id' => $id,
			)
		);
		$Data = $this->Talk->find('first',$params);
		
		if($Data['Talk']['user_id'] == $this->Auth->user('id')) {
			$array = file_get_contents('../../../s3/talks/'.$id.'.json');
			$array = json_decode($array);
			return $this->success($array);
		} else {
			return $this->error('not accepted');
		}
	}
	
	
	public function newTalk() {
		if($_FILES['file']) {
			$id = uniqid(mt_rand(0,9));
			$result = $this->Convert->save($_FILES['file']["tmp_name"],$id,$this->Auth->user('id'));
			
			$this->request->data['Talk']['id'] = $id;
			$this->request->data['Talk']['user_id'] = $this->Auth->user('id');
			$this->request->data['Talk']['type'] = $result['type'];
			$this->request->data['Talk']['lang'] = $result['lang'];
			$this->request->data['Talk']['created'] = date("Y-m-d G:i:s");
			
			$this->Talk->create();
			if($this->Talk->save($this->data)) {
				return $this->success('uploaded!');
			} else {
				return $this->error('error:<');
			}
		} else {
			return $this->error('error:<');
		}
	}
	
}