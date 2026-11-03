# FrameOS Home Assistant Add-on

FrameOS is a control center for smart e-ink and LCD photo frames. This add-on runs the
FrameOS backend inside Home Assistant, so you can manage your frames from the sidebar.

## Installation

1. Go to **Settings → Add-ons → Add-on Store**, open the **⋮** menu, select
   **Repositories**, and add `https://github.com/FrameOS/frameos-home-assistant-addon`.
2. Install the **FrameOS** add-on and click **Start**.
3. Optionally enable **Start on boot** and **Watchdog**.
4. Click **Open Web UI** to access FrameOS.

## Data persistence

The FrameOS database is stored in `/data/frameos.db` inside the add-on's persistent data
volume, so your frames survive restarts and updates.

## Home Assistant integration

FrameOS can share its frames with Home Assistant, so Home Assistant knows how many frames
you have, what they are called, shows their current images, and lets automations react to
every event your frames emit. Archived frames are not shared.

To enable it, open the FrameOS web UI and go to **Settings → Home Assistant**, then turn
on **Share frames with Home Assistant**. Use **Save & sync now** to push the current state
immediately; after that FrameOS keeps Home Assistant up to date automatically whenever
frames change, render new images, or send events.

### What gets shared

- **One device per frame** (archived frames excluded), each with:
  - an **image entity** showing the frame's latest rendered image,
  - **sensors** for the frame's status, active scene, and when it was last seen.
- A **FrameOS hub device** with a frame count sensor (`sensor.frameos_frames`) whose
  attributes list all frame names.
- **Events**: every event a frame sends (button presses, scene changes, renders, custom
  scene events, …) is forwarded to the Home Assistant event bus as `frameos_event`, so you
  can use it in automations with an *Event* trigger:

  ```yaml
  trigger:
    - platform: event
      event_type: frameos_event
      event_data:
        frame_name: Kitchen frame
        event: button_press
  ```

  Each event carries `frame_id`, `frame_name`, `event`, and the original event data in
  `payload`. Events are also published to MQTT under `frameos/frame/<project>/<frame>/event`
  for MQTT triggers.

### MQTT (recommended)

Frame devices and image entities are published via MQTT discovery. If you have the
**Mosquitto broker** add-on installed, FrameOS discovers it automatically through the
Supervisor — no configuration needed. Without an MQTT broker, events on the Home Assistant
event bus still work, but frame device/image entities are unavailable.

FrameOS installs running outside this add-on can use the same feature: set the Home
Assistant URL + long-lived access token (for events) and the MQTT broker host/credentials
(for frame devices) under **Settings → Home Assistant**.

## Ports

- `8989/tcp` — FrameOS API port; frames on your network send logs and events here and fetch
  their scenes and assets from it.
- `8990/tcp` — ingress port used by the Home Assistant UI, not exposed.

## HTTPS for the API port (optional)

The Home Assistant UI reaches FrameOS through ingress, which is already covered by Home
Assistant's own TLS. The frames themselves connect to port `8989` directly. To serve that
port over HTTPS, point the add-on at a certificate in Home Assistant's `/ssl` folder, the
same way the Mosquitto broker and Node-RED add-ons do:

```yaml
ssl: true
certfile: fullchain.pem
keyfile: privkey.pem
```

| Option     | Default         | Meaning                                              |
|------------|-----------------|------------------------------------------------------|
| `ssl`      | `false`         | Serve port `8989` over HTTPS.                        |
| `certfile` | `fullchain.pem` | Certificate (with chain) in `/ssl`.                  |
| `keyfile`  | `privkey.pem`   | Its private key in `/ssl`.                           |

The **Let's Encrypt** and **DuckDNS** add-ons write exactly these two files, so with either
of them installed the defaults work as they are. If `ssl` is on and a file is missing or
unreadable, the add-on does not start and its log says which file it looked for.

What to expect once it is on:

- Frames verify the certificate against the public CA bundle, so it must be one a browser
  would trust (Let's Encrypt is fine; a self-signed certificate is not), and the frames must
  reach the backend by the name on the certificate — set that name as the frame's server
  host (or as **Settings → Defaults → Default backend host** in FrameOS, so every new frame
  gets it).
- New frames are prefilled with an `https://` server address. Frames you added before
  turning `ssl` on keep reporting over plain HTTP until you set their **Server scheme** to
  `https` under the frame's settings and deploy them again, so switch `ssl` on first, update
  the frames, then rely on it.
- The ingress port (`8990`) stays plain HTTP behind the Supervisor's proxy; only port `8989`
  changes.

## Support

If you run into problems, open an issue on the
[GitHub repository](https://github.com/FrameOS/frameos-home-assistant-addon/issues).
