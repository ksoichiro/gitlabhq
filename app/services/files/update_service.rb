# encoding: utf-8
require_relative "base_service"

module Files
  class UpdateService < BaseService
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

      edit_file_action = Gitlab::Satellite::EditFileAction.new(current_user, project, ref, path)
      edit_file_action.commit!(
        params[:content],
        params[:commit_message],
        params[:encoding],
        params[:new_branch]
      )

      success
    rescue Gitlab::Satellite::CheckoutFailed => ex
      error("'#{ref}'をチェックアウトできなかったため、変更をコミットできませんでした", 400)
    rescue Gitlab::Satellite::CommitFailed => ex
      error("変更をコミットできませんでした。コミットするものがない可能性があります", 409)
    rescue Gitlab::Satellite::PushFailed => ex
      error("変更をコミットできませんでした。別のプロセスにファイルが変更された可能性があります", 409)
    end
  end
end
