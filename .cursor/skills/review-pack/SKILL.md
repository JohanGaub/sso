---
name: review-pack
description: Produce a short reviewer pack: summary, test plan, and list of files to review. Use before requesting peer review.
disable-model-invocation: true
---

# Reviewer Pack

## When to use
- Use this skill when the user wants to ask a colleague to review changes.
- Manual invocation only (`/review-pack`) to keep behavior predictable in training.

## Instructions
1. Check `git status --short`. If empty, explain there is nothing to review.
2. Provide:
   - Reviewer summary (2-4 bullets)
   - Test plan (commands + outcomes if known)
   - Files changed (from `git status --short`)
   - Risks / areas to pay attention to
3. Keep it short and actionable.

