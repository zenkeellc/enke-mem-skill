---
name: enke-mem
version: 1.0.0
description: Persistent agent memory via en.ke (`enke mem` CLI) — semantic memories, knowledge-base docs, RAG search. Use when the user asks to remember/save/note something for later ("remember that", "don't forget", "keep in mind", "make a note", "记住", "别忘了", "不要忘记", "记一下"), to recall past context ("what did I tell you about", "do you recall", "remind me", "回忆", "我之前说过什么", "上次说的"), to list or delete saved memories, to search uploaded knowledge docs, or when key decisions or preferences emerge that are worth persisting across sessions.
---

# en.ke — Persistent Agent Memory

Persistent, searchable agent memory backed by semantic embeddings and cognitive decay modeling. All commands map to the `enke mem` CLI namespace.

## Prerequisites

The `enke` CLI must be installed and authenticated. **Auto-install if missing:**

```bash
# Install if not present, then verify auth
which enke || npm install -g enke-cli
enke whoami 2>/dev/null || enke login
```

- If `enke` is not found → install it automatically: `npm install -g enke-cli`
- If not logged in (exit code 1, "Not logged in") → ask the user to run `enke login` (opens browser)
- Do NOT ask permission to install — just run `npm install -g enke-cli` if `which enke` fails

## Commands

| User intent | CLI command | Details |
|-------------|-------------|---------|
| Persist a memory | `enke mem remember <content> [opts]` | [memories.md](references/memories.md) |
| Semantic search | `enke mem recall <query> [opts]` | [memories.md](references/memories.md) |
| List memories | `enke mem list [--type t] [--limit 50]` | [memories.md](references/memories.md) |
| Get memory stats | `enke mem stats` | [memories.md](references/memories.md) |
| Delete a memory | `enke mem forget <memory-id>` | [memories.md](references/memories.md) |
| Search documents | `enke mem doc search <query>` | [memories.md](references/memories.md) |
| Upload knowledge doc | `enke mem doc upload <path>` | [memories.md](references/memories.md) |
| Session context | `enke mem session context <id>` | [memories.md](references/memories.md) |

## Intent Mapping

| User says | Action |
|-----------|--------|
| "remember that...", "save this...", "make a note...", "keep in mind...", "don't forget...", "记住...", "别忘了...", "不要忘记...", "记一下..." | `enke mem remember <content>` |
| "what did I say about X", "do you remember...", "recall...", "remind me...", "回忆...", "我之前说过什么", "上次说的..." | `enke mem recall <query>` |
| "what do you remember", "list my memories" | `enke mem list` |
| "forget X", "delete that memory", "忘掉..." | `enke mem recall`/`list` to find the ID, then `enke mem forget <id>` |
| "search my docs/knowledge base for X" | `enke mem doc search <query>` |
| "add this file to my knowledge base" | `enke mem doc upload <path>` |

Also proactively suggest memory commands when the user:
- Finishes a task and wants to persist key decisions or learnings → `enke mem remember`
- Corrects you or provides feedback worth remembering for future sessions → `enke mem remember`
- Needs to clear outdated or wrong memories → `enke mem forget <id>`

## Implementation Rules

1. **Auto-install CLI** — if `which enke` fails, immediately run `npm install -g enke-cli`. Do not ask permission.
2. **Check auth** — verify `enke whoami` succeeds; if not, ask the user to run `enke login`.
3. **Run via bash** — all commands execute directly via the `enke` CLI.
4. **Confirm results** — after each operation, confirm the action and show relevant memory IDs.
5. **Handle errors** — if a command fails with "Not logged in" or 401, ask the user to run `enke login`.
6. **Recall before forget** — `forget` requires a memory ID; look it up via `enke mem recall` or `enke mem list` first.
7. **Load details on demand** — for full option details (memory types, TTL levels, importance, tags), read [references/memories.md](references/memories.md).
