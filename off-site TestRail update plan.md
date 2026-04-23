# TestRail Upload Tool Implementation Plan

[](https://github.com/donghwanjin/obsidian_general/blob/main/docs/superpowers/plans/2026-04-16-testrail-upload.md#testrail-upload-tool-implementation-plan)

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Python script that reads test case definitions from `config.xlsx`, creates each case in TestRail via REST API, and writes back the Case ID and status to the same file.

**Architecture:** Single script `testrail_upload.py` with four layers — API helpers, lookup fetchers, row mapper, and main loop. The Excel file serves as both input config and output results. All logic is pure-function where possible to keep it testable.

**Tech Stack:** Python 3.8+, `requests` (HTTP), `openpyxl` (Excel), `pytest` + `unittest.mock` (tests)

---

## File Map

[](https://github.com/donghwanjin/obsidian_general/blob/main/docs/superpowers/plans/2026-04-16-testrail-upload.md#file-map)

|Action|Path|Responsibility|
|---|---|---|
|Create|`Scripts/testrail/requirements.txt`|Pin dependencies|
|Create|`Scripts/testrail/config.xlsx`|Input/output Excel template|
|Create|`Scripts/testrail/testrail_upload.py`|All script logic|
|Create|`tests/testrail/test_testrail_upload.py`|Unit tests|

---

## Task 1: Project Setup

[](https://github.com/donghwanjin/obsidian_general/blob/main/docs/superpowers/plans/2026-04-16-testrail-upload.md#task-1-project-setup)

**Files:**

- Create: `Scripts/testrail/requirements.txt`
    
- Create: `tests/testrail/__init__.py`
    
- [x] **Step 1: Create the directory structure** ✅ 2026-04-17
    

```shell
mkdir -p Scripts/testrail
mkdir -p tests/testrail
```

- [x] **Step 2: Create `requirements.txt`** ✅ 2026-04-17

```
requests==2.32.3
openpyxl==3.1.5
pytest==8.3.5
```

- [x] **Step 3: Install dependencies** ✅ 2026-04-17

```shell
pip install -r Scripts/testrail/requirements.txt
```

Expected output: Successfully installed requests, openpyxl, pytest (versions may vary slightly).

- [x] **Step 4: Create empty test package marker** ✅ 2026-04-17

Create `tests/testrail/__init__.py` with empty content.

- [ ]  **Step 5: Commit**

```shell
git add Scripts/testrail/requirements.txt tests/testrail/__init__.py
git commit -m "chore: scaffold testrail upload project structure"
```

---

## Task 2: Create Excel Config Template

[](https://github.com/donghwanjin/obsidian_general/blob/main/docs/superpowers/plans/2026-04-16-testrail-upload.md#task-2-create-excel-config-template)

**Files:**

- Create: `Scripts/testrail/config.xlsx`
    
-  **Step 1: Run this one-off snippet to generate the template**
    

From the repo root, run:

```shell
python - <<'EOF'
import openpyxl
wb = openpyxl.Workbook()
ws = wb.active
ws.append([
    "title", "section", "type", "priority",
    "preconditions", "steps", "expected_result",
    "case_id", "status"
])
ws.append([
    "Example: Verify login",
    "Login Tests",
    "Functional",
    "High",
    "A valid user account exists",
    "1. Navigate to the login page\n2. Enter valid credentials\n3. Click Submit",
    "User is redirected to the dashboard",
    "",
    ""
])

# Freeze header row and set column widths for readability
ws.freeze_panes = "A2"
col_widths = [30, 20, 15, 12, 30, 40, 30, 12, 25]
for i, width in enumerate(col_widths, start=1):
    ws.column_dimensions[ws.cell(1, i).column_letter].width = width

wb.save("/mnt/c/Users/a0006235/Documents/Aldi/test_rail/Scripts/testrail/config.xlsx")
print("config.xlsx created.")
EOF
```

Expected output: `config.xlsx created.`

- [x] **Step 2: Verify the file opens correctly** ✅ 2026-04-17

Open `Scripts/testrail/config.xlsx` in Excel or LibreOffice. Confirm:

- Row 1 has 9 headers: title, section, type, priority, preconditions, steps, expected_result, case_id, status
    
- Row 2 has the sample data
    
-  **Step 3: Commit**
    

```shell
git add Scripts/testrail/config.xlsx
git commit -m "feat: add testrail config excel template"
```

---

## Task 3: API Helpers + Auth Check

[](https://github.com/donghwanjin/obsidian_general/blob/main/docs/superpowers/plans/2026-04-16-testrail-upload.md#task-3-api-helpers--auth-check)

**Files:**

- Create: `Scripts/testrail/testrail_upload.py` (initial skeleton)
    
- Create: `tests/testrail/test_testrail_upload.py` (api helper tests)
    
- [x] **Step 1: Write the failing tests for `api_get`, `api_post`, and `check_auth`** ✅ 2026-04-17
    

Create `tests/testrail/test_testrail_upload.py`:

```python
import sys
import os
import pytest
import requests
from unittest.mock import patch, MagicMock

sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', '..', 'Scripts', 'testrail'))
import testrail_upload as tr

BASE = "https://testrail-ap.dematic.net"

# ── api_get ───────────────────────────────────────────────────────────────────

def test_api_get_returns_json():
    mock_resp = MagicMock()
    mock_resp.json.return_value = {"projects": []}
    mock_resp.raise_for_status = MagicMock()
    with patch("testrail_upload.requests.get", return_value=mock_resp) as mock_get:
        result = tr.api_get(BASE, "user", "key", "get_projects")
    mock_get.assert_called_once()
    assert result == {"projects": []}

def test_api_get_calls_correct_url():
    mock_resp = MagicMock()
    mock_resp.json.return_value = {}
    mock_resp.raise_for_status = MagicMock()
    with patch("testrail_upload.requests.get", return_value=mock_resp) as mock_get:
        tr.api_get(BASE, "user", "key", "get_projects")
    called_url = mock_get.call_args[0][0]
    assert called_url == f"{BASE}/index.php?/api/v2/get_projects"

# ── api_post ──────────────────────────────────────────────────────────────────

def test_api_post_returns_json():
    mock_resp = MagicMock()
    mock_resp.json.return_value = {"id": 42}
    mock_resp.raise_for_status = MagicMock()
    with patch("testrail_upload.requests.post", return_value=mock_resp):
        result = tr.api_post(BASE, "user", "key", "add_case/1", {"title": "t"})
    assert result == {"id": 42}

def test_api_post_sends_json_body():
    mock_resp = MagicMock()
    mock_resp.json.return_value = {"id": 1}
    mock_resp.raise_for_status = MagicMock()
    with patch("testrail_upload.requests.post", return_value=mock_resp) as mock_post:
        tr.api_post(BASE, "user", "key", "add_case/1", {"title": "my case"})
    assert mock_post.call_args[1]["json"] == {"title": "my case"}

# ── check_auth ────────────────────────────────────────────────────────────────

def test_check_auth_exits_on_401():
    mock_resp = MagicMock()
    mock_resp.status_code = 401
    error = requests.HTTPError(response=mock_resp)
    with patch("testrail_upload.api_get", side_effect=error):
        with pytest.raises(SystemExit):
            tr.check_auth(BASE, "user", "bad_key")

def test_check_auth_passes_on_success():
    with patch("testrail_upload.api_get", return_value={"projects": []}):
        tr.check_auth(BASE, "user", "key")  # must not raise

def test_check_auth_reraises_non_401():
    mock_resp = MagicMock()
    mock_resp.status_code = 500
    error = requests.HTTPError(response=mock_resp)
    with patch("testrail_upload.api_get", side_effect=error):
        with pytest.raises(requests.HTTPError):
            tr.check_auth(BASE, "user", "key")
```

- [x] **Step 2: Run the tests — expect ImportError (file doesn't exist yet)** ✅ 2026-04-17

```shell
pytest tests/testrail/test_testrail_upload.py -v 2>&1 | head -20
```

Expected: `ModuleNotFoundError: No module named 'testrail_upload'`

- [ ]  **Step 3: Create `Scripts/testrail/testrail_upload.py` with the API helpers**

```python
import sys
import openpyxl
import requests
from requests.auth import HTTPBasicAuth

# ── Configuration — edit these before running ─────────────────────────────────
TESTRAIL_URL  = "https://testrail-ap.dematic.net"
TESTRAIL_USER = "donghwan.jin@dematic.com"
TESTRAIL_KEY  = "T1kwTZgWra5fcWjvoQnM-Y2YJcx3qhj0IfcWNxiGo"
PROJECT_ID    = "P754"
SUITE_ID      = "S55913"    # set to None if project does not use suites

EXCEL_PATH = "/mnt/c/Users/a0006235/Documents/Aldi/test_rail/Scripts/testrail/config.xlsx"

# Column indices (1-based, matching openpyxl)
COL = {
    "title":           1,
    "section":         2,
    "type":            3,
    "priority":        4,
    "preconditions":   5,
    "steps":           6,
    "expected_result": 7,
    "case_id":         8,
    "status":          9,
}

# ── API helpers ───────────────────────────────────────────────────────────────

def _auth(user, key):
    return HTTPBasicAuth(user, key)


def api_get(base_url, user, key, endpoint):
    url = f"{base_url}/index.php?/api/v2/{endpoint}"
    r = requests.get(url, auth=_auth(user, key), timeout=30)
    r.raise_for_status()
    return r.json()


def api_post(base_url, user, key, endpoint, data):
    url = f"{base_url}/index.php?/api/v2/{endpoint}"
    r = requests.post(url, json=data, auth=_auth(user, key), timeout=30)
    r.raise_for_status()
    return r.json()


def check_auth(base_url, user, key):
    try:
        api_get(base_url, user, key, "get_projects")
    except requests.HTTPError as e:
        if e.response.status_code == 401:
            print("ERROR: TestRail authentication failed. Check TESTRAIL_USER and TESTRAIL_KEY.")
            sys.exit(1)
        raise
```

- [x] **Step 4: Run the tests — expect all to pass** ✅ 2026-04-17

```shell
pytest tests/testrail/test_testrail_upload.py -v -k "api_get or api_post or check_auth"
```

Expected: 7 PASSED

- [x] **Step 5: Commit** ✅ 2026-04-17

```shell
git add Scripts/testrail/testrail_upload.py tests/testrail/test_testrail_upload.py
git commit -m "feat: add testrail API helpers and auth check"
```

---

## Task 4: Lookup Fetchers

[](https://github.com/donghwanjin/obsidian_general/blob/main/docs/superpowers/plans/2026-04-16-testrail-upload.md#task-4-lookup-fetchers)

**Files:**

- Modify: `Scripts/testrail/testrail_upload.py` (append lookup functions)
    
- Modify: `tests/testrail/test_testrail_upload.py` (append lookup tests)
    
- [x] **Step 1: Append failing tests for `fetch_sections`, `fetch_case_types`, `fetch_priorities`** ✅ 2026-04-17
    

Append to `tests/testrail/test_testrail_upload.py`:

```python
# ── fetch_sections ────────────────────────────────────────────────────────────

def test_fetch_sections_returns_name_id_map():
    data = {"sections": [{"id": 10, "name": "Login"}, {"id": 11, "name": "Signup"}]}
    with patch("testrail_upload.api_get", return_value=data):
        result = tr.fetch_sections(BASE, "u", "k", 1, 2)
    assert result == {"Login": 10, "Signup": 11}

def test_fetch_sections_no_suite_omits_suite_param():
    data = {"sections": [{"id": 5, "name": "General"}]}
    with patch("testrail_upload.api_get", return_value=data) as mock_get:
        tr.fetch_sections(BASE, "u", "k", 1, None)
    endpoint = mock_get.call_args[0][3]
    assert "suite_id" not in endpoint

# ── fetch_case_types ──────────────────────────────────────────────────────────

def test_fetch_case_types_returns_name_id_map():
    data = [{"id": 1, "name": "Other"}, {"id": 2, "name": "Functional"}]
    with patch("testrail_upload.api_get", return_value=data):
        result = tr.fetch_case_types(BASE, "u", "k")
    assert result == {"Other": 1, "Functional": 2}

# ── fetch_priorities ──────────────────────────────────────────────────────────

def test_fetch_priorities_returns_name_id_map():
    data = [{"id": 1, "name": "Critical"}, {"id": 4, "name": "Low"}]
    with patch("testrail_upload.api_get", return_value=data):
        result = tr.fetch_priorities(BASE, "u", "k")
    assert result == {"Critical": 1, "Low": 4}
```

- [x] **Step 2: Run to verify new tests fail** ✅ 2026-04-17

```shell
pytest tests/testrail/test_testrail_upload.py -v -k "fetch"
```

Expected: `AttributeError: module 'testrail_upload' has no attribute 'fetch_sections'`

- [x] **Step 3: Append lookup fetchers to `testrail_upload.py`** ✅ 2026-04-17

Append after `check_auth`:

```python
# ── Lookup builders ───────────────────────────────────────────────────────────

def fetch_sections(base_url, user, key, project_id, suite_id):
    endpoint = f"get_sections/{project_id}"
    if suite_id:
        endpoint += f"&suite_id={suite_id}"
    data = api_get(base_url, user, key, endpoint)
    sections = data.get("sections", data) if isinstance(data, dict) else data
    return {s["name"]: s["id"] for s in sections}


def fetch_case_types(base_url, user, key):
    data = api_get(base_url, user, key, "get_case_types")
    return {t["name"]: t["id"] for t in data}


def fetch_priorities(base_url, user, key):
    data = api_get(base_url, user, key, "get_priorities")
    return {p["name"]: p["id"] for p in data}
```

- [x] **Step 4: Run all tests — expect all to pass** ✅ 2026-04-17

```shell
pytest tests/testrail/test_testrail_upload.py -v
```

Expected: 12 PASSED

- [x] **Step 5: Commit** ✅ 2026-04-17

```shell
git add Scripts/testrail/testrail_upload.py tests/testrail/test_testrail_upload.py
git commit -m "feat: add section, case type, and priority lookup fetchers"
```

---

## Task 5: Row Mapper

[](https://github.com/donghwanjin/obsidian_general/blob/main/docs/superpowers/plans/2026-04-16-testrail-upload.md#task-5-row-mapper)

**Files:**

- Modify: `G` (append `map_row`)
    
- Modify: `tests/testrail/test_testrail_upload.py` (append row mapper tests)
    
- [x] **Step 1: Append failing tests for `map_row`** ✅ 2026-04-17
    

Append to `tests/testrail/test_testrail_upload.py`:

```python
# ── map_row ───────────────────────────────────────────────────────────────────

SECTION_MAP  = {"Login": 10, "Signup": 11}
TYPE_MAP     = {"Functional": 2, "Regression": 5}
PRIORITY_MAP = {"Critical": 1, "High": 2, "Medium": 3, "Low": 4}


def _row(title="Verify login", section="Login", type_="Functional", priority="High",
         preconditions="User exists", steps="1. Open app", expected="Success",
         case_id=None, status=None):
    return {
        "title": title, "section": section, "type": type_, "priority": priority,
        "preconditions": preconditions, "steps": steps, "expected_result": expected,
        "case_id": case_id, "status": status,
    }


def test_map_row_full_payload():
    section_id, payload = tr.map_row(_row(), SECTION_MAP, TYPE_MAP, PRIORITY_MAP)
    assert section_id == 10
    assert payload["title"] == "Verify login"
    assert payload["type_id"] == 2
    assert payload["priority_id"] == 2
    assert payload["custom_preconds"] == "User exists"
    assert payload["custom_steps"] == "1. Open app"
    assert payload["custom_expected"] == "Success"


def test_map_row_missing_title_raises():
    with pytest.raises(ValueError, match="missing title/section"):
        tr.map_row(_row(title=""), SECTION_MAP, TYPE_MAP, PRIORITY_MAP)


def test_map_row_missing_section_raises():
    with pytest.raises(ValueError, match="missing title/section"):
        tr.map_row(_row(section=""), SECTION_MAP, TYPE_MAP, PRIORITY_MAP)


def test_map_row_section_not_found_raises():
    with pytest.raises(ValueError, match="section not found"):
        tr.map_row(_row(section="Nonexistent"), SECTION_MAP, TYPE_MAP, PRIORITY_MAP)


def test_map_row_unknown_type_omits_type_id():
    _, payload = tr.map_row(_row(type_="Custom"), SECTION_MAP, TYPE_MAP, PRIORITY_MAP)
    assert "type_id" not in payload


def test_map_row_unknown_priority_omits_priority_id():
    _, payload = tr.map_row(_row(priority="Urgent"), SECTION_MAP, TYPE_MAP, PRIORITY_MAP)
    assert "priority_id" not in payload


def test_map_row_none_optional_fields_omitted():
    _, payload = tr.map_row(
        _row(preconditions=None, steps=None, expected=None),
        SECTION_MAP, TYPE_MAP, PRIORITY_MAP
    )
    assert "custom_preconds" not in payload
    assert "custom_steps" not in payload
    assert "custom_expected" not in payload
```

- [x] **Step 2: Run to verify new tests fail** ✅ 2026-04-17

```shell
pytest tests/testrail/test_testrail_upload.py -v -k "map_row"
```

Expected: `AttributeError: module 'testrail_upload' has no attribute 'map_row'`

- [ ]  **Step 3: Append `map_row` to `testrail_upload.py`**

Append after the lookup fetchers:

```python
# ── Row mapper ────────────────────────────────────────────────────────────────

def map_row(row_dict, section_map, type_map, priority_map):
    title   = (row_dict.get("title")   or "").strip()
    section = (row_dict.get("section") or "").strip()

    if not title or not section:
        raise ValueError("missing title/section")
    if section not in section_map:
        raise ValueError("section not found")

    section_id = section_map[section]
    payload = {"title": title}

    raw_type = (row_dict.get("type") or "").strip()
    if raw_type in type_map:
        payload["type_id"] = type_map[raw_type]

    raw_priority = (row_dict.get("priority") or "").strip()
    if raw_priority in priority_map:
        payload["priority_id"] = priority_map[raw_priority]

    for excel_col, api_field in [
        ("preconditions",   "custom_preconds"),
        ("steps",           "custom_steps"),
        ("expected_result", "custom_expected"),
    ]:
        val = (row_dict.get(excel_col) or "").strip()
        if val:
            payload[api_field] = val

    return section_id, payload
```

- [x] **Step 4: Run all tests — expect all to pass** ✅ 2026-04-17

```shell
pytest tests/testrail/test_testrail_upload.py -v
```

Expected: 20 PASSED

- [x] **Step 5: Commit** ✅ 2026-04-17

```shell
git add Scripts/testrail/testrail_upload.py tests/testrail/test_testrail_upload.py
git commit -m "feat: add row mapper with validation"
```

---

## Task 6: Main Loop

[](https://github.com/donghwanjin/obsidian_general/blob/main/docs/superpowers/plans/2026-04-16-testrail-upload.md#task-6-main-loop)

**Files:**

- Modify: `Scripts/testrail/testrail_upload.py` (append `main`)
    
- Modify: `tests/testrail/test_testrail_upload.py` (append main loop tests)
    
- [x] **Step 1: Append failing tests for `main`** ✅ 2026-04-17
    

Append to `tests/testrail/test_testrail_upload.py`:

```python
# ── main loop ─────────────────────────────────────────────────────────────────

import tempfile
import shutil


def _make_workbook(rows):
    """Helper: create a temp xlsx with given data rows and return its path."""
    import openpyxl
    wb = openpyxl.Workbook()
    ws = wb.active
    ws.append(["title", "section", "type", "priority",
                "preconditions", "steps", "expected_result",
                "case_id", "status"])
    for r in rows:
        ws.append(r)
    tmp = tempfile.NamedTemporaryFile(suffix=".xlsx", delete=False)
    wb.save(tmp.name)
    return tmp.name


def test_main_creates_case_and_writes_id(monkeypatch, tmp_path):
    path = _make_workbook([
        ["Verify login", "Login", "Functional", "High", "", "Steps", "Expected", "", ""]
    ])
    monkeypatch.setattr(tr, "EXCEL_PATH", path)
    monkeypatch.setattr(tr, "TESTRAIL_URL",  BASE)
    monkeypatch.setattr(tr, "TESTRAIL_USER", "u")
    monkeypatch.setattr(tr, "TESTRAIL_KEY",  "k")
    monkeypatch.setattr(tr, "PROJECT_ID",    1)
    monkeypatch.setattr(tr, "SUITE_ID",      None)

    with patch("testrail_upload.check_auth"), \
         patch("testrail_upload.fetch_sections",  return_value={"Login": 10}), \
         patch("testrail_upload.fetch_case_types", return_value={"Functional": 2}), \
         patch("testrail_upload.fetch_priorities", return_value={"High": 2}), \
         patch("testrail_upload.api_post",         return_value={"id": 999}):
        tr.main()

    import openpyxl
    wb2 = openpyxl.load_workbook(path)
    ws2 = wb2.active
    assert ws2.cell(2, 8).value == 999   # case_id
    assert ws2.cell(2, 9).value == "Created"


def test_main_skips_row_with_existing_case_id(monkeypatch):
    path = _make_workbook([
        ["Already created", "Login", "", "", "", "", "", 123, "Created"]
    ])
    monkeypatch.setattr(tr, "EXCEL_PATH", path)
    monkeypatch.setattr(tr, "TESTRAIL_URL",  BASE)
    monkeypatch.setattr(tr, "TESTRAIL_USER", "u")
    monkeypatch.setattr(tr, "TESTRAIL_KEY",  "k")
    monkeypatch.setattr(tr, "PROJECT_ID",    1)
    monkeypatch.setattr(tr, "SUITE_ID",      None)

    with patch("testrail_upload.check_auth"), \
         patch("testrail_upload.fetch_sections",   return_value={"Login": 10}), \
         patch("testrail_upload.fetch_case_types", return_value={}), \
         patch("testrail_upload.fetch_priorities", return_value={}), \
         patch("testrail_upload.api_post") as mock_post:
        tr.main()

    mock_post.assert_not_called()


def test_main_writes_failed_status_on_validation_error(monkeypatch):
    path = _make_workbook([
        ["", "Login", "", "", "", "", "", "", ""]  # missing title
    ])
    monkeypatch.setattr(tr, "EXCEL_PATH", path)
    monkeypatch.setattr(tr, "TESTRAIL_URL",  BASE)
    monkeypatch.setattr(tr, "TESTRAIL_USER", "u")
    monkeypatch.setattr(tr, "TESTRAIL_KEY",  "k")
    monkeypatch.setattr(tr, "PROJECT_ID",    1)
    monkeypatch.setattr(tr, "SUITE_ID",      None)

    with patch("testrail_upload.check_auth"), \
         patch("testrail_upload.fetch_sections",   return_value={"Login": 10}), \
         patch("testrail_upload.fetch_case_types", return_value={}), \
         patch("testrail_upload.fetch_priorities", return_value={}):
        tr.main()

    import openpyxl
    wb2 = openpyxl.load_workbook(path)
    ws2 = wb2.active
    assert ws2.cell(2, 9).value == "Failed: missing title/section"
    assert ws2.cell(2, 8).value is None  # case_id left blank


def test_main_writes_failed_status_on_api_error(monkeypatch):
    path = _make_workbook([
        ["Verify login", "Login", "", "", "", "", "", "", ""]
    ])
    monkeypatch.setattr(tr, "EXCEL_PATH", path)
    monkeypatch.setattr(tr, "TESTRAIL_URL",  BASE)
    monkeypatch.setattr(tr, "TESTRAIL_USER", "u")
    monkeypatch.setattr(tr, "TESTRAIL_KEY",  "k")
    monkeypatch.setattr(tr, "PROJECT_ID",    1)
    monkeypatch.setattr(tr, "SUITE_ID",      None)

    mock_resp = MagicMock()
    mock_resp.status_code = 400
    mock_resp.text = "Bad Request"
    api_error = requests.HTTPError(response=mock_resp)

    with patch("testrail_upload.check_auth"), \
         patch("testrail_upload.fetch_sections",   return_value={"Login": 10}), \
         patch("testrail_upload.fetch_case_types", return_value={}), \
         patch("testrail_upload.fetch_priorities", return_value={}), \
         patch("testrail_upload.api_post",         side_effect=api_error):
        tr.main()

    import openpyxl
    wb2 = openpyxl.load_workbook(path)
    ws2 = wb2.active
    status = ws2.cell(2, 9).value
    assert status.startswith("Failed:")
    assert "400" in status
```

- [x] **Step 2: Run to verify new tests fail** ✅ 2026-04-17

```shell
pytest tests/testrail/test_testrail_upload.py -v -k "main"
```

Expected: `AttributeError: module 'testrail_upload' has no attribute 'main'`

- [x] **Step 3: Append `main` to `testrail_upload.py`** ✅ 2026-04-17

Append after `map_row`:

```python
# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    wb = openpyxl.load_workbook(EXCEL_PATH)
    ws = wb.active

    check_auth(TESTRAIL_URL, TESTRAIL_USER, TESTRAIL_KEY)

    section_map  = fetch_sections(TESTRAIL_URL, TESTRAIL_USER, TESTRAIL_KEY, PROJECT_ID, SUITE_ID)
    type_map     = fetch_case_types(TESTRAIL_URL, TESTRAIL_USER, TESTRAIL_KEY)
    priority_map = fetch_priorities(TESTRAIL_URL, TESTRAIL_USER, TESTRAIL_KEY)

    headers = [ws.cell(1, c).value for c in range(1, len(COL) + 1)]

    for row_idx in range(2, ws.max_row + 1):
        case_id_cell = ws.cell(row_idx, COL["case_id"])
        status_cell  = ws.cell(row_idx, COL["status"])

        if case_id_cell.value:
            continue  # already processed — safe to re-run

        row_dict = {h: ws.cell(row_idx, i + 1).value for i, h in enumerate(headers)}

        try:
            section_id, payload = map_row(row_dict, section_map, type_map, priority_map)
            result = api_post(
                TESTRAIL_URL, TESTRAIL_USER, TESTRAIL_KEY,
                f"add_case/{section_id}", payload
            )
            case_id_cell.value = result["id"]
            status_cell.value  = "Created"
            print(f"Row {row_idx}: Created C{result['id']} — {payload['title']}")
        except ValueError as e:
            status_cell.value = f"Failed: {e}"
            print(f"Row {row_idx}: Failed — {e}")
        except requests.HTTPError as e:
            msg = f"{e.response.status_code} {e.response.text[:120]}"
            status_cell.value = f"Failed: {msg}"
            print(f"Row {row_idx}: Failed — {msg}")
        except Exception as e:
            status_cell.value = f"Failed: {e}"
            print(f"Row {row_idx}: Failed — {e}")

    wb.save(EXCEL_PATH)
    print("Done. Workbook saved.")


if __name__ == "__main__":
    main()
```

- [x] **Step 4: Run all tests — expect all to pass** ✅ 2026-04-17

```shell
pytest tests/testrail/test_testrail_upload.py -v
```

Expected: 28 PASSED

- [x] **Step 5: Commit** ✅ 2026-04-17

```shell
git add Scripts/testrail/testrail_upload.py tests/testrail/test_testrail_upload.py
git commit -m "feat: add main loop — reads excel, creates testrail cases, writes results"
```

---

## Task 7: Configure and Run End-to-End

[](https://github.com/donghwanjin/obsidian_general/blob/main/docs/superpowers/plans/2026-04-16-testrail-upload.md#task-7-configure-and-run-end-to-end)

**Files:**

- Modify: `Scripts/testrail/testrail_upload.py` (fill in real credentials)
    
- Modify: `Scripts/testrail/config.xlsx` (add real test case rows)
    
- [x] **Step 1: Open `testrail_upload.py` and fill in your credentials** ✅ 2026-04-17
    

Edit the configuration block at the top:

```python
TESTRAIL_URL  = "https://YOUR_COMPANY.testrail.io"   # e.g. https://acme.testrail.io
TESTRAIL_USER = "your.email@company.com"
TESTRAIL_KEY  = "your_api_key_from_testrail"          # My Account → API Keys in TestRail
PROJECT_ID    = 1     # The numeric project ID from the TestRail URL
SUITE_ID      = 1     # Suite ID, or set to None if project uses single-suite mode
```

To find your API key: in TestRail → click your avatar → **My Settings** → **API Keys** tab → **Add Key**.

To find Project ID: open your project in TestRail. The URL shows `/index.php?/projects/overview/N` where N is the ID.

- [x] **Step 2: Add real test cases to `config.xlsx`** ✅ 2026-04-17

Open `Scripts/testrail/config.xlsx`. Delete or edit the sample row. Add your test cases, filling in at minimum `title` and `section`. The `section` value must exactly match a section name in TestRail (case-sensitive).

Leave `case_id` and `status` columns blank.

- [x] **Step 3: Do a dry-run auth check** ✅ 2026-04-17

```shell
python - <<'EOF'
import sys
sys.path.insert(0, "Scripts/testrail")
import testrail_upload as tr
tr.check_auth(tr.TESTRAIL_URL, tr.TESTRAIL_USER, tr.TESTRAIL_KEY)
print("Auth OK")
sections = tr.fetch_sections(tr.TESTRAIL_URL, tr.TESTRAIL_USER, tr.TESTRAIL_KEY, tr.PROJECT_ID, tr.SUITE_ID)
print("Sections found:", list(sections.keys()))
EOF
```

Expected output:

```
Auth OK
Sections found: ['Login Tests', 'Signup', ...]
```

If you see `ERROR: TestRail authentication failed` → recheck your URL, username, and API key.

- [x] **Step 4: Run the upload** ✅ 2026-04-17

```shell
python Scripts/testrail/testrail_upload.py
```

Expected output (one line per row):

```
Row 2: Created C1042 — Verify login
Row 3: Created C1043 — Verify logout
...
Done. Workbook saved.
```

- [ ]  **Step 5: Verify results in Excel**

Open `Scripts/testrail/config.xlsx`. Confirm:

- `case_id` column is filled with TestRail IDs (e.g., 1042)
    
- `status` column shows `Created` for successful rows
    
- Any failed rows show `Failed: <reason>` with a clear error message
    
-  **Step 6: Verify in TestRail**
    

Open TestRail → your project → Test Cases. Confirm the new cases appear in the correct sections.

- [ ]  **Step 7: Commit final state**

```shell
git add Scripts/testrail/config.xlsx
git commit -m "feat: testrail upload tool complete"
```

---

## Spec Coverage Check

[](https://github.com/donghwanjin/obsidian_general/blob/main/docs/superpowers/plans/2026-04-16-testrail-upload.md#spec-coverage-check)

|Spec Requirement|Covered By|
|---|---|
|Read `config.xlsx` with standard fields|Task 2 (template), Task 6 (main loop)|
|Authenticate with username + API key|Task 3 (`check_auth`)|
|Fetch sections by name|Task 4 (`fetch_sections`)|
|Map type/priority names to IDs|Task 4 + Task 5|
|POST to `add_case` endpoint|Task 6 (`main`)|
|Write Case ID on success|Task 6|
|Write `Created` / `Failed: <reason>` status|Task 5 + Task 6|
|Skip rows with existing `case_id`|Task 6|
|Exit on 401|Task 3 (`check_auth`)|
|Continue on non-fatal errors|Task 6|