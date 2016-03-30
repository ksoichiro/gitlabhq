# ユーザ管理

## ユーザを開発者としてすべてのプロジェクトに追加

```bash
# omnibus-gitlab
sudo gitlab-rake gitlab:import:user_to_projects[username@domain.tld]

# installation from source
bundle exec rake gitlab:import:user_to_projects[username@domain.tld] RAILS_ENV=production
```

## すべてのユーザをすべてのプロジェクトへ追加

注意:

- 管理者ユーザは Master として追加されます

```bash
# omnibus-gitlab
sudo gitlab-rake gitlab:import:all_users_to_all_projects

# installation from source
bundle exec rake gitlab:import:all_users_to_all_projects RAILS_ENV=production
```

## ユーザを開発者としてすべてのグループに追加

```bash
# omnibus-gitlab
sudo gitlab-rake gitlab:import:user_to_groups[username@domain.tld]

# installation from source
bundle exec rake gitlab:import:user_to_groups[username@domain.tld] RAILS_ENV=production
```

## すべてのユーザをすべてのグループに追加

注意:

- 管理者ユーザは、グループにユーザを追加できるように所有者として追加されます

```bash
# omnibus-gitlab
sudo gitlab-rake gitlab:import:all_users_to_all_groups

# installation from source
bundle exec rake gitlab:import:all_users_to_all_groups RAILS_ENV=production
```

## Maintain tight control over the number of active users on your GitLab installation

- Enable this setting to keep new users blocked until they have been cleared by the admin (default: false).


```
block_auto_created_users: false
```

## Disable Two-factor Authentication (2FA) for all users

This task will disable 2FA for all users that have it enabled. This can be
useful if GitLab's `.secret` file has been lost and users are unable to login,
for example.

```bash
# omnibus-gitlab
sudo gitlab-rake gitlab:two_factor:disable_for_all_users

# installation from source
bundle exec rake gitlab:two_factor:disable_for_all_users RAILS_ENV=production
```
