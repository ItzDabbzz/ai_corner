<p align="center">
  <a href="https://github.com/ItzDabbzz/ai_corner" rel="noopener">
    <img width="150px" height="300px" src="./.docs/dabtool.gif" alt="Project logo">
  </a>
</p>

<h3 align="center">DABZ AI Corner</h3>

<p align="center">
  <a href="#"><img src="https://img.shields.io/badge/status-active-success.svg" alt="Status"></a>
  <a href="https://github.com/ItzDabbzz/ai_corner/issues"><img src="https://img.shields.io/github/issues/ItzDabbzz/ai_corner.svg" alt="GitHub Issues"></a>
  <a href="https://github.com/ItzDabbzz/ai_corner/pulls"><img src="https://img.shields.io/github/issues-pr/ItzDabbzz/ai_corner.svg" alt="GitHub Pull Requests"></a>
  <a href="/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
</p>

---

<p align="center">
  A collection of AI skills, agents, prompts, commands, notes, and workflows I use regularly.
  <br>
  
```bash
npx skills add ItzDabbzz/ai_corner
```
  
</p>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [About](#about)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installing](#installing)
    - [Skills](#skills)
    - [Development / Power User Install](#development--power-user-install)
  - [Addons Usage Pattern](#addons-usage-pattern)
  - [Vendor / Upstream Content](#vendor--upstream-content)
    - [Add upstream repo](#add-upstream-repo)
    - [Update upstream repo](#update-upstream-repo)
- [Built Using](#built-using)
- [Authors](#authors)
- [Acknowledgements](#acknowledgements)

---

## About

This repository contains the AI-related tooling and patterns I rely on across projects.

I maintain some pieces locally and pull others from upstream repositories, keeping them updateable rather than forking permanently. Not everything is original work.

If this is useful, leave a star.

---

## Repository Structure

```text
DABZAICorner
├─ skills/      # Reusable skills, patterns, workflows
├─ agents/      # Agent definitions and specialized roles
├─ commands/    # Command snippets and reusable task entrypoints
├─ prompts/     # Prompts and prompt collections
├─ notes/       # Reference notes, architecture notes, RAG notes, research
├─ addons/      # Extensions, overrides, and custom wrappers for vendor content
└─ vendor/      # Upstream external repositories tracked via git subtree
```

---

## Getting Started

These instructions will get you a copy of the project running locally for development and testing.

### Prerequisites

- [Bun](https://bun.sh) or [Node.js](https://nodejs.org)

### Installing

#### Skills

The quickest way to get started is to install the skills directly:

```bash
bunx skills add ItzDabbzz/ai_corner
```

```bash
npx skills add ItzDabbzz/ai_corner
```

> Learn more about the `skills` CLI at [skills.sh](https://www.skills.sh/) or in the [GitHub docs](https://github.com/vercel-labs/skills/blob/main/README.md).

#### Development / Power User Install

Clone the repository for development or local customization:

```bash
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

Use `addons/` to extend vendor skills without modifying them:

- Extend vendor skills without editing the originals
- Wrap upstream agents with custom logic
- Compose multiple vendor skills into workflows
- Add environment-specific overrides

Example structure:

```text
vendor/vercel-agent-skills/
addons/vercel-agent-skills/overrides/
```

### Vendor / Upstream Content

External repositories live in `vendor/` and are managed with git subtree, which embeds them while allowing updates.

#### Add upstream repo

```bash
git subtree add --prefix=vendor/vercel-agent-skills   https://github.com/vercel-labs/agent-skills.git main --squash
```

#### Update upstream repo

```bash
git subtree pull --prefix=vendor/vercel-agent-skills   https://github.com/vercel-labs/agent-skills.git main --squash
```

Important notes:

- `vendor/` is for upstream imports only
- Do not modify vendor content if you want easy updates
- Put custom work in `skills/`, `agents/`, `prompts/`, or `addons/`

---

## Built Using

- [Markdown](https://www.markdownguide.org) — Plain text deserves respect
- [Caveman](https://github.com/JuliusBrussee/caveman) - Save Token, Speak Like Man!
- [Cavekit](https://github.com/JuliusBrussee/cavekit) - SDD
- [Cavemem](https://github.com/JuliusBrussee/cavemem) - Remember now, or later.
- [Depwire](https://github.com/depwire/depwire)

---

## Authors

- [@ItzDabbzz](https://github.com/ItzDabbzz) — Initial work

See the [contributors](https://github.com/ItzDabbzz/ai_corner/contributors) list for everyone who participated.

---

## Acknowledgements

- Thanks to anyone whose code was used
- References and inspiration from the projects listed above
