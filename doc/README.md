# ドキュメント

## ユーザ向けドキュメント

- [API](api/README.md) シンプルで強力なAPIでGitLabを自動化します。
- [OAuth2認証サービスプロバイダとしてのGitLab](integration/oauth_provider.md)。GitLabから他のアプリケーションにログインできるようにします。
- [GitLabへのインポート](workflow/importing/README.md)。
- [Markdown](markdown/markdown.md) GitLabの高度なフォーマットシステムです。
- [アクセス権](permissions/permissions.md) プロジェクトの各ロール (guest/reporter/developer/master/owner) が何をできるのか学びます。
- [プロフィール設定](profile/README.md)
- [プロジェクトサービス](project_services/project_services.md) CIやチャットなどの外部サービスと、プロジェクトを統合します。
- [公開アクセス](public_access/public_access.md) プロジェクトのアクセス範囲を公開・内部にする方法を学びます。
- [SSH](ssh/README.md) セキュアなアクセスのためにSSHキーやデプロイキーをプロジェクトに設定します。
- [Webフック](web_hooks/web_hooks.md) プロジェクトに新しいコードがプッシュされたときにGitLabがあなたに通知するようにします。
- [ワークフロー](workflow/README.md) GitLabの機能を使いGitHubやSVNからプロジェクトをインポートします。

## 管理者向けドキュメント

- [カスタムgitフック](hooks/custom_hooks.md) Webフックでは不十分な場合のための、ファイルシステム上でのカスタムgitフックについて
- [インストール](install/README.md) インストール要件、ディレクトリ構成、ソースコードからのインストールについて
- [統合](integration/README.md) JIRA、Redmine、LDAP、Twitterなどと統合する方法
- [課題のクローズ](customization/issue_closing.md) コミットメッセージによる課題のクローズをカスタマイズする方法
- [Libravatar](customization/libravatar.md) ユーザのアバターにLibravatarを使う方法
- [ログシステム](logs/logs.md) ログシステム
- [運用](operations/README.md) GitLabを継続的に動作させるための方法
- [Rakeタスク](raketasks/README.md) バックアップ、メンテナンス、自動的なWebフックのセットアップとプロジェクトのインポート方法
- [セキュリティ](security/README.md) GitLabインスタンスをさらにセキュアにするための方法
- [システムフック](system_hooks/system_hooks.md) ユーザ、プロジェクト、キーが変更されたときの通知
- [アップデート](update/README.md) インストール中のGitLabをアップデートするためのガイド
- [ウェルカムメッセージ](customization/welcome_message.md) サインインページにカスタムのメッセージを追加する方法

## コントリビュータ向けドキュメント

- [開発](development/README.md) アーキテクチャとシェルコマンドのガイドラインの説明
- [法的情報](legal/README.md) コントリビュータ向けのライセンス契約
- [リリース](release/README.md) 月次のリリース、セキュリティリリースを行う方法
