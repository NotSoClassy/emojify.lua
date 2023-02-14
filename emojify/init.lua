local gmatch = string.gmatch
local gsub = string.gsub

local insert = table.insert
local remove = table.remove

local random = math.random

local pairs = pairs

local emoji_trie = {
  value = nil,
  children = { },
  char = nil,
  parent = nil
}

local module = {
  trie = emoji_trie
}

-- utility parts

local function trim(str)
  return str:gsub("^%s*(.-)%s*$", "%1")
end

local function search_trie(str)
  local node = emoji_trie

  for char in gmatch(str, '.') do
    node = node.children[char]

    if node == nil then
      return nil
    end
  end

  return node
end

local function memoize(func)
  local cache = {}

  return function(key)
    if cache[key] == nil then
      cache[key] = func(key)
    end

    return cache[key]
  end
end

local function string_from_node(node)
  local buf = ''

  while node ~= nil do
    if node.char ~= nil then
      buf = node.char .. buf
    end

    node = node.parent
  end

  return buf
end

local string_from_value = memoize(function(value)
  local stack = { emoji_trie }
  value = trim(value)

  while #stack > 0 do
    local node = remove(stack)

    if node.value == value then
      return string_from_node(node)
    end

    for _, sub_node in pairs(node.children) do
      insert(stack, sub_node)
    end
  end

  return nil
end)

local function find_all_nodes_helper(start, node, finish, buffer)
  if node.value ~= nil then
    insert(buffer, { value = node.value, key = start .. finish })
  end

  for char, child in pairs(node.children) do
    find_all_nodes_helper(start, child, finish .. char, buffer)
  end
end

local function get_random_node_helper(node, count)
  if node.value ~= nil then
    count = count + 1

    if random() < 1 / count then
      return node.value
    end
  end

  for _, child in pairs(node.children) do
    local value = get_random_node_helper(child, count)

    if value ~= nil then
      return value
    end
  end

  return nil
end

-- module parts

function module.emojify(str)
  local result = gsub(str, ':(.-):', function(text)
    local node = search_trie(text)

    return node and node.value or ':' .. text .. ':' -- don't try replace if it's invalid
  end)

  return result
end

function module.get(str)
  local node = search_trie(str)

  return node and node.value or nil
end

function module.which(value)
  local string = string_from_value(value)

  return string
end

function module.find(string)
  local node = search_trie(string)

  if node == nil then
    return nil
  end

  local buf = { }

  find_all_nodes_helper(string, node, '', buf)

  return buf
end

function module.random()
  return get_random_node_helper(emoji_trie, 0)
end


-- build trie from emoji list
do
  local list = require 'emojify.emoji_list'

  for k, v in pairs(list) do
    local node = emoji_trie

    for char in gmatch(k, '.') do
      if node.children[char] == nil then
        local new_node = { children = { }, parent = node, char = char }

        node.children[char] = new_node

        node = new_node
      else
        node = node.children[char]
      end

    end

    node.value = v
  end
end

return module