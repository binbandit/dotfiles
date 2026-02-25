--- @type vim.lsp.Config
return {
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      experimental = {
        completion = {
          enableServerSideFuzzyMatch = true,
          entriesLimit = 75,
        },
      },
    },
    typescript = {
      updateImportsOnFileMove = { enabled = "always" },
      preferences = {
        importModuleSpecifier = "relative",
        quoteStyle = "single",
        includePackageJsonAutoImports = "on",
        preferTypeOnlyAutoImports = true,
        jsxAttributeCompletionStyle = "auto",
      },
      suggest = {
        completeFunctionCalls = true,
        autoImports = true,
        includeCompletionsForImportStatements = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
      tsserver = {
        maxTsServerMemory = 8192,
      },
    },
    javascript = {
      updateImportsOnFileMove = { enabled = "always" },
      preferences = {
        importModuleSpecifier = "relative",
        quoteStyle = "single",
        includePackageJsonAutoImports = "on",
        jsxAttributeCompletionStyle = "auto",
      },
      suggest = {
        completeFunctionCalls = true,
        autoImports = true,
        includeCompletionsForImportStatements = true,
      },
      inlayHints = {
        enumMemberValues = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        variableTypes = { enabled = false },
      },
    },
  },
}
