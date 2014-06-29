<?php
App::uses('Line', 'Vendor/Converter');

class Converter {

    public function beforeFilter() {
        parent::beforeFilter();

        $this->Line = new Line();
    }


    public function operation($file_path) {
        //ファイルから配列へ
        $Original = file($file_path , FILE_IGNORE_NEW_LINES);

        //HTMLエスケープ
        if(is_array($Original)) {
            $Original = array_map("html_escaape",$Original);
        } else {
            $Original = htmlspecialchars($Original,ENT_NOQUOTES,"UTF-8");
        }

        //配列定義
        $Converted['head'] = array();
        $Converted['timeline'] = array();

        //タイプ別で変換
        if(preg_match('/\[LINE\]\s.+?(のトーク履歴|とのトーク履歴)/',$Original[0]) |
           preg_match('/\[LINE\]\s(Chat)\s(history)\s(with)\s.+?/U',$Original[0])) {
            return $this->Line->Convert($Original);
        } else {
            return 'エラー';
        }
    }

}
