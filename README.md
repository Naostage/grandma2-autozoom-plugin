# Auto Zoom grandma2 plugin <img src="docs/assets/naostage-logo-white.svg" alt="drawing" width="120" align="right" height="100%">

This is a plugin for [grandma2](https://www.malighting.com/) to automatically control the zoom of a moving head to that the beam size will be constant on a moving stage marker.

## 📦️ Installation

1. Download the file `auto-zoom.lua` and `auto-zoom.xml` and put them in the `plugins` folder of grandma2

  - usually `C:\Program Files (x86)\grandma2\pluginsC:\ProgramData\MA Lighting Technologies\grandma\gma2_V_3.9.60\plugins` on windows.
  - In your usb key `gma2/plugins`.

2. Load the plugin in your show file.

  - Open the plugin pool (Create Basic Window -> System -> Plugin)
    ![image-20230211151238298](docs/assets/image-20230211151238298.png)
  - Right click where you want to add the plugin.
    ![image-20230211151459315](docs/assets/image-20230211151459315.png)
  - An Edit Plugin window will show up.
    ![image-20230211151634945](docs/assets/image-20230211151634945.png)
  - You can optionally select `Execute On Load` so that the plugin automatically starts when you load the show file.
    ![image-20230211151716003](docs/assets/image-20230211151716003.png)

3. Next we want to create a couple of macro to control the execution of the plugin.

  - `LUA "AZ.Enable()"`. This will enable the plugin and make it run.
  - `LUA "AZ.Disable()"`. This will disable the plugin and stop it from running.
  - `LUA "AZ.ShowEnabled()"`. This will show a message in the console if the plugin is enabled or not.
  - `LUA "AZ.SetMode('Programmer')"`. This will set the plugin to `Programmer` mode.
  - `LUA "AZ.SetMode('Executor')"`. This will set the plugin to `Executor` mode.
  - `LUA "AZ.ShowMode()"`. This will show a message in the console if the plugin is in `Programmer` or `Executor` mode.
  - `LUA "AZ.Refresh()"`. This will refresh the plugin. This is useful if you change fixture type properties or fixture info.

## 🚀 Usage

### Enable/Disable

To enable the plugin, run the macro containing `LUA "AZ.Enable()"`. To disable the plugin, run the macro containing `LUA "AZ.Disable()"`.
This can also be controlled with user variable `AUTO_ZOOM_PLUGIN_ENABLED` (0 = disabled, 1 = enabled).
If `Execute On Load` is enabled, the plugin will automatically start when you load the show file.

### Prepare fixture

1. Import the fixture type in your show file you want to use, then enable XYZ mode with `Enable XYZ` button.
     ![image-20230211160415146](docs/assets/image-20230211160415146.png)

2. Then edit the fixture type with the `Edit` button.
     ![image-20230211160519776](docs/assets/image-20230211160519776.png)

3. Next edit Pan and with `Edit Row` button.
     ![image-20230211160614279](docs/assets/image-20230211160614279.png)

4. Make sure From/To and FromPhys/ToPhys are set to value matching your fixture. You would be surprise how much fixture are wrong.
     ![image-20230211160826041](docs/assets/image-20230211160826041.png)
       For example with the Arolla Profile MP the website give that pan is 540°. Which divided by 2 gives 270°.
       ![image-20230211160925133](docs/assets/image-20230211160925133.png)

5. Do the same for the tilt value.

6. Next jump to the zoom channel and set From/To to 0 -> 100. And FromPhys/ToPhys to value from the manufacturer website.
     ![image-20230211161130590](docs/assets/image-20230211161130590.png)
       For example with Arolla Profile MP:
       ![image-20230211161111183](docs/assets/image-20230211161111183.png)

7. If you use iris to create a smaller beam when zoom if not enough, do the same for the iris.
     ![image-20230211161303632](docs/assets/image-20230211161303632.png)

That is all that is required, all this steps can be repeated if you have multiple fixture type that you need to use for XYZ tracking.

### Prepare stage marker

Stage marker is a virtual fixture, with XYZ position that can move. A fixture can follow a marker. More [Use Stage Markers](https://help2.malighting.com/Page/grandMA2/xyz_use_stage_markers/en/3.3).

![image-20230211161603314](docs/assets/image-20230211161603314.png)

> It is important for stage marker to be patched with a dmx address, otherwise they won't move.

![image-20230211161841541](docs/assets/image-20230211161841541.png)

Next you need to assign a PSN tracker to your stage marker. More can be found in [PosiStageNet](https://help2.malighting.com/Page/grandMA2/network_psn/en/3.3). The menu can be accessed with Setup -> Network -> Psn Network Configuration.

![image-20230211162015366](docs/assets/image-20230211162015366.png)

In this menu you need to enable it with `Enabled` button.

![image-20230211162057360](docs/assets/image-20230211162057360.png)

Then click on `Add` button and right click on the `Enabled` cell to turn it to `Yes`.

![image-20230211162139690](docs/assets/image-20230211162139690.png)

Kratos server should show up, you can navigate into it with `View Tracker` button.

![image-20230211163445577](docs/assets/image-20230211163445577.png)

Can can view every target coming from Kratos, and assign them to your stage marker of choice by clicking in `Fixture ID` cell.

![image-20230211163758485](docs/assets/image-20230211163758485.png)

Now when a target moves in Kratos, you should see the stage marker move:

![image-20230211164010257](docs/assets/image-20230211164010257.png)

### Programmer mode

Programmer mode is the easiest mode to use as it doesn't require any programming. You should only use this mode for testing purpose, it can be a good idea to test your setup before using executor mode.

- Call your macro with `LUA "AZ.SetMode('Programmer')" ` to enable this mode
- Call in a plugin `LUA "AZ.EnableFixture(<fixture>, <stage marker>, <beam size>)"`. For example `LUA "AZ.EnableFixture(1, 1001, 2)"` will enable XYZ tracking for `Fixture 1` on stage marker `Fixture 1001` with a beam size of 2m.
  - `<fixture>` can be the ID of the fixture or the label
  - `<stage marker>` can be the ID of the fixture or the label
  - `<beam size>` is the value of the beam in meters
- You can disable fixture tracking with `LUA "AZ.DisableFixture(<fixture>)"`

![image-20230211164655140](docs/assets/image-20230211164655140.png)

### Executor mode

Once you made sure you that everything work, you can move to executor mode which have additional requirement.

* Call your macro with `LUA "AZ.SetMode('Executor')" ` to enable this mode
* You can still enable/disable fixture like in Programmer mode.

You will need to create 2 sequences per fixture, assigned on fader. The label of the sequence are important.

* `XYZ_ZOOM_<fixture id>`: A sequence with Temp fader with zoom wide stored. If you fixture id is 1, then sequence name is `XYZ_ZOOM_1`.
* `XYZ_IRIS_<fixture id>`: A sequence with Temp fader with iris open stored. If you fixture id is 1, then sequence name is `XYZ_IRIS_1`.

Then for each pair fixture/marker you need to create a base sequence `XYZ_<fixture id>_<stage marker id>` with:

* STAGEX at 0
* STAGEY at 0
* STAGEZ at 0 (or the offset you need)
* MARK to the stage marker
* ZOOM narrow
* IRIS close (or the minimum iris you want to use).

For example for fixture 1 and stage marker 1001, the sequence will be named `XYZ_1_1001`.

![image-20230211165531115](docs/assets/image-20230211165531115.png)

The plugin will then call the appropriate base sequence when you `LUA "AZ.EnableFixture(fixture, marker, beam size)"` and control zoom and iris temp fader to make the beam size matching your desired value.

## 📄 License

MIT License, see [LICENSE](LICENSE) for more information.
