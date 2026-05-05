<p align="center">
  <a href="https://github.com/ItzDabbzz/ai_corner" rel="noopener">
    <img width="150px" height="300px" src="./.docs/dabtool.gif" alt="Project logo">
  </a>
</p>

<h3 align="center">🤖 DABZ AI Corner</h3>

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/status-active-success.svg" alt="Status"></a>
  <a href="https://github.com/ItzDabbzz/ai_corner/issues"><img src="https://img.shields.io/github/issues/ItzDabbzz/ai_corner.svg" alt="GitHub Issues"></a>
  <a href="https://github.com/ItzDabbzz/ai_corner/pulls"><img src="https://img.shields.io/github/issues-pr/ItzDabbzz/ai_corner.svg" alt="GitHub Pull Requests"></a>
  <a href="/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
</p>

---

<p align="center">
  A curated collection of AI skills, agents, prompts, commands, notes, and reusable workflows.
  <br>
</p>

## 📝 Table of Contents

- [📝 Table of Contents](#-table-of-contents)
- [🧐 About ](#-about-)
- [📁 Repository Structure ](#-repository-structure-)
- [🏁 Getting Started ](#-getting-started-)
  - [Prerequisites](#prerequisites)
  - [Installing](#installing)
  - [Addons Usage Pattern](#addons-usage-pattern)
  - [Vendor / Upstream Content 📦 ](#vendor--upstream-content--)
    - [➕ Add upstream repo](#-add-upstream-repo)
    - [🔄 Update upstream repo](#-update-upstream-repo)
- [🎈 Usage ](#-usage-)
- [⛏️ Built Using ](#️-built-using-)
- [✍️ Authors ](#️-authors-)
- [🎉 Acknowledgements ](#-acknowledgements-)

---

## 🧐 About <a name="about"></a>

This repository is where I keep the AI-related tooling and patterns I use regularly.

It acts as both a **personal working library** and a **curated reference** of practical pieces that are useful across projects.

Not everything here is authored from scratch. Some pieces are maintained locally, while others are pulled from upstream repositories and kept updateable.

If you find anything useful, please leave a ⭐

---

## 📁 Repository Structure <a name="repository_structure"></a>

```
.
├─ skills/      # 🔧 Reusable skills, patterns, workflows
├─ agents/      # 🤖 Agent definitions and specialized roles
├─ commands/    # ⚡ Command snippets and reusable task entrypoints
├─ prompts/     # 💬 Prompts and prompt collections
├─ notes/       # 📓 Reference notes, architecture notes, RAG notes, research
├─ addons/      # 🧩 Extensions, overrides, and custom wrappers for vendor content
└─ vendor/      # 📦 Upstream external repositories tracked via git subtree
```

---

## 🏁 Getting Started <a name="getting_started"></a>

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

What things you need to install the software and how to install them.

- [Git](https://git-scm.com/downloads)

### Installing

A step by step series of examples that tell you how to get a development env running.

```bash
# Clone the repository
git clone https://github.com/ItzDabbzz/ai_corner.git
```

Then run:

```bash
# Linux / macOS
./Install.sh

# Windows
Install.bat
```

### Addons Usage Pattern

Use `addons/` for:

- 🔧 Extending vendor skills without editing them
- 🎭 Wrapping upstream agents with custom logic
- 🔗 Composing multiple vendor skills into workflows
- ⚙️ Environment-specific overrides

**Example:**

```
vendor/vercel-agent-skills/
addons/vercel-agent-skills/overrides/
```

### Vendor / Upstream Content 📦 <a name="vendor_upstream"></a>

External repositories are stored in `vendor/`.

These are managed using **git subtree**, which embeds upstream repositories while allowing updates.

#### ➕ Add upstream repo

```bash
git subtree add --prefix=vendor/vercel-agent-skills   https://github.com/vercel-labs/agent-skills.git main --squash
```

#### 🔄 Update upstream repo

```bash
git subtree pull --prefix=vendor/vercel-agent-skills   https://github.com/vercel-labs/agent-skills.git main --squash
```

> ⚠️ **Notes:**
> - `vendor/` is for upstream imports only
> - Do not modify vendor content if you want easy updates
> - Custom work goes in `skills/`, `agents/`, `prompts/`, or `addons/`

---

## 🎈 Usage <a name="usage"></a>

Add notes about how to use the system.

---

## ⛏️ Built Using <a name="built_using"></a>

- [Markdown](https://www.markdownguide.org) — Because plain text deserves love too 💜

---

## ✍️ Authors <a name="authors"></a>

- **[@ItzDabbzz](https://github.com/ItzDabbzz)** — Idea & Initial work

See also the list of [contributors](https://github.com/ItzDabbzz/ai_corner/contributors) who participated in this project.

---

## 🎉 Acknowledgements <a name="acknowledgements"></a>

- 🎩 Hat tip to anyone whose code was used
- 💡 Inspiration
- 📚 References
