# encoding: utf-8
module VisibilityLevelHelper
  def visibility_level_color(level)
    case level
    when Gitlab::VisibilityLevel::PRIVATE
      'vs-private'
    when Gitlab::VisibilityLevel::INTERNAL
      'vs-internal'
    when Gitlab::VisibilityLevel::PUBLIC
      'vs-public'
    end
  end

  def visibility_level_description(level)
    capture_haml do
      haml_tag :span do
        case level
        when Gitlab::VisibilityLevel::PRIVATE
          haml_concat "明示的にアクセス権を付与したユーザだけがアクセスできます。"
        when Gitlab::VisibilityLevel::INTERNAL
          haml_concat "ログインしたユーザは誰でもプロジェクトをクローンできます。"
        when Gitlab::VisibilityLevel::PUBLIC
          haml_concat "誰でも、認証せずにプロジェクトをクローンできます。"
        end
      end
    end
  end

  def visibility_level_icon(level)
    case level
    when Gitlab::VisibilityLevel::PRIVATE
      private_icon
    when Gitlab::VisibilityLevel::INTERNAL
      internal_icon
    when Gitlab::VisibilityLevel::PUBLIC
      public_icon
    end
  end

  def visibility_level_label(level)
    case level
    when Gitlab::VisibilityLevel::PRIVATE
      "プライベート"
    when Gitlab::VisibilityLevel::INTERNAL
      "内部"
    when Gitlab::VisibilityLevel::PUBLIC
      "公開"
    end
  end

  def restricted_visibility_levels
    current_user.is_admin? ? [] : gitlab_config.restricted_visibility_levels
  end
end
