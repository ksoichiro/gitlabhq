# クリーンアップ

## ファイルシステム上のゴミを削除。重要：データを損失します！

`/home/git/repositories` から、GitLabのデータベースに存在しないネームスペース(ディレクトリ)を削除します。

```
# omnibus-gitlab
sudo gitlab-rake gitlab:cleanup:dirs

# installation from source
bundle exec rake gitlab:cleanup:dirs RAILS_ENV=production
```

`/home/git/repositories` のリポジトリのうちGitLabのデータベースに存在しないリポジトリをリネームします。
新しいリポジトリが作成できるように、リポジトリには `+orphaned+TIMESTAMP` の接尾辞がつけられます。

```
# omnibus-gitlab
sudo gitlab-rake gitlab:cleanup:repos

# installation from source
bundle exec rake gitlab:cleanup:repos RAILS_ENV=production
```
