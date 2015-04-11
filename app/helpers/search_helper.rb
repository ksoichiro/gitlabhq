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
      { label: "管理エリア",          url: admin_root_path },
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
        { label: "#{prefix} - ファイル",         url: project_tree_path(@project, ref) },
        { label: "#{prefix} - コミット",         url: project_commits_path(@project, ref) },
        { label: "#{prefix} - ネットワーク",     url: project_network_path(@project, ref) },
        { label: "#{prefix} - グラフ",           url: project_graph_path(@project, ref) },
        { label: "#{prefix} - 課題",             url: project_issues_path(@project) },
        { label: "#{prefix} - マージリクエスト", url: project_merge_requests_path(@project) },
        { label: "#{prefix} - マイルストーン",   url: project_milestones_path(@project) },
        { label: "#{prefix} - スニペット",       url: project_snippets_path(@project) },
        { label: "#{prefix} - メンバー",         url: project_team_index_path(@project) },
        { label: "#{prefix} - Wiki",             url: project_wikis_path(@project) },
      ]
    else
      []
    end
  end

  # Autocomplete results for the current user's groups
  def groups_autocomplete(term, limit = 5)
    current_user.authorized_groups.search(term).limit(limit).map do |group|
      {
        label: "グループ: #{search_result_sanitize(group.name)}",
        url: group_path(group)
      }
    end
  end

  # Autocomplete results for the current user's projects
  def projects_autocomplete(term, limit = 5)
    ProjectsFinder.new.execute(current_user).search_by_title(term).non_archived.limit(limit).map do |p|
      {
        label: "プロジェクト: #{search_result_sanitize(p.name_with_namespace)}",
        url: project_path(p)
      }
    end
  end

  def search_result_sanitize(str)
    Sanitize.clean(str)
  end
end
