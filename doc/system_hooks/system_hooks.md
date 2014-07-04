# システムフック

GitLabインスタンスは、`create_project`, `delete_project`, `create_user`, `delete_user`, `change_team_member` のイベントが発生したときにHTTP POSTリクエストを実行できます。

システムフックは、例えばログインやLDAPサーバ情報変更に利用することができます。

## フックリクエストの例

**プロジェクトの作成:**

```json
{
          "created_at": "2012-07-21T07:30:54Z",
          "event_name": "project_create",
                "name": "StoreCloud",
         "owner_email": "johnsmith@gmail.com",
          "owner_name": "John Smith",
                "path": "stormcloud",
 "path_with_namespace": "jsmith/stormcloud",
          "project_id": 74,
  "project_visibility": "private",
}
```

**プロジェクトの削除:**

```json
{
          "created_at": "2012-07-21T07:30:58Z",
          "event_name": "project_destroy",
                "name": "Underscore",
         "owner_email": "johnsmith@gmail.com",
          "owner_name": "John Smith",
                "path": "underscore",
 "path_with_namespace": "jsmith/underscore",
          "project_id": 73,
  "project_visibility": "internal",
}
```

**新しいメンバーの追加:**

```json
{
         "created_at": "2012-07-21T07:30:56Z",
         "event_name": "user_add_to_team",
     "project_access": "Master",
         "project_id": 74,
       "project_name": "StoreCloud",
       "project_path": "storecloud",
         "user_email": "johnsmith@gmail.com",
          "user_name": "John Smith",
 "project_visibility": "private",
}
```

**メンバーの削除:**

```json
{
         "created_at": "2012-07-21T07:30:56Z",
         "event_name": "user_remove_from_team",
     "project_access": "Master",
         "project_id": 74,
       "project_name": "StoreCloud",
       "project_path": "storecloud",
         "user_email": "johnsmith@gmail.com",
          "user_name": "John Smith",
 "project_visibility": "private",
}
```

**ユーザの作成:**

```json
{
   "created_at": "2012-07-21T07:44:07Z",
        "email": "js@gitlabhq.com",
   "event_name": "user_create",
         "name": "John Smith",
      "user_id": 41
}
```

**ユーザの削除:**

```json
{
   "created_at": "2012-07-21T07:44:07Z",
        "email": "js@gitlabhq.com",
   "event_name": "user_destroy",
         "name": "John Smith",
      "user_id": 41
}
```
