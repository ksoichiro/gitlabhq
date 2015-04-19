# encoding: utf-8
require_relative "base_service"

module Files
  class CreateService < BaseService
    def execute
      allowed = Gitlab::GitAccess.can_push_to_branch?(current_user, project, ref)

      unless allowed
        return error("このブランチにファイルを作成する権限がありません")
      end

      file_name = File.basename(path)
      file_path = path

      unless file_name =~ Gitlab::Regex.path_regex
        return error(
          'ファイル名に利用できない文字が含まれているため、変更をコミットできません。ファイル名には' +
          Gitlab::Regex.path_regex_message
        )
      end

      if project.empty_repo?
        # everything is ok because repo does not have a commits yet
      else
        unless repository.branch_names.include?(ref)
          return error("You can only create files if you are on top of a branch")
        end

        blob = repository.blob_at_branch(ref, file_path)

        if blob
          return error("この名前のファイルが存在しないため、変更をコミットできません")
        end
      end


      new_file_action = Gitlab::Satellite::NewFileAction.new(current_user, project, ref, file_path)
      created_successfully = new_file_action.commit!(
        params[:content],
        params[:commit_message],
        params[:encoding]
      )

      if created_successfully
        success
      else
        error("ファイルが変更されたため、変更をコミットできません")
      end
    end
  end
end
