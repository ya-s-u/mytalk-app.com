<?php
App::uses('File', 'Utility');

class ConvertComponent extends Component {
	public $name = "Convert";
	
	
	public function save($file_name, $file_id, $user_id) {
		//ファイルから配列へ
		$array = file($file_name , FILE_IGNORE_NEW_LINES);
		
		
		//HTMLエスケープ関数
		function html_escaape($str){
		    if(is_array($str)){
		        return array_map("html_escaape",$str);
		    }else{
		        return htmlspecialchars($str,ENT_NOQUOTES,"UTF-8");
		    }
		}
		
		
		//変数定義
		$dump['head'] = array();
		$dump['timeline'] = array();
		$dump['log'] = array();
		
		
		//HTMLエスケープ
		$array = html_escaape($array);

		
		//トークタイトル
		if(preg_match('/\[LINE\]\s.+?(のトーク履歴|とのトーク履歴)/',$array[0])) {
			preg_match('/\[LINE\]\s(.+?)(のトーク履歴|とのトーク履歴)/',$array[0],$temp);
			$meta['type'] = 'LINE';
			$meta['lang'] = 'ja';
		} else if(preg_match('/\[LINE\]\s(Chat)\s(history)\s(with)\s.+?/U',$array[0])) {
			preg_match('/\[LINE\]\sChat\shistory\swith\s(.+?)/U',$array[0],$temp);
			$meta['type'] = 'LINE';
			$meta['lang'] = 'ja';
		} else {
			echo 'エラー';
		}
		$dump['head']['title'] = $temp[1];
		
		
		//保存日時
		if(preg_match('/保存日時：\d+\/\d+\/\d+\s\d+:\d+/',$array[1])) {
			preg_match('/保存日時：(\d+\/\d+\/\d+\s\d+:\d+)/',$array[1],$temp);
		} else if(preg_match('/Saved\son:\s\d+\/\d+\/\d+\s\d+:\d+/U',$array[1])) {
			preg_match('/Saved\son:\s(\d+\/\d+\/\d+\s\d+:\d+)/U',$array[1],$temp);
		} else {
			echo 'エラー';
		}
		$dump['head']['created'] = $temp[1];
		
		
		//1,2行目削除
		$array = array_slice($array,2);
		
		
		//テキスト処理
		$i = 0;
		foreach($array as $key => $data) {
			//日付表示
			if(preg_match('/^(\d+\/\d+\/\d+).+/',$data,$temp)) {
				$day = $temp[1];
			}
			
			//タイムライン
			else if(preg_match('/^\d+:\d+\t.+\t.+/',$data)) {
				
				//画像
				if(preg_match('/^(\d+:\d+)\t(.+)\t\[画像\]/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = $temp[2];
					$dump['timeline'][$i]['type'] = 'photo';
					$i++;
				}
				
				//動画
				else if(preg_match('/^(\d+:\d+)\t(.+)\t\[動画\]/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = $temp[2];
					$dump['timeline'][$i]['type'] = 'video';
					$i++;
				}
				
				//音声メッセージ
				else if(preg_match('/^(\d+:\d+)\t(.+)\t\[音声メッセージ\]/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = $temp[2];
					$dump['timeline'][$i]['type'] = 'voice';
					$i++;
				}
				
				//連絡先
				else if(preg_match('/^(\d+:\d+)\t(.+)\t\[連絡先\]/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = $temp[2];
					$dump['timeline'][$i]['type'] = 'contact';
					$i++;
				}
				
				//スタンプ
				else if(preg_match('/^(\d+:\d+)\t(.+)\t\[スタンプ\]/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = $temp[2];
					$dump['timeline'][$i]['type'] = 'stamp';
					$i++;
				}
				
				//位置情報
				else if(preg_match('/^(\d+:\d+)\t(.+)\t\[位置情報\]\s.+：(.+)/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = $temp[2];
					$dump['timeline'][$i]['type'] = 'map';
					$dump['timeline'][$i]['value'] = $temp[3];
					$i++;
				}
				
				//通話
				else if(preg_match('/^(\d+:\d+)\t(.+)\t☎\s通話時間\s(.+)/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = $temp[2];
					$dump['timeline'][$i]['type'] = 'call';
					$dump['timeline'][$i]['value'] = $temp[3];
					$i++;
				}
				
				//通話キャンセル
				else if(preg_match('/^(\d+:\d+)\t(.+)\t☎\s通話をキャンセルしました/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = $temp[2];
					$dump['timeline'][$i]['type'] = 'canceled';
					$i++;
				}
				
				//ノート(旧グループボード)
				else if(preg_match('/^(\d+:\d+)\t(.+)\t\[グループボード\]\s(.+)/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = $temp[2];
					$dump['timeline'][$i]['type'] = 'note';
					$dump['timeline'][$i]['value'] = $temp[3];
					$i++;
				}
				
				//複数行メッセージ1行目
				else if(preg_match('/^(\d+:\d+)\t+(.+)\t"(.+)/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = $temp[2];
					$dump['timeline'][$i]['type'] = 'message';
					$dump['timeline'][$i]['value'] = $temp[3];
				}
				
				
				//単数行メッセージ
				else if(preg_match('/^(\d+:\d+)\t(.+)\t(.+)/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = $temp[2];
					$dump['timeline'][$i]['type'] = 'message';
					$dump['timeline'][$i]['value'] = $temp[3];
					$i++;
				}
			}
			
			//事務メッセージ
			else if(preg_match('/^\d+:\d+\t.+/',$data)) {
				
				//招待
				if(preg_match('/^(\d+:\d+)\t(.+)が(.+)を招待しました。/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = 'system';
					$dump['timeline'][$i]['type'] = 'invite';
					$dump['timeline'][$i]['value'] = $temp[2].'が'.$temp[3].'を招待しました。';
					$i++;
				}
				
				//退会
				else if(preg_match('/^(\d+:\d+)\t(.+)が退会しました。/',$data,$temp)) {
					$dump['timeline'][$i]['date'] = $day.' '.$temp[1];
					$dump['timeline'][$i]['name'] = 'system';
					$dump['timeline'][$i]['type'] = 'leave';
					$dump['timeline'][$i]['value'] = $temp[2].'が退会しました。';
					$i++;
				}
			}
			
			//複数行メッセージ最終行
			else if(preg_match('/^(.*)"$/',$data,$temp)) {
				$dump['timeline'][$i]['value'] .= PHP_EOL.$temp[1];
				$i++;
			}
			
			//複数行メッセージ中間行
			else if(preg_match('/(.*)/',$data,$temp)) {
				$dump['timeline'][$i]['value'] .= PHP_EOL.$temp[1];
			}
			
			//複数行メッセージ空白行
			else if(preg_match('/^\n/',$data)) {
				$dump['timeline'][$i]['value'] .= PHP_EOL;
			}
		}
			
		
		//投稿数カウント
		$dump['head']['count']  = count($dump['timeline']);
		
		
		//投稿期間取得
		$dump['head']['start'] = $dump['timeline'][0]['date'];
		$dump['head']['end'] = $dump['timeline'][$dump['head']['count']-1]['date'];
		
		
		//メンバー一覧
		$i = 0;
		$member = array();
		foreach($dump['timeline'] as $key => $data){
			if($data['name'] != 'system') {
			    if(!in_array($data['name'],$member)){
			        $member[] = $data['name'];
					$dump['member'][$i]['name'] = $member[$i];
			        $i++;
			    }
			}
		}
		
		
		//メンバー数カウント
		$dump['head']['member']  = count($dump['member']);
		
		
		//メンバーごとの投稿数
		foreach($dump['member'] as $key => $data){
			foreach($dump['timeline'] as $num => $message){
				if($message['name'] == $data['name']) {
					$dump['member'][$key]['count']++;
				}
			}
		}
		
		
		
		
		
		//月ごとに格納
		foreach($dump['timeline'] as $key => $data) {
			$year = date('Y',strtotime($data['date']));
			$month = date('n',strtotime($data['date']));
			$dump['temp'][$year][$month][] = $data;
		}
		
		//var_dump($dump);
		
		
		
		//ファイル出力
		$filename = '../../../s3/talks/'.$file_id.'.json';
		if (!file_exists($filename)) {
			touch($filename);
		} else {
			echo ('すでにファイルが存在しています。file name:' . $filename);
		}
		
		if (!file_exists($filename) && !is_writable($filename)
			|| !is_writable(dirname($filename))) {
			echo "書き込みできないか、ファイルがありません。",PHP_EOL;
			exit(-1);
		}
		
		$fp = fopen($filename,'a') or dir('ファイルを開けません');
		fwrite($fp, json_encode($dump));
		
		//fwrite($fp, sprintf(json_encode($dump)));
		fclose($fp);
		
		
		/*
		 * Userデータ $dump['log'][$num]['date']
		 */
		//ファイル読み込み
		$array = file_get_contents('../../../s3/users/'.$user_id.'.json');
		$array = json_decode($array); 
		
		 
		//ファイル出力
		$filename = '../../../s3/users/'.$file_id.'.json';
		if (!file_exists($filename)) {
			touch($filename);
		} else {
			echo ('すでにファイルが存在しています。file name:' . $filename);
		}
		
		if (!file_exists($filename) && !is_writable($filename)
			|| !is_writable(dirname($filename))) {
			echo "書き込みできないか、ファイルがありません。",PHP_EOL;
			exit(-1);
		}
		
		$fp = fopen($filename,'a') or dir('ファイルを開けません');
		fwrite($fp, json_encode($dump));
		fclose($fp);
		
		
		return $meta;
	}

}