# encoding: utf-8
# == Schema Information
#
# Table name: services
#
#  id          :integer          not null, primary key
#  type        :string(255)
#  title       :string(255)
#  project_id  :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#  active      :boolean          default(FALSE), not null
#  properties  :text
#

require "flowdock-git-hook"

class FlowdockService < Service
  prop_accessor :token
  validates :token, presence: true, if: :activated?

  def title
    'Flowdock'
  end

  def description
    'Flowdockはテクニカルチーム向けの共同作業用Webアプリケーションです。'
  end

  def to_param
    'flowdock'
  end

  def fields
    [
      { type: 'text', name: 'token',     placeholder: '' }
    ]
  end

  def execute(push_data)
    repo_path = File.join(Gitlab.config.gitlab_shell.repos_path, "#{project.path_with_namespace}.git")
    Flowdock::Git.post(
      push_data[:ref],
      push_data[:before],
      push_data[:after],
      token: token,
      repo: repo_path,
      repo_url: "#{Gitlab.config.gitlab.url}/#{project.path_with_namespace}",
      commit_url: "#{Gitlab.config.gitlab.url}/#{project.path_with_namespace}/commit/%s",
      diff_url: "#{Gitlab.config.gitlab.url}/#{project.path_with_namespace}/compare/%s...%s",
      )
  end
end
