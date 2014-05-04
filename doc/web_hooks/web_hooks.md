プロジェクトWebフックを使うと、新しいコードのプッシュや課題の作成をトリガーとして指定のURLへリクエストすることができます。

---

プッシュ、課題、マージリクエストといったイベントから特定のものに対してWebフックを設定することができます。
GitLab はWebフックのURLに対して POST リクエストでデータを送信します。
Webフックは、外部の課題トラッカーの更新、CIビルドの起動、バックアップミラーの更新、本番サーバへのデプロイなどに利用することができます。
WebフックをSSLエンドポイントへ送信した場合、自己署名の証明書が使われている場合が多いため [証明書は検証されません](https://gitlab.com/gitlab-org/gitlab-ce/blob/ccd617e58ea71c42b6b073e692447d0fe3c00be6/app/models/web_hook.rb#L35)。

---

#### プッシュイベント

リポジトリへのタグ以外のプッシュで実行されます。

**リクエストボディ:**

```json
{
  "before": "95790bf891e76fee5e1747ab589903a6a1f80f22",
  "after": "da1560886d4f094c3e6c9ef40349f7d38b5d27d7",
  "ref": "refs/heads/master",
  "user_id": 4,
  "user_name": "John Smith",
  "project_id": 15,
  "repository": {
    "name": "Diaspora",
    "url": "git@localhost:diaspora.git",
    "description": "",
    "homepage": "http://localhost/diaspora"
  },
  "commits": [
    {
      "id": "b6568db1bc1dcd7f8b4d5a946b0b91f9dacd7327",
      "message": "Update Catalan translation to e38cb41.",
      "timestamp": "2011-12-12T14:27:31+02:00",
      "url": "http://localhost/diaspora/commits/b6568db1bc1dcd7f8b4d5a946b0b91f9dacd7327",
      "author": {
        "name": "Jordi Mallach",
        "email": "jordi@softcatala.org"
      }
    },
    {
      "id": "da1560886d4f094c3e6c9ef40349f7d38b5d27d7",
      "message": "fixed readme",
      "timestamp": "2012-01-03T23:36:29+02:00",
      "url": "http://localhost/diaspora/commits/da1560886d4f094c3e6c9ef40349f7d38b5d27d7",
      "author": {
        "name": "GitLab dev user",
        "email": "gitlabdev@dv6700.(none)"
      }
    }
  ],
  "total_commits_count": 4
}
```

#### 課題イベント

課題の作成/更新/クローズ/再オープンで実行されます。

**リクエストボディ:**

```json
{
  "object_kind": "issue",
  "object_attributes": {
    "id": 301,
    "title": "New API: create/update/delete file",
    "assignee_id": 51,
    "author_id": 51,
    "project_id": 14,
    "created_at": "2013-12-03T17:15:43Z",
    "updated_at": "2013-12-03T17:15:43Z",
    "position": 0,
    "branch_name": null,
    "description": "Create new API for manipulations with repository",
    "milestone_id": null,
    "state": "opened",
    "iid": 23
  }
}
```

#### マージリクエストイベント

マージリクエストの作成/更新/マージ/クローズで実行されます。

**リクエストボディ:**

```json
{
  "object_kind": "merge_request",
  "object_attributes": {
    "id": 99,
    "target_branch": "master",
    "source_branch": "ms-viewport",
    "source_project_id": 14,
    "author_id": 51,
    "assignee_id": 6,
    "title": "MS-Viewport",
    "created_at": "2013-12-03T17:23:34Z",
    "updated_at": "2013-12-03T17:23:34Z",
    "st_commits": null,
    "st_diffs": null,
    "milestone_id": null,
    "state": "opened",
    "merge_status": "unchecked",
    "target_project_id": 14,
    "iid": 1,
    "description": ""
  }
}
```
