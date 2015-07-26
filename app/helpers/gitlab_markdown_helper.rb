module GitlabMarkdownHelper
  include Gitlab::Markdown

  # Use this in places where you would normally use link_to(gfm(...), ...).
  #
  # It solves a problem occurring with nested links (i.e.
  # "<a>outer text <a>gfm ref</a> more outer text</a>"). This will not be
  # interpreted as intended. Browsers will parse something like
  # "<a>outer text </a><a>gfm ref</a> more outer text" (notice the last part is
  # not linked any more). link_to_gfm corrects that. It wraps all parts to
  # explicitly produce the correct linking behavior (i.e.
  # "<a>outer text </a><a>gfm ref</a><a> more outer text</a>").
  def link_to_gfm(body, url, html_options = {})
    return "" if body.blank?

    escaped_body = if body =~ /\A\<img/
                     body
                   else
                     escape_once(body)
                   end

    gfm_body = gfm(escaped_body, {}, html_options)

    gfm_body.gsub!(%r{<a.*?>.*?</a>}m) do |match|
      "</a>#{match}#{link_to("", url, html_options)[0..-5]}" # "</a>".length +1
    end

    link_to(gfm_body.html_safe, url, html_options)
  end

  def markdown(text, options={})
    unless @markdown && options == @options
      @options = options

      options.merge!(
        # Handled further down the line by Gitlab::Markdown::SanitizationFilter
        escape_html: false
      )

      # see https://github.com/vmg/redcarpet#darling-i-packed-you-a-couple-renderers-for-lunch
      rend = Redcarpet::Render::GitlabHTML.new(self, user_color_scheme_class, options)

      # see https://github.com/vmg/redcarpet#and-its-like-really-simple-to-use
      @markdown = Redcarpet::Markdown.new(rend,
        no_intra_emphasis:   true,
        tables:              true,
        fenced_code_blocks:  true,
        strikethrough:       true,
        lax_spacing:         true,
        space_after_headers: true,
        superscript:         true,
        footnotes:           true
      )
    end

    @markdown.render(text).html_safe
  end

  # Return the first line of +text+, up to +max_chars+, after parsing the line
  # as Markdown.  HTML tags in the parsed output are not counted toward the
  # +max_chars+ limit.  If the length limit falls within a tag's contents, then
  # the tag contents are truncated without removing the closing tag.
  def first_line_in_markdown(text, max_chars = nil, options = {})
    md = markdown(text, options).strip

    truncate_visible(md, max_chars || md.length) if md.present?
  end

  def render_wiki_content(wiki_page)
    if wiki_page.format == :markdown
      markdown(wiki_page.content)
    else
      wiki_page.formatted_content.html_safe
    end
  end

  private

  # Return +text+, truncated to +max_chars+ characters, excluding any HTML
  # tags.
  def truncate_visible(text, max_chars)
    doc = Nokogiri::HTML.fragment(text)
    content_length = 0
    truncated = false

    doc.traverse do |node|
      if node.text? || node.content.empty?
        if truncated
          node.remove
          next
        end

        # Handle line breaks within a node
        if node.content.strip.lines.length > 1
          node.content = "#{node.content.lines.first.chomp}..."
          truncated = true
        end

        num_remaining = max_chars - content_length
        if node.content.length > num_remaining
          node.content = node.content.truncate(num_remaining)
          truncated = true
        end
        content_length += node.content.length
      end

      truncated = truncate_if_block(node, truncated)
    end

    doc.to_html
  end

  # Used by #truncate_visible.  If +node+ is the first block element, and the
  # text hasn't already been truncated, then append "..." to the node contents
  # and return true.  Otherwise return false.
  def truncate_if_block(node, truncated)
    if node.element? && node.description.block? && !truncated
      node.content = "#{node.content}..." if node.next_sibling
      true
    else
      truncated
    end
  end

  def cross_project_reference(project, entity)
    path = project.path_with_namespace

    if entity.kind_of?(Issue)
      [path, entity.iid].join('#')
    elsif entity.kind_of?(MergeRequest)
      [path, entity.iid].join('!')
    else
      raise 'Not supported type'
    end
  end
end
