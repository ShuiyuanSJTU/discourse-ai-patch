import { withPluginApi } from "discourse/lib/plugin-api";

// eslint-disable-next-line no-unused-vars
function initializeAiPatch(api) {}

export default {
  name: "discourse-ai-patch",

  initialize(container) {
    withPluginApi("1.22.0", (api) => initializeAiPatch(api, container));
  },
};
