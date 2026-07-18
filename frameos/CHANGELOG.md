# Changelog

Release notes for the FrameOS Home Assistant add-on. Each add-on version ships the matching [FrameOS release](https://github.com/FrameOS/frameos/releases).

## 2026.7.6 (2026-07-18)

### New features
- Waveshare 13.3" E (`EPD_13in3e`) now uses hardware SPI on devices when available, with a software SPI fallback if SPI cannot be opened.
- Deployment planning now treats Waveshare `EPD_13in3e` as a boot-configured SPI device in both backend driver setup and the UI’s deploy driver inference.

### Bug fixes
- Fixed `EPD_13in3e` boot configuration so SPI0 is enabled without kernel chip selects, while GPIO 7 and 8 remain available for the driver’s manual chip-select handling.
- Fixed WebAssembly runtime builds to build QuickJS from source when the `quickjs/` directory contains a prebuilt copy.

### Maintenance
- Moved npm package publishing into a dedicated workflow using trusted publishing, with support for manually rerunning publishes without bumping versions.
- Updated driver setup tests to cover the new Waveshare `EPD_13in3e` SPI boot configuration behavior.

## 2026.7.5 (2026-07-15)

### New features
- Added an embeddable scene editor and live scene preview bundle, so FrameOS editing and WebAssembly previews can be embedded outside the main FrameOS UI.
- Added published WebAssembly/runtime packages for browser-based FrameOS previews and embedded editor integrations.
- Expanded JavaScript app runtime APIs with bounded HTTP requests, text/JSON fetch helpers, scoped settings access, asset file operations, asset image loading, and chunked stream support for larger workflows.

### Bug fixes
- Fixed Home Assistant MQTT sync in Docker deployments by including the required MQTT client dependency in the runtime image.
- Fixed stale embedded firmware and OTA downloads by marking firmware responses as `no-store` and adding checksum-based download URLs.
- Improved embedded/ESP32 runtime stability by avoiding large cached image buffers on-device and rendering error images in-place where needed.
- Fixed several image/data apps so download and service errors render at the correct frame size instead of producing incorrectly sized error images.
- Fixed gallery image downloads to show a FrameOS error image instead of failing the render when the download fails.
- Fixed SVG render failures on embedded devices so errors are drawn safely into the current render buffer.
- Fixed JavaScript/TypeScript transpilation regressions where object keys and values after template literal interpolations or comparisons could be stripped incorrectly.
- Improved ESP32 OTA handling so devices acknowledge OTA requests before the scheduled reboot.

### Maintenance
- Added automated builds for the browser preview/editor packages as part of the release pipeline.
- Updated the Docker build to install and build the new WebAssembly and editor package workspaces.
- Added and expanded tests for embedded firmware APIs, OTA downloads, embedded image URLs, JavaScript runtime HTTP/assets/streams, and transpiler regressions.
- Added generated built-in app metadata and smoke testing for the embedded editor bundle.

## 2026.7.4 (2026-07-08)

### New features
- Home Assistant “Save & sync now” now returns real sync feedback, including how many frames were shared, which MQTT broker was used, warnings, and actionable error messages.
- Home Assistant MQTT host is now optional for standalone setups: when MQTT credentials are provided without a host, FrameOS defaults to the Home Assistant URL hostname, falling back to `homeassistant.local`.
- Home Assistant sync can now warn when frame events are reaching the Home Assistant event bus but no MQTT broker is configured, instead of treating that case as a full failure.

### Bug fixes
- Fixed the in-browser live preview in production builds by serving the `frameos-wasm` bundle from the backend.
- Fixed live preview loading when FrameOS is accessed through Home Assistant ingress by resolving the WASM worker URL through the configured asset/base path.

### Maintenance
- Added backend tests for Home Assistant MQTT host resolution, sync request replies, missing-broker warnings, sync failures, and shared-frame reporting.
- Updated settings UI visual snapshots after the Home Assistant settings changes.
- Improved toast/working-message handling so longer success, warning, and error messages stay visible long enough to read.

## 2026.7.3 (2026-07-08)

### New features
- Added a live browser preview for interpreted scenes, powered by a WebAssembly build of the FrameOS runtime and available from the scene UI.
- Added backend/API support for live previews, including frame-specific preview settings and a guarded server-side fetch proxy for scene data apps that need device-like HTTP access.
- Added Home Assistant sharing: FrameOS can publish non-archived frames via MQTT discovery with image, status, scene, and last-seen entities, plus a summary frame-count sensor.
- Added Home Assistant event forwarding for meaningful frame events to the Home Assistant event bus and per-frame MQTT event topics.
- Added Home Assistant settings support, including a backend endpoint to trigger an immediate sync when sharing is enabled.
- System scene templates now include stable template IDs and versions so installed scenes can track their source and detect template updates.

### Bug fixes
- Home Assistant MQTT credentials and sync-only settings are no longer included in the frame configuration sent to devices; frame apps only receive the Home Assistant URL and access token when required.
- Apps that are unavailable on embedded targets are now also blocked from the WebAssembly live-preview target, with clearer “not available on this build target” errors.
- The live-preview HTTP proxy now rejects loopback, private, link-local, multicast, reserved, and unspecified hosts to reduce the risk of using the backend as an internal network probe.

### Maintenance
- Added a WebAssembly build pipeline for the FrameOS interpreted-scene runtime and includes the generated preview bundle in the frontend build.
- Added an MQTT client dependency for the Home Assistant sync service.
- Added backend tests for Home Assistant discovery payloads, sync behavior, settings notifications, template metadata, and Home Assistant setting filtering.
- Updated visual snapshots for the scene, workspace, and settings UI changes.
- Updated Docker build steps and release/deployment automation to build the new frontend/runtime assets and publish add-on metadata.

## 2026.7.2 (2026-07-06)

### New features
- Added a new Weather sample template with bundled scenes for current conditions, hourly charts, daily forecasts, stacked layouts, and icon sheets.
- Added new JavaScript weather apps: Weather icon set, Weather icon, and Weather panel for building weather-focused scenes from Open-Meteo data.
- Improved the Weather data app with a proper date field, configurable forecast days from 1–16, and automatic use of the frame timezone.
- Added support for JavaScript scene apps in compiled scenes through a new runtime import path.
- Added a two-step system template API: repository listings now include `scenesUrl`, and scene JSON is fetched separately when needed.
- Added date input rendering in the frame runtime control page.

### Bug fixes
- Fixed frame settings comparisons so numeric fields edited in the UI no longer appear as unsaved changes after saving.
- Fixed tooltip positioning so large popovers, including JSON output examples, stay within the viewport.
- Fixed a runtime/device crash risk in JavaScript app support when Nim stack traces are enabled.
- Fixed AI scene features on installs where analytics is not configured.
- Improved JSON viewer loading compatibility in the UI debug panel and node output tooltips.

### Maintenance
- Added backend and frame runtime tests for the new system template `scenes.json` endpoints and access control.
- Added visual and generated-scene coverage for the new weather scenes.
- Added frontend visual tests for tooltip behavior, diagram node width, and responsive workspace layouts.
- Refactored shared JSON viewer loading into a frontend utility.
- Updated visual snapshots for workspace, frame overview, scenes, and apps drawer UI changes.

## 2026.7.1 (2026-07-03)

### New features
- No notable changes were found for this category.

### Bug fixes
- Deployment/backend: Asset folder setup is now best-effort, so deploys no longer fail when an assets partition rejects `chown`/`chmod`, such as `vfat`, `exfat`, or `msdos` filesystems.
- Deployment/backend: FrameOS now attempts to remount a read-only assets partition as read-write before preparing asset folders, and skips font sync with a warning if the assets path is still not writable.
- Deployment/backend: Asset paths with spaces are now safely quoted during remote setup.
- Runtime/device: Images decoded directly into a target now respect the frame scaling mode (`cover`, `contain`, or `stretch`) on embedded builds, preserving the intended aspect behavior.
- Runtime/device: Host-side data-URL image downloads with a target now keep their native size so later placement can crop or fit them correctly.
- Runtime/device: FrameOS Gallery downloads now pass the frame’s scaling mode through to image decoding.

### Maintenance
- Added backend tests for asset folder setup, writable detection, font sync skipping, and path quoting.
- Added runtime tests for image download target behavior, data-URL fitting, scaling-mode mapping, and gallery download parameters.

## 2026.7.0 (2026-07-02)

### New features
- Added new data apps for Google Photos shared albums and Immich photo libraries, including sample scenes.
- Added a new Chart render app, with a sample scene for displaying charts on frames.
- Added a new Zoom/Pan render app for Ken Burns-style image movement, with a sample slideshow scene.
- Added conditional `showIf` field support in scene/app configuration, including a UI editor for defining when fields are shown.
- Downloaded image metadata can now include parsed JPEG EXIF details and a one-line EXIF summary for use in scene state.
- Embedded frames can now receive Immich settings through the embedded settings API.

### Bug fixes
- Embedded boot logs no longer overwrite a configured hostname such as `frame.local` with the device’s current IP address; IP-based frame hosts still update when the IP changes.
- Reduced noisy reboot markers in metrics so routine log activity is less likely to appear as device reboots.
- Improved memory-bounded image decoding for large images and screenshots, helping reduce render failures on memory-constrained devices.
- Fixed the Nim runtime build flag so Linux/Raspberry Pi renders use the intended malloc behavior and can reclaim render memory more reliably.
- Improved ESP32 fast-deploy error reporting by including device status context such as firmware version, storage, memory, and loaded scene counts when uploads fail.
- Improved ESP32 image handling so Wikimedia Commons images preserve aspect ratio before render placement.

### Maintenance
- Updated ESP32 firmware build configuration and compatibility checks, including flash/PSRAM layout reporting and additional SDK configuration defaults.
- Added tests for the new Google Photos, Immich, Chart, and Zoom/Pan apps.
- Added test coverage for EXIF parsing, conditional field visibility, interpreter cache behavior, and ESP32-compatible sample scenes.
- Updated frontend visual snapshots for settings, scene editing, app drawer, and workspace changes.
- Added build tooling support for using a local Pixie checkout during development.

## 2026.6.30 (2026-07-01)

### New features
- Added a selectable **Waveshare 7.3" RPi Zero PhotoPainter** frame profile in the UI and device catalog, using the Waveshare `EPD_7in3e` driver with 800x480 dimensions.
- Backend/API device defaults now include PhotoPainter GPIO pin mappings and known GPIO button defaults for supported devices, reducing manual frame configuration.
- Runtime setup and driver selection now recognize the PhotoPainter device profile and load the matching Waveshare driver.

### Bug fixes
- Corrected the embedded Waveshare ESP32-S3 ePaper 13.3E6 display and SD-card GPIO defaults so firmware builds use the vendor pinout.
- Fixed generated/shared driver context handling so display pin overrides are passed through to device drivers.
- Runtime config now accepts both `sclk` and `sck` pin names for SPI clock overrides.
- Switching away from the PhotoPainter profile now removes profile-only pin defaults while preserving explicit custom overrides.

### Maintenance
- Added and updated tests for PhotoPainter profiles, device defaults, embedded presets, driver generation, frame API behavior, and setup scripts.
- Updated release-driver generation to map custom Waveshare device IDs to their underlying driver variants.
- Updated release metadata for FrameOS 2026.6.30.

## 2026.6.29 (2026-06-30)

### New features
- Scene editor now supports creating and editing custom events, including typed payload fields, directly from the Events panel.
- Custom events are now included in scene sync/deploy comparisons, so backend and frame-side scene differences report changes to custom event definitions.
- Scene code generation now uses custom event schemas when dispatching events, preserving configured payload field types.
- Runtime diagnostics now carry the original diagram node ID for JavaScript errors, helping the UI point operators to the node that caused the failure.
- ESP32 embedded frames using the Waveshare ESP32-S3 PhotoPainter preset now get the correct 7.3" e-paper device, GPIO buttons for BOOT and KEY1, and PhotoPainter-specific display power handling.

### Bug fixes
- Event nodes now filter incoming payloads by their configured fields for interpreted scenes, not only by legacy button labels.
- Compiled scene event listeners now generate payload filters from event node configuration, improving consistency with interpreted scenes.
- Frame sync diffs now account for custom event definitions instead of ignoring them.
- Backend frame request forwarding for JSON requests now uses the bounded frame HTTP path, keeping response handling consistent with other frame API calls.
- Embedded error rendering no longer depends on font rendering on ESP32; devices now show a simple visible error marker instead.
- Waveshare 7.3" e-paper handling now includes safer reset timing, bounded BUSY waits, and faster bulk framebuffer transfer to avoid stuck or slow refreshes.
- Linux framebuffer rendering now reuses its render buffer between frames, reducing allocation pressure during repeated renders.

### Maintenance
- Updated ESP32 firmware build metadata and partition layout handling, including 16MB/32MB OTA layout coverage in tests.
- Added tests for custom event code generation, event payload filtering, runtime error node mapping, frame sync behavior, embedded firmware defaults, and setup script behavior.
- Refactored scene field editing UI into a reusable field definition form.
- Updated ESP32 documentation, SDK defaults, and display component wiring for the new PhotoPainter support.
- The setup/bootstrap scripts now explicitly require `awk` before continuing.

## 2026.6.28 (2026-06-29)

### New features
- Added on-frame upgrade support: FrameOS now includes an `upgrade` command, and the frame settings UI exposes admin upgrade controls with dry-run support.
- Added on-frame admin template/repository support so frame-admin can serve bundled scene templates and repository data directly from the device.
- Added backend/API sync hints on frame list and detail responses, helping the UI show whether a frame has changes that differ from the last deployed revision.
- Added runtime commands for display-driver setup and setup reboots, including `driver-setup` and `--reboot-if-required`.

### Bug fixes
- Fixed Buildroot first-boot setup so the setup hotspot and FrameOS service start reliably on release images without preconfigured Wi-Fi credentials.
- Fixed Buildroot NetworkManager connection handling by using the correct secure permissions and persistent state-backed connection storage.
- Fixed remote frame HTTP responses containing non-ASCII text by decoding remote text as UTF-8.
- Fixed the Waveshare 12.48" B V2 driver binding to compile the correct C source file.
- Fixed snapshot/preview-related UI regressions covered by updated visual snapshots.

### Maintenance
- Expanded Buildroot image tooling and tests for service setup, persistent NetworkManager paths, image composition tools, and release image behavior.
- Updated generated driver registries to expose available driver names for runtime/admin use.
- Improved deployment source packaging to include shared frontend public assets and bundled scene repository files.
- Updated asset preparation to track bundled repository scenes and regenerate embedded asset modules when they change.
- Added and updated backend, runtime, and frontend tests for frame sync hints, remote HTTP handling, upgrades, setup behavior, driver generation, and visual UI coverage.

## 2026.6.27 (2026-06-28)

### New features
- Added standalone frame admin/API support, including authenticated local frame access and backend sync flows for comparing and applying `frame.json` and `scenes.json` changes.
- Added ESP32 flash-size profiles for embedded frames, including 4MB no-OTA builds and larger OTA-capable layouts for 8MB/16MB/32MB devices.
- Added embedded hardware presets for Waveshare ESP32-S3 PhotoPainter and ESP32-S3 ePaper 13.3E6 boards, including matching display, PSRAM, flash, GPIO, and SD-card asset settings.
- Added SD-card asset mounting for ESP32 firmware so compatible embedded frames can serve assets from `/srv/assets`.
- Added USB-focused embedded deployment support in the UI and backend, including USB logs, local deploy actions, and deploy-completion tracking.
- Added default backend host/port settings and frontend helpers to make local/standalone frame setup easier.
- Added template favourites in user settings so preferred scene templates can be saved.
- Added bundled Noto Color Emoji font assets for improved emoji rendering on deployed frames.
- Increased Buildroot SD image asset partition sizing so deployments with more local assets/fonts have more room.

### Bug fixes
- Fixed 13.3" Waveshare rendering timing by increasing the driver timeout for long refresh operations.
- Fixed embedded 4MB firmware builds so OTA manifest/download endpoints are not offered when the firmware layout does not support OTA.
- Fixed generated frame configuration to include the configured refresh interval, ensuring runtimes receive the frame’s intended update cadence.
- Fixed embedded boot handling so successful boots record last-boot metadata and only mark generated firmware as deployed after the matching firmware has actually booted.
- Fixed Buildroot SD image composition so the assets partition is sized from the staged asset contents instead of remaining fixed.
- Fixed frame activity timestamps to use the latest relevant activity log entry more consistently.

### Maintenance
- Expanded backend, embedded firmware, runtime, and frontend tests for standalone admin sync, embedded flash layouts, USB deploy completion, settings, logs, and frame HTTP behavior.
- Updated ESP32 firmware build scripts, partition tables, and SDK defaults for the new flash-size profiles.
- Updated frontend visual snapshots for settings, logs, schedule, and workspace UI changes.
- Added API documentation for the standalone/admin sync work.
- Updated Buildroot image metadata and customization tracking for the new asset partition layout.

## 2026.6.26 (2026-06-27)

### New features
- Added a split-screen scene builder in the workspace UI, with layout presets, drag-and-drop scene assignment, adjustable split ratios, borders, backgrounds, per-scene state fields, and generated preview thumbnails.
- Scene tiles in the workspace can now be dragged into split-screen layouts.
- Split-screen layout metadata is saved with scenes so existing split-screen scenes can be reopened and edited.
- Added a back button from the AI chat drawer to the Add scene drawer when chat is opened from the scene/template flow.

### Bug fixes
- Backend/API: frame preview images reported as `uploaded/<scene-id>` are now stored under the original configured scene ID when appropriate, preventing duplicate or missing scene thumbnails for uploaded previews.
- UI: scene previews now include referenced scenes from scene nodes and `setCurrentScene` dispatch nodes, improving previews for composed or linked scenes.

### Maintenance
- Added backend tests for uploaded scene preview image caching behavior.
- Updated frontend visual snapshots for the scene and workspace UI changes.
- Updated frontend development tooling, including TypeScript and kea-typegen.
- Added a package manager peer dependency extension for kea-forms.

## 2026.6.25 (2026-06-26)

### New features
- No notable changes were found for this category.

### Bug fixes
- Fixed runtime/device memory retention when rendering images by clearing transient image inputs after each render and reclaiming render memory after framebuffer updates.
- Fixed remote deployment reconnect handling so commands already sent to a disconnected Remote websocket fail promptly instead of hanging until timeout.
- Fixed backend frame update broadcasts to refresh from the committed database state before publishing, preserving Remote agent version and capability updates made by concurrent connections.
- Improved deployment handling for read-only root filesystems by adding timeouts and warning logs when remounting back to read-only fails, avoiding stuck deploy cleanup steps.

### Maintenance
- Synced bundled timezone data.
- Added backend and runtime tests for Remote websocket disconnect handling, frame update publishing, and render image memory cleanup.

## 2026.6.24 (2026-06-25)

### New features
- The Metrics view now includes reboot details alongside metric history, backed by runtime reboot-reason tracking on devices.
- Deploy plans can now detect when FrameOS Remote is out of date and include a remote upgrade step in the deployment workflow.
- Frame bootstrap now installs and starts `frameos-remote.service`, including cleanup for legacy FrameOS agent services.

### Bug fixes
- Fixed Buildroot precompiled SD image customization in Home Assistant ingress installs so it does not incorrectly select a configured build host.
- First-boot setup now runs before `frameos-remote.service`, preventing the remote service from starting with stale setup state.
- Remote restart/deploy commands now clean up legacy agent services and paths to avoid duplicate old/new background services.

### Maintenance
- Renamed the device-side “agent” implementation to “FrameOS Remote” across backend tasks, WebSocket routes, runtime service files, Docker builds, and frontend labels.
- Refreshed cross-toolchain image digests and Buildroot release-image metadata.
- Expanded backend, runtime, deployment, Buildroot, WebSocket, and frontend visual test coverage for the remote rename and deployment changes.

## 2026.6.23 (2026-06-24)

### New features
- No notable changes were found for this category.

### Bug fixes
- Home Assistant add-on deployments now default to no local build environment instead of assuming Docker is available.
- Backend/API: Buildroot SD image generation now shows Home Assistant-specific guidance when compilation requires a build host or Modal sandbox.
- Runtime/device: the framebuffer driver now handles invalid framebuffer metadata that can cause division-by-zero errors, falling back to configured screen dimensions instead of failing initialization.

### Maintenance
- Added backend tests for Home Assistant build environment defaults and Buildroot SD image error messaging.
- Updated release metadata for FrameOS 2026.6.23.

## 2026.6.22 (2026-06-24)

### New features
- Added partial refresh support for Waveshare `EPD_7in5_V2` and `EPD_13in3b` displays, including runtime tracking of changed regions and automatic fallbacks to full refreshes.
- Added UI settings for supported Waveshare partial refresh displays, including maximum partial-refresh area and the number of partial refreshes before a full refresh.
- The backend/API now preserves device configuration when creating a new frame, so partial refresh settings can be applied during frame setup.
- Waveshare drivers now advertise display on/off support to FrameOS.

### Bug fixes
- Fixed framebuffer deployments so `getty@tty1` is only restarted after FrameOS has actually stopped, avoiding console/service conflicts during restarts.
- Added a restart delay to generated `frameos.service` units to avoid rapid restart loops.
- Improved Waveshare environment detection on devices running FrameOS/Buildroot and Raspberry Pi systems detected via device tree.
- Improved Waveshare `EPD_7in5_V2` initialization and partial-refresh routines.
- Fixed partial-refresh base restoration for Waveshare `EPD_13in3b` so partial updates can resume correctly after sleep.

### Maintenance
- Added backend and runtime tests for partial refresh device configuration and generated Waveshare driver hooks.
- Updated frontend visual snapshots for the workspace UI.
- Updated generated driver context plumbing so partial refresh settings are available to compiled/shared drivers.
- Updated setup scripts, service templates, and Buildroot image metadata.

## 2026.6.21 (2026-06-21)

### New features

- Framebuffer-based frames now claim `/dev/tty1` for FrameOS, stop the competing `getty@tty1` service, and run the framebuffer in graphics mode for cleaner full-screen output.
- Standalone setup, backend bootstrap scripts, and generated systemd service files now include framebuffer-specific TTY settings automatically when the frame device is `framebuffer`.
- Bundled timezone data was refreshed from the FrameOS timezone distribution.

### Bug fixes

- Framebuffer devices now restore terminal echo and text mode when FrameOS exits or receives termination signals, reducing the chance of leaving the console in a broken state.
- The evdev input driver no longer fails the runtime when no `/dev/input/event*` devices are available; it logs the condition and stops the input driver cleanly.
- Low-memory remote deploys now stop FrameOS with `systemctl stop frameos.service`, improving service handling during on-device builds.
- Timezone update logs now display ETags without surrounding HTTP quote characters.
- Buildroot image installs now preserve the staged FrameOS service configuration, including runtime environment paths, without mirroring service logs to the framebuffer console.

### Maintenance

- Added automation for building and publishing Buildroot base images.
- Docker CI now builds the runtime image and ESP32 firmware/QEMU image in separate jobs, with a dedicated ESP32 CI Docker target.
- Timezone sync automation now imports prebuilt distribution artifacts from the timezone repository and validates them before updating FrameOS assets.
- Added tests for framebuffer TTY service generation, setup user detection, agent-run setup detection, timezone ETag formatting, Buildroot overlays, and deploy workflow behavior.

## 2026.6.20 (2026-06-17)

### New features
- No notable changes were found for this category.

### Bug fixes
- Fixed agent-based deployments so the systemd service install runs outside the current agent sandbox, allowing `/etc/systemd/system/frameos_agent.service` to be copied, owned by root, and permissioned correctly before restart.

### Maintenance
- Added backend deployment tests covering agent-transport service installation through `systemd-run`.

## 2026.6.19 (2026-06-17)

### New features
- No notable changes were found for this category.

### Bug fixes
- Fixed agent deployment on read-only Buildroot hosts by remounting the root filesystem read-write before staging agent files, not only during service installation.
- Ensured old agent build cleanup runs before remounting read-only roots back to read-only, preventing cleanup failures on affected devices.

### Maintenance
- Added deployment flow test coverage for read-only root handling during agent staging, service setup, release verification, and cleanup.

## 2026.6.18 (2026-06-15)

### New features
- Added an `embedded` frame mode for ESP32-S3 devices, including backend/API support for firmware builds, downloads, OTA status, and per-frame embedded configuration.
- Added ESP32 device-facing endpoints for authenticated scene polling, service settings, OTA manifests/downloads, and diagnostic bitmap rendering.
- Added an ESP32 embedded runtime with Wi-Fi, OTA, buttons, battery/status handling, scene loading, QuickJS/Nim execution, and Waveshare e-paper display support.
- Added a web-based embedded flasher UI and updated frame creation/settings flows to support ESP32 embedded frames.
- Added support for serving embedded scene updates with ETags so devices can poll without downloading unchanged scene data.
- Added embedded firmware defaults for HTTPS proxying, device pins, maximum HTTP response size, and supported panel selection.
- Added Waveshare 13.3" Spectra 6 (`EPD_13in3e`) driver support.

### Bug fixes
- Fixed frame image previews fetched as BMPs by converting them to PNG before returning and caching them in the backend/API.
- Fixed embedded frame boot reporting so valid ESP32 boot IPs can update the frame host automatically.
- Fixed embedded boot metadata handling so width and height can be populated from device boot logs when not explicitly configured.
- Fixed HTTPS proxy port normalization to fall back to a valid default when invalid values are stored.
- Fixed Waveshare `EPD_13in3k` color classification from black-only to four-gray.
- Fixed Buildroot image services so FrameOS logs are not mirrored over the framebuffer display console.

### Maintenance
- Added ESP32 firmware build tasks, artifact handling, configuration hashing, OTA request tracking, and extensive backend tests.
- Added Docker image support for the ESP-IDF toolchain and ESP32 firmware build dependencies.
- Added CI coverage for ESP32 firmware builds, QEMU boot checks, and embedded Nim compilation.
- Added embedded app registry guards for apps that require host-only runtime features.
- Updated frontend visual regression snapshots for the new frame/workspace/settings UI.
- Refactored frame workspace/editor logic and removed the older panel container/panel registry components.

## 2026.6.17 (2026-06-11)

### New features
- No notable changes were found for this category.

### Bug fixes
- Backend/API log ingestion now commits each device log before publishing live updates, preventing SQLite write-lock starvation and “database is locked” storms during large batched log uploads.
- Backend log and metrics retention pruning now uses bulk deletes, reducing long write transactions when old per-frame records are trimmed.
- Settings UI now shows the actual FrameOS release version instead of a component version that may not change on every release.

### Maintenance
- Release automation no longer forces agent component version bumps when agent sources have not changed.
- Added a regression test to ensure log writes are committed before live log publishing.

## 2026.6.16 (2026-06-11)

### New features
- No notable changes were found for this category.

### Bug fixes
- Fixed backend database concurrency issues when using SQLite by enabling WAL mode, setting a 30-second busy timeout, and allowing SQLite connections to wait for write locks instead of failing immediately.

### Maintenance
- Updated release metadata for FrameOS 2026.6.16.

## 2026.6.15 (2026-06-11)

### New features
- Added a UI action to cancel an in-progress deploy from frame action menus and the deploy drawer.
- Added a backend/API cancel deploy endpoint that aborts the active deploy job, clears the per-frame deploy lock, and resets a stuck `deploying` status.
- Added a forced deploy option in the backend/API so operators can clear an existing deploy before starting a new one.
- Enabled agent deployment and agent-based deploy controls for Buildroot frames where an agent is configured.

### Bug fixes
- Fixed Buildroot agent updates by temporarily remounting the root filesystem read-write while installing or enabling agent service files, then remounting it read-only again.
- Fixed agent-driven setup runs so disruptive live hardening steps are deferred instead of interrupting the active agent connection.
- Improved deploy job tracking so completed or failed jobs only clear their own active deploy registration, avoiding races with newer deploys.

### Maintenance
- Added backend/API and task tests for cancelling deploys, forced deploys, deploy lock cleanup, and active deploy job tracking.
- Added runtime setup tests for detecting agent-managed setup processes and deferring live hardening changes.
- Added agent deployment test coverage for Buildroot-style read-only root remount handling.

## 2026.6.14 (2026-06-11)

### New features
- Runtime/device services now use systemd watchdog heartbeats and memory limits so FrameOS can restart automatically if the runner stalls or leaks memory.
- Backend/API log fetching now supports incremental log loading, letting the UI request only new log lines after the last seen log ID.
- Deployment now uses a per-frame deploy lock to prevent two deploy jobs from racing against the same device.
- Buildroot frames can resolve to precompiled Debian Bookworm ARM64 artifacts where applicable, reducing the need for a configured build environment.
- Home Assistant ingress can derive the frontend ingress path from the `x-ingress-path` header when available.

### Bug fixes
- Fixed unsafe asset path validation in the frame asset API so paths that merely share a prefix with the assets directory cannot escape it.
- Added a hard decompressed-size limit for gzipped request bodies to protect log ingestion and other APIs from oversized gzip payloads.
- Fixed generated Nim string/comment escaping for scene values containing backslashes, carriage returns, or newlines, avoiding deploy compile failures from malformed generated source.
- Improved frame image placeholder/error rendering so CPU-bound image generation no longer blocks the backend event loop.
- Fixed deploy job failure reporting so failed full and fast deploys are recorded as failed jobs instead of silently completing after logging an error.
- Improved log and metrics retention performance with indexed frame/timestamp queries, batched log commits, and less frequent prune checks.
- Fixed worker database session handling so concurrent background jobs no longer share one SQLAlchemy session.
- Fixed Redis lifecycle handling by reusing a shared Redis client per event loop and closing it cleanly on shutdown.
- Improved cross-compilation/build packaging for Waveshare drivers by copying external C sources and local headers referenced by Nim compile pragmas.
- Improved runtime/device resilience across setup, proxying, HTTP requests, process handling, logging, scheduling, and several display/input drivers.

### Maintenance
- Added database migrations for log and metrics frame/timestamp indexes.
- Added and expanded backend tests for frame logs, deploy workflow planning, cross-compile target resolution, deploy locking support, and driver build source staging.
- Added runtime tests for HTTP client and process helpers, and expanded setup/channel/portal coverage.
- Updated Buildroot image metadata used by deployment tooling.
- Bumped the release to FrameOS 2026.6.14.

## 2026.6.13 (2026-06-10)

### New features

- Backend database support was added for cloud auth identities, backend links, and synced cloud memberships.
- Buildroot images now include cron support via `dcron` and enable time synchronization with `systemd-timesyncd`.

### Bug fixes

- Runtime/device: the framebuffer driver now respects framebuffer row stride padding, improving rendering on devices where `/dev/fb0` line length is larger than the visible pixel width.
- Runtime/device: framebuffer rendering now scales images to the detected screen resolution when the rendered image size does not match the framebuffer size.
- Runtime/device: framebuffer rendering now rejects unsupported bit depths instead of attempting invalid writes.
- Backend/API: frame bootup logs no longer overwrite an explicitly configured frame width or height with autodetected device dimensions.
- Deployment: regenerated Buildroot base image metadata for Raspberry Pi Zero 2 W to match the updated image layout and service set.

### Maintenance

- UI: clarified the cross-compilation option label to say “Always compile on backend (this server)”.
- Added tests covering bootup resolution preservation and Buildroot image configuration changes.
- Bumped the FrameOS release to 2026.6.13.

## 2026.6.12 (2026-06-10)

### New features
- Buildroot frame creation now supports setting a root SSH password and selecting SSH keys during setup.
- Buildroot first-boot setup can apply `/boot` SSH settings, including root password and authorized keys, before Dropbear starts.
- Connected FrameOS agents now report their agent version to the backend, enabling the UI to show agent upgrade information.
- Frame image cards now include a preview shortcut for opening the frame preview view.
- The deploy plan UI now highlights FrameOS version install/upgrade information when planning deployments.

### Bug fixes
- Buildroot frames now respect an intentionally empty SSH key selection instead of falling back to default keys.
- Buildroot SD card image status is refreshed from the backend while preparing images, so stale, missing, failed, or completed jobs are surfaced instead of leaving the UI waiting indefinitely.
- Queued Buildroot SD image jobs now use a separate queue timeout, reducing false failures while a job is waiting to start.
- First-boot setup now writes the updated `frame.json` to the agent release directory as well as the runtime release directory, keeping the agent configuration in sync after setup.
- Dark mode styling was improved for auth/setup screens, including footer and warning panels.

### Maintenance
- Updated Buildroot SD image customization/bootstrap versions and refreshed the Buildroot image manifest.
- Added tests for Buildroot SSH password/key setup, SD image job status handling, agent version reporting, SSH key selection, setup payload syncing, and agent config loading.
- Refreshed frontend visual snapshots for the updated UI.
- Bumped the release to FrameOS 2026.6.12.

## 2026.6.11 (2026-06-09)

### New features
- No notable changes were found for this category.

### Bug fixes
- Fixed Buildroot first-boot startup so FrameOS systemd services are queued with `systemctl --no-block`, avoiding setup hangs while the first-boot oneshot service is still running.

### Maintenance
- Added a regression test to ensure first-boot service startup remains non-blocking.
- Updated release metadata for FrameOS 2026.6.11.

## 2026.6.10 (2026-06-09)

### New features
- HDMI/framebuffer devices can now detect `/dev/fb0` dimensions during setup and update the frame configuration with the detected width and height.
- The framebuffer driver now exposes a setup step, improving precompiled/shared-driver deployments for HDMI-style displays.

### Bug fixes
- Fixed split/grid rendering when all configured width or height ratios are `0`; FrameOS now falls back to equal cell sizing instead of dividing by zero.
- Buildroot SD image customization now accepts precompiled release images whose FrameOS or ASSETS partitions are larger than the default minimum layout.
- Deployments now continue cleanly when stopping `frameos.service` reports that the service is not loaded, while still stopping any matching FrameOS process.
- The framebuffer runtime now handles missing or unreadable `/dev/fb0` more safely by falling back to configured dimensions instead of failing initialization.

### Maintenance
- Buildroot helper image publishing now targets and validates `linux/amd64`, `linux/arm64/v8`, and `linux/arm/v7`.
- Device setup logging now uses a shared flushed logger for more consistent setup output.
- Added test coverage for framebuffer dimension persistence, shared driver setup logging, Buildroot image composition, deployment service stopping, and split/grid ratio handling.

## 2026.6.9 (2026-06-07)

### New features
- Added build environment selection for FrameOS builds, including local builds, SSH build hosts, Modal sandboxes, and an option to disable server-side builds when using precompiled Buildroot SD images.
- Added backend/API probes for build environments: operators can test an SSH build host for Docker/Buildx support and test Modal sandbox credentials/tooling before starting builds.
- Added Docker availability to the system info API and settings UI so operators can see whether the Docker CLI and daemon are available on the FrameOS server.
- Added support for preparing compatible precompiled Buildroot SD card images without requiring Docker or a configured build executor.
- Added a standalone `scripts/frameos-setup.sh` installer for deployment/setup workflows outside the main application container.
- Added a native FrameOS JavaScript transpiler/runtime path for device builds, replacing the previous bundled frontend transpiler asset.

### Bug fixes
- Buildroot SD image jobs now detect stale queued/running work using heartbeats and can recover instead of leaving frames stuck in a stale build state.
- Buildroot SD image status can still report usable precompiled image state when resolving the Buildroot base image metadata fails.
- Buildroot frame binary builds now disable on-device fallback when composing SD images, avoiding invalid fallback behavior during image generation.
- Removed the external `liblgpio` runtime/build dependency for native GPIO-based drivers, reducing deployment failures on systems where `liblgpio-dev` is unavailable.
- Waveshare build archives now include the required GPIO header when needed, fixing native driver compilation packaging.
- Agent cross-compilation now respects the selected build environment and reports clearer failures when a configured executor cannot support the target architecture.

### Maintenance
- Updated QuickJS to the 2026-06-04 source release across Docker builds, deployment helpers, and test targets.
- Refactored build execution into shared local, SSH build host, and Modal sandbox executors.
- Refreshed cross-toolchain image configuration and CI coverage for cross-compilation workflows.
- Added and expanded tests for build environments, Modal sandboxes, Buildroot SD images, deploy planning, the setup script, native JS transpilation, and GPIO bindings.
- Reduced default Buildroot FrameOS/assets partition sizes and added data partition headroom logic for generated SD images.

## 2026.6.8 (2026-06-04)

### New features

- Added per-frame timezone update settings across the UI, backend/API, and device runtime, including enable/disable, update hour, and update URL.
- Buildroot SD image generation can now customize precompiled full SD images, reducing the need for local FrameOS and agent builds when a matching image is available.
- Buildroot images now include first-boot SD card expansion support, so the device can grow its partitions after being written to a larger card.
- Deploy and fast-deploy tasks can now use stable task IDs, with start, completion, and failure markers in frame logs for better UI progress tracking.
- Frame boot reports now include timezone update configuration, and the backend can learn a frame’s timezone from boot logs when no timezone is already stored.

### Bug fixes

- Frame image previews now return a rendered error PNG when a refresh fails and no cached image is available, instead of returning a JSON error response.
- Explicit timezones are now preserved for Raspberry Pi OS frames instead of being omitted from generated frame configuration.
- Stored timezone handling now accepts safe custom timezone names while still rejecting unsafe paths and malformed values.
- The FrameOS agent now closes its internal HTTP client after proxied HTTP commands, preventing connection/resource leaks.
- RTSP snapshot capture now streams ffmpeg output through a managed process with timeout and output-size limits, improving reliability and cleanup.
- Metrics logging now records a metrics error sample instead of letting a metrics collection exception stop the loop.

### Maintenance

- Added database migration support for the new per-frame timezone updater configuration.
- Added backend tests for timezone handling, deploy task IDs, frame image error responses, Buildroot SD image behavior, and local command logging.
- Added runtime process utility tests and updated metrics/timezone updater tests.
- Updated Buildroot image tooling, manifests, and documentation for the newer SD image customization flow.
- Refined frontend visual snapshots for the updated frame settings, metrics, workspace, and global settings screens.

## 2026.6.7 (2026-06-03)

### New features
- UI: workspace frame cards now show metric alert indicators and fetch lightweight recent metrics previews for faster status checks.
- Backend/API: added `GET /frames/{id}/metrics/recent` with `limit` and `since` filters for efficient recent metric loading.
- Runtime/device: metrics now report CPU core count and include a per-boot runtime ID, helping operators distinguish data across device reboots.
- Runtime/device: FrameOS now starts a timezone updater so configured timezone changes can be applied while the device is running.
- Deployment: release automation now builds a Raspberry Pi Zero 2 W Buildroot SD image artifact, including metadata, for easier first-time installation.

### Bug fixes
- Deployment: fixed Buildroot release image Docker mount handling so release image composition can find downloaded prebuilt artifacts correctly.
- Deployment/runtime: Buildroot devices now prefer the active `/boot/config.txt` when applying boot config changes, avoiding writes to the Raspberry Pi OS firmware config path.
- Deployment: cross-compilation now uses safer Docker base image selection, including canonical Ubuntu codenames, fallback defaults for invalid detected releases, and the correct Buildroot toolchain base.
- Backend/API: metrics are now returned as stored without adding synthetic reboot marker annotations, while preserving runtime boot IDs.
- Runtime/device: Buildroot systemd service setup now supports console logging and can install the packaged service file when present.
- Runtime/device: Buildroot image boot config now reserves less GPU memory by default, returning more RAM to Linux/userland.

### Maintenance
- Added tests for recent metrics, metric boot IDs, Buildroot release image generation, boot config detection, timezone updating, cross-compilation image selection, and deployment planning.
- Updated Buildroot image tooling and documentation for release-image generation.
- Updated visual regression snapshots for the frame debug UI.
- Improved release workflow ordering so multi-arch image publishing waits for Buildroot release image generation.

## 2026.6.6 (2026-06-02)

### New features
- Added the first backend/API foundation for multiple projects: frames, settings, assets, fonts, templates, repositories, chats, logs, metrics, scene images, and AI tools are now scoped to a project.
- Added project listing and lookup APIs, with default project creation for existing single-user installs and Home Assistant ingress installs.
- Updated deployment/bootstrap flows to be project-aware, including generated frame bootstrap URLs and project-scoped frame access.
- Updated the frontend to load project context and route API calls through the selected project.
- Added Home Assistant ingress routing support for project-aware frontend navigation.

### Bug fixes
- Fixed frame workspace actions by moving them into a dedicated actions menu so frame operations remain available and correctly wired from the workspace UI.
- Fixed runtime/device HTTP limit handling across FrameOS HTTP downloads/uploads and data apps, improving reliability for larger images and URL-based assets.
- Fixed project isolation for shared resources so assets, fonts, templates, repositories, chats, scene images, settings, and frame lookups no longer leak across projects.
- Fixed frame image, state, and uploaded-scene cache keys to use frame IDs, reducing collisions between frames with similar network settings.
- Improved AI scene/app chat error handling for missing or inaccessible configured models, returning clearer operator-facing guidance.
- Fixed Home Assistant ingress authentication behavior for project-scoped APIs and websocket access.

### Maintenance
- Added database migrations for organizations, projects, memberships, and project IDs on existing FrameOS data.
- Removed legacy stored AI embedding models/endpoints and replaced scene context building with a catalog-based backend utility.
- Added multitenancy migration and API test coverage across frames, repositories, templates, settings, logs, metrics, and websockets.
- Updated frontend visual snapshots and E2E seed data for the project-aware UI.
- Added explicit Monaco editor worker configuration for the frontend build.
- Updated CI workflows for buildroot/cross-toolchain image publishing and to avoid unnecessary test runs on digest-only updates.

## 2026.6.5 (2026-06-01)

### New features
- Added a per-frame “Maximum HTTP response size for JavaScript apps” setting in Frame Settings, used by `frameos.fetchText` and `frameos.fetchJson` for larger feeds or API responses.
- Exposed the HTTP response size limit through the backend API and device runtime configuration, with a default of 64 MiB.
- Added a “Scene settings” action to the workspace scene dropdown for quicker access to scene configuration.

### Bug fixes
- Fixed rotated frame preview placeholders so “no image” placeholders use the correct rotated dimensions.
- Improved frame image loading so the UI detects initial placeholder images and requests a fresh image once instead of leaving stale “no image” previews visible.
- Avoided unnecessary image refresh work for cache-check `HEAD` requests when no cached image exists.
- Fixed shared compiled scene bundle initialization by setting host callbacks directly, improving reliability for shared-scene deployments.

### Maintenance
- Added a database migration and schema coverage for the new frame HTTP response size limit.
- Expanded backend, runtime, and code generation tests around image placeholders, frame config, server API payloads, and shared scene bundles.
- Updated visual regression snapshots for frame debug and settings screens.
- Updated the bundled app metadata after reordering the “Set as state” app fields.

## 2026.6.4 (2026-06-01)

### New features
- Added a frame-level image engine setting, allowing FrameOS operators to choose Pixie/default rendering or ImageMagick where supported.
- Exposed the configured/effective image engine through frame configuration, device startup logs, and the frame API.
- Added ImageMagick support to Buildroot images and included FFmpeg/FFprobe libraries for richer runtime media handling.
- Increased the Buildroot FrameOS partition default size to 1 GB to allow more room for runtime files and deployments.
- Consolidated the FrameOS setup/deploy flow so setup JSON handling uses the runtime `frameos setup --with-setup` path.

### Bug fixes
- Fixed deploy planning so detected device OS can update the frame deployment mode between Raspberry Pi OS and Buildroot, including resetting the SSH user from `root` back to `pi` when appropriate.
- Fixed Buildroot full deploy planning to avoid Raspberry Pi OS package-install assumptions such as remote `apt` handling.
- Fixed deploy plan previews so mode and SSH user changes discovered during planning are persisted back to the frame when needed.
- Fixed precompiled FrameOS deployments to skip unnecessary local source preparation and modification steps.
- Improved SVG rendering by using the new image decoding fallback path instead of requiring ImageMagick-only SVG rendering.
- Scene generation now fails clearly when a referenced child scene is missing instead of silently logging and stopping generation.

### Maintenance
- Added a database migration for the new `image_engine` frame setting.
- Updated frontend frame settings and deploy-plan UI snapshots for the new deployment and image-engine behavior.
- Expanded backend and runtime tests for deploy planning, Buildroot image configuration, setup handling, frame serialization, and image utilities.
- Updated Nim package dependencies used by the FrameOS runtime and app editing context.
- Refreshed Buildroot image tooling, manifest data, and boot logo assets.

## 2026.6.3 (2026-05-31)

### New features

- Added a Buildroot-based installation path for supported Raspberry Pi targets, including Raspberry Pi Zero 2 W, with backend SD-image generation, network/Wi-Fi defaults, boot logo customization, and UI install/deploy flow support.
- Added a new frame bootstrap flow that generates a `curl | sudo sh` command to install FrameOS and the FrameOS agent as systemd services, with token regeneration and Home Assistant ingress/forwarded URL handling.
- Added per-frame timezone support, including a global default timezone setting and bundled runtime timezone data.
- Added a `shared-scenes` compilation mode for deployments that package compiled scenes as shared libraries.
- Frame creation now fills in known display dimensions for many Pimoroni Inky, HyperPixel, and Waveshare devices.

### Bug fixes

- Fixed timezone alias handling so aliases are preserved alongside canonical timezone data and existing timezone selections are not dropped.
- Fixed release driver setup generation so shared/precompiled driver artifacts include the expected setup helpers.
- Fixed release agent setup generation paths used by deployment tooling.
- Buildroot SD-image deploy state is now updated when a frame reports bootup, so successful deploy tracking reflects the booted image.
- Improved frame state/image refresh coordination to reduce duplicate refreshes and back off after failed state refresh attempts.

### Maintenance

- Added E2E installation coverage, including real Buildroot SD-image and FrameOS runtime tests.
- Split visual regression tests into shards and changed snapshot updates to be collected and committed after shard completion.
- Added workflows and tooling for publishing Buildroot and cross-toolchain container images.
- Added automated timezone data sync and validation.
- Updated Docker runtime dependencies needed for image generation and device deployment tooling.

## 2026.6.2 (2026-05-28)

### New features
- Added configurable frame error behavior in the UI, backend/API, and runtime: operators can choose safe mode, show-error-and-retry, or silent retry modes with retry timing settings.
- Added native Nim driver support for many Pimoroni Inky displays, including Inky Impression, Inky pHAT, and Inky wHAT variants, with PNG rendering support where applicable.
- Added a native `pimoroni.hyperpixel2r_native` driver path using `lgpio`, while keeping existing `pimoroni.hyperpixel2r` configs on the legacy framebuffer-based driver.
- Added deployment/prebuilt target support for Ubuntu 26.04 / resolute.
- Added a shared frame connection status dot component in the UI for clearer frame connectivity indicators.

### Bug fixes
- Fixed Waveshare `EPD_5in83_V2` handling to use the four-gray initialization and display path instead of treating it as black-only.
- Improved Raspberry Pi OS sudo failure guidance during deploys with the exact `raspi-config` menu path for disabling the Admin Password requirement.
- Preserved legacy HyperPixel 2r deployments by separating the old Python/vendor-backed framebuffer driver from the new native driver.
- Normalized and migrated frame error behavior settings, including legacy silent retry window fields, to avoid invalid or missing runtime configuration.

### Maintenance
- Expanded tests for device driver selection, frame error behavior normalization, deploy planning, cross-compilation targets, and release driver generation.
- Updated prebuilt dependency tooling and manifests for `lgpio` and Ubuntu 26.04 targets.
- Updated frontend visual snapshots for the changed frame settings, debug, and workspace UI.
- Added release workflow automation for posting published release notifications.
- Updated bundled Inky Python requirements and related vendor setup tests.

## 2026.6.1 (2026-05-27)

### New features
- Added an agent bootstrap flow: the backend/API and UI can generate a tokenized `curl | sudo sh` command that installs a precompiled FrameOS agent and writes the frame’s agent configuration.
- Added selectable agent task transport for deploy and restart operations (`auto`, `agent`, or `ssh`), allowing agent-managed frames to deploy and restart without relying on SSH.
- Added frame mountpoint configuration for Samba/CIFS shares, with backend storage/API support, deployment planning for `cifs-utils`, and runtime/device support for mounting configured shares.
- Added refreshed FrameOS logo assets and related UI updates across the workspace and frame screens.

### Bug fixes
- Agent deploys are more robust: binaries are uploaded compressed, verified with SHA-256 before activation, staged releases are checked, and deploys wait for the restarted agent to come back.
- Restarting the agent through the agent transport now uses a delayed systemd restart command so the restart can complete without killing the active command connection too early.
- Deployments using the agent transport now skip SSH `authorized_keys` installation and use the current remote user for the runtime service instead of assuming the configured SSH user.
- Agent bootstrap URLs now respect forwarded host/protocol information and ingress paths, improving operation behind proxies and Home Assistant ingress.
- Remote command execution now validates the requested transport and gives clearer failures when agent transport is forced but unavailable.

### Maintenance
- Added database migrations for frame mountpoints and scene execution mode defaults.
- Expanded backend tests for frame APIs, agent bootstrap/deploy/restart flows, remote execution, terminal websockets, and deployment planning.
- Expanded runtime/device tests for configuration, setup, runner loop behavior, server APIs, and web routes.
- Sharded frontend visual regression tests in CI and updated visual snapshots for the UI changes.

## 2026.6.0 (2026-05-27)

### New features
- Major UI redesign with a new FrameOS shell, redesigned login/signup screens, frame home, frame dashboard, and dedicated frame, scene, and app workspaces.
- Added new workspace drawers and indicators for deploy plans, unsaved frame changes, live frame status, and frame change status.
- Added long-running task toasts so deploys, uploads, and other background work can surface progress and results in the UI.
- Added local account management for non-Home Assistant installs, including API and settings support for viewing the current user, changing email, and changing password.
- Added persistent terminal session UI support for frame terminals.
- Added cached backend responses for frame assets and frame state, with cache status metadata returned to the UI.
- Added active scene information to frame API responses for easier dashboard and workspace state display.

### Bug fixes
- Fixed frame “last activity” timestamps so backend connection attempts, SSH noise, and image fetch failures no longer make a frame look recently active.
- Improved scene image serving by adding private cache headers and generating thumbnails only when thumbnail images are requested.
- Fixed Home Assistant ingress path handling by normalizing Supervisor-provided paths and honoring the `x-ingress-path` header when serving the frontend.
- Disabled local account-management endpoints when running under Home Assistant modes, where authentication is handled externally.
- Improved agent deployment and restart logging so missing frames and command failures are recorded in frame logs.
- Fixed the runtime `frameos setup` command to exit successfully after setup completes without requiring a reboot.

### Maintenance
- Added frontend end-to-end and visual regression coverage for the redesigned UI across light/dark themes and multiple viewport sizes.
- Expanded backend tests for account management, ingress behavior, frame activity timestamps, frame asset caching, and log handling.
- Expanded CI to run the new frontend visual regression suite and upload reports.
- Updated release automation and cross-build validation for generated release artifacts.
- Refreshed frontend dependencies and shared UI/theme utilities to support the redesign.

## 2026.5.16 (2026-05-24)

### New features
- Agent deployments can now use the precompiled agent binary from FrameOS release archives on supported targets, reducing the need to compile the agent locally during deployment.
- FrameOS release archives now include the `frameos_agent` binary alongside the FrameOS runtime artifacts.
- The agent `version` command now reports the packaged FrameOS agent version instead of always returning `0.0.0`.

### Bug fixes
- Deploy plan previews and full deploy planning no longer require Nim to be available unless a source build is actually needed.
- Agent deployment no longer requires Nim before the deployer starts, allowing precompiled-agent deployments to proceed on systems without a local Nim installation.
- Agent release builds now quote build paths and version flags correctly, fixing failures when source paths contain spaces.
- Precompiled release extraction now supports the new archive layout while retaining compatibility with the older `prebuilt-cross/<target>` layout.

### Maintenance
- Release artifacts are now packaged under a single top-level archive directory named for the FrameOS version and target.
- Cross-compilation tooling was extended to build and cache agent release artifacts in addition to FrameOS runtime artifacts.
- Added tests for precompiled agent downloads, agent deployment fallback behavior, archive layout handling, and cross-build command generation.

## 2026.5.14 (2026-05-21)

### New features
- Frames can now be archived from FrameOS, with backend/API support for the archived state and archived frames shown at the bottom of the frames list in the UI.
- Deployments now default to precompiled FrameOS mode when eligible, falling back to a single executable when precompiled releases cannot be used.

### Bug fixes
- Docker deployments once again include packaged scene templates, restoring built-in system repository templates in container installs.
- The RTSP Snapshot app now runs `ffmpeg` with safer argument handling, improved timeout/cleanup behavior, output size protection, and debug logs for start/completion details.
- Device log files now use the original log event timestamp for dated filenames and line timestamps instead of the time the logger writes the file.
- Shared/precompiled driver setup now keeps driver libraries loaded after setup, improving reliability for runtime/device driver initialization.

### Maintenance
- Added a database migration for the new frame archived flag.
- Expanded backend, deployment, RTSP Snapshot, logger, and driver code generation test coverage.
- Updated Docker build inputs to include scene templates in both build and runtime images.

## 2026.5.13 (2026-05-20)

### New features
- Metrics now retain more history: the backend keeps up to 11,000 metric samples per frame, and the on-device admin server keeps a larger recent metrics buffer.
- The Metrics panel now includes a time range selector, shows the number of metric points, and adds runtime size metrics with pixel-formatted values.
- Runtime diagnostics are now included in regular device metrics even when debug mode is off, making stalled renders and active scene/node state easier to inspect.

### Bug fixes
- Fixed automatic reboot schedules: hourly reboot options now generate valid cron entries for the selected hour, and legacy saved schedules are normalized during API serialization and deployment.
- Fixed remote build host command output handling so line breaks are preserved, avoiding merged file lists in build/deploy workflows.
- Improved metrics trimming so the backend removes exactly the excess samples when a frame exceeds the retention limit.
- Fixed the Metrics brush chart so custom visible time ranges remain selectable even when they extend beyond the loaded metric range.
- Improved Home Assistant sensor runtime diagnostics handling to avoid recomputing scene/event context during deferred logging.
- Improved UI asset loading for shared logo images in the header, login, and signup screens.

### Maintenance
- Added `ping` to the FrameOS container image for easier network diagnostics from deployments.
- Added and updated backend and runtime tests for reboot cron normalization, metrics retention, runtime diagnostics, build host output handling, and deployment planning.
- Cleaned up diagram zoom labels so app, event, and state node names keep their original capitalization.

## 2026.5.12 (2026-05-18)

### New features
- RTSP Snapshot now has a configurable “FFmpeg timeout in seconds” setting, defaulting to 15 seconds.
- The scene diagram now shows large node labels when zoomed far out, making complex scenes easier to navigate.
- The scene diagram now highlights edges connected to the selected node, making data and execution flow easier to trace.
- Imported or older scenes without saved node positions are now automatically arranged with updated scene graph layout handling.

### Bug fixes
- RTSP Snapshot timeout errors now report the configured timeout duration instead of always showing the default.
- Backend metrics storage now keeps recent metrics entries separately from general logs, so the metrics API returns only stored metrics records more reliably.
- Device log forwarding now preserves log JSON payloads without double-encoding them.
- Frame health/status UI can now treat otherwise “ready” frames with logs older than an hour as stale.

### Maintenance
- Updated tests for RTSP Snapshot timeout handling, log serialization, channel logging, metrics logging, and frame API metrics behavior.
- Refactored runtime logging to use a structured serialized log type across channels, file logging, WebSocket broadcast, and backend upload.
- Updated sample scenes, including the Webcam RTSP sample configuration.
- Simplified the Docker release workflow by removing the separate release test job dependency from artifact builds.

## 2026.5.11 (2026-05-17)

### New features
- Runtime/device metrics now include disk usage totals, used space, available space, percentage, and filesystem details.
- The frame UI now shows disk usage in the Metrics panel, header summaries, and expanded metrics log entries.

### Bug fixes
- Fixed `frameos_agent` startup on older systems where `/boot/firmware` is not present.
- Improved RTSP snapshot handling so `ffmpeg` timeouts and oversized outputs are stopped cleanly and reported with clearer error messages.
- Home Assistant sensor apps now use bounded HTTP fetching with response size and time limits, improving behavior when Home Assistant responses hang or are too large.

### Maintenance
- FrameOS runtime and shared driver/scene library builds now compile with Nim’s `-d:malloc` flag for consistent allocator behavior.
- Added tests for disk usage metrics, RTSP snapshot timeout handling, and FrameOS build flag generation.

## 2026.5.10 (2026-05-17)

### New features
- Added a new Wikimedia Commons data app, including tests and a sample scene/template for pulling images from Wikimedia Commons.
- Added shared compiled scene libraries for shared/precompiled compilation modes, so compiled scenes can be built and deployed as separate `.so` libraries.
- Updated frame compilation settings to use a broader `compilationMode`, covering both driver and scene library behavior.
- Added metadata display support in image-related sample scenes/apps, including URL images, SD card images, Unsplash images, AI-generated images, and Wikimedia Commons images.

### Bug fixes
- Fixed the backend frame image endpoint so it no longer crashes when a frame returns an image without a scene ID header and there is no cached active scene.
- Improved shared-library deployment behavior so compiled driver setup hooks can run from driver libraries in shared/precompiled modes.

### Maintenance
- Added an SSH deployment end-to-end CI job using a disposable Debian SSH target to validate real deploy flows.
- Added deployment E2E documentation and test infrastructure for SSH targets.
- Added tooling and tests for installing prebuilt QuickJS dependencies.
- Expanded backend code generation and deployment tests for shared driver libraries, shared scene libraries, precompiled builds, and cross-build metadata.

## 2026.5.9 (2026-05-08)

### New features
- The Logs panel can now expand metrics entries with “show all”, including nested and array-based metrics with clearer formatting for bytes, percentages, temperatures, and status/error fields.

### Bug fixes
- Hardened runtime/device HTTP downloads across data apps, image loading, URL downloads, weather, BeRecycle, and JS app fetches with response size limits, time limits, HTTP URL validation, and safer connection headers.
- Home Assistant sensor reads now reject oversized or stalled responses, avoid compressed responses, close connections explicitly, and cache very recent data sensor fetches to reduce repeated requests.
- RTSP snapshot capture is now safer and more reliable: ffmpeg uses a temporary output file, has a 15-second timeout, enforces a maximum output size, disables stdin, and cleans up temporary files.

### Maintenance
- Added a shared bounded HTTP client helper used by multiple FrameOS runtime and data app download paths.
- Added Home Assistant sensor test coverage for cached responses.
- Prepared the FrameOS 2026.5.9 release.

## 2026.5.8 (2026-05-08)

### New features
- Runtime/device setup has moved onto the frame: deployments can now use device-side setup steps for SPI, I2C, no-SPI, boot config, and supported display drivers.
- Shared/precompiled display drivers can now provide setup hooks, including Waveshare driver variants.
- The frame logs UI/backend now supports downloading the full persisted log history as a `.log` file.
- Frame runtime diagnostics and command discovery were added so deployments can detect supported runtime commands such as setup/check.

### Bug fixes
- Frame log listing now returns the latest 1,000 logs in chronological order without loading the entire log history first.
- Per-frame log retention was increased to 10,000 logs, reducing premature log pruning for busy frames.
- Waveshare setup handling was corrected for IT8951/EPD_10in3 and no-SPI variants so deployments apply the right boot configuration instead of generic SPI setup.
- Raspberry Pi OS Bullseye targets can now resolve prebuilt dependencies for cross-compilation.
- The lgpio dependency checksum was corrected for source-based installs.
- Frame tasks now reload fresh frame data before deploy, restart, reboot, stop, reset, and agent actions, reducing stale-state issues after settings changes.

### Maintenance
- Added tests for device setup, setup command behavior, deployment planning, driver build modes, log downloads, and cross-compile dependency handling.
- Updated build and cross-toolchain tooling for frame runtime and driver builds.
- Updated default models used by AI-assisted app and scene tooling.
- Improved release/deployment automation, including Home Assistant add-on publishing updates.

## 2026.5.7 (2026-05-05)

### New features
- Added an experimental **Precompiled only** driver build mode in RPi OS frame settings.
- Full deploys can now use a published precompiled FrameOS binary with shared driver libraries when all scenes are interpreted.
- Deploy planning now shows whether a precompiled release will be used, or why it was skipped, in the deploy summary.
- Backend deployment now caches downloaded precompiled FrameOS archives and extracts only the required driver libraries and vendor folders for the frame.

### Bug fixes
- Runtime metrics logging no longer emits an extra “enabled” placeholder event before the first metrics sample.

### Maintenance
- Release publishing now waits for prebuilt cross-compilation artifacts before publishing multi-architecture deployment images.
- Cross-build tooling and tests were updated to support the new precompiled driver build mode.
- Added backend tests for precompiled release download, caching, deploy planning, and driver build mode behavior.

## 2026.5.6 (2026-05-04)

_See the [GitHub release](https://github.com/FrameOS/frameos/releases/tag/v2026.5.6)._

## 2026.5.5 (2026-05-04)

Prebuilt cross artifacts are attached as versioned tar.gz archives.
