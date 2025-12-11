---
description: Add or list feature_list.json todos
argument-hint: [description] or --list
---

**Arguments:** $ARGUMENTS

**Instructions:**

## If arguments contain "--list" or "-l":

Display todos from feature_list.json in two sections:

### Section 1: Ready to Work On
Features where:
- `status` is `pending` or `in_progress`
- All items in `depends_on` have `status: "complete"` (or `depends_on` is empty)

Format as a table:
```
| ID | Name | Status |
|----|------|--------|
| FEAT-XXX | Name here | pending |
```

### Section 2: Waiting on Dependencies
Features where:
- `status` is `pending` or `in_progress`
- At least one item in `depends_on` does NOT have `status: "complete"`

Format as:
```
| ID | Name | Waiting On |
|----|------|------------|
| FEAT-XXX | Name here | FEAT-YYY (incomplete) |
```

Group by the blocking dependency if possible, or just list with the blocker noted.

### Section 3: Summary
Show counts: "X ready, Y blocked, Z complete"

---

## If arguments are a description (not a switch):

Add a new feature to feature_list.json:

1. Read feature_list.json to find the highest FEAT-XXX number
2. Create the next sequential ID
3. Add the new feature with:
   - `id`: Next FEAT-XXX
   - `name`: Brief name extracted from description (3-5 words)
   - `description`: Full description from user
   - `status`: "pending"
   - `depends_on`: []
   - `references`: []

4. Confirm what was added: "Added FEAT-XXX: [name]"
5. Ask if user wants to add dependencies or references
