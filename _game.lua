_showtime_hero_params = {0, 80}
_showtime_mic_params = {4, 76}
_showtime_hero_index = 0
_showtime_hero_ttl = 3
_notebook = {}
_guesses = {}
function _showtime_draw()
  cls()

  for k, v in pairs(fx.stars) do 
    pset(v.x, v.y, rnd() > 0.9 and 10 or 7)
  end

  palt(0, false)
  map(0,12,16,24,12,19)
  palt()

  palt(11, true)

  -- input guy
  input:draw(24, 96)

  -- baddies
  baddie_mngr:draw()

  -- showtime banner
  spr(64, 22, 0, 10, 2)
  dshad("giggles: ".._score, 40, 18, 7, 2)

  -- stage
  spr(137, 24, 44, 4, 4)
  -- hero
  spr(32, 40, 52)
  -- mic
  palt(0, false)
  spr(76, 48, 52)
  palt()

  -- time limit
  -- Border is 62 px high, to accommodae 60px of filled meter
  rect(8,86,13,24,7)
  rectfill(9,85,12,25 + (SHOWTIME_TIMER - _showtime_current_timer),14)
  spr(91, 7, 88)


  dshad(BUTTON_O..": notebook    "..BUTTON_X..": enter", 12, 116, 7, 2)

  palt()
end

function _notebookst_draw()
  cls()

  for k, v in pairs(fx.stars) do 
    pset(v.x, v.y, rnd() > 0.9 and 10 or 7)
  end

  palt(0, false)
  map(0,12,16,24,12,19)
  palt()

  palt(11, true)

  -- input guy
  input:draw(24, 96)

  -- baddies
  baddie_mngr:draw()

  -- showtime banner
  spr(64, 22, 0, 10, 2)
  dshad("giggles: ".._score, 40, 18, 7, 2)

  -- stage
  spr(137, 24, 44, 4, 4)
  -- hero
  spr(32, 40, 52)
  -- mic
  palt(0, false)
  spr(76, 48, 52)
  palt()

  -- time limit
  -- Border is 62 px high, to accommodae 60px of filled meter
  rect(8,86,13,24,7)
  rectfill(9,85,12,25 + (SHOWTIME_TIMER - _showtime_current_timer),14)
  spr(91, 7, 88)

  -- notebook
  fx.msgbox:draw()

  palt()
end

