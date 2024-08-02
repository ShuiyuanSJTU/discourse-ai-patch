# frozen_string_literal: true

module DiscourseAiPatch::OverrideBgeLargeEnTokenizer
  module ClassMethods
    def tokenizer
      Tokenizers.from_file(File.expand_path("../../tokenizers/bge-large-zh.json", __dir__))
    end
  end

  def self.prepended(klass)
    klass.singleton_class.prepend(ClassMethods)
  end
end