# FrameOS Home Assistant Add-on

Run FrameOS as a Home Assistant add-on.

## Installation

1. **Add the Repository:**

   - Go to **Settings > Add-ons > Add-on Store** in Home Assistant.
   - Click on the **...** menu in the top right corner.
   - Select **Repositories**.
   - Add the URL of this repository: `https://github.com/FrameOS/frameos-home-assistant-addon`

2. **Install the Add-on:**

   - Find **FrameOS** in the add-on store under **FrameOS Add-ons**.
   - Click **Install**.

3. **Start the Add-on:**

   - After installation, click **Start**.
   - Optionally, enable **Start on boot** and **Watchdog**.

4. **Access FrameOS:**

   - Click on **Open Web UI** to access the FrameOS interface.

## Home Assistant Integration

FrameOS can share its frames with Home Assistant: frame devices with live image entities and
status sensors (via MQTT discovery, using the Mosquitto broker add-on if installed), plus
`frameos_event` events on the Home Assistant event bus for automations. Enable it in the
FrameOS web UI under **Settings → Home Assistant**. Archived frames are not shared. See the
Documentation tab for details.

## Data Persistence

The database is stored at `/data/frameos.db` in the persistent data volume provided by Home Assistant, so data is not lost across restarts or updates.

## Support

If you encounter any issues, please open an issue on the [GitHub repository](https://github.com/FrameOS/frameos-home-assistant-addon/issues).

## License

Apache License Version 2.0