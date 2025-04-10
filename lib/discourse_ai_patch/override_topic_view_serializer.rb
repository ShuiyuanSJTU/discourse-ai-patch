# frozen_string_literal: true

module DiscourseAiPatch::OverrideTopicViewSerializer
  def summarizable
    super && object.topic.posts_count <= SiteSetting.ai_max_summary_posts
  end
end
