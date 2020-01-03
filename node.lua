gl.setup(NATIVE_WIDTH, NATIVE_HEIGHT)

util.no_globals()

local font = resource.load_font "font.ttf"

local channel = 1
local channels = {}

local video
local next_try = 0

local audio = true
local logo = resource.load_image "package.png"
local cec_mapping = {"channel-up", "channel-down"}

local function stop_and_wait(t)
    if video then
        video:dispose()
        video = nil
    end
    next_try = sys.now() + t
end

local function maybe_restart()
    if sys.now() < next_try then
        return
    end
    video = resource.load_video{
        file = "http://127.0.0.1:8000",
        audio = audio,
        raw = true,
    }
end

util.json_watch("config.json", function(config)
    audio = config.audio
    logo = resource.load_image(config.logo.asset_name)
    cec_mapping = config.cec_mapping

    channels = config.channels
    if #channels == 0 then
        channels = {{
            name = "no channels define",
            url = "",
        }}
    end
    channel = 1
    stop_and_wait(0)
end)

local clients = {}

node.event("connect", function(client, path)
    clients[client] = true
end)

node.event("disconnect", function(client)
    clients[client] = nil
end)

local function send_channel()
    for client in pairs(clients) do
        node.client_write(client, channels[channel].url)
    end
end

local function handle_channel_down()
    channel = channel - 1
    if channel < 1 then
        channel = #channels
    end
    stop_and_wait(0)
end

local function handle_channel_up()
    channel = channel + 1
    if channel > #channels then
        channel = 1
    end
    stop_and_wait(0)
end

local function handle_channel_name(name)
    -- since name is not an unique identifier,
    -- start at current channel position
    -- and pick next name.
    for i = 1, #channels do
        -- start search at current position, wrap at list end
        local idx = (channel + i - 1) % #channels + 1
        if channels[idx].name == name then
            channel = idx
            break
        end
    end
    stop_and_wait(0)
end

local function handle_channel_id(id)
    local index = tonumber(id)
    if index and 1 <= index and index <= #channels then
        channel = index
        stop_and_wait(0)
    end
end

local function handle_cec(key)
    if key == cec_mapping[1] then
        handle_channel_up()
    elseif key == cec_mapping[2] then
        handle_channel_down()
    end
end

util.data_mapper{
    ["sys/cec/key"] = handle_cec;
    ["channel/up"] = handle_channel_up;
    ["channel/down"] = handle_channel_down;
    ["channel/name"] = handle_channel_name;
    ["channel/id"] = handle_channel_id;
}

function node.render()
    gl.clear(1, 1, 1, 1)
    local w, h = logo:size()
    logo:draw(WIDTH/2 - w/2, HEIGHT/2 - h/2, WIDTH/2 + w/2, HEIGHT/2 + h/2)

    local text = "Opening " .. channels[channel].name
    local text_w = font:width(text, 30)
    local x = WIDTH/2 - text_w/2
    local y = HEIGHT/2 + w/2 + 40
    x = x + font:write(x, y, text, 30, .2,.2,.8,1)
    local dotdot = ("..."):sub(0, 1+math.floor(sys.now()*2 % 3)) 
    font:write(x, y, dotdot, 30, .2,.2,.8,1)

    send_channel()

    if video then
        local state, w, h = video:state()
        if state == "loaded" then
            gl.clear(0, 0, 0, 1)
            local x1, y1, x2, y2 = util.scale_into(WIDTH, HEIGHT, w, h)
            video:place(x1, y1, x2, y2):layer(2)
        elseif state == "finished" or state == "error" then
            stop_and_wait(1)
        end
    else
        maybe_restart()
    end
end
