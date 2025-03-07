# frozen_string_literal: true

module DiscourseAiPatch::OverrideSemanticSearch
  def hypothetical_post_from(search_term)
    prompt = DiscourseAi::Completions::Prompt.new(<<~TEXT.strip)
      你是一个论坛ai助手，你需要帮助用户从关键词搜索论坛内容。这是一个大学的论坛，主要用户为大学生，讨论内容包括学校生活、课程学习。
    TEXT

    prompt.push(type: :user, content: <<~TEXT.strip)
      使用下面用户询问的关键词，帮用户写出咨询帖子的标题和简短的内容，标题和正文之间留一个空行，不需要标注出“标题”和“正文”。直接回答，不要进行对话。
      用户输入的关键词放在了<input>与</input>之间：

      <input>#{search_term.gsub(/(?<=\p{Han})\s+(?=\p{Han})/, "")}</input>
    TEXT

    llm_response =
      DiscourseAi::Completions::Llm.proxy(
        SiteSetting.ai_embeddings_semantic_search_hyde_model,
      ).generate(prompt, user: @guardian.user, feature_name: "semantic_search_hyde")

    llm_response
  end
end
