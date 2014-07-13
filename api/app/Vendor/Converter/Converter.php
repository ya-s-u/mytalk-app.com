<?php
require_once(dirname(__FILE__)."/Line.php");

class Converter {
    public $name = 'Converter';

    public function operation($FILE_DATA,$FILE_NAME) {
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
        $FILE_DATA = html_escaape($FILE_DATA);
        $FILE_NAME = html_escaape($FILE_NAME);

        //配列定義
        $Converted['head'] = array();
        $Converted['timeline'] = array();

        //LINE (スマホ日本語/スマホ英語/パソコン)
        if(preg_match('/\[LINE\]\s*.+?(のトーク履歴|とのトーク履歴)/',$FILE_DATA[0]) |
           preg_match('/\[LINE\]\s*(Chat)\s(history)\s(with)\s.+?/U',$FILE_DATA[0]) |
           preg_match('/\[LINE\](.+?).txt/',$FILE_NAME) ) {
            return $this->Line->Convert($FILE_DATA,$FILE_NAME);
        } else {
            return 'エラー';
        }
    }

}


//preg_match('/\[LINE\]\s*.+?(のトーク履歴|とのトーク履歴)/',$Original[0]
