#サーバーAPI

##API使用時の注意事項
- レスポンスのステータスコード(200or400)のみを用い、エラーメッセージは使わない
- ビジネスロジックは全てサーバーAPIで行う

##API使用例(cURL)
###テストアカウント
|アカウント名|アドレス|パスワード|
|---|---|---|
|アカウント1|yasu1003@gmail.com|omoide|

###ログイン(アカウント1)
```Bash
curl -c cookie -d address=yasu1003@gmail.com -d password=omoide  http://omoide.folder.jp/api/users/login
```

###ユーザー情報
```Bash
curl -b cookie -H 'Accept:application/json' http://omoide.folder.jp/api/users
```

###トーク一覧
```Bash
curl -b cookie -H 'Accept:application/json' http://omoide.folder.jp/api/talks
```

###トーク取得(ID:153b03b8e93edd)
```Bash
curl -b cookie -H 'Accept:application/json' http://omoide.folder.jp/api/talks/153b03b8e93edd
```

###ログアウト
```Bash
curl -b cookie -H 'Accept:application/json' http://omoide.folder.jp/api/users/logout
```
