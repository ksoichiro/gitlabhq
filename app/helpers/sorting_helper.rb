# encoding: utf-8
module SortingHelper
  def sort_options_hash
    {
      sort_value_name => sort_title_name,
      sort_value_recently_updated => sort_title_recently_updated,
      sort_value_oldest_updated => sort_title_oldest_updated,
      sort_value_recently_created => sort_title_recently_created,
      sort_value_oldest_created => sort_title_oldest_created,
      sort_value_milestone_soon => sort_title_milestone_soon,
      sort_value_milestone_later => sort_title_milestone_later,
      sort_value_largest_repo => sort_title_largest_repo,
      sort_value_recently_signin => sort_title_recently_signin,
      sort_value_oldest_signin => sort_title_oldest_signin,
    }
  end

  def sort_title_oldest_updated
    '最近更新されていない'
  end

  def sort_title_recently_updated
    '最近更新された'
  end

  def sort_title_oldest_created
    '古い順'
  end

  def sort_title_recently_created
    '新しい順'
  end

  def sort_title_milestone_soon
    'マイルストーンが近い順'
  end

  def sort_title_milestone_later
    'マイルストーンが遠い順'
  end

  def sort_title_name
    '名前'
  end

  def sort_title_largest_repo
    'リポジトリの大きさ'
  end

  def sort_title_recently_signin
    '最近サインインした'
  end

  def sort_title_oldest_signin
    'サインインした順'
  end

  def sort_value_oldest_updated
    'updated_asc'
  end

  def sort_value_recently_updated
    'updated_desc'
  end

  def sort_value_oldest_created
    'created_asc'
  end

  def sort_value_recently_created
    'created_desc'
  end

  def sort_value_milestone_soon
    'milestone_due_asc'
  end

  def sort_value_milestone_later
    'milestone_due_desc'
  end

  def sort_value_name
    'name_asc'
  end

  def sort_value_largest_repo
    'repository_size_desc'
  end

  def sort_value_recently_signin
    'recent_sign_in'
  end

  def sort_value_oldest_signin
    'oldest_sign_in'
  end
end
