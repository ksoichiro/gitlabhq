1. プロジェクトをクローンします

  ```bash
  git clone git@example.com:project-name.git
  ```
2. 機能追加用のブランチを作成します

  ```bash
  git checkout -b $feature_name
  ```

3. コードを書いて変更をコミットします

  ```bash
  git commit -am "My feature is ready"
  ```

4. ブランチをGitLabにプッシュします
  
  ```bash
  git push origin $feature_name
  ```

5. コミットのページでコードをレビューします
6. マージリクエストを作成します
7. チームリーダがコードレビューしメインのブランチにマージします
