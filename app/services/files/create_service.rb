# encoding: utf-8
require_relative "base_service"

module Files
  class CreateService < Files::BaseService
    def commit
      repository.commit_file(current_user, @file_path, @file_content, @commit_message, @target_branch, false)
    end

    def validate
      super

      if @file_path =~ Gitlab::Regex.directory_traversal_regex
        raise_error(
          'Your changes could not be committed, because the file name ' +
          Gitlab::Regex.directory_traversal_regex_message
        )
      end

      unless @file_path =~ Gitlab::Regex.file_path_regex
        raise_error(
          '変更をコミットできません。ファイル名には' +
          Gitlab::Regex.file_path_regex_message
        )
      end

      unless project.empty_repo?
        @file_path.slice!(0) if @file_path.start_with?('/')

        blob = repository.blob_at_branch(@current_branch, @file_path)

        if blob
          raise_error("この名前のファイルが存在しているため、変更をコミットできません")
        end
      end
    end
  end
end
