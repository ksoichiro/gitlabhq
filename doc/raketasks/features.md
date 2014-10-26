# フィーチャー

## ユーザのプロジェクトでのユーザ名とネームスペースを有効化

このコマンドは、v4.0 で導入されたネームスペースの機能を有効にします。
すべてのプロジェクトをネームスペースフォルダに移動します。

注意:

- **リポジトリの場所が変更されるため** 、新しい場所を指すように **すべてのGitのURLを更新** する必要があります。
- ユーザ名は [プロフィール / アカウント設定](/profile/account) から変更することができます。

**例:**

古いパス: `git@example.org:myrepo.git`

新しいパス: `git@example.org:username/myrepo.git` または `git@example.org:groupname/myrepo.git`

```
bundle exec rake gitlab:enable_namespaces RAILS_ENV=production
```
