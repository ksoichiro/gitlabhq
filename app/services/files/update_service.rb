# encoding: utf-8
require_relative "base_service"

module Files
  class UpdateService < BaseService
    def execute
      allowed = if project.protected_branch?(ref)
                  can?(current_user, :push_code_to_protected_branches, project)
                else
                  can?(current_user, :push_code, project)
                end

      unless allowed
        return error("このブランチへのプッシュは許可されていません")
      end

      unless repository.branch_names.include?(ref)
        return error("ブランチ上にしかファイルは作成できません")
      end

      blob = repository.blob_at_branch(ref, path)

      unless blob
        return error("テキストファイルのみ編集できます")
      end

      edit_file_action = Gitlab::Satellite::EditFileAction.new(current_user, project, ref, path)
      created_successfully = edit_file_action.commit!(
        params[:content],
        params[:commit_message],
        params[:encoding]
      )

      if created_successfully
        success
      else
        error("ファイルが変更されたため、変更をコミットできませんでした。別のプロセスにファイルが変更されたか、コミットするものがありません")
      end
    end
  end
end
