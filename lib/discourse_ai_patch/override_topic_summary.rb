# frozen_string_literal: true

module DiscourseAiPatch::OverrideTopicSummary
  def as_llm_messages(contents)
    resource_path = "#{Discourse.base_path}/t/-/#{target.id}"
    content_title = target.title
    input = contents.to_json

    messages = []
    messages << {
      type: :user,
      content:
        "Here are the posts inside <input></input> XML tags:\n\n<input>[{\"id\":1,\"poster\":\"user1\",\"text\":\"I love Mondays\"},{\"id\":2,\"poster\":\"user2\",\"text\":\"I hate Mondays\"}]</input>\n\nGenerate a concise, coherent summary of the text above maintaining the original language.",
    }

    messages << {
      type: :model,
      content:
        "Two users are sharing their feelings toward Mondays. [user1](#{resource_path}/1) hates them, while [user2](#{resource_path}/2) loves them.",
    }

    messages << { type: :user, content: <<~TEXT.strip }
      #{content_title.present? ? "The discussion title is: " + content_title + ".\n" : ""}
      The `resource_url` is #{resource_path}.
      Here are the posts, inside <input></input> XML tags:

      <input>
        #{input}
      </input>

      Generate a concise, coherent summary of the text in Simplified Chinese.
    TEXT

    puts messages
    messages
  end
end