function _explore_draw()
  cls()
  

  for k, v in pairs(fx.stars) do 
    pset(v.x, v.y, rnd() > 0.9 and 10 or 7)
  end

  foreach(fx.parts, function(p)
    p:draw()
  end)

  palt(0, false)
  map(0,0,16,16,14,12)
  palt()

  palt(11, true)
  -- time limit
  rect(8,84,13,24,7)
  -- 60 px high
  rectfill(9,83,12,25 + (SHOWTIME_TIMER - _showtime_remaining_timer),14)
  spr(91, 7, 86)

  dshad(BUTTON_O..": notebook", 30, 106, 7, 2)

  local x_offset, y_offset = 0, 0
  local bits = btn() & player.allowed_inputs
  if isset(bits, 5) then
    x_offset = flr(rnd(2) - 1)
    y_offset = flr(rnd(2) - 1)
  end
  local str = BUTTON_X..": hold for showtime"
  local prefix = sub(str, 1, flr(#str * (showtime_bucket / 80)))
  dshad(str, 30 + x_offset, 113 + y_offset, 7, 2)
  if isset(bits,5) then
    print(prefix, 30 + x_offset, 113 + y_offset, 14)
  end

  -- player
  player:draw()

  -- baddies
  baddie_mngr:draw()

  palt()
end

function _notebook_update(dt)
  local bits = btn()

  fx.msgbox:update(dt)
  if btnp(4) then
    -- notebook close
    fx.msgbox = nil
    change_state(STATE_EXPLORE)
  end
end

function _notebookst_update(dt)
  local bits = btn()

  fx.msgbox:update(dt)
  if btnp(4) then
    -- notebook close
    fx.msgbox = nil
    -- doing this manually to avoid all the init code in change_state
    _current_state = STATE_SHOWTIME
  end
end

function _notebook_draw()
  cls()
  
  palt(11, true)

  for k, v in pairs(fx.stars) do 
    pset(v.x, v.y, rnd() > 0.9 and 10 or 7)
  end

  palt(0, false)
  map(0,0,16,16,14,12)
  palt()

  palt(11, true)
  -- time limit
  rect(8,84,13,24,7)
  -- 60 px high
  rectfill(9,83,12,25 + (SHOWTIME_TIMER - _showtime_remaining_timer),14)
  spr(91, 7, 86)


  foreach(fx.parts, function(p)
    p:draw()
  end)

  -- player
  player:draw()

  -- baddies
  baddie_mngr:draw()

  -- notebook
  fx.msgbox:draw()

  palt()
end

function _gameover_draw()
  cls()

  palt(11, true)

  dshad("bravo!", 48, 32, 7, 2)
  dshad("giggles: ".._score, 40, 42, 7, 2)

  dshad("grammar solution!", 32, 72, 12, 1)
  _grammar:explain(32, 82)

  palt()
end

function _gameover_update(dt)
  if btnp(4) or btnp(5) then
    change_state(STATE_TITLE)
  end

  foreach(timers, function(t)
    t.ttl -= dt
    if t.ttl <= 0 then
      t.f()
      del(timers, t)
    end
  end)
end

function _explore_update(dt)
  local bits = btn()

  if rnd() > 0.7 then
    add(fx.stars, {x=130, y=flr(rnd(120)), dx=rnd()})
  end

  for k, v in pairs(fx.stars) do 
    v.x -= v.dx
  end

  player:update(bits, dt)
  baddie_mngr:update(dt, player.x + 4, player.y + 4)

  foreach(fx.parts, function(part) 
    part:update(dt)
    if part.ttl <= 0 then
      del(fx.parts, part)
    end
  end)

  local bits = btn() & player.allowed_inputs
  if isset(bits, 5) then
    showtime_bucket += 1
    if showtime_bucket >= 90 then
      change_state(STATE_SHOWTIME)
    end
  elseif showtime_bucket > 0 then
    showtime_bucket -= 3 
    if showtime_bucket < 0 then
      showtime_bucket = 0
    end
  end

  local bitsp = btnp() & player.allowed_inputs
  if isset(bitsp, 4) then
    -- generate string with seen hints
    local str = "  -- notes --\n"
    for v in all(_notebook) do
      str = str..v.."\n" 
    end
    str = str.."\n"..BUTTON_O.." close"
    -- notebook
    fx.msgbox = new_msgbox(33, 30, 102, 90, 0.2, str)
    change_state(STATE_NOTEBOOK)
  end

end

function _showtime_update(dt)
  if rnd() > 0.7 then
    add(fx.stars, {x=130, y=flr(rnd(120)), dx=rnd()})
  end

  for k, v in pairs(fx.stars) do 
    v.x -= v.dx
  end

  _showtime_current_timer -= dt
  if _showtime_current_timer < 0 then
    change_state(STATE_GAMEOVER)
  end

  _showtime_hero_ttl -= dt
  if _showtime_hero_ttl < 0 then
    _showtime_hero_index = (_showtime_hero_index + 1) % #_showtime_hero_params
    _showtime_hero_ttl = 3
  end

  if btnp(1) then 
    input:moveright()
  end
  if btnp(0) then 
    input:moveleft()
  end
  if btnp(2) then 
    input:moveup()
  end
  if btnp(3) then 
    input:movedown()
  end

  if btnp(5) then
    local joined, joined_str = input:submit() 
    if #joined > 0 then
      local result = _grammar:check(joined)
      if result then
        if not elem(_guesses, joined_str) then
          _score += #joined * 5
          baddie_mngr:react("haha")
          sfx(24)
          add(timers, {
            ttl = 1.2,
            f = function()
              sfx(24, -2) 
            end,
            })
          add(_guesses, joined_str)
        else -- repeat
          _score += 1
          baddie_mngr:react("ha…")
          sfx(25)
          add(timers, {
            ttl = 1.2,
            f = function()
              sfx(25, -2) 
            end,
            })
        end
      -- failed, give a "..."
      else
        baddie_mngr:react("…\n…\n…")
          sfx(26)
          add(timers, {
            ttl = 1.2,
            f = function()
              sfx(26, -2) 
            end,
            })
      end
    end
  end
  
  if btnp(4) then
    -- generate string with seen hints
    local str = "  -- notes --\n"
    for v in all(_notebook) do
      str = str..v.."\n" 
    end
    str = str.."\n"..BUTTON_O.." close"
    -- notebook
    fx.msgbox = new_msgbox(28, 30, 97, 90, 0.2, str)
    -- fx.msgbox = new_msgbox(33, 30, 102, 90, 0.2, str)
    change_state(STATE_NOTEBOOKST)
  end

  -- passing 0,0 as dummy values for player pos
  baddie_mngr:update(dt, 0, 0)

  foreach(timers, function(t)
    t.ttl -= dt
    if t.ttl <= 0 then
      t.f()
      del(timers, t)
    end
  end)
end

function _title_draw()
  cls()
  for k, v in pairs(fx.stars) do 
    pset(v.x, v.y, rnd() > 0.9 and 1 or 7)
  end
  map(20,0,24,30,11,4)
  fx.cyclers[1]:draw(18, 90)

  byline(5)
end

function _title_update(dt)
  if btnp(4) or btnp(5) then
    music(1, 500)
    change_state(STATE_EXPLORE)
  end

  if rnd() > 0.7 then
    add(fx.stars, {x=130, y=flr(rnd(120)), dx=rnd()})
  end

  fx.cyclers[1]:update(dt)

  for k, v in pairs(fx.stars) do 
    v.x -= v.dx
  end
end

function change_state(new_state)
  if new_state == STATE_SHOWTIME then
    _current_state = new_state
    _showtime_current_timer = _showtime_remaining_timer
    _showtime_hero_ttl = 3
    -- change baddie locations
    local locations = {{74, 49},{80,38},{87,53},{78,63},{89,72}}
    for k, v in pairs(baddie_mngr.baddies) do 
      v.x, v.y = locations[k][1],locations[k][2]
      v.flip = true
    end
    _guesses = {}
  elseif new_state == STATE_TITLE then
    _current_state = new_state
    _showtime_remaining_timer = SHOWTIME_TIMER
    __init()
  elseif new_state == STATE_EXPLORE then
    _current_state = new_state
  elseif new_state == STATE_NOTEBOOK then
    _current_state = new_state
  elseif new_state == STATE_NOTEBOOKST then
    _current_state = new_state
  elseif new_state == STATE_GAMEOVER then
    music(-1, 500)
    _current_state = new_state
  else
    printh("Invalid game state!")
  end
  printh("new state: "..new_state)

end

function dshad(str, x, y, clr_main, clr_shad)
  print(str, x+1, y, clr_shad)
  print(str, x, y, clr_main)
end
