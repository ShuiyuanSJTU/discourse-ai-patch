# frozen_string_literal: true

module DiscourseAiPatch::OverrideSummaryController
  def show
    topic = Topic.find(params[:topic_id])
    if topic.posts_count > SiteSetting.ai_max_summary_posts
      raise Discourse::NotFound
    else
      super  
    end
  end
end
