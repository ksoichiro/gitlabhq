# Common methods and setup for Gitlab::Markdown reference filter specs
#
# Must be included into specs manually
module ReferenceFilterSpecHelper
  extend ActiveSupport::Concern

  # Shortcut to Rails' auto-generated routes helpers, to avoid including the
  # module
  def urls
    Rails.application.routes.url_helpers
  end

  # Perform `call` on the described class
  #
  # Automatically passes the current `project` value to the context if none is
  # provided.
  #
  # html     - String text to pass to the filter's `call` method.
  # contexts - Hash context for the filter. (default: {project: project})
  #
  # Returns the String text returned by the filter's `call` method.
  def filter(html, contexts = {})
    contexts.reverse_merge!(project: project)
    described_class.call(html, contexts)
  end

  # Run text through HTML::Pipeline with the current filter and return the
  # result Hash
  #
  # body     - String text to run through the pipeline
  # contexts - Hash context for the filter. (default: {project: project})
  #
  # Returns the Hash of the pipeline result
  def pipeline_result(body, contexts = {})
    contexts.reverse_merge!(project: project)

    pipeline = HTML::Pipeline.new([described_class], contexts)
    pipeline.call(body)
  end

  def allow_cross_reference!
    allow_any_instance_of(described_class).
      to receive(:user_can_reference_project?).and_return(true)
  end

  def disallow_cross_reference!
    allow_any_instance_of(described_class).
      to receive(:user_can_reference_project?).and_return(false)
  end
end
