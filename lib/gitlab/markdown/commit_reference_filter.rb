require 'gitlab/markdown'

module Gitlab
  module Markdown
    # HTML filter that replaces commit references with links.
    #
    # This filter supports cross-project references.
    class CommitReferenceFilter < ReferenceFilter
      include CrossProjectReference

      # Public: Find commit references in text
      #
      #   CommitReferenceFilter.references_in(text) do |match, commit, project_ref|
      #     "<a href=...>#{commit}</a>"
      #   end
      #
      # text - String text to search.
      #
      # Yields the String match, the String commit identifier, and an optional
      # String of the external project reference.
      #
      # Returns a String replaced with the return of the block.
      def self.references_in(text)
        text.gsub(Commit.reference_pattern) do |match|
          yield match, $~[:commit], $~[:project]
        end
      end

      def self.referenced_by(node)
        project = Project.find(node.attr("data-project")) rescue nil
        return unless project

        id = node.attr("data-commit")
        commit = commit_from_ref(project, id)

        return unless commit

        { commit: commit }
      end

      def call
        replace_text_nodes_matching(Commit.reference_pattern) do |content|
          commit_link_filter(content)
        end
      end

      # Replace commit references in text with links to the commit specified.
      #
      # text - String text to replace references in.
      #
      # Returns a String with commit references replaced with links. All links
      # have `gfm` and `gfm-commit` class names attached for styling.
      def commit_link_filter(text)
        self.class.references_in(text) do |match, id, project_ref|
          project = self.project_from_ref(project_ref)

          if commit = self.class.commit_from_ref(project, id)
            url = url_for_commit(project, commit)

            title = escape_once(commit.link_title)
            klass = reference_class(:commit)
            data  = data_attribute(project: project.id, commit: id)

            project_ref += '@' if project_ref

            %(<a href="#{url}" #{data}
                 title="#{title}"
                 class="#{klass}">#{project_ref}#{commit.short_id}</a>)
          else
            match
          end
        end
      end

      def self.commit_from_ref(project, id)
        if project && project.valid_repo?
          project.commit(id)
        end
      end

      def url_for_commit(project, commit)
        h = Gitlab::Application.routes.url_helpers
        h.namespace_project_commit_url(project.namespace, project, commit,
                                        only_path: context[:only_path])
      end
    end
  end
end
