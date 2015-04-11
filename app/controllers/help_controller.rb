# encoding: utf-8
class HelpController < ApplicationController
  def index
  end

  def show
    @category = params[:category]
    @category = "README" if @category.blank?
    @categories_i18n = {:README => 'はじめに', :projects => 'プロジェクト', :project_snippets => 'スニペット', :repositories => 'リポジトリ', :repository_files => 'ファイル', :commits => 'コミット', :deploy_keys => 'デプロイキー', :users => 'ユーザ', :groups => 'グループ', :session => 'セッション', :issues => '課題', :milestones => 'マイルストーン', :merge_requests => 'マージリクエスト', :notes => 'ノート', :system_hooks => 'システムフック'}
    @category_i18n = @categories_i18n[@category.to_sym]
    @file = params[:file]

    if File.exists?(Rails.root.join('doc', @category, @file + '.md'))
      render 'show'
    else
      not_found!
    end
  end

  def shortcuts
  end
end
