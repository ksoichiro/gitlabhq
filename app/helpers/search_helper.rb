# encoding: utf-8
module SearchHelper
  def search_autocomplete_opts(term)
    return unless current_user

    resources_results = [
      groups_autocomplete(term),
      projects_autocomplete(term)
    ].flatten

    generic_results = project_autocomplete + default_autocomplete + help_autocomplete
    generic_results.select! { |result| result[:label] =~ Regexp.new(term, "i") }

    [
      resources_results,
      generic_results
    ].flatten.uniq do |item|
      item[:label]
    end
  end

  private

  # Autocomplete results for various settings pages
  def default_autocomplete
    [
      { label: "プロフィール設定",    url: profile_path },
      { label: "SSHキー",             url: profile_keys_path },
      { label: "ダッシュボード",      url: root_path },
      { label: "管理セクション",      url: admin_root_path },
    ]
  end

  # Autocomplete results for internal help pages
  def help_autocomplete
    [
      { label: "ヘルプ: API Help",           url: help_page_path("api", "README") },
      { label: "ヘルプ: Markdown Help",      url: help_page_path("markdown", "markdown") },
      { label: "ヘルプ: Permissions Help",   url: help_page_path("permissions", "permissions") },
      { label: "ヘルプ: Public Access Help", url: help_page_path("public_access", "public_access") },
      { label: "ヘルプ: Rake Tasks Help",    url: help_page_path("raketasks", "README") },
      { label: "ヘルプ: SSH Keys Help",      url: help_page_path("ssh", "README") },
      { label: "ヘルプ: System Hooks Help",  url: help_page_path("system_hooks", "system_hooks") },
      { label: "ヘルプ: Web Hooks Help",     url: help_page_path("web_hooks", "web_hooks") },
      { label: "ヘルプ: Workflow Help",      url: help_page_path("workflow", "README") },
    ]
  end

  # Autocomplete results for the current project, if it's defined
  def project_autocomplete
    if @project && @project.repository.exists? && @project.repository.root_ref
      prefix = search_result_sanitize(@project.name_with_namespace)
      ref    = @ref || @project.repository.root_ref

      [
        { label: "#{prefix} - ファイル",         url: namespace_project_tree_path(@project.namespace, @project, ref) },
        { label: "#{prefix} - コミット",         url: namespace_project_commits_path(@project.namespace, @project, ref) },
        { label: "#{prefix} - ネットワーク",     url: namespace_project_network_path(@project.namespace, @project, ref) },
        { label: "#{prefix} - グラフ",           url: namespace_project_graph_path(@project.namespace, @project, ref) },
        { label: "#{prefix} - 課題",             url: namespace_project_issues_path(@project.namespace, @project) },
        { label: "#{prefix} - マージリクエスト", url: namespace_project_merge_requests_path(@project.namespace, @project) },
        { label: "#{prefix} - マイルストーン",   url: namespace_project_milestones_path(@project.namespace, @project) },
        { label: "#{prefix} - スニペット",       url: namespace_project_snippets_path(@project.namespace, @project) },
        { label: "#{prefix} - メンバー",         url: namespace_project_project_members_path(@project.namespace, @project) },
        { label: "#{prefix} - Wiki",             url: namespace_project_wikis_path(@project.namespace, @project) },
      ]
    else
      []
    end
  end

  # Autocomplete results for the current user's groups
  def groups_autocomplete(term, limit = 5)
    GroupsFinder.new.execute(current_user).search(term).limit(limit).map do |group|
      {
        label: "グループ: #{search_result_sanitize(group.name)}",
        url: group_path(group)
      }
    end
  end

  # Autocomplete results for the current user's projects
  def projects_autocomplete(term, limit = 5)
    ProjectsFinder.new.execute(current_user).search_by_title(term).
      sorted_by_stars.non_archived.limit(limit).map do |p|
      {
        label: "プロジェクト: #{search_result_sanitize(p.name_with_namespace)}",
        url: namespace_project_path(p.namespace, p)
      }
    end
  end

  def search_result_sanitize(str)
    Sanitize.clean(str)
  end

  def search_filter_path(options={})
    exist_opts = {
      search: params[:search],
      project_id: params[:project_id],
      group_id: params[:group_id],
      scope: params[:scope]
    }

    options = exist_opts.merge(options)
    search_path(options)
  end

  # Sanitize html generated after parsing markdown from issue description or comment
  def search_md_sanitize(html)
    sanitize(html, tags: %w(a p ol ul li pre code))
  end
end
