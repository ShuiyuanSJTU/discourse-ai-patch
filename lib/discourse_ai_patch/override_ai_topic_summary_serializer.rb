# frozen_string_literal: true

module DiscourseAiPatch::OverrideAiTopicSummarySerializer
  def algorithm
    LlmModel.find_by(name:object.algorithm)&.display_name || ""
  end
end
