<?php

class Line extends Converter {
    public $name = 'Line';

    protected function Convert($FILE_DATA,$FILE_NAME) {

        //スマホ日本語
        if(preg_match('/\[LINE\]\s(.+?)(のトーク履歴|とのトーク履歴)/',$FILE_DATA[0],$temp)) {
            $Converted['head'] = array(
                'title' => $temp[1],
                'type' => 'Line',
                'lang' => 'ja',
                'device' => 'pc',
            );

            //1行目削除
            $FILE_DATA = array_slice($FILE_DATA,1);

        //スマホ英語
        } else if(preg_match('/\[LINE\]\sChat\shistory\swith\s(.+?)/U',$FILE_DATA[0],$temp)) {
            $Converted['head'] = array(
                'title' => $temp[1],
                'type' => 'Line',
                'lang' => 'en',
                'device' => 'pc',
            );

            //1行目削除
            $FILE_DATA = array_slice($FILE_DATA,1);

        //パソコン
        } else if(preg_match('/\[LINE\](.+?).txt/',$FILE_NAME,$temp)) {
            $Converted['head'] = array(
                'title' => $temp[1],
                'type' => 'Line',
                'lang' => 'ja',
                'device' => 'sp',
            );
        }


        //スマホ日本語,スマホ英語
        if(preg_match('/(保存日時|Saved\son)：(\d+\/\d+\/\d+\s\d+:\d+)/',$FILE_DATA[0],$temp)) {
               $Converted['head']['saved'] = $temp[2];

               //1行目削除
               $FILE_DATA = array_slice($FILE_DATA,1);
        }


        //1行ずつ処理し、投稿ごとに分ける
        $i = 0;
        $timeline = array();

        foreach($FILE_DATA as $key => $data) {
            //日付表示
            if(preg_match('/^(\d+\/\d+\/\d+).+/',$data,$temp)) {
                $day = $temp[1];
            }

            //タイムライン
            else if(preg_match('/^\d+:\d+\s.+\s.+/',$data)) {

                //画像
                if(preg_match('/^(\d+:\d+)\s(.+)\s\[画像\]/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = $temp[2];
                    $timeline[$i]['type'] = 'photo';
                    $i++;
                }

                //動画
                else if(preg_match('/^(\d+:\d+)\s(.+)\s\[動画\]/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = $temp[2];
                    $timeline[$i]['type'] = 'video';
                    $i++;
                }

                //音声メッセージ
                else if(preg_match('/^(\d+:\d+)\s(.+)\s\[音声メッセージ\]/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = $temp[2];
                    $timeline[$i]['type'] = 'voice';
                    $i++;
                }

                //連絡先
                else if(preg_match('/^(\d+:\d+)\s(.+)\s\[連絡先\]/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = $temp[2];
                    $timeline[$i]['type'] = 'contact';
                    $i++;
                }

                //スタンプ
                else if(preg_match('/^(\d+:\d+)\s(.+)\s\[スタンプ\]/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = $temp[2];
                    $timeline[$i]['type'] = 'stamp';
                    $i++;
                }

                //位置情報
                else if(preg_match('/^(\d+:\d+)\s(.+)\s\[位置情報\]\s.+：(.+)/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = $temp[2];
                    $timeline[$i]['type'] = 'map';
                    $timeline[$i]['value'] = $temp[3];
                    $i++;
                }

                //通話
                else if(preg_match('/^(\d+:\d+)\s(.+)\s☎\s通話時間\s(.+)/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = $temp[2];
                    $timeline[$i]['type'] = 'call';
                    $timeline[$i]['value'] = $temp[3];
                    $i++;
                }

                //通話キャンセル
                else if(preg_match('/^(\d+:\d+)\s(.+)\s☎\s通話をキャンセルしました/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = $temp[2];
                    $timeline[$i]['type'] = 'canceled';
                    $i++;
                }

                //ノート(旧グループボード)
                else if(preg_match('/^(\d+:\d+)\s(.+)\s\[グループボード\]\s(.+)/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = $temp[2];
                    $timeline[$i]['type'] = 'note';
                    $timeline[$i]['value'] = $temp[3];
                    $i++;
                }

                //複数行メッセージ1行目
                else if(preg_match('/^(\d+:\d+)\t+(.+)\t"(.*)/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = $temp[2];
                    $timeline[$i]['type'] = 'message';
                    $timeline[$i]['value'] = $temp[3];
                }

                //単数行メッセージ
                else if(preg_match('/^(\d+:\d+)\t(.+)\t(.+)/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = $temp[2];
                    $timeline[$i]['type'] = 'message';
                    $timeline[$i]['value'] = $temp[3];
                    $i++;
                }
            }

            //事務メッセージ
            else if(preg_match('/^\d+:\d+\s.+/',$data)) {

                //招待
                if(preg_match('/^(\d+:\d+)\s(.+)が(.+)を招待しました。/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = 'system';
                    $timeline[$i]['type'] = 'invite';
                    $timeline[$i]['value'] = $temp[2].'が'.$temp[3].'を招待しました。';
                    $i++;
                }

                //退会
                else if(preg_match('/^(\d+:\d+)\s(.+)が退会しました。/',$data,$temp)) {
                    $timeline[$i]['date'] = $day.' '.$temp[1];
                    $timeline[$i]['name'] = 'system';
                    $timeline[$i]['type'] = 'leave';
                    $timeline[$i]['value'] = $temp[2].'が退会しました。';
                    $i++;
                }
            }

            //複数行メッセージ最終行
            else if(preg_match('/^(.*)"$/',$data,$temp)) {
                $timeline[$i]['value'] .= PHP_EOL.$temp[1];
                $i++;
            }

            //複数行メッセージ中間行
            else if(preg_match('/(.*)/',$data,$temp)) {
                $timeline[$i]['value'] .= PHP_EOL.$temp[1];
            }

            //複数行メッセージ空白行
            else if(preg_match('/^\n/',$data)) {
                $timeline[$i]['value'] .= PHP_EOL;
            }
        }


        //投稿数カウント
        $Converted['head']['count']  = count($timeline);


        //投稿期間取得
        $Converted['head']['start'] = $timeline[0]['date'];
        $Converted['head']['end'] = $timeline[$Converted['head']['count']-1]['date'];


        //メンバー一覧
        $i = 0;
        $member = array();

        foreach($timeline as $key => $data){
            if($data['name'] != 'system') {
                if(!in_array($data['name'],$member)){
                    $member[] = $data['name'];
                    $Converted['member'][$i]['name'] = $member[$i];
                    $i++;
                }
            }
        }


        //メンバー数カウント
        $Converted['head']['member']  = count($Converted['member']);


        //メンバーごとの投稿数
        foreach($Converted['member'] as $key => $data){
            foreach($timeline as $num => $message){
                if($message['name'] == $data['name']) {
                    $Converted['member'][$key]['count']++;
                }
            }
        }


        //月ごとに格納
        foreach($timeline as $key => $data) {
            $year = date('Y',strtotime($data['date']));
            $month = date('n',strtotime($data['date']));

            $Converted['timeline'][$year][$month][] = $data;
        }


        //不要な配列除去
        unset($timeline);


        //返却
        return $Converted;
    }
}
