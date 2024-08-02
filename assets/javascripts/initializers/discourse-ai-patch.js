import { action } from "@ember/object";
import { withPluginApi } from "discourse/lib/plugin-api";
import I18n from "I18n";

function initializeAiPatch(api) {
  api.modifyClass('component:ai-suggestion-dropdown', {
    pluginId: 'discourse-ai-patch',

    get showAIButton() {
      const minCharacterCount = 10;
      const isShowAIButton = this.composer.model.replyLength > minCharacterCount;
      const composerFields = document.querySelector(".composer-fields");
      if (composerFields) {
        if (isShowAIButton) {
          composerFields.classList.add("showing-ai-suggestions");
        } else {
          composerFields.classList.remove("showing-ai-suggestions");
        }
      }
      return isShowAIButton;
    },
    closeMenu() {
      if (this.showMenu && this.args.mode === "suggest_category") {
        document
          .querySelector(".category-input")
          ?.classList.remove("showing-ai-suggestion-menu");
      }
      this.suggestIcon = "discourse-sparkles";
      this.showMenu = false;
      this.showErrors = false;
      this.errors = "";
    },
    updateTags(suggestion, composer) {
      const maxTags = this.siteSettings.max_tags_per_topic;

      if (!composer.tags) {
        composer.set("tags", [suggestion]);
        // remove tag from the list of suggestions once added
        this.generatedSuggestions = this.generatedSuggestions.filter(
          (s) => s !== suggestion
        );
        return;
      }
      const tags = composer.tags;

      if (tags?.length >= maxTags) {
        // Show error if trying to add more tags than allowed
        this.showErrors = true;
        this.error = I18n.t("select_kit.max_content_reached", { count: maxTags });
        return;
      }

      tags.push(suggestion);
      composer.set("tags", [...tags]);
      // remove tag from the list of suggestions once added
      return (this.generatedSuggestions = this.generatedSuggestions.filter(
        (s) => s !== suggestion
      ));
    },
    @action
    applySuggestion(suggestion) {
      if (!this.args.mode) {
        return;
      }

      const composer = this.args?.composer;
      if (!composer) {
        return;
      }

      if (this.args.mode === this.SUGGESTION_TYPES.title) {
        composer.set("title", suggestion);
        return this.closeMenu();
      }

      if (this.args.mode === this.SUGGESTION_TYPES.category) {
        const selectedCategoryId = this.composer.categories.find(
          (c) => c.name === suggestion
        ).id;
        composer.set("categoryId", selectedCategoryId);
        return this.closeMenu();
      }

      if (this.args.mode === this.SUGGESTION_TYPES.tag) {
        this.updateTags(suggestion, composer);
      }
    }
  });
}

export default {
  name: "discourse-ai-patch",

  initialize(container) {
    withPluginApi("1.22.0", (api) => initializeAiPatch(api, container));
  },
};