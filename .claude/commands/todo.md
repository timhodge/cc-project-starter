---
description: Add or list feature_list.json todos
argument-hint: [description] or --list or complete FEAT-XXX
---

**Arguments:** $ARGUMENTS

**Instructions:**

## If arguments contain "--list" or "-l":

Display todos from feature_list.json in two sections.

**Dependency logic:** Only active (in feature_list.json) incomplete items can block. If a dependency ID is NOT found in feature_list.json, it's archived and therefore complete/satisfied.

### Section 1: Ready to Work On
Features where:
- `status` is `pending` or `in_progress`
- All items in `depends_on` are either:
  - Not found in feature_list.json (archived = satisfied), OR
  - Empty array

Format as a table:
```
| ID | Name | Status |
|----|------|--------|
| FEAT-XXX | Name here | pending |
```

### Section 2: Waiting on Dependencies
Features where:
- `status` is `pending` or `in_progress`
- At least one item in `depends_on` IS found in feature_list.json (still active = blocking)

Format as:
```
| ID | Name | Waiting On |
|----|------|------------|
| FEAT-XXX | Name here | FEAT-YYY (pending) |
```

### Section 3: Summary
Show counts: "X ready, Y blocked, Z complete (archived)"

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

---

## If arguments start with "complete" followed by a FEAT-XXX ID:

Mark a feature complete and move it to the archive:

1. Find the feature in feature_list.json by ID
2. If not found, report error and stop
3. Remove the feature object from feature_list.json
4. Read feature_list_archive.json
5. Add the feature object to the archive's features array with `"status": "complete"`
6. Write updated feature_list_archive.json
7. Confirm: "Completed and archived FEAT-XXX: [name]"

**Note:** This is the standard way to complete a feature. Do NOT just change status to "complete" - always use this flow to keep feature_list.json lean.
