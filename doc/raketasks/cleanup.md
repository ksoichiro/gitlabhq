# クリーンアップ

## ファイルシステム上のゴミを削除。重要：データを損失します！

`/home/git/repositories` から、GitLabのデータベースに存在しないネームスペース(ディレクトリ)を削除します。

```
# omnibus-gitlab
sudo gitlab-rake gitlab:cleanup:dirs

# installation from source or cookbook
bundle exec rake gitlab:cleanup:dirs RAILS_ENV=production
```

`/home/git/repositories` から、GitLabのデータベースに存在しないリポジトリ(現在のところはグローバルなもののみ)を削除します。

```
# omnibus-gitlab
sudo gitlab-rake gitlab:cleanup:repos

# installation from source or cookbook
bundle exec rake gitlab:cleanup:repos RAILS_ENV=production
```
