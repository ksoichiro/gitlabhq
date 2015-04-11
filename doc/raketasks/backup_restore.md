# バックアップ・リストア

![backup banner](backup_hrz.png)

## GitLabシステムのバックアップの作成

データベースとすべてのリポジトリのバックアップアーカイブを作成します。
このアーカイブは backup_path ( `config/gitlab.yml` を参照)に保存されます。

ファイル名は `[TIMESTAMP]_gitlab_backup.tar` の形式です。このタイムスタンプはバックアップをリストアするときに使用されます。

```
# omnibus-gitlab
sudo gitlab-rake gitlab:backup:create

# installation from source or cookbook
bundle exec rake gitlab:backup:create RAILS_ENV=production
```

出力例:

```
Dumping database tables:
- Dumping table events... [DONE]
- Dumping table issues... [DONE]
- Dumping table keys... [DONE]
- Dumping table merge_requests... [DONE]
- Dumping table milestones... [DONE]
- Dumping table namespaces... [DONE]
- Dumping table notes... [DONE]
- Dumping table projects... [DONE]
- Dumping table protected_branches... [DONE]
- Dumping table schema_migrations... [DONE]
- Dumping table services... [DONE]
- Dumping table snippets... [DONE]
- Dumping table taggings... [DONE]
- Dumping table tags... [DONE]
- Dumping table users... [DONE]
- Dumping table users_projects... [DONE]
- Dumping table web_hooks... [DONE]
- Dumping table wikis... [DONE]
Dumping repositories:
- Dumping repository abcd... [DONE]
Creating backup archive: $TIMESTAMP_gitlab_backup.tar [DONE]
Deleting tmp directories...[DONE]
Deleting old backups... [SKIPPING]
```

## 設定ファイルの保存

バックアップでは設定ファイルは保存されないことに注意してください。
Omnibus-GitLab を使用している場合は、 [READMEの設定のバックアップ方法](https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md#backup-and-restore-omnibus-gitlab-configuration) を参照してください。
Cookbookでインストールしている場合は、Chefに設定のコピーがあるはずです。
手動でインストールした場合は、gitlab.ymlファイル、SSLキー、証明書のバックアップを検討してください。

## 以前のバックアップへのリストア

```
# omnibus-gitlab
sudo gitlab-rake gitlab:backup:restore

# installation from source or cookbook
bundle exec rake gitlab:backup:restore RAILS_ENV=production
```

オプション:

```
BACKUP=timestamp_of_backup (required if more than one backup exists)
```

出力例:

```
Unpacking backup... [DONE]
Restoring database tables:
-- create_table("events", {:force=>true})
   -> 0.2231s
[...]
- Loading fixture events...[DONE]
- Loading fixture issues...[DONE]
- Loading fixture keys...[SKIPPING]
- Loading fixture merge_requests...[DONE]
- Loading fixture milestones...[DONE]
- Loading fixture namespaces...[DONE]
- Loading fixture notes...[DONE]
- Loading fixture projects...[DONE]
- Loading fixture protected_branches...[SKIPPING]
- Loading fixture schema_migrations...[DONE]
- Loading fixture services...[SKIPPING]
- Loading fixture snippets...[SKIPPING]
- Loading fixture taggings...[SKIPPING]
- Loading fixture tags...[SKIPPING]
- Loading fixture users...[DONE]
- Loading fixture users_projects...[DONE]
- Loading fixture web_hooks...[SKIPPING]
- Loading fixture wikis...[SKIPPING]
Restoring repositories:
- Restoring repository abcd... [DONE]
Deleting tmp directories...[DONE]
```

## 日次バックアップを行うためのcronの設定

For omnibus-gitlab, see https://gitlab.com/gitlab-org/omnibus-gitlab/blob/master/README.md#scheduling-a-backup .

```
cd /home/git/gitlab
sudo -u git -H editor config/gitlab.yml # Enable keep_time in the backup section to automatically delete old backups
sudo -u git crontab -e # Edit the crontab for the git user
```

以下の行を末尾に追加します。

```
# Create a full backup of the GitLab repositories and SQL database every day at 2am
0 2 * * * cd /home/git/gitlab && PATH=/usr/local/bin:/usr/bin:/bin bundle exec rake gitlab:backup:create RAILS_ENV=production
```
