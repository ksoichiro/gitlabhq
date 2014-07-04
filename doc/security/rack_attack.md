# Rack attack

クライアントからの大量アクセスによる被害を防ぐため、GitLabは rack-attack の gem を使っています。

公式ガイドに沿ってGitLabをインストールまたはアップデートしている場合は、デフォルトで有効になっています。

もし `config/initializers/rack_attack.rb` が存在しない場合は、GitLabインスタンスの保護を有効にするために次のステップを実行する必要があります。

1.  config/application.rb の中で次の行を探してコメントを外します：

        config.middleware.use Rack::Attack

1.  `config/initializers/rack_attack.rb.example` を `config/initializers/rack_attack.rb` にリネームします。

1.  `paths_to_be_protected` を確認し、他に保護すべきパスがあれば追加します。

1.  GitLabインスタンスを再起動します。

デフォルトでは、ユーザのサインイン、サインアップ(有効な場合)、ユーザのパスワードリセットは 6 リクエスト/ 分 に制限されています。6 回試行すると、クライアントは次の1分間はアクセスできなくなります。この設定は `config/initializers/rack_attack.rb` にあります。

さらに制限を厳しい、または緩いスロットル・ルールを設定したい場合は、 `limit` または `period` の値を変更します。例えば、 limit: 3 、 period: 1.second と設定するとより緩やかなスロットル・ルールになります(これは秒間 3 リクエストの制限になります)。 さらに他のパスを保護の対象としたい場合は `paths_to_be_protected` 変数にパスを追加します。これらの設定を変更した後は、GitLabインスタンスを再起動する必要があります。

大量アクセスするクライアントから保護するのにスロットルでは不十分な場合のために、 rack-attack gem はIPホワイトリスト、ブラックリスト、Fail2ban 形式のフィルターと追跡の機能も備えています。

これらのオプションに関するさらに詳細な情報については [rack-attack README](https://github.com/kickstarter/rack-attack/blob/master/README.md) を参照してください。
