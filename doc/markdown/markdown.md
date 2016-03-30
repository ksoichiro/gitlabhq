# Markdown

## 目次

**[GitLab Flavored Markdown](#gitlab-flavored-markdown-gfm)**

* [改行](#newlines)
* [単語内の複数のアンダースコア](#multiple-underscores-in-words)
* [URLの自動リンク](#url-auto-linking)
* [コードとシンタックスハイライト](#code-and-syntax-highlighting)
* [絵文字](#emoji)
* [GitLabでの参照](#special-gitlab-references)
* [タスクリスト](#task-lists)

**[標準のMarkdown](#standard-markdown)**

* [ヘッダ](#headers)
* [強調](#emphasis)
* [リスト](#lists)
* [リンク](#links)
* [画像](#images)
* [引用](#blockquotes)
* [インライン HTML](#inline-html)
* [水平線](#horizontal-rule)
* [改行](#line-breaks)
* [表](#tables)

**[リファレンス](#references)**

## GitLab Flavored Markdown (GFM)

GitLabでは、"GitLab Flavored Markdown" (GFM)と呼ばれるものを開発しました。これは、いくつかの重要な点で便利な機能を追加するために標準の Markdown を拡張するものです。

GFM は以下の場所で使うことができます。

- コメント
- 課題
- マージリクエスト
- マイルストーン
- Wikiページ

依存するソフトウェアをインストールして、GitLab上の他のリッチテキストファイルでも使うことができます。その場合、依存関係をインストールする必要があるかもしれません。詳しい情報は、 [github-markup gem readme](https://github.com/gitlabhq/markup#markups) を参照してください。

## 改行

GFMは [段落と改行の取り扱い](https://daringfireball.net/projects/markdown/syntax#p) での Markdown 仕様にならっています。

段落は単純に1行以上の空行で分けられた、1行以上のテキストです。
ラインブレーク、ソフトリターンを使うには行末に2つ以上のスペースを入れます。

    Roses are red [followed by two or more spaces]  
    Violets are blue

    Sugar is sweet

Roses are red  
Violets are blue

Sugar is sweet

## 単語内の複数のアンダースコア

単語の _一部_ だけをイタリック体にしてしまうのは便利とは言えません。複数のアンダースコアを含むコードと名前を扱う場合には特にそうです。このため、GFMは単語内の複数のアンダースコアを無視します。

    perform_complicated_task
    do_this_and_do_that_and_another_thing

perform_complicated_task  
do_this_and_do_that_and_another_thing

## URLの自動リンク

GFM は、URLをコピー＆ペーストするとほとんどの場合、自動的にリンクします。

    * https://www.google.com
    * https://google.com/
    * ftp://ftp.us.debian.org/debian/
    * smb://foo/bar/baz
    * irc://irc.freenode.net/gitlab
    * http://localhost:3000

* https://www.google.com
* https://google.com/
* ftp://ftp.us.debian.org/debian/
* smb://foo/bar/baz
* irc://irc.freenode.net/gitlab
* http://localhost:3000

## コードとシンタックスハイライト

コードのブロックは3つのバッククオート<code>```</code>からなる行で仕切りを入れるか、4つのスペースでインデントすることで表現できます。行で仕切る方法でのみ、シンタックスハイライトがサポートされます。

```no-highlight
インラインの`コード`は`バッククオート`で括られています。
```

インラインの`コード`は`バッククオート`で括られています。

例:

    ```javascript
    var s = "JavaScript syntax highlighting";
    alert(s);
    ```

    ```python
    def function():
        #仕切られたコードブロックではインデントが有効です
        s = "Python syntax highlighting"
        print s
    ```

    ```ruby
    require 'redcarpet'
    markdown = Redcarpet.new("Hello World!")
    puts markdown.to_html
    ```

    ```
    言語が示されていない場合は、シンタックスハイライトされません。
    s = "There is no highlighting for this."
    But let's throw in a <b>tag</b>.
    ```

これは次のように表示されます。

```javascript
var s = "JavaScript syntax highlighting";
alert(s);
```

```python
def function():
    #仕切られたコードブロックではインデントが有効です
    s = "Python syntax highlighting"
    print s
```

```ruby
require 'redcarpet'
markdown = Redcarpet.new("Hello World!")
puts markdown.to_html
```

```
言語が示されていない場合は、シンタックスハイライトされません。
s = "There is no highlighting for this."
But let's throw in a <b>tag</b>.
```

## 絵文字

	時には、 :monkey: になり :speech_balloon: に :star2: を追加したいこともあるでしょう。そんなあなたにプレゼントがあります。

	:zap: あなたはGFMがサポートされた場所ならどこでも、絵文字を使うことができます :v:

	:bug: の指摘や :speak_no_evil: パッチの警告に使うこともできます。そして、もし誰かが本当に :snail: なコードを改善したら、彼らに :birthday: を送りましょう。皆あなたを :heart: になるでしょう。

	あなたが絵文字の初心者だとしても、 :fearful: にならないでください。あなたも簡単に絵文字の :family: に入ることができます。サポートされたコードを使うだけです。

	サポートされている絵文字コードの一覧は、 [Emoji Cheat Sheet](http://emoji.codes) を確認してください。 :thumbsup:

時には、 :monkey: になり :speech_balloon: に :star2: を追加したいこともあるでしょう。そんなあなたにプレゼントがあります。

:zap: あなたはGFMがサポートされた場所ならどこでも、絵文字を使うことができます :v:

:bug: の指摘や :speak_no_evil: パッチの警告に使うこともできます。そして、もし誰かが本当に :snail: なコードを改善したら、彼らに :birthday: を送りましょう。皆あなたを :heart: になるでしょう。

あなたが絵文字の初心者だとしても、 :fearful: にならないでください。あなたも簡単に絵文字の :family: に入ることができます。サポートされたコードを使うだけです。

サポートされている絵文字コードの一覧は、 [Emoji Cheat Sheet](http://emoji.codes) を確認してください。 :thumbsup:

## GitLabでの特別な参照

GFM は特別な参照を認識します。

例えばプロジェクト内のチームメンバー、課題、コミットメッセージを簡単に参照することができます。

GFM は参照をリンクに変換するため、それらの参照に対して簡単にナビゲーションすることができます。

GFM は以下を認識します。

| 入力                   | 参照                       |
|:-----------------------|:---------------------------|
| `@user_name`           | 特定のユーザ               |
| `@group_name`          | 特定のグループ             |
| `@all`                 | チーム全体                 |
| `#123`                 | 課題                       |
| `!123`                 | マージリクエスト           |
| `$123`                 | スニペット                 |
| `~123`                 | ラベル by ID               |
| `~bug`                 | 1単語ラベル by 名前        |
| `~"feature request"`   | 複数単語ラベル by 名前     |
| `9ba12248`             | 特定のコミット             |
| `9ba12248...b19a04f5`  | コミット範囲比較           |
| `[README](doc/README)` | リポジトリ内のファイル     |

GFM はクロスプロジェクトも認識します。

| 入力                                    | 参照                    |
|:----------------------------------------|:------------------------|
| `namespace/project#123`                 | 課題                    |
| `namespace/project!123`                 | マージリクエスト        |
| `namespace/project$123`                 | スニペット              |
| `namespace/project@9ba12248`            | 特定のコミット          |
| `namespace/project@9ba12248...b19a04f5` | コミット範囲比較        |

## Task Lists

You can add task lists to issues, merge requests and comments. To create a task list, add a specially-formatted Markdown list, like so:

```no-highlight
- [x] Completed task
- [ ] Incomplete task
    - [ ] Sub-task 1
    - [x] Sub-task 2
    - [ ] Sub-task 3
```

- [x] Completed task
- [ ] Incomplete task
    - [ ] Sub-task 1
    - [x] Sub-task 2
    - [ ] Sub-task 3

Task lists can only be created in descriptions, not in titles. Task item state can be managed by editing the description's Markdown or by toggling the rendered check boxes.

# 標準のMarkdown

## ヘッダ

```no-highlight
# H1
## H2
### H3
#### H4
##### H5
###### H6

H1とH2では下線を使ったスタイルも使うことができます。

H1の別表現
======

H2の別表現
------
```

# H1
## H2
### H3
#### H4
##### H5
###### H6

H1とH2では下線を使ったスタイルも使うことができます。

H1の別表現
======

H2の別表現
------

### ヘッダのIDとリンク

すべての Markdown からレンダリングされたヘッダは、コメントを除いて自動的にIDを取得します。

ヘッダへのリンクを誰かに知らせやすくするために、リンク上にカーソルをあてるとIDが表示されます。

コンテンツのヘッダから生成されたIDは以下のルールになっています。

1. すべての文字が小文字に変換されます
1. 単語構成文字以外のすべての文字(句読点、HTMLなど)は削除されます
1. すべての空白はハイフンに変換されます
1. 連続する2個以上のハイフンは1つのハイフンに変換されます
1. 同じIDを持つヘッダがすでに生成されていた場合、1から開始する一意となる連番が付加されます

例:

```
# This header has spaces in it
## This header has a :thumbsup: in it
# This header has Unicode in it: 한글
## This header has spaces in it
### This header has spaces in it
```

これらは以下のようなIDのリンクに変換されます。

1. `this-header-has-spaces-in-it`
1. `this-header-has-a-in-it`
1. `this-header-has-unicode-in-it-한글`
1. `this-header-has-spaces-in-it`
1. `this-header-has-spaces-in-it-1`

絵文字はヘッダのIDが生成される前に処理されるため、絵文字は画像に変換され、IDからは削除されます。

## 強調

```no-highlight
強調(イタリック体)は *アスタリスク* や _アンダースコア_ で表現します。

さらに強い強調(太字)は **アスタリスク** or __アンダースコア__ で表現します。

組み合わせた強調は **アスタリスクと _アンダースコア_** のように表現します。

取消線には二つのチルダを使います。 ~~ここを削除~~
```

強調(イタリック体)は *asterisks* や _underscores_ で表現します。

さらに強い強調(太字)は **アスタリスク** or __アンダースコア__ で表現します。

組み合わせた強調は **アスタリスクと _アンダースコア_** のように表現します。

取消線には二つのチルダを使います。 ~~ここを削除~~

## リスト

```no-highlight
1. 先頭のリスト項目
2. 別の項目
  * 番号のないサブリスト
1. 実際の番号は問題ではなく、数字であることが必要です
  1. 番号付きのサブリスト
4. さらに別の項目

* 番号のないリストはアスタリスクを使います
- またはマイナス
+ またはプラス
```

1. 先頭のリスト項目
2. 別の項目
  * 番号のないサブリスト
1. 実際の番号は問題ではなく、数字であることが必要です
  1. 番号付きのサブリスト
4. さらに別の項目

* 番号のないリストはアスタリスクを使います
- またはマイナス
+ またはプラス

If a list item contains multiple paragraphs,
each subsequent paragraph should be indented with four spaces.

```no-highlight
1.  First ordered list item

    Second paragraph of first item.
2.  Another item
```

1.  First ordered list item

    Second paragraph of first item.
2.  Another item

If the second paragraph isn't indented with four spaces,
the second list item will be incorrectly labeled as `1`.

```no-highlight
1. First ordered list item

   Second paragraph of first item.
2. Another item
```

1. First ordered list item

   Second paragraph of first item.
2. Another item

## リンク

リンクを作るには、インラインスタイルとリファレンススタイルの二つの方法があります。

    [インラインスタイルのリンクです](https://www.google.com)

    [リファレンススタイルのリンクです][Arbitrary case-insensitive reference text]

    [リポジトリのファイルへの相対パスでの参照です](LICENSE)

    [リファレンススタイルのリンク定義に番号を使うこともできます][1]

    あるいは中身を空にすることもできます [link text itself][]

    リファレンスのリンク先は後に続けて書きます。

    [arbitrary case-insensitive reference text]: https://www.mozilla.org
    [1]: http://slashdot.org
    [link text itself]: https://www.reddit.com

[インラインスタイルのリンクです](https://www.google.com)

[リファレンススタイルのリンクです][Arbitrary case-insensitive reference text]

[リポジトリのファイルへの相対パスでの参照です](LICENSE)

[リファレンススタイルのリンク定義に番号を使うこともできます][1]

あるいは中身を空にすることもできます [link text itself][]

リファレンスのリンク先は後に続けて書きます。

[arbitrary case-insensitive reference text]: https://www.mozilla.org
[1]: http://slashdot.org
[link text itself]: https://www.reddit.com

**注意**

相対パスのリンクでは、Wikiページ内のプロジェクトファイルやプロジェクトファイル内のWikiページを参照することはできません。理由は、GitLabではWikiが常に別のGitリポジトリに分けられているためです。例えば

`[リファレンススタイルのリンクです](style)`

は Wiki の Markdown ファイル内でのリンクならば `wikis/style` へリンクします。

## 画像

    私たちのロゴです(マウスオーバーでタイトル文字列を表示します)。

    インラインスタイル:
    ![alt text](assets/logo-white.png)

    リファレンススタイル:
    ![alt text1][logo]

    [logo]: assets/logo-white.png

私たちのロゴです。

インラインスタイル:

![alt text](/assets/logo-white.png)

リファレンススタイル:

![alt text][logo]

[logo]: /assets/logo-white.png

## 引用

```no-highlight
> 引用はメールの返信をエミュレートするのに非常に便利です。
> この行は引用の一部です。

引用は終わります。

> これはとても長い行ですが正常にワードラップされて引用することができます。さあ、これが実際にワードラップしてくれることを皆が確かめられるように、十分に長く書き続けましょう。この引用にも **Markdown** を入れることができます。
```

> 引用はメールの返信をエミュレートするのに非常に便利です。
> この行は引用の一部です。

引用は終わります。

> これはとても長い行ですが正常にワードラップされて引用することができます。さあ、これが実際にワードラップしてくれることを皆が確かめられるように、十分に長く書き続けましょう。この引用にも **Markdown** を入れることができます。

## インライン HTML

生のHTMLを Markdown で使うことができ、大半はうまく機能するでしょう。

See the documentation for HTML::Pipeline's [SanitizationFilter](http://www.rubydoc.info/gems/html-pipeline/HTML/Pipeline/SanitizationFilter#WHITELIST-constant) class for the list of allowed HTML tags and attributes.  In addition to the default `SanitizationFilter` whitelist, GitLab allows `span` elements.

```no-highlight
<dl>
  <dt>定義リスト</dt>
  <dd>は時々使われるものです。</dd>

  <dt>HTMLでのMarkdown</dt>
  <dd>これは **うまく** 機能 *しません* 。HTML <em>タグ</em>を使ってください。</dd>
</dl>
```

<dl>
  <dt>定義リスト</dt>
  <dd>は時々使われるものです。</dd>

  <dt>HTMLでのMarkdown</dt>
  <dd>これは **うまく** 機能 *しません* 。HTML <em>タグ</em>を使ってください。</dd>
</dl>

## 水平線

```
3つ以上...

---

ハイフン

***

アスタリスク

___

アンダースコア
```

3つ以上...

---

ハイフン

***

アスタリスク

___

アンダースコア

## 改行

基本的に、改行がどのような挙動になるか学ぶには、実験して発見することをおすすめします。 &lt;Enter&gt; を1回押し(改行を挿入し)、2回押し(2つの改行を挿入し)、何が起きるを見てください。すぐに知りたいことを知ることができるでしょう。"Markdownのトグル"が役に立ちます。

以下を試してみてください。

```
ここが最初の行です。

この行は2つの改行で上の行と分けられており *別の段落*になります。

この行も段落が分かれていますが...
この行は1つの改行だけで分けられているため、 *同じ段落* の別の行になります。

この行も段落が分かれており...  
前の行が2つのスペースで終わっているため、この行はこの行だけで表示されます。
```

ここが最初の行です。

この行は2つの改行で上の行と分けられており *別の段落*になります。

この行も段落が分かれていますが...
この行は1つの改行だけで分けられているため、 *同じ段落* の別の行になります。

この行も段落が分かれており...  
前の行が2つのスペースで終わっているため、この行はこの行だけで表示されます。

## 表

テーブルはコアの Markdown の使用には含まれていませんが、GFMやここでのMarkdownではサポートされています。

```
| ヘッダ 1 | ヘッダ 2 |
| -------- | -------- |
| セル 1   | セル 2   |
| セル 3   | セル 4   |
```

上記のコードでは、次のように表示されます。

| ヘッダ 1 | ヘッダ 2 |
| -------- | -------- |
| セル 1   | セル 2   |
| セル 3   | セル 4   |

**注意**

表のヘッダとボディの間のダッシュの行は、それぞれの列に対して3つ以上のダッシュを含んでいる必要があります。

ヘッダ行にコロンを含めることで、列内のテキストの位置を揃えることができます。

```
| 左揃え       | 中央揃え | 右揃え        | 左揃え       | 中央揃え | 右揃え        |
| :----------- | :------: | ------------: | :----------- | :------: | ------------: |
| Cell 1       | Cell 2   | Cell 3        | Cell 4       | Cell 5   | Cell 6        |
| Cell 7       | Cell 8   | Cell 9        | Cell 10      | Cell 11  | Cell 12       |
```

| 左揃え       | 中央揃え | 右揃え        | 左揃え       | 中央揃え | 右揃え        |
| :----------- | :------: | ------------: | :----------- | :------: | ------------: |
| Cell 1       | Cell 2   | Cell 3        | Cell 4       | Cell 5   | Cell 6        |
| Cell 7       | Cell 8   | Cell 9        | Cell 10      | Cell 11  | Cell 12       |

## リファレンス

- このドキュメントは [Markdown-Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) に多いに参考にしています。
- Daring Fireball の [Markdown Syntax Guide](https://daringfireball.net/projects/markdown/syntax) は標準の Markdown について詳細に説明しているすばらしいリソースです。
- [Dillinger.io](http://dillinger.io) は標準の Markdown をテストできる便利なツールです。
