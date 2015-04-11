# encoding: utf-8
require_relative "base_service"

module Files
  class CreateService < BaseService
    def execute
      allowed = if project.protected_branch?(ref)
                  can?(current_user, :push_code_to_protected_branches, project)
                else
                  can?(current_user, :push_code, project)
                end

      unless allowed
        return error("このブランチにファイルを作成する権限がありません")
      end

      unless repository.branch_names.include?(ref)
        return error("ブランチ上にしかファイルは作成できません")
      end

      file_name = File.basename(path)
      file_path = path

      unless file_name =~ Gitlab::Regex.path_regex
        return error(
          'ファイル名に利用できない文字が含まれているため、変更をコミットできません。ファイル名には' +
          Gitlab::Regex.path_regex_message
        )
      end

      blob = repository.blob_at_branch(ref, file_path)

      if blob
        return error("この名前のファイルが存在しないため、変更をコミットできません")
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
