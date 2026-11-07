return {
	settings = {
		yaml = {
			keyOrdering = false,
			-- SchemaStore supplies the schemas below, so turn off yamlls' own store
			schemaStore = { enable = false, url = "" },
			schemas = require("schemastore").yaml.schemas(),
		},
	},
}
