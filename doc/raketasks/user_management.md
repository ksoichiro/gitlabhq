# ユーザ管理

## ユーザを開発者としてすべてのプロジェクトに追加

```bash
# omnibus-gitlab
sudo gitlab-rake gitlab:import:user_to_projects[username@domain.tld]

# installation from source or cookbook
bundle exec rake gitlab:import:user_to_projects[username@domain.tld]
```

## すべてのユーザをすべてのプロジェクトへ追加

注意:

- 管理者ユーザは Master として追加されます

```bash
# omnibus-gitlab
sudo gitlab-rake gitlab:import:all_users_to_all_projects

# installation from source or cookbook
bundle exec rake gitlab:import:all_users_to_all_projects
```

## ユーザを開発者としてすべてのグループに追加

```bash
# omnibus-gitlab
sudo gitlab-rake gitlab:import:user_to_groups[username@domain.tld]

# installation from source or cookbook
bundle exec rake gitlab:import:user_to_groups[username@domain.tld]
```

## すべてのユーザをすべてのグループに追加

注意:

- 管理者ユーザは、グループにユーザを追加できるように所有者として追加されます

```bash
# omnibus-gitlab
sudo gitlab-rake gitlab:import:all_users_to_all_groups

# installation from source or cookbook
bundle exec rake gitlab:import:all_users_to_all_groups
```
