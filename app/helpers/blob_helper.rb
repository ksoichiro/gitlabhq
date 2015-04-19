# encoding: utf-8
module BlobHelper
  def highlight(blob_name, blob_content, nowrap = false)
    formatter = Rugments::Formatters::HTML.new(
      nowrap: nowrap,
      cssclass: 'code highlight',
      lineanchors: true,
      lineanchorsid: 'LC'
    )

    begin
      lexer = Rugments::Lexer.guess(filename: blob_name, source: blob_content)
    rescue Rugments::Lexer::AmbiguousGuess
      lexer = Rugments::Lexers::PlainText
    end

    formatter.format(lexer.lex(blob_content)).html_safe
  end

  def no_highlight_files
    %w(credits changelog copying copyright license authors)
  end

  def edit_blob_link(project, ref, path, options = {})
    blob =
      begin
        project.repository.blob_at(ref, path)
      rescue
        nil
      end

    if blob && blob.text?
      text = '編集'
      after = options[:after] || ''
      from_mr = options[:from_merge_request_id]
      link_opts = {}
      link_opts[:from_merge_request_id] = from_mr if from_mr
      cls = 'btn btn-small'
      if allowed_tree_edit?(project, ref)
        link_to text, project_edit_blob_path(project, tree_join(ref, path),
                                             link_opts), class: cls
      else
        content_tag :span, text, class: cls + ' disabled'
      end + after.html_safe
    else
      ''
    end
  end

  def leave_edit_message
    "編集モードを終了しますか？\n保存していない変更は失われます。"
  end

  def editing_preview_title(filename)
    if Gitlab::MarkdownHelper.previewable?(filename)
      'プレビュー'
    else
      '変更をプレビュー'
    end
  end
end
