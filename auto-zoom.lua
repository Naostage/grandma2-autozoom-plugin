-- Auto Zoom Plugin for XYZ Tracking
--               _
--              | |
--    __ _ _   _| |_ ___ _______   ___  _ __ ___
--   / _` | | | | __/ _ \_  / _ \ / _ \| '_ ` _ \
--  | (_| | |_| | || (_) / / (_) | (_) | | | | | |
--   \__,_|\__,_|\__\___/___\___/ \___/|_| |_| |_|
--                                    For Grandma2
--
-- Released under MIT License by Naostage (www.naostage.com)
--                               __
--   ____ _____    ____  _______/  |______     ____   ____
--  /    \\__  \  /  _ \/  ___/\   __\__  \   / ___\_/ __ \
-- |   |  \/ __ \(  <_> )___ \  |  |  / __ \_/ /_/  >  ___/
-- |___|  (____  /\____/____  > |__| (____  /\___  / \___  >
--      \/     \/           \/            \//_____/      \/
--
-- MIT License
--
-- Copyright (c) 2023 Olivier Le Doeuff
-- Copyright (c) 2023 Naostage
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

-- ------------------------------------------------------------------------------
-- GrandMa2 API
-- ------------------------------------------------------------------------------

--                            gma.sleep(number:sleep_seconds)
--                            gma.echo(all kind of values)
--                            gma.feedback(all kind of values)
--
-- string:build_date        = gma.build_date()
-- string:build_time        = gma.build_time()
-- string:version_hash      = gma.git_version()
--
--                            gma.export(string:filename,table:export_data)
--                            gma.export_csv(string:filename,table:export_data)
--                            gma.export_json(string:filename,table:export_data)
-- table:import_data        = gma.import(string:filename, [string:gma_subfolder])
--
--                            gma.cmd(string:command)
--                            gma.timer(function:name,number:dt,number:max_count,[function:cleanup])
-- number:time              = gma.gettime()
-- string:result            = gma.textinput(string:title,[string:old_text])
--
-- bool:result              = gma.gui.confirm(string:title,string:message)
--                          = gma.gui.msgbox(string:title,string:message)
--
-- number:handle            = gma.gui.progress.start(string:progress_name)
--                            gma.gui.progress.stop(number:progress_handle)
--                            gma.gui.progress.settext(number:progress_handle,string:text)
--                            gma.gui.progress.setrange(number:progress_handle,number:from,number:to)
--                            gma.gui.progress.set(number:progress_handle,number:value)
--
-- number:value             = gma.show.getdmx(number:dmx_addr)
-- table:values             = gma.show.getdmx(table:recycle,number:dmx_addr,number:amount)
--
-- number:handle            = gma.show.getobj.handle(string:name)
-- string:classname         = gma.show.getobj.class(number:handle)
-- number:index             = gma.show.getobj.index(number:handle)
-- number:commandline_number= gma.show.getobj.number(number:handle)
-- string:name              = gma.show.getobj.name(number:handle)
-- string:label             = gma.show.getobj.label(number:handle)  returns nil if object has no label set
-- number:amount_children   = gma.show.getobj.amount(number:handle)
-- number:child_handle      = gma.show.getobj.child(number:handle, number:index)
-- number:parent_handle     = gma.show.getobj.parent(number:handle)
-- bool:result              = gma.show.getobj.verify(number:handle)
-- bool:result              = gma.show.getobj.compare(number:handle1,number:handle2)
--
-- number:amount            = gma.show.property.amount(number:handle)
-- string:property_name     = gma.show.property.name(number:handle,number:index)
-- string:property          = gma.show.property.get(number:handle,number:index/string:property_name)
--
-- string:value             = gma.show.getvar(string:varname)
--                            gma.show.setvar(string:varname,string:value)
--
-- string:value             = gma.user.getvar(string:varname)
--                            gma.user.setvar(string:varname,string:value")
-- number:object handle     = gma.user.getcmddest()
-- number:object_handle     = gma.user.getselectedexec()
--
-- string:type              = gma.network.gethosttype()
-- string:subtype           = gma.network.gethostsubtype()
-- string:ip                = gma.network.getprimaryip()
-- string:ip                = gma.network.getsecondaryip()
-- string:status            = gma.network.getstatus()
-- number:session_number    = gma.network.getsessionnumber()
-- string:session_name      = gma.network.getsessionname()
-- number:slot              = gma.network.getslot()
--
-- table:host_data          = gma.network.gethostdata(string:ip,[table:recycle])
-- table:slot_data          = gma.network.getmanetslot(number:slot,[table:recycle])
-- table:performance_data   = gma.network.getperformance(number:slot,[table:recycle])

-- string:type              = gma.gethardwaretype()

local GmaShowPropertyAmount = gma.show.property.amount;
local GmaShowPropertyName = gma.show.property.name;
local GmaShowPropertyValue = gma.show.property.get;
local GmaUserGetCmdDest = gma.user.getcmddest;
local GmaShowGetObjHandle = gma.show.getobj.handle;
local GmaShowGetObjParent = gma.show.getobj.parent;
local GmaShowGetObjClass = gma.show.getobj.class;
local GmaShowGetObjIndex = gma.show.getobj.index;
local GmaShowGetObjNumber = gma.show.getobj.number;
local GmaShowGetObjChild = gma.show.getobj.child;
local GmaShowGetObjAmount = gma.show.getobj.amount;
local GmaShowGetObjName = gma.show.getobj.name;
local GmaShowGetObjLabel = gma.show.getobj.label;
local GmaTimer = gma.timer;
local GmaShowSetVar = gma.show.setvar;
local GmaShowGetVar = gma.show.getvar;

-- ------------------------------------------------------------------------------
-- Constants
-- ------------------------------------------------------------------------------

-- Plugin functions that are expected to be called from macros are prefixed with "AZ."
-- This is a namespace that stands for "Auto Zoom"
-- It aims to avoid conflicts with other plugins
AZ = AZ or {}

local SETTINGS = {
    PRINT_TO_ECHO = true,
    PRINT_TO_FEEDBACK = true,
    REFRESH_RATE = 30,
    ENABLE_VAR = "AUTO_ZOOM_PLUGIN_ENABLED",
}

local INTERNAL_NAME = select(1, ...);
local VISIBLE_NAME  = select(2, ...);

local MAIN_MODULE_ID = 1;

-- ------------------------------------------------------------------------------
-- Utils
-- ------------------------------------------------------------------------------

-- print to gma.echo and gma.feedback
-- Output can be controlled with SETTINGS.PRINT_TO_ECHO and SETTINGS.PRINT_TO_FEEDBACK
-- If both are false, nothing will be printed
-- This is useful for debugging
local function GmaPrint(...)
    if not SETTINGS.PRINT_TO_ECHO and not SETTINGS.PRINT_TO_FEEDBACK then
        return;
    end

    local args = { ... };
    local str = "";
    for i = 1, #args do
        str = str .. tostring(args[i]);
    end

    str = VISIBLE_NAME .. ": " .. str;

    if SETTINGS.PRINT_TO_ECHO then
        gma.echo(str);
    end
    if SETTINGS.PRINT_TO_FEEDBACK then
        gma.feedback(str);
    end
end

-- print a table to gma.echo
--
-- param t:table table to print
local function GmaPrintTable(t)
    for k, v in pairs(t) do
        GmaPrint(k .. ":" .. type(k) .. " = " .. v .. ":" .. type(v));
    end
end

-- convert an array to a string
--
-- param array:table array to convert
-- return a string with the array elements separated by a space
local function Array2String(array)

    local str = "{";
    for i = 1, #array do
        str = str .. " " .. array[i];
    end
    str = str .. " }";
    return str;
end

local function Position2String(table)
    return "{" .. table.x .. ", " .. table.y .. ", " .. table.z .. "}";
end

local function GmaPrintProperties(handle)
    local amount = GmaShowPropertyAmount(handle);
    if amount == 0 then
        GmaPrint("No properties exist");
    end

    for i = 0, amount - 1 do
        local name = GmaShowPropertyName(handle, i);
        local value = GmaShowPropertyValue(handle, i);
        GmaPrint("Property[" .. i .. "]: " .. name .. "=" .. value);
    end
end

local function GmaPrintObject(handle)
    local class = GmaShowGetObjClass(handle);
    local index = GmaShowGetObjIndex(handle);
    local number = GmaShowGetObjNumber(handle);
    local name = GmaShowGetObjName(handle);
    local label = GmaShowGetObjLabel(handle);
    local amount = GmaShowGetObjAmount(handle);

    GmaPrint("-----Object Info-----");
    GmaPrint("   Index:", index);
    GmaPrint("   Class:", class);
    GmaPrint("    Name:", name);
    GmaPrint("   Label:", label);
    GmaPrint(" Cmd_Num:", number);
    GmaPrint("Children:", amount);

    GmaPrint("-----Properties-----");
    GmaPrintProperties(handle);
end

-- ------------------------------------------------------------------------------
-- Object ids
-- ------------------------------------------------------------------------------

local ROOT_OBJECTS = {
    SHOWFILE               = 1,
    TIMECONFIG             = 2,
    SETTINGS               = 3,
    DMX_PROTOCOLS          = 4,
    NET_CONFIG             = 5,
    CITP_NET_CONFIG        = 6,
    TRACKING_SYSTEMS       = 7,
    USER_IMAGE_POOL        = 8,
    RDM_DATA               = 9,
    LIVE_SETUP             = 10,
    EDIT_SETUP             = 11,
    MACROS                 = 13,
    FLIGHT_RECORDINGS      = 14,
    PLUGINS                = 15,
    GELS                   = 16,
    PRESETS                = 17,
    WORLDS                 = 18,
    FILTERS                = 19,
    FADE_PATHS             = 20,
    PROGRAMMER             = 21,
    GROUPS                 = 22,
    FORMS                  = 23,
    EFFECTS                = 24,
    SEQUENCES              = 25,
    TIMERS                 = 26,
    MASTER_SECTIONS        = 27,
    EXECUTOR_PAGES         = 30,
    CHANNEL_PAGES          = 31,
    SONGS                  = 33,
    AGENDAS                = 34,
    TIMECODES              = 35,
    REMOTE_TYPES           = 36,
    DMX_SNAPSHOT_TOOL      = 37,
    LAYOOUTS               = 38,
    USER_PROFILES          = 39,
    USERS                  = 40,
    PIXEL_MAPPER_CONTAINER = 41,
    NDP_ROOT               = 42,
}

local LIVE_SETUP_OBJECTS = {
    DMX_PROFILES  = 1,
    PRESET_TYPES  = 2,
    FIXTURE_TYPES = 3,
    LAYERS        = 4,
    UNIVERSES     = 5,
    OBJECTS3D     = 6,
}

local FIXTURE_TYPE_OBJECTS = {
    MODULES               = 1,
    INSTANCES             = 2,
    WHEELS                = 3,
    PRESET_REFERENCES     = 5,
    FIXTURE_MACRO_COLLECT = 6,
    RDM_NOTIFICATIONS     = 7,
}

-- ------------------------------------------------------------------------------
-- Property ids
-- ------------------------------------------------------------------------------

local FIXTURE_PROPERTIES = {
    NAME          = 0,
    FIX_ID        = 1,
    CHA_ID        = 2,
    FIXTURE_TYPE  = 3,
    PATCH         = 4,
    NO_PARAMETERS = 5,
    POS_X         = 6,
    POS_Y         = 7,
    POS_Z         = 8,
    ROT_X         = 9,
    ROT_Y         = 10,
    ROT_Z         = 11,
    INFO          = 12,
    RDM_ID        = 13,
}

local SUBFIXTURE_PROPERTIES = {
    FIX_ID          = 0,
    CHA_ID          = 1,
    NAME            = 2,
    FIXTURE_TYPE    = 3,
    PATCH           = 4,
    REACT_TO_MASTER = 5,
    PAN_DMX_INVERT  = 6,
    TILT_DMX_INVERT = 7,
    PAN_ENC_INVERT  = 8,
    TILT_ENC_INVERT = 9,
    PAN_OFFSET      = 10,
    TILT_OFFSET     = 11,
    SWAP            = 12,
    BITMAP_DISABLE  = 13,
    COLOR           = 14,
    POS_X           = 15,
    POS_Y           = 16,
    POS_Z           = 17,
    ROT_X           = 18,
    ROT_Y           = 19,
    ROT_Z           = 20,
    NO_PARAMETERS   = 21,
    RDM_ID          = 22,
}

local FIXTURETYPE_PROPERTIES = {
    NO               = 0,
    LONG_NAME        = 1,
    SHORT_NAME       = 2,
    MANUFACTURER     = 3,
    SHORT_MANU       = 4,
    DMX_FOOTPRINT    = 5,
    INSTANCES        = 6,
    MODE             = 7,
    USED             = 8,
    XYZ              = 9,
    MODEL            = 10,
    RDM_FIXTURE_TYPE = 11,

}

local CHANNELTYPE_PROPERTIES = {
    NO               = 0,
    ATTRIB           = 1,
    BREAK            = 2,
    COARSE           = 3,
    FINE             = 4,
    ULTRA            = 5,
    DEFAULT          = 6,
    HIGHLIGHT        = 7,
    STAGE            = 8,
    SNAP             = 9,
    INVERT           = 10,
    REACT_TO_MASTER  = 11,
    MIB_DISABLE      = 12,
    MIB_FADE         = 13,
    PROFILE          = 14,
    MODE             = 15,
    REACT_TO_DIM     = 16,
    COLOR            = 17,
    MINIMUM_DMX_TIME = 18,
    TRIGGER          = 19,
}

local CHANNELFUNCTION_PROPERTIES = {
    NO              = 0,
    SUBATTRIB       = 1,
    NAME            = 2,
    WHEEL           = 3,
    FROM            = 4,
    TO              = 5,
    FROM_DMX        = 6,
    TO_DMX          = 7,
    FROM_PHYS       = 8,
    TO_PHYS         = 9,
    ADDITIONAL_PHYS = 10,
    MINIMUM_3D_TIME = 11,
    MODE_START      = 12,
    MODE_END        = 13,
}

local PSNTRACKER_PROPERTIES = {
    PSN_ID  = 0,
    FIX_ID  = 1,
    NAME    = 2,
    POS_X   = 3,
    POS_Y   = 4,
    POS_Z   = 5,
    ROT_X   = 6,
    ROT_Y   = 7,
    ROT_Z   = 8,
    PREDICT = 9,
}

-- ------------------------------------------------------------------------------
-- Objects methods
-- ------------------------------------------------------------------------------

-- cache handle to root, seems to always be 1
local g_root_handle_cached = nil;

-- get the handle of the root object
-- return the handle of the root object
local function GetRootHandle()

    if g_root_handle_cached then
        return g_root_handle_cached;
    end

    local handle = GmaUserGetCmdDest();

    while true do
        local parent_handle = GmaShowGetObjParent(handle);
        if parent_handle == nil then
            break;
        end
        handle = parent_handle;
    end
    g_root_handle_cached = handle;
    return handle;
end

function TestGetRootHandle()
    GmaPrint("TestGetRootHandle")
    gma.cmd("cd /; cd 10")
    local root_handle = GetRootHandle();
    if root_handle == nil then
        GmaPrint("TestGetRootHandle failed");
    else
        GmaPrint("TestGetRootHandle succeeded, value is " .. root_handle);
    end

    -- benchmark the function call
    local start_time = os.clock();
    local count = 1000;
    for _ = 1, count do
        GetRootHandle();
    end
    local end_time = os.clock();
    GmaPrint("GetRootHandle takes " .. (end_time - start_time) / count * 1000 .. " ms on average");

    gma.cmd("cd /");
end

-- get the handle of an object from its path
-- param path:list(number) path of the object
-- return the handle of the object or nil if the object does not exist
local function GetHandleFromRoot(path)
    local handle = GetRootHandle();

    for i = 1, #path do
        handle = GmaShowGetObjChild(handle, path[i] - 1);
        if handle == nil then
            GmaPrint("Warning: GetHandleFromPath called with invalid path \"" ..
                Array2String(path) .. "\":" .. type(path),
                ", fail to find object at index " .. i .. " which is " .. path[i]);
            return nil;
        end
    end

    return handle;
end

function AZ.TestGetHandleFromPath()
    GmaPrint("TestGetHandleFromPath");

    GmaPrint("Try to find LIVE_SETUP/LAYERS")
    local handle = GetHandleFromRoot({ ROOT_OBJECTS.LIVE_SETUP, LIVE_SETUP_OBJECTS.LAYERS });

    if handle == nil then
        GmaPrint("Could not find LIVE_SETUP/LAYERS");
    else
        if GmaShowGetObjClass(handle) == "CMD_FIXTURE_LAYER_COLLECT" then
            GmaPrint("Found LIVE_SETUP/LAYERS with handle " .. handle);
        else
            GmaPrint("Error: Found LIVE_SETUP/LAYERS with handle " ..
                handle .. ", but class is " .. GmaShowGetObjClass(handle));
        end
    end

    -- benchmark GetHandleFromRoot
    local start_time = os.clock();
    local count = 100;
    for _ = 1, count do
        GetHandleFromRoot({ ROOT_OBJECTS.LIVE_SETUP, LIVE_SETUP_OBJECTS.LAYERS });
    end
    local end_time = os.clock();
    GmaPrint("GetHandleFromRoot takes " .. (end_time - start_time) / count * 1000 .. " ms on average");
end

-- get the handle of an object from its parent
--
-- param parent_handle:number handle of the parent object
-- param child_id:number id of the child object, 1 indexed
--
-- return the handle of the child object or nil if the object does not exist
local function GetChildHandle(handle, child_id)
    local ch_amount = GmaShowGetObjAmount(handle);
    if child_id < 1 or child_id > ch_amount then
        GmaPrint("Invalid child id " .. child_id);
        return nil;
    end

    return GmaShowGetObjChild(handle, child_id - 1);
end

-- ------------------------------------------------------------------------------
-- Subfixtures methods
-- ------------------------------------------------------------------------------

-- get the sub fixture position
-- param sub_fixture_handle:number sub fixture handle. Can be obtained by gma.show.getobj.handle("Fixture 1")
-- Then you need to get the 0 index sub fixture handle by gma.show.getobj.child(fixture_handle, 0)
-- It the caller responsibility to make sure the handle is valid
-- return a table with the following keys:
-- - x:number x position
-- - y:number y position
-- - z:number z position
local function GetSubFixturePosition(sub_fixture_handle)
    return {
        x = tonumber(GmaShowPropertyValue(sub_fixture_handle, SUBFIXTURE_PROPERTIES.POS_X)),
        y = tonumber(GmaShowPropertyValue(sub_fixture_handle, SUBFIXTURE_PROPERTIES.POS_Y)),
        z = tonumber(GmaShowPropertyValue(sub_fixture_handle, SUBFIXTURE_PROPERTIES.POS_Z)),
    }
end

-- ------------------------------------------------------------------------------
-- Fixture methods
-- ------------------------------------------------------------------------------

-- get the fixture transform
-- param handle:number fixture handle. Can be obtained by gma.show.getobj.handle("Fixture 1")
-- It the caller responsibility to make sure the handle is valid
-- return a table with the following keys:
-- - x:number x position
-- - y:number y position
-- - z:number z position
local function GetFixturePositionFromSubFixture(fixture_handle)

    -- position/rotation is a property of the first child of the fixture
    -- The fixture also has a property pos/rot, but it is always 0 for some reason
    local sub_fixture_handle = GmaShowGetObjChild(fixture_handle, 0);
    return GetSubFixturePosition(sub_fixture_handle);
end

-- get the fixture id
--
-- param handle:number fixture handle. Can be obtained by gma.show.getobj.handle("Fixture 1")
-- It the caller responsibility to make sure the handle is valid
-- return the fixture id
local function GetFixtureId(fixture_handle)
    return tonumber(GmaShowPropertyValue(fixture_handle, FIXTURE_PROPERTIES.FIX_ID));
end

-- get the fixture type
--
-- param handle:number fixture handle. Can be obtained by gma.show.getobj.handle("Fixture 1")
-- It the caller responsibility to make sure the handle is valid
-- return the fixture type, in the form "15 Mistral Standard"
--
-- Note: You can get the fixture type id by calling GetFixtureTypeIdFromFixtureType
local function GetFixtureType(fixture_handle)
    return GmaShowPropertyValue(fixture_handle, FIXTURE_PROPERTIES.FIXTURE_TYPE);
end

-- get the fixture type id.
--
-- param fixture_type:string fixture type, in the form "15 Mistral Standard"
--
-- return number the fixture type id
local function GetFixtureTypeIdFromFixtureType(fixture_type)
    -- fixture type is in the form "15 Mistral Standard"
    -- we need to extract the number
    local fixture_type_id = string.match(fixture_type, "%d+");
    return tonumber(fixture_type_id);
end

function AZ.TestGetFixtureTransform()
    -- For this test to work you must have a fixture named "Fixture 1"
    GmaPrint("TestGetFixtureTransform");

    local fixture_name = "Fixture 1"
    local handle = GmaShowGetObjHandle(fixture_name);
    local fixture_transform = GetFixturePositionFromSubFixture(handle);

    GmaPrint("Fixture transform for " .. fixture_name .. ":");
    GmaPrintTable(fixture_transform);

    -- Run benchmark of function call
    local start_time = os.clock();
    local count = 1000;
    for _ = 1, count do
        GetFixturePositionFromSubFixture(handle);
    end
    local end_time = os.clock();
    GmaPrint("GetFixtureTransform takes " .. (end_time - start_time) / count * 1000 .. " ms on average");
end

-- Get the info for a fixture.
--
-- Return a table with the following keys:
-- {
--     position = {
--         x = x_position,
--         y = y_position,
--         z = z_position,
--     },
--     fixture_type_id = fixture_type_id,
--     fixture_id = fixture_id,
-- }
local function GetFixtureInfo(fixture_handle)
    local position = GetFixturePositionFromSubFixture(fixture_handle);
    local fixture_id = GetFixtureId(fixture_handle);

    local fixture_type = GetFixtureType(fixture_handle);
    local fixture_type_id = GetFixtureTypeIdFromFixtureType(fixture_type);

    return {
        fixture_id      = fixture_id,
        fixture_type_id = fixture_type_id,
        position        = position,
    }
end

-- Get the position of all fixtures.
--
-- The returned table has the following structure:
-- {
--     [fixture_id] = {
--        position = {
--            x = x_position,
--            y = y_position,
--            z = z_position,
--        },
--        fixture_type_id = fixture_type_id,
--        fixture_id = fixture_id,
--     },
--     ...
-- }
local function GetAllFixturesInfo()
    local infos = {};
    local handle = GetHandleFromRoot({ ROOT_OBJECTS.LIVE_SETUP, LIVE_SETUP_OBJECTS.LAYERS });
    local ch_amount = GmaShowGetObjAmount(handle);

    -- loop through all layers
    -- we ignore child 0 (layer 1 Auto-Created) that doesn't contain fixtures
    for i = 1, ch_amount - 1 do
        local layer_handle = GmaShowGetObjChild(handle, i);

        -- loop through all fixtures in the layer
        local fixture_amount = GmaShowGetObjAmount(layer_handle);
        for j = 0, fixture_amount - 1 do
            local fixture_handle = GmaShowGetObjChild(layer_handle, j);
            local info = GetFixtureInfo(fixture_handle);
            infos[info.fixture_id] = info;
        end
    end
    return infos;
end

function AZ.TestGetAllFixtureInfo()
    GmaPrint("TestGetAllFixturePosition");
    local start_time = os.clock();
    local infos = GetAllFixturesInfo();
    local end_time = os.clock();
    GmaPrint("GetAllFixturesPosition takes " .. (end_time - start_time) * 1000 .. " ms");
    for fixture_id, info in pairs(infos) do
        GmaPrint("Fixture " ..
            fixture_id .. " has position " .. Position2String(info.position) .. ", type id " .. info.fixture_type_id);
    end
end

local g_fixture_infos = {};

-- Update the fixture positions info cache.
-- This function should be called when the fixture positions change
-- It is the caller responsibility to make sure the cache is updated when needed
--
-- You can call this function from a macro using the following code:
-- LUA "UpdateFixturePositionsCache()"
function AZ.UpdateFixturePositionsInfo()
    g_fixture_infos = GetAllFixturesInfo();
end

-- ------------------------------------------------------------------------------
-- Fixture types methods
-- ------------------------------------------------------------------------------

local function GetFixtureTypesHandle()
    local fixture_types_handle = GetHandleFromRoot({ ROOT_OBJECTS.LIVE_SETUP, LIVE_SETUP_OBJECTS.FIXTURE_TYPES });
    if fixture_types_handle == nil then
        GmaPrint("Can't find fixture types handle");
        return nil;
    end
    return fixture_types_handle;
end

-- Get the fixture type handle.
--
-- param fixture_type_id:number fixture type id
--
-- return number the fixture type handle
-- return nil if the fixture type id is invalid or the fixture type handle can't be found
local function GetFixtureTypeHandle(fixture_type_id)
    local fixture_types_handle = GetFixtureTypesHandle();
    return GetChildHandle(fixture_types_handle, fixture_type_id);
end

local function GetFixtureTypeModulesHandle(fixture_type_handle)
    return GetChildHandle(fixture_type_handle, FIXTURE_TYPE_OBJECTS.MODULES);
end

-- Get the module handle of a fixture type.
-- We assume the module is the first child of the fixture type.
--
-- param modules_handle:number the modules handle, can be obtained by calling GetFixtureTypeModulesHandle
-- param module_id:number the module id. The main module is MAIN_MODULE_ID
--
-- return number the module handle
local function GetFixtureTypeModuleHandle(modules_handle, module_id)
    return GetChildHandle(modules_handle, module_id);
end

-- Get the channel type of a module attribute.
--
-- param module_handle:number module handle. The handle can be obtained by calling GetFixtureTypeMainModule
-- param attribute_name:string the attribute name, e.g. "Pan"
local function GetModuleChannelTypeHandle(module_handle, attribute_name)
    local ch_amount = GmaShowGetObjAmount(module_handle);

    -- loop through all ChannelType until we find the one with the same name as attribute_name
    for i = 0, ch_amount - 1 do
        local channel_type_handle = GmaShowGetObjChild(module_handle, i);
        local attrib_value = GmaShowPropertyValue(channel_type_handle, CHANNELTYPE_PROPERTIES.ATTRIB)
        -- check if attribute_name is in attrib_value
        if string.find(attrib_value, attribute_name) then
            return channel_type_handle;
        end
    end

    return nil
end

function AZ.TestGetModuleChannelType()
    local fixture = "Fixture 1";
    local attrib = "Zoom";
    local fixture_type_id = GetFixtureTypeIdFromFixtureType(GetFixtureType(GmaShowGetObjHandle(fixture)))
    local fixture_type_handle = GetFixtureTypeHandle(fixture_type_id);
    local modules_handle = GetFixtureTypeModulesHandle(fixture_type_handle);
    local module_handle = GetFixtureTypeModuleHandle(modules_handle, MAIN_MODULE_ID);
    local channel_type_handle = GetModuleChannelTypeHandle(module_handle, "Zoom");
    if channel_type_handle == nil then
        GmaPrint("Can't find channel type handle for attribute " .. attrib);
    else
        GmaPrint("Channel type handle is " .. channel_type_handle .. " for attribute " .. attrib);
        GmaPrintObject(channel_type_handle);
    end
end

local function GetChannelFunctionHandle(channel_type_handle, channel_function_id)
    return GetChildHandle(channel_type_handle, channel_function_id);
end

-- Get the number value from a physical value.
-- Phys value have the following format: "6.70 *"
-- This function will return 6.7
--
-- param phys_value:string the physical value
--
-- return number the number value
local function GetNumberFromPhysValue(phys_value)
    -- we need to remove the " *" from the end of the string
    local number_value = string.sub(phys_value, 1, string.len(phys_value) - 2);
    return tonumber(number_value);
end

local function GetFromToAndPhysFromChannelFunction(channel_function_handle)
    local from_value = GmaShowPropertyValue(channel_function_handle, CHANNELFUNCTION_PROPERTIES.FROM);
    local to_value = GmaShowPropertyValue(channel_function_handle, CHANNELFUNCTION_PROPERTIES.TO);
    local from_phys_value = GmaShowPropertyValue(channel_function_handle, CHANNELFUNCTION_PROPERTIES.FROM_PHYS);
    local to_phys_value = GmaShowPropertyValue(channel_function_handle, CHANNELFUNCTION_PROPERTIES.TO_PHYS);

    return {
        from = from_value,
        to = to_value,
        from_phys = GetNumberFromPhysValue(from_phys_value),
        to_phys = GetNumberFromPhysValue(to_phys_value)
    };
end

local function GetZoomChannelFunctionForModule(module_handle)
    local channel_type_handle = GetModuleChannelTypeHandle(module_handle, "Zoom");
    if channel_type_handle == nil then
        GmaPrint("Can't find channel type handle for attribute Zoom");
        return nil;
    end

    local channel_function_handle = GetChannelFunctionHandle(channel_type_handle, 1);
    return GetFromToAndPhysFromChannelFunction(channel_function_handle);
end

local function GetZoomChannelFunctionForFixtureType(fixture_type_handle)
    local modules_handle = GetFixtureTypeModulesHandle(fixture_type_handle);
    if modules_handle == nil then
        GmaPrint("Can't find modules handle");
        return nil;
    end

    local module_handle = GetFixtureTypeModuleHandle(modules_handle, MAIN_MODULE_ID);
    if module_handle == nil then
        GmaPrint("No main module found");
        return nil;
    end

    return GetZoomChannelFunctionForModule(module_handle);
end

function AZ.TestGetZoomChannelFunctionForFixtureType()
    local fixture = "Fixture 1";
    local fixture_type_id = GetFixtureTypeIdFromFixtureType(GetFixtureType(GmaShowGetObjHandle(fixture)))
    local fixture_type_handle = GetFixtureTypeHandle(fixture_type_id);
    local fromto_values = GetZoomChannelFunctionForFixtureType(fixture_type_handle);
    if fromto_values == nil then
        GmaPrint("Can't find zoom channel function");
        return;
    end

    GmaPrint("Zoom channel function:")
    GmaPrint("From: " .. fromto_values.from .. " To: " .. fromto_values.to);
    GmaPrint("From phys: " .. fromto_values.from_phys .. " To phys: " .. fromto_values.to_phys);
end

-- Get fixture type infos
--
-- param fixture_type_handle:integer the fixture type handle
--
-- return table the fixture type infos with the following structure:
-- {
--     fixture_type_id = 1,
--     zoom = {
--         from = 0,
--         to = 255,
--         from_phys = 0,
--         to_phys = 100
--     }
-- }
local function GetFixtureTypeInfo(fixture_type_handle)
    local fixture_type_id = tonumber(GmaShowPropertyValue(fixture_type_handle, FIXTURETYPE_PROPERTIES.NO));
    local name = GmaShowPropertyValue(fixture_type_handle, FIXTURETYPE_PROPERTIES.LONG_NAME);
    local zoom_values = GetZoomChannelFunctionForFixtureType(fixture_type_handle);

    local info = {
        fixture_type_id = fixture_type_id,
        name = name,
    };
    if zoom_values ~= nil then
        info.zoom = zoom_values;
    end

    return info
end

-- Get fixture type infos
--
-- param fixture_types_handle:integer the fixture types handle
--
-- return table the fixture type infos with the following structure:
-- {
--     [1] = {
--         fixture_type_id = 1,
--         zoom = {
--             from = 0,
--             to = 255,
--             from_phys = 0,
--             to_phys = 100
--         },
--     [...] = {
--         ...
--         },
--     },
local function GetFixtureTypeInfos(fixture_types_handle)
    local infos = {};
    local fixture_types_amount = GmaShowGetObjAmount(fixture_types_handle);
    for i = 0, fixture_types_amount - 1 do
        local fixture_type_handle = GmaShowGetObjChild(fixture_types_handle, i);
        local info = GetFixtureTypeInfo(fixture_type_handle);
        if info ~= nil then
            infos[info.fixture_type_id] = info;
        end
    end

    return infos;
end

function AZ.TestGetFixtureTypeInfos()
    GmaPrint("Get fixture type infos");

    local fixture_types_handle = GetFixtureTypesHandle();
    local infos = GetFixtureTypeInfos(fixture_types_handle);

    if infos == nil then
        GmaPrint("Can't get fixture type infos");
        return;
    end

    for fixture_type_id, info in pairs(infos) do
        GmaPrint("Fixture type " .. fixture_type_id .. "(" .. info.name .. ")" .. ":");
        if info.zoom == nil then
            GmaPrint("No zoom channel function");
        else
            GmaPrint("Zoom from: " .. info.zoom.from .. " to: " .. info.zoom.to);
            if info.zoom.to_phys == nil then
                GmaPrint("No zoom physical values");
            else
                GmaPrint("Zoom from phys: " .. info.zoom.from_phys .. " to phys: " .. info.zoom.to_phys);
            end
        end
    end
end

local g_fixture_types_info = {};

-- Update the fixture positions info cache.
-- This function should be called when the fixture positions change
-- It is the caller responsibility to make sure the cache is updated when needed
--
-- You can call this function from a macro using the following code:
-- LUA "UpdateFixturePositionsCache()"
function AZ.UpdateFixtureTypeInfo()
    local fixture_types_handle = GetFixtureTypesHandle();
    local infos = GetFixtureTypeInfos(fixture_types_handle);
    g_fixture_types_info = infos;
end

-- ------------------------------------------------------------------------------
-- Markers methods
-- ------------------------------------------------------------------------------

-- Get the position of tracker_handle
--
-- param tracker_handle:number tracker handle.
-- It the caller responsibility to make sure the handle is valid
-- return a table with the following keys:
-- - x:number x position
-- - y:number y position
-- - z:number z position
local function GetPsnTrackerPosition(tracker_handle)
    return {
        x = tonumber(GmaShowPropertyValue(tracker_handle, PSNTRACKER_PROPERTIES.POS_X)),
        y = tonumber(GmaShowPropertyValue(tracker_handle, PSNTRACKER_PROPERTIES.POS_Y)),
        z = tonumber(GmaShowPropertyValue(tracker_handle, PSNTRACKER_PROPERTIES.POS_Z)),
    }
end

local function GetPsnTrackerFixtureId(tracker_handle)
    local fixture_id = GmaShowPropertyValue(tracker_handle, PSNTRACKER_PROPERTIES.FIX_ID);
    if fixture_id == "None" then
        return nil;
    end
    return tonumber(fixture_id);
end

local function GetAllMarkersPostitionFromPSNSystem(psn_system_handle)
    local positions = {};

    local ch_amount = GmaShowGetObjAmount(psn_system_handle);

    for i = 0, ch_amount - 1 do
        local tracker_handle = GmaShowGetObjChild(psn_system_handle, i);
        local fixture_id = GetPsnTrackerFixtureId(tracker_handle);
        if fixture_id ~= nil then
            positions[fixture_id] = GetPsnTrackerPosition(tracker_handle);
        end
    end

    return positions;
end

-- Get the position of all markers
--
-- The returned table has the following structure:
-- {
--     [marker_id] = {
--         x = x_position,
--         y = y_position,
--         z = z_position,
--     },
--     ...
-- }
--
-- Note: the marker_id is the fixture id of the marker
--
-- Note: this will only work for marker assign to posistagenet tracker,
-- this won't return positions of markers assigned to nothing on moved by programmer
local function GetAllMarkersPosition()
    local positions = {};
    local tracking_system_handle = GetHandleFromRoot({ ROOT_OBJECTS.TRACKING_SYSTEMS });
    local ch_amount = GmaShowGetObjAmount(tracking_system_handle);

    for i = 0, ch_amount - 1 do
        local tracking_system_handle = GmaShowGetObjChild(tracking_system_handle, i);
        local system_positions = GetAllMarkersPostitionFromPSNSystem(tracking_system_handle);
        for marker_id, position in pairs(system_positions) do
            positions[marker_id] = position;
        end
    end
    return positions;
end

function AZ.TestGetAllMarkersPosition()
    local markers = GetAllMarkersPosition();

    for marker_id, position in pairs(markers) do
        GmaPrint("Marker " .. marker_id .. " has position " .. Position2String(position));
    end

end

-- ------------------------------------------------------------------------------
-- Runtime Functions
-- ------------------------------------------------------------------------------

local enabled = false;
local RegisterUpdateLoop

-- Called at fix refresh rate, configured in settings
local function UpdateLoop()
    if not enabled then
        return;
    end


    RegisterUpdateLoop();
end

local function RegisterUpdateLoopImpl()
    if not enabled then
        GmaPrint("Auto Zoom Plugin is disabled, fail to start update loop");
        return;
    end

    GmaTimer(UpdateLoop, 1 / SETTINGS.REFRESH_RATE, 1)
end

RegisterUpdateLoop = RegisterUpdateLoopImpl;

-- Enable the plugin, this will start the update loop.
-- You should call this function from a macro:
-- `LUA "EnableAutoZoomPlugin()"`
function AZ.Enable()
    GmaPrint("Enable Auto Zoom Plugin")
    enabled = true;
    GmaShowSetVar(SETTINGS.ENABLE_VAR, 1);
    RegisterUpdateLoop();
end

-- Disable the plugin, this will stop the update loop.
-- You should call this function from a macro:
-- `LUA "DisableAutoZoomPlugin()"`
function AZ.Disable()
    GmaPrint("Disable Auto Zoom Plugin")
    enabled = false;
    GmaShowSetVar(SETTINGS.ENABLE_VAR, 0);
end

-- Read the environment variable to determine if the plugin is enabled or disabled.
-- This function is called at startup.
local function EnableOrDisableFromEnv()
    GmaPrint("Read Enabled From Env " .. SETTINGS.ENABLE_VAR .. " ...");
    local enabled = GmaShowGetVar(SETTINGS.ENABLE_VAR);
    if enabled == 1 then
        AZ.Enable();
    else
        AZ.Disable();
    end
end

function Refresh()
    GmaPrint("Update Fixture Info Cache ...");
    AZ.UpdateFixturePositionsInfo();

    GmaPrint("Update Fixture Type Info Cache ...");
    AZ.UpdateFixturePositionsInfo();
end

local function Start()
    GmaPrint("Start Auto Zoom Plugin");

    Refresh();
    EnableOrDisableFromEnv();

    GmaPrint("Initialization Complete");
end

local function Cleanup()
    gma.echo("Stop Auto Zoom Plugin");
end

return Start, Cleanup;
