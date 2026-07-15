# enke-mem Skill for Claude Code

**Persistent agent memory for Claude Code, backed by en.ke.**

Semantic memories, knowledge-base documents (RAG), and session context via the `enke mem` CLI.

## Quick Start

### 1. Install the CLI

```bash
npm install -g enke-cli
enke login
```

Verify installation:
```bash
enke whoami
```

If `enke` is not found after install, ensure your npm global bin directory is in PATH.

### 2. Install the Skill

```bash
git clone git@github.com:zenkeellc/enke-mem-skill.git
mkdir -p ~/.claude/skills/enke-mem
cp enke-mem-skill/SKILL.md ~/.claude/skills/enke-mem/
cp -r enke-mem-skill/references ~/.claude/skills/enke-mem/
```

### 3. Recommended: add a routing rule to your CLAUDE.md

Claude Code has a built-in local memory system. Without an explicit routing rule, "remember this" may be written to local memory files instead of en.ke. Add this to your `~/.claude/CLAUDE.md` (or a project `CLAUDE.md`):

```markdown
When I ask you to remember, save, or recall information
(remember / don't forget / recall / 记住 / 别忘了 / 回忆),
use the enke-mem skill (`enke mem remember` / `enke mem recall`)
instead of local memory files.
```

## What triggers the skill

| You say | Claude runs |
|---------|-------------|
| "remember that X", "don't forget X", "记住 X", "别忘了 X" | `enke mem remember` |
| "what did I say about X", "recall X", "回忆一下 X" | `enke mem recall` |
| "what do you remember?", "list my memories" | `enke mem list` |
| "forget X", "delete that memory" | `enke mem forget <id>` |
| "search my knowledge base for X" | `enke mem doc search` |
| "add this file to my knowledge base" | `enke mem doc upload` |

## Memory model

- **Types**: `semantic` (facts), `episodic` (events), `procedural` (how-tos)
- **TTL**: `buffer` (24h), `working` (7 days), `permanent`
- **Importance**: 0–1 — higher values resist cognitive decay longer

See [references/memories.md](references/memories.md) for the full CLI reference.

## Skill Structure

```
enke-mem-skill/
├── SKILL.md                  # Skill instructions (loaded when triggered)
├── references/
│   └── memories.md           # Full memory CLI reference — loaded on demand
├── README.md                 # This file
├── LICENSE                   # MIT
└── release.sh                # Release script
```

## Development

Symlink the repo for live editing (changes take effect without re-copying):

```bash
ln -s /path/to/enke-mem-skill ~/.claude/skills/enke-mem
```

## Related

Short links, file sharing, and landing pages live in the main [enke skill](https://github.com/zenkeellc/enke-link-skill).

## License

MIT
