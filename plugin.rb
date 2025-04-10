# frozen_string_literal: true

# name: discourse-ai-patch
# about: Patch for Discourse AI
# meta_topic_id: TODO
# version: 0.0.3
# authors: pangbo
# url: https://github.com/ShuiyuanSJTU/discourse-ai-patch
# required_version: 2.7.0

enabled_site_setting :discourse_ai_patch_enabled

module ::DiscourseAiPatch
  PLUGIN_NAME = "discourse-ai-patch"
end

require_relative "lib/discourse_ai_patch/engine"

after_initialize do
  # Add setting to optional disable bluk embedding backfill
  DiscourseAi::Embeddings::Vector.prepend DiscourseAiPatch::OverrideEmbeddingsVector

  # Replace the default BgeLargeEn tokenizer with Chinese tokenizer
  DiscourseAi::Tokenizer::BgeLargeEnTokenizer.prepend DiscourseAiPatch::OverrideBgeLargeEnTokenizer

  # Replace the prompts of semantic search and topic summary
  DiscourseAi::Embeddings::SemanticSearch.prepend DiscourseAiPatch::OverrideSemanticSearch
  DiscourseAi::Summarization::Strategies::TopicSummary.prepend DiscourseAiPatch::OverrideTopicSummary

  # Display the display name of model in summary
  DiscourseAi::Summarization::SummaryController.prepend DiscourseAiPatch::OverrideSummaryController

  # Add a setting to limit the maximum number of posts for summary
  # Although it is recommended use `add_to_serializer`, but the 
  # origin ai plugin already use `add_to_serializer`, use prepend
  # to get higher priority
  AiTopicSummarySerializer.prepend DiscourseAiPatch::OverrideAiTopicSummarySerializer
  TopicViewSerializer.prepend DiscourseAiPatch::OverrideTopicViewSerializer
end
