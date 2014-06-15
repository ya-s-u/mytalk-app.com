<?php
 
App::uses('AppController', 'Controller');
 
class ApiController extends AppController {
    //CakeのJsonViewとXmlViewを使用するので、RequestHandler必須。
    public $components = array('Session', 'RequestHandler');
 
    // JSONやXMLにして返す値を格納するための配列です。
    protected $result = array();
 
    public function beforeFilter() {
        parent::beforeFilter();
 
        // Ajaxでないアクセスは禁止。直アクセスを許すとXSSとか起きかねないので。
        //if (!$this->request->is('ajax')) throw new BadRequestException('Ajax以外でのアクセスは許可していません。');
 
        //meta情報とかを返すといいですね。とりあえずいまアクセスしているurlとhttp methodでも含めておきましょう
        $this->result['meta'] = array(
            'url' => $this->request->here,
            'method' => $this->request->method(),
        );
 
        // nosniffつけるべし。じゃないとIEでXSS起きる可能性あり。
        $this->response->header('X-Content-Type-Options', 'nosniff');
    }
 
    public function beforeRender() {
        // jsonp対応。JsonpViewクラスを自作(後述)
        if ($this->viewClass === 'Json' && isset($this->request->query['callback'])) {
            $this->viewClass = 'Jsonp';
        }
    }
 
    // 成功系処理。$this->resultに値いれる
    protected function success($response = array()) {
        $this->result['response'] = $response;
 
        $this->set('meta', $this->result['meta']);
        $this->set('response', $this->result['response']);
        $this->set('_serialize', array('meta', 'response'));
    }
 
    // エラー系処理。$this->resultに値いれる
    protected function error($message = '') {
        $this->result['error']['message'] = $message;
 
        //ちゃんと400ステータスコードにするの大事。後述
        $this->response->statusCode(400);
        $this->set('meta', $this->result['meta']);
        $this->set('error', $this->result['error']);
        $this->set('_serialize', array('meta', 'error'));
    }
 
    // バリデーションエラー系処理。$this->resultに値いれる
    protected function validationError($modelName, $validationError = array()) {
        $this->result['error']['message'] = 'Validation Error';
        $this->result['error']['code'] = '422'; //エラーコードはプロジェクトごとに定義すべし
        $this->result['error']['validation'][$modelName] = array();
        foreach ($validationError as $key => $value) {
            $this->result['error']['validation'][$modelName][$key] = $value[0];
        }
 
        //ちゃんと400ステータスコードにするの大事。後述
        $this->response->statusCode(400);
        $this->set('meta', $this->result['meta']);
        $this->set('error', $this->result['error']);
        $this->set('_serialize', array('meta', 'error'));
    }


}