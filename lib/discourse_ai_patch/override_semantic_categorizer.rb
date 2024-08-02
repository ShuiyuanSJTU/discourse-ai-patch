# frozen_string_literal: true
module DiscourseAiPatch::OverrideSemanticCategorizer
  def categories
    return [] if @text.blank?
    return [] unless SiteSetting.ai_embeddings_enabled

    candidates = nearest_neighbors(limit: 100)
    candidate_ids = candidates.map(&:first)

    ::Topic
      .joins(:category)
      .where(id: candidate_ids)
      .where("categories.id IN (?)", Category.topic_create_allowed(@user.guardian).pluck(:id))
      .order("array_position(ARRAY#{candidate_ids}, topics.id)")
      .pluck("categories.name")
      .map
      .with_index { |category, index| { name: category, score: candidates[index].last } }
      .map do |c|
        c[:score] = 1 / (c[:score] + 1) # inverse of the distance
        c
      end
      .group_by { |c| c[:name] }
      .map { |name, scores| { name: name, score: scores.sum { |s| s[:score] } } }
      .sort_by { |c| -c[:score] }
      .take(5)
  end
end