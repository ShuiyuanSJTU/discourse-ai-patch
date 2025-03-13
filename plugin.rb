# frozen_string_literal: true

# name: discourse-ai-patch
# about: Patch for Discourse AI
# meta_topic_id: TODO
# version: 0.0.2
# authors: pangbo
# url: https://github.com/ShuiyuanSJTU/discourse-ai-patch
# required_version: 2.7.0

enabled_site_setting :discourse_ai_patch_enabled

module ::DiscourseAiPatch
  PLUGIN_NAME = "discourse-ai-patch"
end

require_relative "lib/discourse_ai_patch/engine"

after_initialize do
  DiscourseAi::Tokenizer::BgeLargeEnTokenizer.prepend DiscourseAiPatch::OverrideBgeLargeEnTokenizer
  DiscourseAi::Embeddings::SemanticSearch.prepend DiscourseAiPatch::OverrideSemanticSearch
  DiscourseAi::Embeddings::Vector.prepend DiscourseAiPatch::OverrideEmbeddingsVector
end
