# frozen_string_literal: true

# name: discourse-ai-patch
# about: TODO
# meta_topic_id: TODO
# version: 0.0.1
# authors: pangbo
# url: https://github.com/ShuiyuanSJTU/discourse-ai-patch
# required_version: 2.7.0

enabled_site_setting :discourse_ai_enabled

module ::DiscourseAiPatch
  PLUGIN_NAME = "discourse-ai-patch"
end

register_asset "stylesheets/common/ai-helper.scss"

require_relative "lib/discourse_ai_patch/engine"

after_initialize do
  DiscourseAi::Tokenizer::BgeLargeEnTokenizer.prepend DiscourseAiPatch::OverrideBgeLargeEnTokenizer
  DiscourseAi::Embeddings::SemanticSearch.prepend DiscourseAiPatch::OverrideSemanticSearch
  DiscourseAi::AiHelper::SemanticCategorizer.prepend DiscourseAiPatch::OverrideSemanticCategorizer
end
