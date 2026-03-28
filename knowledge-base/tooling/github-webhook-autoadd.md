# Webhook Auto-Add for New Repos

When creating or cloning any new repository for `ocmuki-hub`, automatically add the push webhook.

---

## Webhook Details

| Config | Value |
|--------|-------|
| URL | `https://smee.io/uWA4H8psVoOciewv` |
| Events | `push`, `pull_request` |
| Content-Type | `json` |

---

## Command to Add Webhook

```bash
gh api repos/ocmuki-hub/REPO_NAME/hooks -X POST \
  -F name=web -F active=true \
  -F 'events[]=push' -F 'events[]=pull_request' \
  -F 'config[url]=https://smee.io/uWA4H8psVoOciewv' \
  -F 'config[content_type]=json'
```

---

## Workflow Integration

When `code-builder` or any agent creates a new repo:

1. Create/initialize repo
2. Add webhook immediately using command above
3. Confirm webhook is active
4. Proceed with code work

---

## Verification

Test webhook with ping:
```bash
gh api repos/ocmuki-hub/REPO_NAME/hooks/HOOK_ID/pings -X POST
```

---

## Telegram Chat ID

| Target | Chat ID |
|--------|---------|
| Murat | `8274533218` |

---

**Created:** 2026-03-28
**Related:** MEMORY.md, TOOLS.md