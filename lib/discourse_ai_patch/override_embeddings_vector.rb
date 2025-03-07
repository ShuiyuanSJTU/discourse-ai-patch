# frozen_string_literal: true

module DiscourseAiPatch::OverrideEmbeddingsVector
  def gen_bulk_reprensentations(relation)
    if SiteSetting.discourse_ai_enabled
      relation.each do |t|
        generate_representation_from(t)
      end
    else
      super relation
    end
  end
end
