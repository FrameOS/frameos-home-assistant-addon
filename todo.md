# Home Assistant integration — status

The plan in this file has been implemented (2026-07-08) across both repos. Kept as a
record of what shipped and what's left.

## Done in `frameos` (branch `wasm`)

### 1. Release notes → add-on changelog

`.github/workflows/docker-publish-multi.yml`:
- New `release-notes` job generates `release-notes.md` once (via
  `tools/generate_release_notes.py`) and uploads it as an artifact.
- `update-addon-repo` downloads it and prepends a `## <version> (<date>)` section to
  `frameos/CHANGELOG.md` in this repo before committing (idempotent; headings demoted so
  version headers stay at `##`, which HA's update dialog matches on).
- `github-release` consumes the same artifact instead of regenerating the notes.

### 2. Frame sharing (backend)

- `backend/app/ha/` — new module:
  - `discovery.py`: pure topic/payload builders — per-frame MQTT discovery device
    (image entity fed by retained PNGs, status/scene/last-seen sensors), hub device with
    frame-count sensor (names in attributes), removal payloads, HA event payloads.
  - `client.py`: Supervisor Core API / URL+token resolution, Mosquitto service discovery
    via `http://supervisor/services/mqtt`, HA event-bus firing.
  - `sync.py`: the sync service. Subscribes to Redis `broadcast_channel` (reacts to
    `new_frame`/`update_frame`/`delete_frame`/`new_log`/`new_scene_image`/`frame_rendered`)
    and the new `ha_sync` control channel (`settings_changed`, `sync_now`). Archived frames
    are excluded and removed on archive/delete. Log events (except `log`/`debug`/`metrics`)
    are forwarded to the HA event bus as `frameos_event` and to
    `frameos/frame/<pid>/<fid>/event`. LWT availability on `frameos/status`.
- Runs as a singleton task in the arq worker (`backend/app/tasks/worker.py` startup hook) —
  the add-on runs two uvicorns but only one worker.
- `backend/app/api/settings.py`: `POST /settings` publishes `settings_changed` when the
  `homeAssistant` key changes; new `POST /settings/home_assistant/sync` endpoint for the
  UI button.
- `backend/app/models/frame.py`: `get_frame_json` now strips sync internals (MQTT
  credentials, flags) from the `homeAssistant` settings sent to frames — devices only get
  `url` + `accessToken`.
- New dependency: `aiomqtt` (requirements.in/.txt).

### 3. Frame sharing (frontend)

- Settings → Home Assistant section: "Share frames with Home Assistant" toggle,
  "Save & sync now" button, and (for non-add-on installs) MQTT broker fields. In add-on
  (ingress) mode the broker and connection are auto-discovered and the UI says so.
- `settingsLogic.tsx`: `syncHomeAssistant` action (saves the section, then requests a sync).
- `types.tsx`: `homeAssistant` settings type extended.

### 4. Tests

- `backend/app/ha/tests/test_discovery.py` — payload builders.
- `backend/app/ha/tests/test_sync.py` — full sync, archived exclusion, archive/delete
  removal, disabled-project filtering, event forwarding (MQTT + REST), noisy-event
  filtering, scene-change state refresh, image publish + throttle.
- `backend/app/api/tests/test_settings.py` — settings-change notification, sync endpoint.
- `backend/app/models/tests/test_frame.py` — homeAssistant filtering in `get_frame_json`.
- Verified end-to-end against a real Mosquitto broker (Docker) and real Redis: discovery,
  state, retained image, live `process_log` event forwarding, archive removal.

## Done in this repo

- `frameos/CHANGELOG.md` — backfilled from all GitHub releases; workflow keeps it current.
- `frameos/config.yaml` — `homeassistant_api: true` + `services: [mqtt:want]`.
- `frameos/DOCS.md`, READMEs — integration documentation.

## Still open

- Release a new FrameOS version so the add-on ships the integration (the changelog job
  takes effect on the next release).
- Optional: `event` entities per frame via MQTT discovery (currently events are on the HA
  bus + raw MQTT topics; HA `event` entities need a fixed `event_types` list, which frames
  don't have).
- Optional: HA `image` entity publishes the full-size render; if broker payload size ever
  becomes a concern, switch to the stored JPEG thumbnails.
