# Claude Code Memory - barebone Project

## Framework: wnode Web Server

This project uses **wnode**, an in-house web server framework. 

**IMPORTANT**: For detailed coding patterns, see:
- @doc/references/wnode_code_pattern.md - wnode framework patterns
- @doc/references/wnode_checkin_patterns.md - Parameter validation system
- @doc/references/wbs5_bootstrap_integration.md - Bootstrap 5 integration guide
- @doc/references/wbs5_quick_reference.md - WBS5 quick reference
- @doc/references/wbs5/layout_patterns.md - WBS5 layout system (grid, layout, rowGrid)
- @doc/references/wbs5/form_components.md - WBS5 form controls and widgets (from source analysis)
- @doc/references/wbs5/ui_components.md - WBS5 UI components (alerts, accordions, dropdowns, etc.)
- @doc/references/wbs5/practical_examples.md - Real-world WBS5 usage patterns and examples
- @doc/references/wbs5_UIC/README.md - WBS5 UIC components (tab, modal, accordion, etc.) usage guide

## Key Points:
- DO NOT suggest React/Vue patterns
- Use wnode's 4-export palet structure: `checkIn`, `model`, `view`, `control`
- **Parameter Validation**: Use object-based `exports.checkIn = { param: { '@type': 'dataType' } }` pattern (NOT function pattern)
- **Palet Reuse**: Use direct embedding with `paletXS.create()` in view function (like iframe). NEVER use delegation patterns between palets.
- **Architecture Preference**: Favor 2-layer flat architecture over deep nesting. Small code duplication is preferred over complex delegation chains.
- Component creation: `componentXS.create('cssID', params)` (NOT `xs.create()`)
- HTML generation with `xs.root()` and chained methods
- Event bubbling with `notify()` method
- UIC components imported as groups: `importUIC('/path')`
- API calls with `coimAPI` and standard response format
- **WBS5 Module Resolution**: wnode provides customized `require('bs5:main')`, `require('bs5:form')`, and `importUIC('bs5:components')` functions that automatically resolve WBS5 library paths
- **CSS Styling**: ALWAYS prefer Bootstrap 5 utility classes over custom CSS. Use classes like `mb-3`, `fw-semibold`, `p-3`, `border-top`, `d-flex`, `justify-content-end`, etc. instead of writing custom CSS rules. This prevents CSS specificity conflicts with wnode's CSS encapsulation and reduces code significantly.

## Project Info:
- **Name**: barebone (the minimum wnode webapp)
- **Description**: A minimum webapp to show how a wnode webapp can be built.
- **Language**: JavaScript (wnode framework)

## Available Commands:
- **Linting**: `npx eslint` (ESLint available)

## Dependencies:
- Bootstrap 5.3.3 for UI framework
- Async library for flow control
- ESLint for code quality

## Development Notes:
- Check for lint errors before committing: `npx eslint .`
- Project includes MCP (Model Context Protocol) integration