# FrameOS Home Assistant Add-on

Run FrameOS as a Home Assistant add-on.

## Status

This starts FrameOS on port 8989 on your Home Assistant machine.

Ingress (automatic login, etc) is **not yet implemented**. You'll have to sign up manually. 

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

## Data Persistence

The database is stored in the `/data/db` directory provided by Home Assistant to ensure data is not lost across restarts or updates.

## Support

If you encounter any issues, please open an issue on the [GitHub repository](https://github.com/FrameOS/frameos-home-assistant-addon/issues).

## License

Apache License Version 2.0