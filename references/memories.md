# Memory Commands Reference

The `enke mem` namespace provides persistent agent memory backed by semantic embeddings and cognitive decay modeling.

---

## Quick Reference

```bash
# Core CRUD
enke mem remember <content> [--type semantic|episodic|procedural] [--ttl buffer|working|permanent] [--importance 0.5] [--tags tag1,tag2]
enke mem recall <query> [--limit 10] [--type semantic] [--threshold 0.5]
enke mem list [--type semantic] [--limit 50]
enke mem forget <memory-id>
enke mem stats

# Documents (knowledge base — RAG over uploaded files)
enke mem doc upload <file-path> [--name filename]
enke mem doc search <query> [--limit 5]
enke mem doc list [--limit 20]
enke mem doc delete <document-id>

# Sessions (context assembly for agents)
enke mem session create [--agent name]
enke mem session context <session-id> [--limit 10]
```

---

## Memory Types

| Type | Use case |
|------|----------|
| `semantic` (default) | Facts, concepts, knowledge — "the API uses port 8080" |
| `episodic` | Events, experiences — "we fixed the auth bug on Tuesday" |
| `procedural` | How-to, workflows — "to deploy, run docker_build.sh then docker_rerun.sh" |

## TTL Levels

| Level | Expiration | Use case |
|-------|-----------|----------|
| `buffer` | 24 hours | Temporary context, session notes |
| `working` | 7 days | Active project details |
| `permanent` | Never | Long-term knowledge, preferences |

## Importance

Float 0–1. Higher values resist cognitive decay longer. Default 0.5.

- `0.0` — trivial, decays quickly
- `0.5` — default
- `1.0` — critical, permanent retention

---

## `enke mem remember`

Persist a memory for later recall.

```bash
enke mem remember "the staging server is at staging.example.com:3000" --type semantic --ttl working --importance 0.7
```

**Options:**

| Flag | Values | Default | Notes |
|------|--------|---------|-------|
| `--type` | semantic, episodic, procedural | semantic | Categorizes the memory |
| `--ttl` | buffer, working, permanent | working | Auto-expiration |
| `--importance` | 0.0–1.0 | 0.5 | Higher = longer retention |
| `--tags` | comma-separated | — | e.g. `--tags deploy,staging` |

**When to use:**
- User explicitly asks to remember something
- Important configuration, preferences, or decisions emerge in conversation
- Wrapping up a task — save key outcomes
- User shares context that will be relevant later

**Stdout:** JSON with `{ id, content, memory_type, ttl_level, importance, created_at }`.

---

## `enke mem recall`

Semantic + keyword search across memories. Returns ranked by relevance.

```bash
enke mem recall "staging server"
enke mem recall "auth bug" --type episodic --limit 5
enke mem recall "deployment steps" --type procedural --threshold 0.6
```

**Options:**

| Flag | Values | Default | Notes |
|------|--------|---------|-------|
| `--limit` | 1–50 | 10 | Max results |
| `--type` | semantic, episodic, procedural | all types | Filter by type |
| `--threshold` | 0.0–1.0 | 0.5 | Minimum similarity score |

**When to use:**
- User asks "do you remember" or "what did I tell you about X"
- Need to retrieve past context before starting work
- Checking if a fact/decision was already recorded

**Stdout:** JSON array of `[{ id, content, memory_type, relevance_score, created_at }]`.

---

## `enke mem list`

Paginated list of recent memories.

```bash
enke mem list --type semantic --limit 20
```

No semantic search — just chronological listing with optional type filter.

---

## `enke mem forget`

Delete a specific memory by ID.

```bash
enke mem forget mem_abc123
```

**Soft-delete:** The memory ID is retired but the content may persist for audit. Use the ID from `recall` or `list` output.

---

## `enke mem stats`

Aggregated statistics about stored memories.

**Stdout:** JSON with `{ total, by_type: {semantic, episodic, procedural}, by_ttl: {buffer, working, permanent}, avg_importance }`.

---

## Knowledge Base Documents

Documents are uploaded files (PDF, DOCX, TXT, MD) that get chunked and embedded for RAG search.

### `enke mem doc upload`

```bash
enke mem doc upload ./meeting-notes.pdf --name "Q3 Meeting Notes"
```

- Supports: PDF, DOCX, TXT, MD, HTML
- Max file size: 10 MB
- Content is chunked and embedded for semantic search

### `enke mem doc search`

```bash
enke mem doc search "quarterly revenue projections" --limit 5
```

Searches across uploaded documents using RAG. Returns relevant chunks with source attribution.

### `enke mem doc list`

Lists uploaded documents with metadata (filename, size, chunk count, created_at).

### `enke mem doc delete`

Deletes a document and all its chunks/embeddings.

---

## Sessions

Sessions group related memories for context assembly (useful for agent loops).

### `enke mem session create`

Creates a new session. Returns a session ID.

### `enke mem session context <id>`

Assembles a context payload from memories created within this session. Useful for injecting into agent prompts.

## Error Handling

| Error | Response |
|-------|----------|
| Token expired (401) | Guide user to `enke login` |
| Memory not found | Suggest `enke mem list` or `enke mem recall` |
| CLI not installed | `npm install -g enke-cli && enke login` |
