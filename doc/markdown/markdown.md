# Markdown

## 目次

**[GitLab Flavored Markdown](#gitlab-flavored-markdown-gfm)**

[改行](#newlines)

[単語内の複数のアンダースコア](#multiple-underscores-in-words)

[URLの自動リンク](#url-autolinking)

[コードとシンタックスハイライト](#code-and-syntax-highlighting)

[絵文字](#emoji)

[GitLabでの参照](#special-gitlab-references)

**[標準のMarkdown](#standard-markdown)**

[ヘッダ](#headers)

[強調](#emphasis)

[リスト](#lists)

[リンク](#links)

[画像](#images)

[引用](#blockquotes)

[インライン HTML](#inline-html)

[水平線](#horizontal-rule)

[改行](#line-breaks)

[表](#tables)

**[リファレンス](#references)**

## GitLab Flavored Markdown (GFM)

GitLabでは、"GitLab Flavored Markdown" (GFM)と呼ばれるものを開発しました。これは、いくつかの重要な点で便利な機能を追加するために標準の Markdown を拡張するものです。

GFM は以下の場所で使うことができます。

- コミットメッセージ
- コメント
- 課題
- マージリクエスト
- マイルストーン
- Wikiページ

依存するソフトウェアをインストールして、GitLab上の他のリッチテキストファイルでも使うことができます。詳しい情報は、 [github-markup gem readme](https://github.com/gitlabhq/markup#markups) を参照してください。

## 改行

GFMは [段落と改行の取り扱い](http://daringfireball.net/projects/markdown/syntax#p) での Markdown 仕様にならっています。

段落は単純に1行以上の空行で分けられた、1行以上のテキストです。

    Roses are red
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

GFM は、標準的なURLをコピー＆ペーストすると自動的にリンクします。つまり、(テキストのリンクの代わりに)URLをリンクしたければ、単純にURLを記述すればそのURLへのリンクができあがります。

    http://www.google.com

http://www.google.com

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

        時には、あなたの :speech_balloon: を :cool: にして、 :sparkles: を追加したいこともあるでしょう。そんなあなたに :gift: があります。
        
        :exclamation: あなたはGFMがサポートされた場所ならどこでも、絵文字を使うことができます :sunglasses:
        
        :bug: の指摘や :monkey:パッチの警告に使うこともできます。そして、もし誰かが本当に :snail: なコードを改善したら、彼らに :bouquet: か :candy: を送りましょう。皆あなたを :heart: になるでしょう。
        
        あなたが絵文字について :new: な場合、 :fearful: にならないでください。あなたも簡単に絵文字の :circus_tent: に入ることができます。サポートされたコードを使うだけです。 :book:
        
        サポートされている絵文字コードの一覧は、 [Emoji Cheat Sheet](http://www.emoji-cheat-sheet.com/) を確認してください。 :thumbsup:

時には、あなたの :speech_balloon: を :cool: にして、 :sparkles: を追加したいこともあるでしょう。そんなあなたに :gift: があります。

:exclamation: あなたはGFMがサポートされた場所ならどこでも、絵文字を使うことができます :sunglasses:

:bug: の指摘や :monkey:パッチの警告に使うこともできます。そして、もし誰かが本当に :snail: なコードを改善したら、彼らに :bouquet: か :candy: を送りましょう。皆あなたを :heart: になるでしょう。

あなたが絵文字について :new: な場合、 :fearful: にならないでください。あなたも簡単に絵文字の :circus_tent: に入ることができます。サポートされたコードを使うだけです。 :book:

サポートされている絵文字コードの一覧は、 [Emoji Cheat Sheet](http://www.emoji-cheat-sheet.com/) を確認してください。 :thumbsup:

## GitLabでの特別な参照

GFM は特別な参照を認識します。

例えばプロジェクト内のチームメンバー、課題、コミットメッセージを簡単に参照することができます。

GFM は参照をリンクに変換するため、それらの参照に対して簡単にナビゲーションすることができます。

GFM は以下を認識します。

- @foo : チームメンバーへの参照
- #123 : 課題への参照
- !123 : マージリクエストへの参照
- $123 : スニペットへの参照
- 1234567 : コミットへの参照
- \[file\](path/to/file) : ファイルへの参照

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

1. 先頭のハッシュ `#` を削除し、行の残りの部分をヘッダでなかった場合のように処理します
2. その結果から、すべてのHTMLタグを削除し、ただしタグの中のコンテンツは残すように処理します
3. すべての文字を小文字に変換します
4. `[a-z0-9_-]` 以外のすべての文字をハイフン `-` に変換します
5. 連続するハイフンを1つのハイフンに変換します
6. 先頭と末尾のハイフンを削除します

例:

```
###### ..Ab_c-d. e [anchor](url) ![alt text](url)..
```

以下のように表示されます。

###### ..Ab_c-d. e [anchor](url) ![alt text](url)..

これはステップ 1) によって次のような文字列に変換されます。

```
..Ab_c-d. e &lt;a href="url">anchor&lt;/a> &lt;img src="url" alt="alt text"/>..
```

ステップ 2) でタグを削除すると次のようになります。

```
..Ab_c-d. e anchor ..
```

そして以降のステップを適用するとIDができあがります。

```
ab_c-d-e-anchor
```

特に以下の点に注意してください。

- Markdown のアンカー `[text](url)` は `text` だけが使用されます
- Markdown のイメージ `![alt](url)` は完全に無視されます

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

   テキストは上の項目と位置を合わせる必要があります。

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

   テキストは上の項目と位置を合わせる必要があります。

* 番号のないリストはアスタリスクを使います
- またはマイナス
+ またはプラス

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
    [link text itself]: http://www.reddit.com

[インラインスタイルのリンクです](https://www.google.com)

[リファレンススタイルのリンクです][Arbitrary case-insensitive reference text]

[リポジトリのファイルへの相対パスでの参照です](LICENSE)

[リファレンススタイルのリンク定義に番号を使うこともできます][1]

あるいは中身を空にすることもできます [link text itself][]

リファレンスのリンク先は後に続けて書きます。

[arbitrary case-insensitive reference text]: https://www.mozilla.org
[1]: http://slashdot.org
[link text itself]: http://www.reddit.com

**注意**

相対パスのリンクでは、Wikiページ内のプロジェクトファイルやプロジェクトファイル内のWikiページを参照することはできません。理由は、GitLabではWikiが常に別のGitリポジトリに分けられているためです。例えば

`[リファレンススタイルのリンクです][style]`

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
この行は1つの改行だけで分けられているため、 *同じ段落* になります。
```

ここが最初の行です。

この行は2つの改行で上の行と分けられており *別の段落*になります。

この行も段落が分かれていますが...
この行は1つの改行だけで分けられているため、 *同じ段落* になります。

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

## リファレンス

- このドキュメントは [Markdown-Cheatsheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) に多いに参考にしています。
- Daring Fireball の [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) は標準の Markdown について詳細に説明しているすばらしいリソースです。
- [Dillinger.io](http://dillinger.io) は標準の Markdown をテストできる便利なツールです。
