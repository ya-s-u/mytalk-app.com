<?php
App::uses('ApiController', 'Controller');
App::uses('File', 'Utility');
App::uses('Converter', 'Vendor/Converter');

class TalksController extends ApiController {
	public $name = 'Talks';
	public $uses = array('User','Talk');


    public function beforeFilter() {
        parent::beforeFilter();
        $this->Converter = new Converter();
    }


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
		if($_FILES["talk_file"]) {
			//ファイルから配列へ
			$Original = file($_FILES["talk_file"]["tmp_name"],FILE_IGNORE_NEW_LINES);


			//トーク変換
			$Converted = $this->Converter->operation($Original);

			//トークID
			$file_id = uniqid(mt_rand(0,9));

			//ファイル出力
			$filename = '../../../s3/talks/'.$file_id.'.json';
			if (!file_exists($filename)) {
				touch($filename);
				$fp = fopen($filename,'a') or dir('ファイルを開けません');
				fwrite($fp, json_encode($Converted));
				fclose($fp);
			} else {
				return $this->error('error:<');
			}

			//db保存用パラメータ
			$this->request->data['Talk'] = array(
				'id' => $file_id,
				'user_id' => $this->Auth->user('id'),
				'title' => $Converted['head']['title'],
				'member' => $Converted['head']['member'],
				'count' => $Converted['head']['count'],
				'type' => $Converted['head']['type'],
				'lang' => $Converted['head']['lang'],
				'created' => date("Y-m-d G:i:s"),
			);

			//db保存
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
