<?php
require_once(dirname(__FILE__)."/Line.php");

class Converter {
    public $name = 'Converter';

    public function operation($Original) {
        //クラス読み込み
        $this->Line = new Line();

        //HTMLエスケープ関数
        function html_escaape($str){
            if(is_array($str)){
                return array_map("html_escaape",$str);
            }else{
                return htmlspecialchars($str,ENT_NOQUOTES,"UTF-8");
            }
        }

        //HTMLエスケープ
        $Original = html_escaape($Original);

        //配列定義
        $Converted['head'] = array();
        $Converted['timeline'] = array();

        return $this->Line->Convert($Original);

        //タイプ別で変換
        /*
        if(preg_match('/\[LINE\].+?/',$Original[0]) |
           preg_match('/\[LINE\]\s*(Chat)\s(history)\s(with)\s.+?/U',$Original[0])) {
            return $this->Line->Convert($Original);
        } else {
            return 'エラー';
        }
        */
    }

}


//preg_match('/\[LINE\]\s*.+?(のトーク履歴|とのトーク履歴)/',$Original[0]
