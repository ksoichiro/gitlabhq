# encoding: utf-8
require_relative "base_service"

module Files
  class DeleteService < BaseService
    def execute
      allowed = ::Gitlab::GitAccess.new(current_user, project).can_push_to_branch?(ref)

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

      delete_file_action = Gitlab::Satellite::DeleteFileAction.new(current_user, project, ref, path)

      deleted_successfully = delete_file_action.commit!(
        nil,
        params[:commit_message]
      )

      if deleted_successfully
        success
      else
        error("ファイルが変更されたため、変更をコミットできません")
      end
    end
  end
end
