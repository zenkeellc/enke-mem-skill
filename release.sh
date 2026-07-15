#!/bin/bash
set -euo pipefail

VERSION="${1:-1.0.0}"
REPO="enke-mem-skill"
GITHUB_REMOTE="origin"

echo "=== Releasing $REPO v$VERSION ==="

# 1. Check working directory clean
if [[ -n $(git status --porcelain) ]]; then
  echo "Error: working directory not clean. Commit or stash changes first."
  exit 1
fi

# 2. Update version in skill frontmatter
sed -i '' "s/version: .*/version: $VERSION/" SKILL.md

# 3. Git tag & push
git add SKILL.md
git commit -m "release: v$VERSION"
git tag "v$VERSION"
git push "$GITHUB_REMOTE" main
git push "$GITHUB_REMOTE" "v$VERSION"

# 4. Create GitHub Release
if command -v gh &> /dev/null; then
  gh release create "v$VERSION" \
    --title "enke-mem Claude Code Skill v$VERSION" \
    --notes "## enke-mem Claude Code Skill v$VERSION

### Install
\`\`\`bash
git clone git@github.com:zenkeellc/enke-mem-skill.git
mkdir -p ~/.claude/skills/enke-mem
cp enke-mem-skill/SKILL.md ~/.claude/skills/enke-mem/
cp -r enke-mem-skill/references ~/.claude/skills/enke-mem/
\`\`\`

Requires: \`npm install -g enke-cli && enke login\`

### Memory Commands
| User says | CLI executed |
|-----------|-------------|
| \"remember that X\", \"don't forget X\", \"记住 X\" | \`enke mem remember\` |
| \"what did I say about X\", \"recall X\", \"回忆 X\" | \`enke mem recall\` |
| \"list memories\" | \`enke mem list\` |
| \"forget X\" | \`enke mem forget <id>\` |
| \"search my knowledge base for X\" | \`enke mem doc search\` |
| \"add this file to my knowledge base\" | \`enke mem doc upload\` |

### Changes
- Initial release: memory module split out of the enke skill
- Focused bilingual (EN/中文) activation triggers for remember/recall/forget
- Recommended CLAUDE.md routing rule to take precedence over built-in local memory" \
    --repo "zenkeellc/$REPO"
else
  echo "GitHub CLI (gh) not found. Create release manually at:"
  echo "  https://github.com/zenkeellc/$REPO/releases/new?tag=v$VERSION"
fi

echo "=== Release complete: v$VERSION ==="
