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

3. **Configure the Add-on:**

   - After installation, go to the add-on's **Configuration** tab.
   - Set the `secret_key` option. This is required for security.
     - You can use Home Assistant's secrets by setting `!secret frameos_secret_key`.
     - Alternatively, enter a strong, random string.

4. **Start the Add-on:**

   - After configuring, click **Start**.
   - Optionally, enable **Start on boot** and **Watchdog**.

5. **Access FrameOS:**

   - Click on **Open Web UI** to access the FrameOS interface.

## Configuration Options

- **`secret_key`** (required): The secret key used by FrameOS for session management and security. It should be a strong, random string.

## Data Persistence

The database is stored in the `/data/db` directory provided by Home Assistant to ensure data is not lost across restarts or updates.

## Support

If you encounter any issues, please open an issue on the [GitHub repository](https://github.com/FrameOS/frameos-home-assistant-addon/issues).

## License

Apache License Version 2.0